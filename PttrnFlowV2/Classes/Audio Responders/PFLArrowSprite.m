//
//  Arrow.m
//  PttrnFlow
//
//  Created by John Saba on 1/20/14.
//
//

#import "PFLArrowSprite.h"
#import "NSString+PFLDegrees.h"
#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"
#import "PFLSwitchReceiverAttributes.h"
#import "PFLPuzzleState.h"

@interface PFLArrowSprite ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (strong, nonatomic) PFLEvent *event;
@property (copy, nonatomic) NSString* direction;

@end

@implementation PFLArrowSprite

- (id)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    self.color = self.defaultColor;
    
    CCSprite* detailSprite = [CCSprite spriteWithImageNamed:@"arrow_up.png"];
    self.detailSprite = detailSprite;
    detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    [self addChild:detailSprite];
    detailSprite.color = [PFLColorUtils padWithTheme:self.theme isStatic:glyph.isStatic];
    
    // TOOD: might need to load saved state?
    if (glyph.switchReceiverAttributes)
    {
      [self audioResponderSwitchToState:@0 animated:NO senderCell:cell];
    }
    else
    {
      self.rotation = [glyph.direction degrees];
      self.event = [PFLEvent directionEventWithDirection:glyph.direction];
    }
  }
  return self;
}

#pragma mark - PFLAudioResponder

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  self.color = self.activeColor;
  
  CCActionTintTo* tint = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
  [self runAction:[CCActionEaseSineOut actionWithAction:tint]];
  
  return self.event;
}

- (void)audioResponderSwitchToState:(NSNumber*)state animated:(BOOL)animated senderCell:(PFLCoord *)senderCell
{
  if ([self.switchState isEqual:state])
  {
    return;
  }
  
  self.switchState = state;
  PFLSwitchReceiverAttributes* attributes = self.glyph.switchReceiverAttributes[[state integerValue]];
  
  [self stopAllActions];
  CCTime beatDuration = self.glyph.puzzle.puzzleSet.beatDuration;
  
  self.active = attributes.active;
  if (self.active)
  {
    if (animated)
    {
      CCActionFadeTo* fade = [CCActionFadeTo actionWithDuration:beatDuration opacity:1.0f];
      [self runAction:[CCActionEaseSineOut actionWithAction:fade]];
    }
    else
    {
      self.detailSprite.opacity = 1.0f;
    }
  }
  else
  {
    if (animated)
    {
      CCActionFadeTo* fade = [CCActionFadeTo actionWithDuration:beatDuration opacity:0.0f];
      [self runAction:[CCActionEaseSineOut actionWithAction:fade]];
    }
    else
    {
      self.detailSprite.opacity = 0.0f;
    }
  }
  
  self.direction = attributes.direction;
  if (self.direction)
  {
    if (animated)
    {
      CCActionRotateTo* rotate = [CCActionRotateTo actionWithDuration:beatDuration angle:[self.direction degrees]];
      [self runAction:[CCActionEaseBackInOut actionWithAction:rotate]];
    }
    else
    {
      self.rotation = [self.direction degrees];
    }
  }
  
  self.event = [PFLEvent directionEventWithDirection:self.direction];
}

@end
