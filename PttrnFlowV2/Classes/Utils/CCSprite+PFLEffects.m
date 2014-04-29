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
  CCActionScaleTo* scaleUp = [CCActionScaleTo actionWithDuration:beatDuration * 2.0f scale:self.scale + 0.5f];
  CCActionEaseSineOut* backlightAnimations = [CCActionEaseSineOut actionWithAction:[CCActionSpawn actionWithArray:@[fadeOut, scaleUp]]];
  
  CCActionCallBlock* resetScale = [CCActionCallBlock actionWithBlock:^{
    self.scale = 1.0f;
  }];
  
  CCActionCallBlock* completionAction = [CCActionCallBlock actionWithBlock:^{
    if (completion) {
      completion();
    }
  }];
  
  [self runAction:[CCActionSequence actionWithArray:@[backlightAnimations, resetScale, completionAction]]];
}

- (void)backlightRotate:(CGFloat)beatDuration completion:(void (^)(void))completion
{
  [self stopAllActions];
  self.scale = 1.0f;
  
  CCActionFadeOut* fadeOut = [CCActionFadeOut actionWithDuration:beatDuration * 2.0f];
  CCActionScaleTo* scaleUp = [CCActionScaleTo actionWithDuration:beatDuration * 2.0f scale:self.scale + 0.5f];
  CCActionRotateBy* rotate = [CCActionRotateBy actionWithDuration:beatDuration * 2.0f angle:360.0f];
  CCActionEaseSineOut* backlightAnimations = [CCActionEaseSineOut actionWithAction:[CCActionSpawn actionWithArray:@[fadeOut, scaleUp, rotate]]];
  
  CCActionCallBlock* resetScale = [CCActionCallBlock actionWithBlock:^{
    self.scale = 1.0f;
  }];
  
  CCActionCallBlock* completionAction = [CCActionCallBlock actionWithBlock:^{
    if (completion) {
      completion();
    }
  }];
  
  [self runAction:[CCActionSequence actionWithArray:@[backlightAnimations, resetScale, completionAction]]];
}

@end