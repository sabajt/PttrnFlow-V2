//
//  ToggleButton.m
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "PFLToggleButton.h"
#import "PFLGeometry.h"

@interface PFLToggleButton ()

// using different sprites for on / off state
@property (weak, nonatomic) CCSprite *offSprite;
@property (weak, nonatomic) CCSprite *onSprite;

// using tint colors with one sprite for on / off state
@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;

@end

@implementation PFLToggleButton

- (id)initWithImage:(NSString*)image defaultColor:(CCColor*)defaultColor activeColor:(CCColor*)activeColor target:(id)target
{
  self = [super initWithImageNamed:image];
  if (self)
  {
    self.userInteractionEnabled = YES;
    self.target = target;
    self.defaultColor = defaultColor;
    self.activeColor = activeColor;
    self.color = defaultColor;
  }
  return self;
}

- (void)callSelectorNamed:(NSString*)selectorName
{
  // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
  SEL selector = NSSelectorFromString(selectorName);
  IMP imp = [self.target methodForSelector:selector];
  void (*func)(id, SEL) = (void*)imp;
  func(self.target, selector);
}

- (void)toggle
{
  [self toggleIgnoringTarget:NO];
}

- (void)toggleIgnoringTarget:(BOOL)ignoringTarget
{
  self.isOn = !self.isOn;
  
  if (self.offSprite)
  {
    self.offSprite.visible = !self.isOn;
    self.onSprite.visible = self.isOn;
  }
  else
  {
    if (self.isOn)
    {
      self.color = self.activeColor;
    }
    else
    {
      self.color = self.defaultColor;
    }
  }
  
  if (!ignoringTarget && self.target && self.touchBeganSelectorName)
  {
    [self callSelectorNamed:self.touchBeganSelectorName];
  }
}

#pragma mark - CCTargetedTouchDelegate

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self toggle];
}

@end
