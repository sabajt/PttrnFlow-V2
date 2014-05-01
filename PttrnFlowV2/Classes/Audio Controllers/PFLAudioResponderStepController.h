//
//  PFLAudioResponderStepController.h
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "CCNode.h"
#import "PFLPuzzleControlsLayer.h"
#import "PFLAudioResponder.h"
#import "PFLEntrySprite.h"

@class PFLPuzzle, PFLAudioEventController;

FOUNDATION_EXPORT NSString* const PFLNotificationStartSequence;
FOUNDATION_EXPORT NSString* const PFLNotificationStepSequence;
FOUNDATION_EXPORT NSString* const PFLNotificationEndSequence;

FOUNDATION_EXPORT NSString* const kKeyCoord;
FOUNDATION_EXPORT NSString* const kKeyEmpty;
FOUNDATION_EXPORT NSString* const kKeyInBounds;
FOUNDATION_EXPORT NSString* const kKeyIndex;
FOUNDATION_EXPORT NSString* const kKeyIsCorrect;
FOUNDATION_EXPORT NSString* const kKeyLoop ;

@interface PFLAudioResponderStepController : CCNode <PFLPuzzleControlsDelegate>

@property (weak, nonatomic) PFLEntrySprite* entry;

- (id)initWithPuzzle:(PFLPuzzle*)puzzle audioEventController:(PFLAudioEventController*)audioEventController;
- (void)addResponder:(id<PFLAudioResponder>)responder;
- (void)clearResponders;

@end
