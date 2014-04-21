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
#import "PFLColorUtils.h"
#import "PFLKeyframe.h"
#import "PFLAudioEventController.h"
#import "PFLGlyph.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"

@interface PFLPuzzleSetLayer ()

@property (strong, nonatomic) PFLPuzzleSet *puzzleSet;
@property (strong, nonatomic) NSMutableArray* combinedSampleNames;
@property NSInteger loopIndex;
@property (weak, nonatomic) PFLAudioEventController* audioEventController;

@end

@implementation PFLPuzzleSetLayer

+ (CCScene*)sceneWithPuzzleSet:(PFLPuzzleSet*)puzzleSet
{
  CCScene* scene = [CCScene node];
  
  PFLPuzzleBackgroundLayer* background = [PFLPuzzleBackgroundLayer backgroundLayerWithColor:[PFLColorUtils controlPanelFillWithTheme:puzzleSet.theme]];
  [scene addChild:background];
  
  PFLPuzzleSetLayer* menuLayer = [[PFLPuzzleSetLayer alloc] initWithPuzzleSet:puzzleSet];
  [scene addChild:menuLayer];
  menuLayer.contentSizeType = CCSizeTypeNormalized;
  menuLayer.contentSize = CGSizeMake(1.0f, 1.0f);
  menuLayer.positionType = CCPositionTypeNormalized;
  menuLayer.scrollBoundsInPoints = CGRectMake(0.0f, 0.0f, scene.contentSizeInPoints.width, scene.contentSizeInPoints.height);
  
  return scene;
}

- (id)initWithPuzzleSet:(PFLPuzzleSet*)puzzleSet
{
  self = [super init];
  if (self)
  {
    self.puzzleSet = puzzleSet;
    self.allowsScrollHorizontal = NO;
    self.combinedSampleNames = [NSMutableArray array];
    
    int i = 0;
    for (PFLPuzzle* puzzle in self.puzzleSet.puzzles)
    {
      PFLPuzzleSetCell* cell = [[PFLPuzzleSetCell alloc] initWithIndex:i];
      cell.anchorPoint = ccp(0, 0);
      cell.contentSizeType = CCSizeTypeNormalized;
      cell.contentSize = CGSizeMake(1.0f, 0.2f);
      cell.positionType = CCPositionTypeNormalized;
      cell.position = ccp(0, i * cell.contentSize.height);
      cell.propogateTouch = YES;
      cell.menuCellDelegate = self;
      [self addChild:cell];
      
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
      
      i++;
    }

    PFLAudioEventController* audioEventController = [PFLAudioEventController audioEventController];
    self.audioEventController = audioEventController;
    self.audioEventController.beatDuration = puzzleSet.beatDuration;
    [self addChild:self.audioEventController];
    [self.audioEventController loadSamples:self.combinedSampleNames];
    
    //
    self.audioEventController.mute = YES;
    
    self.loopIndex = 0;
    [self schedule:@selector(stepLoopSequence) interval:self.puzzleSet.beatDuration];
  };
  return self;
}

- (void)stepLoopSequence
{
  NSArray* events = self.puzzleSet.combinedSolutionEvents[self.loopIndex];
  [self.audioEventController receiveEvents:events];
  
  self.loopIndex++;
  if (self.loopIndex >= self.puzzleSet.combinedSolutionEvents.count)
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
