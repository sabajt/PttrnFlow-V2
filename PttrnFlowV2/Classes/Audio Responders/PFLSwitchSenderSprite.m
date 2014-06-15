//
//  PFLSwitchSenderSprite.m
//  PttrnFlowV2
//
//  Created by John Saba on 5/10/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLSwitchSenderSprite.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

@interface PFLSwitchSenderSprite ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation PFLSwitchSenderSprite

- (instancetype)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    self.color = self.defaultColor;
    self.event = [PFLEvent switchSenderEventWithChannel:glyph.switchChannel];
    
    NSString* spriteName = [NSString stringWithFormat:@"switch_sender_%i.png", [glyph.switchChannel integerValue] + 1];
    CCSprite* detailSprite = [CCSprite spriteWithImageNamed:spriteName];
    self.detailSprite = detailSprite;
    detailSprite.position = ccp(self.contentSize.width / 2.0f, self.contentSize.height / 2.0f);
    [self addChild:detailSprite];
    detailSprite.color = [PFLColorUtils padWithTheme:self.theme isStatic:glyph.isStatic];
    
    [self audioResponderSwitchToState:@0 animated:NO senderCell:cell];
  }
  return self;
}

#pragma mark - PFLAudioResponder

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  // toggle the state
  NSNumber* nextState;
  if ([self.switchState integerValue] == 0)
  {
    nextState = @1;
  }
  else
  {
    nextState = @0;
  }

  // broadcast hit notification here so we don't have to for both touch and step controllers
  // if notification needs touch or step distinction, move this into respective controllers
  NSDictionary* userInfo =
  @{
    PFLSwitchChannelKey : self.glyph.switchChannel,
    PFLSwitchStateKey : nextState,
    PFLSwitchCoordKey : self.cell
  };
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLSwitchSenderHitNotification object:nil userInfo:userInfo];
  
  // we listen to our own notification for the benefit of other senders of the same channel,
  // but manually call switch on this instance to make sure state changes before the animation
  [self audioResponderSwitchToState:nextState animated:YES senderCell:self.cell];
  
  return self.event;
}

- (void)audioResponderSwitchToState:(NSNumber*)state animated:(BOOL)animated senderCell:(PFLCoord *)senderCell
{
  if ([self.switchState isEqual:state])
  {
    return;
  }
  
  self.switchState = state;
  
  [self stopAllActions];
  CCTime beatDuration = self.glyph.puzzle.puzzleSet.beatDuration;
  
  if ([state isEqual:@0])
  {
    self.defaultColor = [PFLColorUtils glyphDetailWithTheme:self.theme];
    
    if (animated)
    {
      CCActionTintTo* tintSelf = [CCActionTintTo actionWithDuration:beatDuration color:self.defaultColor];
      [self runAction:[CCActionEaseSineOut actionWithAction:tintSelf]];
      
      CCActionTintTo* tintDetail = [CCActionTintTo actionWithDuration:beatDuration color:[PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic]];
      [self.detailSprite runAction:[CCActionEaseSineOut actionWithAction:tintDetail]];
    }
    else
    {
      self.color = self.defaultColor;
    }
  }
  else
  {
    self.defaultColor = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
    
    if (animated)
    {
      CCActionTintTo* tint = [CCActionTintTo actionWithDuration:self.glyph.puzzle.puzzleSet.beatDuration color:self.defaultColor];
      [self runAction:[CCActionEaseSineOut actionWithAction:tint]];
      
      CCActionTintTo* tintDetail = [CCActionTintTo actionWithDuration:beatDuration color:[PFLColorUtils glyphDetailWithTheme:self.theme]];
      [self.detailSprite runAction:[CCActionEaseSineOut actionWithAction:tintDetail]];
    }
    else
    {
      self.color = self.defaultColor;
    }
  }
}

@end
