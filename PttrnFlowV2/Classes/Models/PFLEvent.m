//
//  PFLEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"
#import "PFLEvent.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"

NSString *const kChannelNone = @"ChannelNone";

@implementation NSArray (PFLEvent)

- (NSArray*)audioEvents
{
  NSMutableArray* filtered = [NSMutableArray array];
  for (PFLEvent* event in self)
  {
    if ([event isKindOfClass:[PFLEvent class]] && event.audioID)
    {
      [filtered addObject:event];
    }
  }
  return [NSArray arrayWithArray:filtered];
}

@end

@interface PFLEvent ()

@end

@implementation PFLEvent

#pragma mark - constructors

+ (id)synthEventWithAudioID:(NSNumber *)audioID midiValue:(NSString *)midiValue synthType:(NSString*)synthType
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeSynth];
  event.audioID = audioID;
  event.midiValue = midiValue;
  event.synthType = synthType;
  return event;
}

+ (id)sampleEventWithAudioID:(NSNumber*)audioID file:(NSString*)file time:(NSNumber*)time
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeSample];
  event.audioID = audioID;
  event.file = file;
  event.time = time;
  return event;
}

+ (id)directionEventWithDirection:(NSString *)direction
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeDirection];
  event.direction = direction;
  return event;
}

+ (id)exitEvent
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeExit];
  return event;
}

+ (id)audioStopEventWithAudioID:(NSNumber*)audioID
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = PFLEventTypeAudioStop;
  event.audioID = audioID;
  return event;
}

+ (id)multiSampleEventWithAudioID:(NSNumber*)audioID sampleEvents:(NSArray*)sampleEvents
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeMultiSample];
  event.audioID = audioID;
  event.sampleEvents = sampleEvents;
  return event;
}

+ (id)multiSampleEventWithAudioID:(NSNumber*)audioID multiSample:(PFLMultiSample*)multiSample
{
  NSMutableArray* sampleEvents = [NSMutableArray array];
  for (PFLSample* sample in multiSample.samples)
  {
    PFLEvent* sampleEvent = [PFLEvent sampleEventWithAudioID:audioID file:sample.file time:sample.time];
    [sampleEvents addObject:sampleEvent];
  }
  return [PFLEvent multiSampleEventWithAudioID:audioID sampleEvents:[NSArray arrayWithArray:sampleEvents]];
}

+ (id)goalEvent
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeGoal];
  return event;
}

+ (id)switchSenderEventWithChannel:(NSNumber*)channel
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeSwitchSender];
  event.switchSenderChannel = channel;
  return event;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self)
  {
    self.eventType = [aDecoder decodeObjectForKey:@"eventType"];
    self.audioID = [aDecoder decodeObjectForKey:@"audioID"];
    self.direction = [aDecoder decodeObjectForKey:@"direction"];
    self.file = [aDecoder decodeObjectForKey:@"file"];
    self.midiValue = [aDecoder decodeObjectForKey:@"midiValue"];
    self.sampleEvents = [aDecoder decodeObjectForKey:@"sampleEvents"];
    self.switchSenderChannel = [aDecoder decodeObjectForKey:@"switchSenderChannel"];
    self.synthType = [aDecoder decodeObjectForKey:@"synthType"];
    self.time = [aDecoder decodeObjectForKey:@"time"];
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.eventType forKey:@"eventType"];
  [aCoder encodeObject:self.audioID forKey:@"audioID"];
  [aCoder encodeObject:self.direction forKey:@"direction"];
  [aCoder encodeObject:self.file forKey:@"file"];
  [aCoder encodeObject:self.midiValue forKey:@"midiValue"];
  [aCoder encodeObject:self.sampleEvents forKey:@"sampleEvents"];
  [aCoder encodeObject:self.switchSenderChannel forKey:@"switchSenderChannel"];
  [aCoder encodeObject:self.synthType forKey:@"synthType"];
  [aCoder encodeObject:self.time forKey:@"time"];
}

#pragma mark - PFLCompareObjectsDelegate

- (BOOL)isEqualToObject:(id)object
{
  if ([object isKindOfClass:[PFLEvent class]])
  {
    PFLEvent* event = (PFLEvent*)object;
    return [self.audioID isEqualToNumber:event.audioID];
  }
  return NO;
}

@end