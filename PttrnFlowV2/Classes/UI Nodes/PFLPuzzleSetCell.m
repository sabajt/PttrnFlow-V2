//
//  SequenceMenuCell.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLPuzzleSetCell.h"
#import "PFLColorUtils.h"

@interface PFLPuzzleSetCell ()

@property (assign) NSInteger cellIndex;

@end

@implementation PFLPuzzleSetCell

- (id)initWithPuzzle:(PFLPuzzle *)puzzle cellIndex:(NSInteger)cellIndex
{
  self = [super initWithImageNamed:@"audio_box.png"];
  if (self)
  {
    self.userInteractionEnabled = YES;
    self.cellIndex = cellIndex;
    self.color = [PFLColorUtils dimPurple];
    self.margin = 0.25;
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", cellIndex + 1] fontName:@"Helvetica" fontSize:40];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor blackColor];
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
