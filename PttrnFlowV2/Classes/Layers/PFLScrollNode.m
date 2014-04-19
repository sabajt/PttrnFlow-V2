//
//  PFLScrollLayer.m
//  PttrnFlow
//
//  Created by John Saba on 1/24/14.
//
//  Adapted with changes from: http://www.sidebolt.com/simulating-uiscrollview-in-cocos2d/

#import "PFLScrollNode.h"
#import "CCNode+PFLRecursiveTouch.h"

static CGFloat const kClipSpeed = 0.25f;
static CGFloat const kDefaultCancelDelegateTouchDistance = 10.0f;

@interface PFLScrollNode ()

@property (strong, nonatomic) NSMutableArray *scrollDelegates;

@property BOOL hasCancelledDelegateTouch;
@property BOOL isTouching;

@property CGPoint lastTouchPosition;
@property CGPoint startingTouchPosition;
@property CGPoint unfilteredVelocity;
@property CGPoint velocity;

@end

@implementation PFLScrollNode

- (id)init
{
  self = [super init];
  if (self)
  {
    self.userInteractionEnabled = YES;
    self.allowsScrollHorizontal = YES;
    self.allowsScrollVertical = YES;
    self.cancelDelegateTouchDistance = kDefaultCancelDelegateTouchDistance;
    self.scrollDelegates = [NSMutableArray array];
  }
  return self;
}

- (void)addScrollDelegate:(id<PFLScrollNodeDelegate>)delegate
{
  [self.scrollDelegates addObject:delegate];
}

- (CGFloat)elasticPull:(CGFloat)distance
{
  // adapted from http://squareb.wordpress.com/2013/01/06/31/
  // not calculating anything based on screen or container size
  // just using constants for consistent feel
  return (1.0f - (1.0f / ((distance * 0.30f / 900.0f) + 1.0f))) * 900.f;
}

- (void)clipVelocity
{
  // stop after min value
  if (fabsf(self.velocity.x) < kClipSpeed)
  {
    self.velocity = ccp(0.0f, self.velocity.y);
  }
  if (fabsf(self.velocity.y) < kClipSpeed)
  {
    self.velocity = ccp(self.velocity.x, 0.0f);
  }
}

