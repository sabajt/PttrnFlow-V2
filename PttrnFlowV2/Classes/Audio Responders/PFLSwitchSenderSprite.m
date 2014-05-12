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
  }
  return self;
}

#pragma mark - PFLAudioResponder

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  self.color = self.activeColor;
  
  CCActionTintTo* tint = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
  [self runAction:[CCActionEaseSineOut actionWithAction:tint]];
  
  // broadcast hit notification here so we don't have to for both touch and step controllers
  // if notification needs touch or step distinction, move this into respective controllers
  if ([self.switchState integerValue] == 0)
  {
    self.switchState = @1;
  }
  else
  {
    self.switchState = @0;
  }
  NSDictionary* userInfo = @{
    PFLSwitchChannelKey : self.glyph.switchChannel,
    PFLSwitchStateKey : self.switchState
  };
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLSwitchSenderHitNotification object:nil userInfo:userInfo];
  
  return self.event;
}

- (void)audioResponderSwitchToState:(NSNumber*)state
{
  self.switchState = state;
}

@end
