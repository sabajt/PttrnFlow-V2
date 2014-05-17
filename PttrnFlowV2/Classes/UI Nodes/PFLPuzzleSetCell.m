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

@interface PFLPuzzleSetCell ()

@property (assign) NSInteger cellIndex;

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
    self.margin = 0.40;
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:puzzle.name fontName:@"ArialRoundedMTBold" fontSize:20];
    label.positionType = CCPositionTypeNormalized;
    label.color = [PFLColorUtils dimPurple];
    label.position = ccp(0.5f, 0.5f);
    [self addChild:label];
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

@end
