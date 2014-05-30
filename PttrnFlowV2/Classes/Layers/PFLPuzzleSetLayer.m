//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLPuzzleSetLayer.h"
#import "PFLPuzzleLayer.h"
#import "PFLPuzzle.h"
#import "PFLAudioResponderTouchController.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzleBackgroundLayer.h"
#import "PFLPuzzleState.h"
#import "PFLColorUtils.h"
#import "PFLAudioEventController.h"
#import "PFLGlyph.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"
#import "PFLEvent.h"

@interface PFLPuzzleSetLayer ()

@property (strong, nonatomic) PFLPuzzleSet* puzzleSet;
@property (strong, nonatomic) NSMutableArray* combinedSampleNames;
@property (strong, nonatomic) NSMutableArray* combinedEventsLoop;
@property NSInteger loopIndex;
@property (weak, nonatomic) PFLAudioEventController* audioEventController;
@property (strong, nonatomic) NSMutableDictionary* puzzleSetCells;

@end

@implementation PFLPuzzleSetLayer

+ (CCScene*)sceneWithPuzzleSet:(PFLPuzzleSet*)puzzleSet
{
  CCScene* scene = [CCScene node];
  
  PFLPuzzleBackgroundLayer* background = [PFLPuzzleBackgroundLayer backgroundLayerWithColor:[PFLColorUtils backgroundWithTheme:puzzleSet.theme]];
  [scene addChild:background z:0];
  
//  [CCLabelTTF labelWithString:puzzleSet.name fontName:@"ArialRoundedMTBold" fontSize:20];
  
  // menu
  PFLPuzzleSetLayer* menuLayer = [[PFLPuzzleSetLayer alloc] initWithPuzzleSet:puzzleSet];
  menuLayer.contentSizeType = CCSizeTypeNormalized;
  menuLayer.contentSize = CGSizeMake(1.0f, 1.0f);
  menuLayer.positionType = CCPositionTypeNormalized;
  menuLayer.scrollBoundsInPoints = CGRectMake(0.0f, 0.0f, scene.contentSizeInPoints.width, scene.contentSizeInPoints.height);
  [scene addChild:menuLayer z:1];
  
  // HUD layer
  PFLHudLayer* hudLayer = [[PFLHudLayer alloc] initWithTheme:puzzleSet.theme contentMode:NO];
  hudLayer.delegate = menuLayer;
  [scene addChild:hudLayer z:3];
  
  return scene;
}

