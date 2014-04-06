//
//  PFLAudioResponderTouchController.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "PFLAudioResponder.h"
#import "PFLScrollLayer.h"

FOUNDATION_EXPORT NSString *const kPFLAudioTouchDispatcherCoordKey;
FOUNDATION_EXPORT NSString *const kPFLAudioTouchDispatcherHitNotification;

@interface PFLAudioResponderTouchController : CCNode <ScrollLayerDelegate>

@property (assign) BOOL allowScrolling;
@property (strong, nonatomic) NSArray *areaCells;

- (id)initWithBeatDuration:(CGFloat)duration;
- (void)addResponder:(id<PFLAudioResponder>)responder;
- (void)clearResponders;

@end
