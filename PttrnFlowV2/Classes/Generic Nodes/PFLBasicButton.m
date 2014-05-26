//
//  BasicButton.m
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "PFLBasicButton.h"
#import "PFLGeometry.h"
#import "CCDirector.h"

@interface PFLBasicButton ()

@property (weak, nonatomic) CCSprite *offSprite;
@property (weak, nonatomic) CCSprite *onSprite;
@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;
@property BOOL useColor;

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

- (void)highlightUI:(BOOL)shouldHighlight
{
  if (self.offSprite && self.onSprite)
  {
    self.offSprite.visible = !shouldHighlight;
    self.onSprite.visible = shouldHighlight;
  }
  
  if (self.useColor)
  {
    if (shouldHighlight)
    {
      self.color = self.activeColor;
    }
    else
    {
      self.color = self.defaultColor;
    }
  }
}

#pragma mark -

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self highlightUI:YES];
  
  if (self.target && self.touchBeganSelectorName)
  {
    [self callSelectorNamed:self.touchBeganSelectorName];
  }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint worldTouchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[CCDirector sharedDirector].view]];
  if (![self hitTestWithWorldPos:worldTouchLocation])
  {
    [self highlightUI:NO];
  }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self highlightUI:NO];
  
  CGPoint worldTouchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[CCDirector sharedDirector].view]];
  if ([self hitTestWithWorldPos:worldTouchLocation] && self.target && self.touchEndedSelectorName)
  {
    [self callSelectorNamed:self.touchEndedSelectorName];
  }
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self highlightUI:NO];
}

@end