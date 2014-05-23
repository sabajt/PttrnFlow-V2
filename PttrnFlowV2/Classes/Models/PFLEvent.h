//
//  PFLEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "cocos2d.h"
#import "NSArray+PFLCompareObjects.h"

FOUNDATION_EXPORT NSString *const kChannelNone;

typedef NS_ENUM(NSInteger, PFLEventType)
{
  PFLEventTypeAudioStop = 0,
  PFLEventTypeDirection,
  PFLEventTypeExit,
  PFLEventTypeGoal,
  PFLEventTypeMultiSample,
  PFLEventTypeSample,
  PFLEventTypeSwitchSender,
  PFLEventTypeSynth,
};

@class PFLEvent, PFLPuzzle, PFLMultiSample;

@protocol PFLEventDelegate <NSObject>

- (void)eventFired:(PFLEvent*)event;

@end

@interface NSArray (PFLEvent)

- (NSArray *)audioEvents;

@end

@interface PFLEvent : NSObject <PFLCompareObjectsDelegate>

// if delegate is used, must be assigned at runtime ( will not attempt to be archived )
@property (weak, nonatomic) id<PFLEventDelegate> delegate;

@property (strong, nonatomic) NSNumber* audioID;
@property (copy, nonatomic) NSString* direction;
@property (strong, nonatomic) NSNumber* eventType;
@property (copy, nonatomic) NSString* midiValue;
@property (strong, nonatomic) NSString* puzzleFile;
@property (copy, nonatomic) NSString* sampleFile;
@property (strong, nonatomic) NSArray* sampleEvents;
@property (strong, nonatomic) NSNumber* switchSenderChannel;
@property (copy, nonatomic) NSString* synthType;
@property (strong, nonatomic) NSNumber* time;

// Individual event constructors
+ (id)synthEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString*)puzzleFile midiValue:(NSString*)midiValue synthType:(NSString*)synthType;
+ (id)sampleEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString*)puzzleFile sampleFile:(NSString*)sampleFile time:(NSNumber*)time;
+ (id)directionEventWithDirection:(NSString*)direction;
+ (id)exitEvent;
+ (id)audioStopEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString *)puzzleFile;
+ (id)audioStopEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString*)puzzleFile;
+ (id)multiSampleEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString*)puzzleFile sampleEvents:(NSArray*)sampleEvents;
+ (id)multiSampleEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString*)puzzleFile multiSample:(PFLMultiSample*)multiSample;
+ (id)goalEvent;
+ (id)switchSenderEventWithChannel:(NSNumber*)channel;

@end
