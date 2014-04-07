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
- (BOOL)shouldScroll;
@end

@interface PFLScrollNode : CCNode

@property (assign) BOOL allowsScrollHorizontal;
@property (assign) BOOL allowsScrollVertical;
@property (assign) CGRect scrollBounds;
@property (weak, nonatomic) id<PFLScrollNodeDelegate> scrollDelegate;

- (id)initWithSize:(CGSize)size;

@end
