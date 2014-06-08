//
//  PFLWarpSprite.m
//  PttrnFlowV2
//
//  Created by John Saba on 6/7/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLWarpSprite.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLColorUtils.h"

@interface PFLWarpSprite ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation PFLWarpSprite

- (instancetype)initWithImageNamed:(NSString*)imageName glyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    self.event = [PFLEvent warpEventWithWarpChannel:glyph.warpChannel];
    self.color = self.defaultColor;
    
    NSString* spriteName = [NSString stringWithFormat:@"warp_%i.png", [glyph.warpChannel integerValue] + 1];
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
  
  return self.event;
}

@end