- (void)update:(CCTime)dt
{
  for (id<PFLScrollNodeDelegate> scrollDelegate in self.scrollDelegates)
  {
    if ([scrollDelegate respondsToSelector:@selector(shouldScroll)] && ![scrollDelegate shouldScroll])
    {
      self.velocity = CGPointZero;
      self.unfilteredVelocity = CGPointZero;
      
      return;
    }
  }
  
  if (self.isTouching)
  {
    const float kFilterAmount = 0.25f;
    CGFloat xVelocity = (self.velocity.x * kFilterAmount) + (self.unfilteredVelocity.x * (1.0f - kFilterAmount));
    CGFloat yVelocity = (self.velocity.y * kFilterAmount) + (self.unfilteredVelocity.y * (1.0f - kFilterAmount));
    self.velocity = ccp(xVelocity, yVelocity);
    self.unfilteredVelocity = CGPointZero;
    [self clipVelocity];
    
    return;
  }
  
  // calculate elastic momentum while not touching
  CGPoint minPos = self.positionInPoints;
  CGPoint maxPos = ccp(self.positionInPoints.x + self.contentSizeInPoints.width, self.positionInPoints.y + self.contentSizeInPoints.height);
  static CGFloat elasticDecay = 0.6f;
  BOOL hasDecayX = YES;
  BOOL hasDecayY = YES;

  if ((minPos.x > self.scrollBoundsInPoints.origin.x) &&
      self.allowsScrollHorizontal)
  {
    hasDecayX = NO;
    if (self.velocity.x > kClipSpeed)
    {
      self.velocity = ccp(self.velocity.x * elasticDecay, self.velocity.y);
    }
    else
    {
      CGFloat distance = minPos.x - self.scrollBoundsInPoints.origin.x;
      CGFloat dx = -[self elasticPull:distance];
      self.velocity = ccp(dx, self.velocity.y);
    }
  }
  if ((minPos.y > self.scrollBoundsInPoints.origin.y) &&
      self.allowsScrollVertical)
  {
    hasDecayY = NO;
    if (self.velocity.y > kClipSpeed)
    {
      self.velocity = ccp(self.velocity.x, self.velocity.y * elasticDecay);
    }
    else
    {
      CGFloat distance = minPos.y - self.scrollBoundsInPoints.origin.y;
      CGFloat dy = -[self elasticPull:distance];
      self.velocity = ccp(self.velocity.x, dy);
    }
  }
  if ((maxPos.x < self.scrollBoundsInPoints.origin.x + self.scrollBoundsInPoints.size.width) &&
      self.allowsScrollHorizontal)
  {
    hasDecayX = NO;
    if (self.velocity.x < -kClipSpeed)
    {
      self.velocity = ccp(self.velocity.x * elasticDecay, self.velocity.y);
    }
    else
    {
      CGFloat distance = (self.scrollBoundsInPoints.origin.x + self.scrollBoundsInPoints.size.width) - maxPos.x;
      CGFloat dx = [self elasticPull:distance];
      self.velocity = ccp(dx, self.velocity.y);
    }
  }
  if ((maxPos.y < self.scrollBoundsInPoints.origin.y + self.scrollBoundsInPoints.size.height) &&
      self.allowsScrollVertical)
  {
    hasDecayY = NO;
    if (self.velocity.y < -kClipSpeed)
    {
      self.velocity = ccp(self.velocity.x, self.velocity.y * elasticDecay);
    }
    else
    {
      CGFloat distance = (self.scrollBoundsInPoints.origin.y + self.scrollBoundsInPoints.size.height) - maxPos.y;
      CGFloat dy = [self elasticPull:distance];
      self.velocity = ccp(self.velocity.x, dy);
    }
  }

  static CGFloat decayValue = 0.9f;
  if (hasDecayX)
  {
    self.velocity = ccp(self.velocity.x * decayValue, self.velocity.y);
  }
  if (hasDecayY)
  {
    self.velocity = ccp(self.velocity.x, self.velocity.y * decayValue);
  }
  [self clipVelocity];
  
  CGPoint positionInPoints = ccpAdd(self.positionInPoints, self.velocity);
  if (self.positionType.xUnit == CCPositionUnitNormalized && self.positionType.yUnit == CCPositionUnitNormalized)
  {
    self.position = ccp(positionInPoints.x / self.contentSizeInPoints.width, positionInPoints.y / self.contentSizeInPoints.height);
  }
  else if (self.positionType.xUnit == CCPositionUnitPoints && self.positionType.yUnit == CCPositionUnitPoints)
  {
    self.position = positionInPoints;
  }
  else
  {
    CCLOG(@"Warning: scroll node has unsupported position type");
  }
}

#pragma mark - CCResponder

- (void)touchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
  if (self.isTouching)
  {
    return;
  }
  
  CGPoint touchPosition = [touch locationInWorld];
  
  self.lastTouchPosition = touchPosition;
  self.startingTouchPosition = touchPosition;
  self.isTouching = YES;
  self.hasCancelledDelegateTouch = NO;
}

