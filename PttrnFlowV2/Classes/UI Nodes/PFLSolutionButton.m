//
//  SolutionButton.m
//  PttrnFlow
//
//  Created by John Saba on 1/15/14.
//
//

#import "PFLSolutionButton.h"
#import "PFLColorUtils.h"
#import "PFLGameConstants.h"

@interface PFLSolutionButton ()

@property (weak, nonatomic) id<PFLSolutionButtonDelegate> delegate;
@property (weak, nonatomic) CCSprite* numberSprite;
@property (weak, nonatomic) CCSprite* hitDot;

@end

@implementation PFLSolutionButton

+ (CGFloat)hitOffset
{
  CGSize screenSize = [CCDirector sharedDirector].designSize;
  if ((NSInteger)screenSize.width == PFLIPadDesignWidth)
  {
    return 16.0f;
  }
  else
  {
    return 8.0f;
  }
}

- (id)initWithPlaceholderImage:(NSString*)placeholderImage size:(CGSize)size index:(NSInteger)index defaultColor:(CCColor*)defaultColor activeColor:(CCColor*)activeColor delegate:(id<PFLSolutionButtonDelegate>)delegate
{
  self = [super initWithImageNamed:placeholderImage];
  if (self)
  {
    self.userInteractionEnabled = YES;
    self.contentSize = size;
    self.index = index;
    self.delegate = delegate;
    
    // dot that will appear and fade out when hit
    CCSprite *hitDot = [CCSprite spriteWithImageNamed:@"numButtonHighlight.png"];
    self.hitDot = hitDot;
    hitDot.color = activeColor;
    hitDot.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    hitDot.opacity = 0;
    [self addChild:hitDot];
    
    CCSprite *numberSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"numButton%i.png", index + 1]];
    self.numberSprite = numberSprite;
    numberSprite.color = defaultColor;
    numberSprite.position = ccp(size.width / 2.0f, size.height / 2.0f);
    [self addChild:numberSprite];
  }
  return self;
}

- (void)press
{
  self.hitDot.position = self.numberSprite.position;
  CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1];
  [self.hitDot runAction:fadeOut];
  [self.delegate solutionButtonPressed:self];
}

- (void)animateCorrectHit:(BOOL)correct
{
  CGFloat  offset = -[PFLSolutionButton hitOffset];
  if (correct)
  {
    offset *= -1.0f;
  }

  CCActionMoveTo *buttonMoveTo = [CCActionMoveTo actionWithDuration:1.0f position:ccp(self.numberSprite.position.x, (self.contentSize.height / 2) + offset)];
  CCActionEaseElasticOut *buttonEase = [CCActionEaseElasticOut actionWithAction:buttonMoveTo];
  [self.numberSprite runAction:buttonEase];
  self.isDisplaced = YES;
}

- (void)reset
{
  [self.numberSprite stopAllActions];
  self.numberSprite.position = ccp(self.numberSprite.position.x, self.numberSprite.contentSize.height / 2);
  self.isDisplaced = NO;
}

#pragma mark - Touch

- (void)touchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self press];
}

@end
