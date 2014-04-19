//
//  PFLScrollLayer.h
//  PttrnFlow
//
//  Created by John Saba on 1/24/14.
//
//

#import "cocos2d.h"

@protocol PFLScrollNodeDelegate <NSObject>
@optional
// Implement if delegate should cancel its touch after scroll node has moved cancelDelegateTouchDistance
- (void)cancelTouch;
// Implement to allow delegate to stop our scrolling
- (BOOL)shouldScroll;
@end

@interface PFLScrollNode : CCNode

@property BOOL allowsScrollHorizontal;
@property BOOL allowsScrollVertical;
@property CGFloat cancelDelegateTouchDistance;
@property BOOL ignoreTouchBounds;
@property CGRect scrollBoundsInPoints;

- (void)addScrollDelegate:(id<PFLScrollNodeDelegate>)delegate;

@end
