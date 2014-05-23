//
//  SequenceMenuCell.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLPuzzleSetCell.h"
#import "PFLColorUtils.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleState.h"
#import "PFLPuzzleSet.h"

@interface PFLPuzzleSetCell ()

@property (assign) NSInteger cellIndex;

@property (weak, nonatomic) CCSprite* label;
@property (weak, nonatomic) CCSprite* check;
@property (weak, nonatomic) CCSprite9Slice* cellFill;

@end

@implementation PFLPuzzleSetCell

- (id)initWithPuzzle:(PFLPuzzle *)puzzle cellIndex:(NSInteger)cellIndex
{
  self = [super initWithImageNamed:@"2pt_border_9slice.png"];
  if (self)
  {
    self.userInteractionEnabled = YES;
    self.cellIndex = cellIndex;
    self.color = [PFLColorUtils dimPurple];
    self.margin = 0.4f;
    self.puzzle = puzzle;
    
    CCSprite9Slice* cellFill = [CCSprite9Slice spriteWithImageNamed:@"rounded_fill_9slice.png"];
    cellFill.margin = 0.4f;
    cellFill.contentSizeType = CCSizeTypeNormalized;
    cellFill.contentSize = CGSizeMake(1.0f, 1.0f);
    cellFill.positionType = CCPositionTypeNormalized;
    cellFill.position = ccp(0.5f, 0.5f);
    cellFill.opacity = 0.0f;
    cellFill.color = [PFLColorUtils dimPurple];
    self.cellFill = cellFill;
    [self addChild:cellFill];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:puzzle.name fontName:@"ArialRoundedMTBold" fontSize:20];
    label.positionType = CCPositionTypeNormalized;
    label.color = [PFLColorUtils dimPurple];
    label.position = ccp(0.33f, 0.5f);
    self.label = label;
    [self addChild:label];
    
    PFLPuzzleState* puzzleState = [PFLPuzzleState puzzleStateForPuzzle:puzzle];
    if (puzzleState.loopedEvents)
    {
      CCSprite* check = [CCSprite spriteWithImageNamed:@"check.png"];
      check.color = [PFLColorUtils dimPurple];
      check.positionType = CCPositionTypeNormalized;
      check.position = ccp(0.66, 0.5f);
      
      self.check = check;
      [self addChild:check];
    }
  }
  return self;
}

#pragma mark CCResponder

- (void)touchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
  if (self.propogateTouch)
  {
    [self.parent touchBegan:touch withEvent:event];
  }
}

- (void)touchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
  if (self.propogateTouch)
  {
    [self.parent touchMoved:touch withEvent:event];
  }
}

- (void)touchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
  if (self.propogateTouch)
  {
    [self.parent touchEnded:touch withEvent:event];
  }
  
  if ([self hitTestWithWorldPos:[touch locationInWorld]])
  {
    [self.menuCellDelegate puzzleSetCellTouchUpInside:self index:self.cellIndex];
  }
}

- (void)touchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
  if (self.propogateTouch)
  {
    [self.parent touchCancelled:touch withEvent:event];
  }
}

#pragma mark - PFLEventDelegate

- (void)eventFired:(PFLEvent *)event
{
  if ([event.eventType integerValue] == PFLEventTypeSample)
  {
    CGFloat beatDuration = self.puzzle.puzzleSet.beatDuration;
    [self stopAllActions];
    
    [self.cellFill runAction:[CCActionFadeOut actionWithDuration:beatDuration]];
    
    self.label.color = [PFLColorUtils activeYellow];
    [self.label runAction:[CCActionTintTo actionWithDuration:beatDuration color:[PFLColorUtils dimPurple]]];
    
    self.check.color = [PFLColorUtils activeYellow];
    [self.check runAction:[CCActionTintTo actionWithDuration:beatDuration color:[PFLColorUtils dimPurple]]];
  }
}

@end
