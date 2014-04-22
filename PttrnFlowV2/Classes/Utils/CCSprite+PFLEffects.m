//
//  CCSprite+PFLEffects.m
//  PttrnFlow
//
//  Created by John Saba on 3/20/14.
//
//

#import "CCSprite+PFLEffects.h"
#import "cocos2d.h"

@implementation CCSprite (PFLEffects)

- (void)backlight:(CGFloat)beatDuration completion:(void (^)(void))completion
{
  [self stopAllActions];
  self.scale = 1.0f;
  
  CCActionFadeOut* fadeOut = [CCActionFadeOut actionWithDuration:beatDuration * 2.0f];
  [self runAction:[CCActionEaseSineOut actionWithAction:fadeOut]];

  CCActionScaleTo* scaleUp = [CCActionScaleTo actionWithDuration:beatDuration * 2.0f scale:self.scale + 0.5f];
  CCActionEaseSineOut *easeUp = [CCActionEaseSineOut actionWithAction:scaleUp];
  
  CCActionCallBlock* resetScale = [CCActionCallBlock actionWithBlock:^{
    self.scale = 1.0f;
  }];
  
  CCActionCallBlock* completionAction = [CCActionCallBlock actionWithBlock:^{
    if (completion) {
      completion();
    }
  }];
  
  [self runAction:[CCActionSequence actionWithArray:@[easeUp, resetScale, completionAction]]];
}

@end