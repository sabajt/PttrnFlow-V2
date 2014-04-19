//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLPuzzleSetNode.h"
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

@interface PFLPuzzleSetNode ()

@property (strong, nonatomic) PFLPuzzleSet *puzzleSet;
@property (strong, nonatomic) NSMutableArray* combinedSampleNames;
@property NSInteger loopIndex;
@property (weak, nonatomic) PFLAudioEventController* audioEventController;

@end

@implementation PFLPuzzleSetNode

+ (CCScene*)sceneWithPuzzleSet:(PFLPuzzleSet*)puzzleSet leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding
{
  CCScene* scene = [CCScene node];
  
  // background
  PFLPuzzleBackgroundLayer* background = [PFLPuzzleBackgroundLayer backgroundLayerWithColor:[PFLColorUtils controlPanelFillWithTheme:puzzleSet.theme]];
  background.contentSize = CGSizeMake(background.contentSize.width + leftPadding + rightPadding, background.contentSize.height);
  background.position = ccpSub(background.position, ccp(leftPadding, 0.0f));
  [scene addChild:background];
  
  PFLPuzzleSetNode* menuLayer = [[PFLPuzzleSetNode alloc] initWithPuzzleSet:puzzleSet];
  [scene addChild:menuLayer];
  return scene;
}

- (id)initWithPuzzleSet:(PFLPuzzleSet*)puzzleSet
{
  self = [super initWithSize:CGSizeMake(320, 568)];
  if (self)
  {
    self.puzzleSet = puzzleSet;
    self.allowsScrollHorizontal = NO;

    // create and layout cells
    CGSize sideMargins = CGSizeMake(50, 50);
    CGSize padding = CGSizeMake(20, 20);
    
    self.combinedSampleNames = [NSMutableArray array];
    int i = 0;
    for (PFLPuzzle* puzzle in self.puzzleSet.puzzles)
    {
      PFLPuzzleSetCell* cell = [[PFLPuzzleSetCell alloc] initWithIndex:i];
      cell.propogateTouch = YES;
      cell.anchorPoint = ccp(0.5, 0.5);
      CGFloat yPosition = sideMargins.height + ((i * cell.contentSize.height) + (i * padding.height));
      cell.position = ccp(self.contentSize.width / 2, yPosition);
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
  CCScene* scene = [PFLPuzzleLayer sceneWithPuzzle:self.puzzleSet.puzzles[index] leftPadding:80.0f rightPadding:0.0f];
  CCTransition* transition = [CCTransition transitionCrossFadeWithDuration:0.33f];
  [[CCDirector sharedDirector] replaceScene:scene withTransition:transition];
}

@end
