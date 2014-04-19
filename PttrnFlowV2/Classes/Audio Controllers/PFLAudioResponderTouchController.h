//
//  PFLAudioResponderTouchController.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "PFLAudioResponder.h"
#import "PFLScrollNode.h"

@class PFLAudioEventController;

FOUNDATION_EXPORT NSString* const kPFLAudioTouchDispatcherCoordKey;
FOUNDATION_EXPORT NSString* const kPFLAudioTouchDispatcherHitNotification;

@interface PFLAudioResponderTouchController : CCNode <PFLScrollNodeDelegate>

@property BOOL allowScrolling;
@property (strong, nonatomic) NSArray* areaCells;

- (id)initWithBeatDuration:(CGFloat)duration audioEventController:(PFLAudioEventController*)audioEventController;
- (void)addResponder:(id<PFLAudioResponder>)responder;
- (void)clearResponders;

@end