- (void)touchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
  for (id<PFLScrollNodeDelegate> scrollDelegate in self.scrollDelegates)
  {
    if ([scrollDelegate respondsToSelector:@selector(shouldScroll)] && ![scrollDelegate shouldScroll])
    {
      self.velocity = CGPointZero;
      self.unfilteredVelocity = CGPointZero;
      
      return;
    }
  }
  
  CGPoint currentTouch = [touch locationInWorld];
  
  if ((fabsf(currentTouch.x - self.startingTouchPosition.x) > self.cancelDelegateTouchDistance ||
      fabsf(currentTouch.y - self.startingTouchPosition.y) > self.cancelDelegateTouchDistance) &&
      !self.hasCancelledDelegateTouch)
  {
    for (id<PFLScrollNodeDelegate> scrollDelegate in self.scrollDelegates)
    {
      if ([scrollDelegate respondsToSelector:@selector(cancelTouch)])
      {
        [scrollDelegate cancelTouch];
      }
    }
    self.hasCancelledDelegateTouch = YES;
  }
  
  // calculate elastic drag while touching

  self.unfilteredVelocity = ccp(currentTouch.x - self.lastTouchPosition.x, currentTouch.y - self.lastTouchPosition.y);
  self.lastTouchPosition = currentTouch;
  
  CGPoint minPos = self.positionInPoints;
  CGPoint maxPos = ccp(self.positionInPoints.x + self.contentSizeInPoints.width, self.positionInPoints.y + self.contentSizeInPoints.height);
  CGFloat strech = 20.0f;
  
  if ((minPos.x > self.scrollBoundsInPoints.origin.x) &&
      (self.unfilteredVelocity.x > kClipSpeed))
  {
    CGFloat distance = minPos.x - self.scrollBoundsInPoints.origin.x;
    CGFloat dx = [self elasticPull:distance];
    CGFloat normalized = 1.0f - (dx / strech);
    self.unfilteredVelocity = ccp(self.unfilteredVelocity.x * normalized, self.unfilteredVelocity.y);
  }
  if ((minPos.y > self.scrollBoundsInPoints.origin.y) &&
      (self.unfilteredVelocity.y > kClipSpeed))
  {
    CGFloat distance = minPos.y - self.scrollBoundsInPoints.origin.y;
    CGFloat dy = [self elasticPull:distance];
    CGFloat normalized = 1.0f - (dy / strech);
    self.unfilteredVelocity = ccp(self.unfilteredVelocity.x, self.unfilteredVelocity.y * normalized);
  }
  if ((maxPos.x < self.scrollBoundsInPoints.origin.x + self.scrollBoundsInPoints.size.width) &&
      (self.unfilteredVelocity.x < -kClipSpeed))
  {
    CGFloat distance = (self.scrollBoundsInPoints.origin.x + self.scrollBoundsInPoints.size.width) - maxPos.x;
    CGFloat dx = [self elasticPull:distance];
    CGFloat normalized = 1.0f - (dx / strech);
    self.unfilteredVelocity = ccp(self.unfilteredVelocity.x  * normalized, self.unfilteredVelocity.y);
  }
  if ((maxPos.y < self.scrollBoundsInPoints.origin.y + self.scrollBoundsInPoints.size.height) &&
      (self.unfilteredVelocity.y < -kClipSpeed))
  {
    CGFloat distance = (self.scrollBoundsInPoints.origin.y + self.scrollBoundsInPoints.size.height) - maxPos.y;
    CGFloat dy = [self elasticPull:distance];
    CGFloat normalized = 1.0f - (dy / strech);
    self.unfilteredVelocity = ccp(self.unfilteredVelocity.x, self.unfilteredVelocity.y  * normalized);
  }

  if (!self.allowsScrollHorizontal)
  {
    self.unfilteredVelocity = ccp(0.0f, self.unfilteredVelocity.y);
  }
  if (!self.allowsScrollVertical)
  {
    self.unfilteredVelocity = ccp(self.unfilteredVelocity.x, 0.0f);
  }
  
  CGPoint positionInPoints = ccpAdd(self.positionInPoints, self.unfilteredVelocity);
  if (self.positionType.xUnit == CCPositionUnitNormalized && self.positionType.yUnit == CCPositionUnitNormalized)
  {
    self.position = ccp(positionInPoints.x / self.contentSizeInPoints.width, positionInPoints.y / self.contentSizeInPoints.height);
  }
  else if (self.positionType.xUnit == CCPositionUnitPoints && self.positionType.yUnit == CCPositionUnitPoints)
  {
    self.position = positionInPoints;
  }
  else
  {
    CCLOG(@"Warning: scroll node has unsupported position type");
  }
}

- (void)touchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.isTouching = NO;
}

- (void)touchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
  self.isTouching = NO;
}

- (BOOL)hitTestWithWorldPos:(CGPoint)pos
{
  if (self.ignoreTouchBounds)
  {
    return YES;
  }
  else
  {
    return [super hitTestWithWorldPos:pos];
  }
}

@end
