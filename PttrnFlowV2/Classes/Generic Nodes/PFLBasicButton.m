//
//  BasicButton.m
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "PFLBasicButton.h"
#import "PFLGeometry.h"

@interface PFLBasicButton ()

@property (weak, nonatomic) CCSprite *offSprite;
@property (weak, nonatomic) CCSprite *onSprite;
@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;
@property (assign) BOOL useColor;

@end

@implementation PFLBasicButton

- (id)initWithImage:(NSString *)image defaultColor:(CCColor*)defaultColor activeColor:(CCColor*)activeColor target:(id)target
{
  self = [super initWithImageNamed:image];
  if (self)
  {
    self.userInteractionEnabled = YES;
    self.target = target;
    self.defaultColor = defaultColor;
    self.activeColor = activeColor;
    self.color = defaultColor;
    self.useColor = YES;
  }
  return self;
}

- (void)callSelectorNamed:(NSString*)selectorName
{
  // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
  SEL selector = NSSelectorFromString(selectorName);
  IMP imp = [self.target methodForSelector:selector];
  void (*func)(id, SEL) = (void *)imp;
  func(self.target, selector);
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  if (self.offSprite && self.onSprite)
  {
    self.offSprite.visible = NO;
    self.onSprite.visible = YES;
  }
  if (self.useColor)
  {
    self.color = self.activeColor;
  }
  
  if (self.target && self.touchBeganSelectorName)
  {
    [self callSelectorNamed:self.touchBeganSelectorName];
  }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  if (self.offSprite && self.onSprite)
  {
    self.offSprite.visible = YES;
    self.onSprite.visible = NO;
  }
  
  if (self.useColor)
  {
    self.color = self.defaultColor;
  }
  
  if (self.target && self.touchEndedSelectorName)
  {
    [self callSelectorNamed:self.touchEndedSelectorName];
  }
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
  if (self.offSprite && self.onSprite)
  {
    self.offSprite.visible = YES;
    self.onSprite.visible = NO;
  }
  
  if (self.useColor)
  {
    self.color = self.defaultColor;
  }
}

@end