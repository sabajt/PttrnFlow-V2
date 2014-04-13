//
//  PFLAudioResponderTouchController.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "PFLAudioResponder.h"
#import "PFLScrollNode.h"

FOUNDATION_EXPORT NSString *const kPFLAudioTouchDispatcherCoordKey;
FOUNDATION_EXPORT NSString *const kPFLAudioTouchDispatcherHitNotification;

@interface PFLAudioResponderTouchController : CCNode <PFLScrollNodeDelegate>

@property BOOL allowScrolling;
@property (strong, nonatomic) NSArray *areaCells;

- (id)initWithBeatDuration:(CGFloat)duration;
- (void)addResponder:(id<PFLAudioResponder>)responder;
- (void)clearResponders;

@end