- (id)initWithPuzzleSet:(PFLPuzzleSet*)puzzleSet
{
  self = [super init];
  if (self)
  {
    self.contentSize = [[CCDirector sharedDirector] designSize];
    self.puzzleSet = puzzleSet;
    self.allowsScrollHorizontal = NO;
    self.combinedSampleNames = [NSMutableArray array];
    self.combinedEventsLoop = [NSMutableArray array];
    
    // puzzle cells
    NSInteger puzzleCount = [self.puzzleSet.puzzles count];
    static CGFloat normalizedVertButtonPadding = 1.0f / 20.0f;
    self.puzzleSetCells = [NSMutableDictionary dictionary];
    
    CGFloat normalizedHeaderPosY = (self.contentSize.height - [PFLHudLayer accesoryBarHeight]) / self.contentSize.height;
    
    int i = 0;
    for (PFLPuzzle* puzzle in self.puzzleSet.puzzles)
    {
      // puzzle set cells
      PFLPuzzleSetCell* cell = [[PFLPuzzleSetCell alloc] initWithPuzzle:puzzle cellIndex:i];
      cell.anchorPoint = ccp(0, 1);
      cell.contentSizeType = CCSizeTypeNormalized;
      cell.contentSize = CGSizeMake(0.9f, (normalizedHeaderPosY - ((puzzleCount + 1) * normalizedVertButtonPadding)) / puzzleCount);
      cell.positionType = CCPositionTypeNormalized;
      cell.position = ccp((1.0f - cell.contentSize.width) / 2.0f,
                          (normalizedHeaderPosY - (i * cell.contentSize.height)) - ((i + 1.0f) * normalizedVertButtonPadding));
      cell.propogateTouch = YES;
      cell.menuCellDelegate = self;
      
      [self addChild:cell];
      [self.puzzleSetCells setObject:cell forKey:puzzle.file];
      
      // collect sample names to pre-load
      for (PFLGlyph* glyph in puzzle.glyphs)
      {
        if (glyph.audioID)
        {
          id object = puzzle.audio[[glyph.audioID integerValue]];
          if ([object isKindOfClass:[PFLMultiSample class]])
          {
            PFLMultiSample* multiSample = (PFLMultiSample*)object;
            for (PFLSample* sample in multiSample.samples)
            {
              [self.combinedSampleNames addObject:sample.file];
            }
          }
        }
      }
      
      // build combined event loop from puzzle states
      PFLPuzzleState* puzzleState = [PFLPuzzleState puzzleStateForPuzzle:puzzle];
      if (puzzleState.loopedEvents)
      {
        for (NSInteger b = 0; b < self.puzzleSet.length; b++)
        {
          NSArray* eventsAtBeat;
          if ([puzzleState.loopedEvents count] > b)
          {
            eventsAtBeat = puzzleState.loopedEvents[b];
          }
          else
          {
            eventsAtBeat = puzzleState.loopedEvents[b % [puzzleState.loopedEvents count]];
          }
          
          NSArray* existingEvents;
          if (b < [self.combinedEventsLoop count])
          {
            existingEvents = [self.combinedEventsLoop[b] arrayByAddingObjectsFromArray:eventsAtBeat];
            
            // cell wants callbacks for animation
            for (PFLEvent* event in existingEvents)
            {
              if (event.audioID && ([event.puzzleFile isEqualToString:cell.puzzle.file]))
              {
                event.delegate = cell;
              }
            }
            
            [self.combinedEventsLoop replaceObjectAtIndex:b withObject:existingEvents];
          }
          else
          {
            // cell wants callbacks for animation
            for (PFLEvent* event in eventsAtBeat)
            {
              if (event.audioID && ([event.puzzleFile isEqualToString:cell.puzzle.file]))
              {
                event.delegate = cell;
              }
            }
            
            [self.combinedEventsLoop addObject:eventsAtBeat];
          }
        }
      }
      
      i++;
    }

    // audio event controller
    PFLAudioEventController* audioEventController = [PFLAudioEventController audioEventController];
    self.audioEventController = audioEventController;
    self.audioEventController.beatDuration = puzzleSet.beatDuration;
    [self addChild:self.audioEventController];
    [self.audioEventController loadSamples:self.combinedSampleNames];
    self.audioEventController.mute = NO;
    
    // begin playing loop
    self.loopIndex = 0;
    [self schedule:@selector(stepLoopSequence) interval:self.puzzleSet.beatDuration];
  };
  return self;
}

- (void)stepLoopSequence
{
  if (self.loopIndex < [self.combinedEventsLoop count])
  {
    NSArray* events;
    events = self.combinedEventsLoop[self.loopIndex];
    [self.audioEventController receiveEvents:events];
  }
  
  self.loopIndex++;
  if (self.loopIndex >= [self.combinedEventsLoop count])
  {
    self.loopIndex = 0;
  }
}

#pragma mark SequenceMenuCellDelegate

- (void)puzzleSetCellTouchUpInside:(PFLPuzzleSetCell*)cell index:(NSInteger)index
{
  CCScene* scene = [PFLPuzzleLayer sceneWithPuzzle:self.puzzleSet.puzzles[index]];
  CCTransition* transition = [CCTransition transitionCrossFadeWithDuration:0.33f];
  [[CCDirector sharedDirector] replaceScene:scene withTransition:transition];
}

@end
