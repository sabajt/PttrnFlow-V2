//
//  PFLAudioResponder.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import <Foundation/Foundation.h>
#import "PFLCoord.h"

@class PFLEvent;

@protocol PFLAudioResponder <NSObject>

@optional

// Any responder on the board must have a cell
- (PFLCoord*)audioResponderCell;
- (void)setAudioResponderCell:(PFLCoord*)coord;

// Triggered on touch down or step
// Handle glyph actions here, like highlighting / animation
// Responder may return and event to be processed as sound, or sequence logic
- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration;

// Triggered after touch up or after a step
- (NSArray*)audioResponderRelease:(NSInteger)bpm;

// For use with puzzle states
- (NSNumber*)audioResponderID;
- (void)audioResponderSwitchToState:(NSNumber*)state animated:(BOOL)animated senderCell:(PFLCoord*)senderCell;

@end
