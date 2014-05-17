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

@property (strong, nonatomic) PFLPuzzleSet* puzzleSet;
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
  
  // header
  CCNodeColor* header = [[CCNodeColor alloc] initWithColor:[PFLColorUtils dimPurple] width:1.0f height:0.1f];
  header.contentSizeType = CCSizeTypeNormalized;
  header.positionType = CCPositionTypeNormalized;
  header.position = ccp(0.0f, 1.0f - header.contentSize.height);
  [scene addChild:header z:1];
  
  CCLabelTTF* headerLabel = [CCLabelTTF labelWithString:puzzleSet.name fontName:@"ArialRoundedMTBold" fontSize:20];
  headerLabel.color = [PFLColorUtils darkCream];
  headerLabel.anchorPoint = ccp(0.5f, 0.5f);
  headerLabel.positionType = CCPositionTypeNormalized;
  headerLabel.position = ccp(0.5f, 0.5f);
  [header addChild:headerLabel];
  
  // menu
  PFLPuzzleSetLayer* menuLayer = [[PFLPuzzleSetLayer alloc] initWithPuzzleSet:puzzleSet header:header];
  [scene addChild:menuLayer];
  menuLayer.contentSizeType = CCSizeTypeNormalized;
  menuLayer.contentSize = CGSizeMake(1.0f, 1.0f);
  menuLayer.positionType = CCPositionTypeNormalized;
  menuLayer.scrollBoundsInPoints = CGRectMake(0.0f, 0.0f, scene.contentSizeInPoints.width, scene.contentSizeInPoints.height);
  
  return scene;
}

- (id)initWithPuzzleSet:(PFLPuzzleSet*)puzzleSet header:(CCNode*)header
{
  self = [super init];
  if (self)
  {
    self.contentSize = [[CCDirector sharedDirector] designSize];
    self.puzzleSet = puzzleSet;
    self.allowsScrollHorizontal = NO;
    self.combinedSampleNames = [NSMutableArray array];
    
    // puzzle cells
    NSInteger puzzleCount = [self.puzzleSet.puzzles count];
    static CGFloat normalizedVertButtonPadding = 1.0f / 20.0f;
    
    int i = 0;
    for (PFLPuzzle* puzzle in self.puzzleSet.puzzles)
    {
      PFLPuzzleSetCell* cell = [[PFLPuzzleSetCell alloc] initWithPuzzle:puzzle cellIndex:i];
      [self addChild:cell];
      
      cell.anchorPoint = ccp(0, 1);
      cell.contentSizeType = CCSizeTypeNormalized;
      cell.contentSize = CGSizeMake(0.9f, (header.position.y - ((puzzleCount + 1) * normalizedVertButtonPadding)) / puzzleCount);
      cell.positionType = CCPositionTypeNormalized;
      cell.position = ccp((1.0f - cell.contentSize.width) / 2.0f,
                          (header.position.y - (i * cell.contentSize.height)) - ((i + 1.0f) * normalizedVertButtonPadding));
      cell.propogateTouch = YES;
      cell.menuCellDelegate = self;
      
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
    self.audioEventController.mute = YES;
    
    self.loopIndex = 0;
//    [self schedule:@selector(stepLoopSequence) interval:self.puzzleSet.beatDuration];
  };
  return self;
}

// TODO: needs refactoring to work with dynamic solution sequences
//- (void)stepLoopSequence
//{
//  NSArray* events = self.puzzleSet.combinedSolutionEvents[self.loopIndex];
//  [self.audioEventController receiveEvents:events];
//  
//  self.loopIndex++;
//  if (self.loopIndex >= self.puzzleSet.combinedSolutionEvents.count)
//  {
//    self.loopIndex = 0;
//  }
//}

#pragma mark SequenceMenuCellDelegate

- (void)puzzleSetCellTouchUpInside:(PFLPuzzleSetCell*)cell index:(NSInteger)index
{
  CCScene* scene = [PFLPuzzleLayer sceneWithPuzzle:self.puzzleSet.puzzles[index]];
  CCTransition* transition = [CCTransition transitionCrossFadeWithDuration:0.33f];
  [[CCDirector sharedDirector] replaceScene:scene withTransition:transition];
}

@end
