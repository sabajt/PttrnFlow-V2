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

FOUNDATION_EXPORT NSString* const PFLForwardTouchControllerMovedNotification;
FOUNDATION_EXPORT NSString* const PFLForwardTouchControllerEndedNotification;
FOUNDATION_EXPORT NSString* const PFLForwardTouchControllerTouchKey;

@protocol PFLAudioResponderTouchControllerDelegate <NSObject>

- (void)glyphNodeDraggedOffBoardFromCell:(PFLCoord*)cell;

@end

@protocol PFLControlEntryDelegate <NSObject>

- (void)startUserSequence;
- (void)stopUserSequence;

@end

@interface PFLAudioResponderTouchController : CCNode <PFLScrollNodeDelegate>

@property (weak, nonatomic) id<PFLAudioResponderTouchControllerDelegate> touchControllerDelegate;
@property (weak, nonatomic) id<PFLControlEntryDelegate> controlEntryDelegate;

@property BOOL allowScrolling;
@property (strong, nonatomic) NSArray* areaCells;

- (id)initWithBeatDuration:(CGFloat)duration audioEventController:(PFLAudioEventController*)audioEventController;
- (void)addResponder:(id<PFLAudioResponder>)responder;
- (void)removeResponder:(id<PFLAudioResponder>)responder;
- (void)clearResponders;

@end
