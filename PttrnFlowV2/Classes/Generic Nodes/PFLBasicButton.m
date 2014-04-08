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
@property (weak, nonatomic) id<BasicButtonDelegate> delegate;
@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;
@property (assign) BOOL useColor;

@end

@implementation PFLBasicButton

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName
                      offFrameName:(NSString *)offFrameName
                       onFrameName:(NSString *)onFrameName
                          delegate:(id<BasicButtonDelegate>)delegate
{
    self = [super initWithImageNamed:placeholderFrameName];
    if (self) {
        self.delegate = delegate;
        
        CCSprite *offSprite = [CCSprite spriteWithImageNamed:offFrameName];
        self.offSprite = offSprite;
        CCSprite *onSprite = [CCSprite spriteWithImageNamed:onFrameName];
        self.onSprite = onSprite;
        
        // minimum size to contain both sprites
        self.contentSize = CGContainingSize(offSprite.contentSize, onSprite.contentSize);
        
        offSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:offSprite];
        
        onSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:onSprite];
        onSprite.visible = NO;
    }
    return self;
}

- (id)initWithImage:(NSString *)image defaultColor:(CCColor*)defaultColor activeColor:(CCColor*)activeColor delegate:(id<BasicButtonDelegate>)delegate
{
    self = [super initWithImageNamed:image];
    if (self) {
        self.delegate = delegate;
        self.defaultColor = defaultColor;
        self.activeColor = activeColor;
        self.color = defaultColor;
        self.useColor = YES;
    }
    return self;
}

//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
//    if ([super ccTouchBegan:touch withEvent:event]) {
        if (self.offSprite && self.onSprite) {
            self.offSprite.visible = NO;
            self.onSprite.visible = YES;
        }
        if (self.useColor) {
            self.color = self.activeColor;
        }
//        return YES;
//    }
//    return NO;
}

//- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
//    [super ccTouchMoved:touch withEvent:event];
//    
//    BOOL containsTouch = [self containsTouch:touch];
//    
//    if (self.offSprite && self.onSprite) {
//        self.offSprite.visible = !containsTouch;
//        self.onSprite.visible = containsTouch;
//    }
//    if (self.useColor) {
//        if (containsTouch) {
//            self.color = self.activeColor;
//        }
//        else {
//            self.color = self.defaultColor;
//        }
//    }
}

//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//    [super ccTouchEnded:touch withEvent:event];
    
    if (self.offSprite && self.onSprite) {
        self.offSprite.visible = YES;
        self.onSprite.visible = NO;
    }
    
    if (self.useColor) {
        self.color = self.defaultColor;
    }
    
//    if ([self containsTouch:touch]) {
        [self.delegate basicButtonPressed:self];
//    }
}

//- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
//    [super ccTouchCancelled:touch withEvent:event];
    
    self.offSprite.visible = YES;
    self.onSprite.visible = NO;
}

@end