//
//  SequenceMenuCell.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLPuzzleSetCell.h"
#import "PFLColorUtils.h"

@interface PFLPuzzleSetCell ()

@property (assign) NSInteger index;

@end


@implementation PFLPuzzleSetCell

-(id) initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(320, 50);
        self.userInteractionEnabled = YES;
        _index = index;
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", index + 1] fontName:@"Helvetica" fontSize:40];
        label.color = [CCColor blackColor];
        label.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:label];
    }
    return self;
}

//#pragma mark - TouchNodeDelegate
//
//- (BOOL)containsTouch:(UITouch *)touch
//{
//    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
//    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
//    return (CGRectContainsPoint(rect, touchPosition));
//}

#pragma mark CCResponder

// Must override touchBegan to recieve touchEnded (cocos2d v3 bug?)
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.propogateTouch) {
        [self.parent touchBegan:touch withEvent:event];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.propogateTouch) {
        [self.parent touchMoved:touch withEvent:event];
    }
}

//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.propogateTouch) {
        [self.parent touchEnded:touch withEvent:event];
    }
    
    if ([self hitTestWithWorldPos:[touch locationInWorld]]) {
        [self.menuCellDelegate puzzleSetCellTouchUpInside:self index:self.index];
    }
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.propogateTouch) {
        [self.parent touchCancelled:touch withEvent:event];
    }
}

@end
