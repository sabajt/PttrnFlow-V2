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

+ (id)synthEventWithAudioID:(NSNumber *)audioID puzzleFile:(NSString *)puzzleFile midiValue:(NSString *)midiValue synthType:(NSString *)synthType
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeSynth];
  event.audioID = audioID;
  event.midiValue = midiValue;
  event.synthType = synthType;
  event.puzzleFile = puzzleFile;
  return event;
}

+ (id)sampleEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString *)puzzleFile sampleFile:(NSString *)sampleFile time:(NSNumber *)time
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeSample];
  event.audioID = audioID;
  event.sampleFile = sampleFile;
  event.time = time;
  event.puzzleFile = puzzleFile;
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

+ (id)audioStopEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString *)puzzleFile
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = PFLEventTypeAudioStop;
  event.audioID = audioID;
  event.puzzleFile = puzzleFile;
  return event;
}

+ (id)multiSampleEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString *)puzzleFile sampleEvents:(NSArray *)sampleEvents
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeMultiSample];
  event.audioID = audioID;
  event.sampleEvents = sampleEvents;
  event.puzzleFile = puzzleFile;
  return event;
}

+ (id)multiSampleEventWithAudioID:(NSNumber*)audioID puzzleFile:(NSString *)puzzleFile multiSample:(PFLMultiSample *)multiSample
{
  NSMutableArray* sampleEvents = [NSMutableArray array];
  for (PFLSample* sample in multiSample.samples)
  {
    PFLEvent* sampleEvent = [PFLEvent sampleEventWithAudioID:audioID puzzleFile:puzzleFile sampleFile:sample.file time:sample.time];
    [sampleEvents addObject:sampleEvent];
  }
  return [PFLEvent multiSampleEventWithAudioID:audioID puzzleFile:puzzleFile sampleEvents:[NSArray arrayWithArray:sampleEvents]];
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

+ (id)warpEventWithWarpChannel:(NSNumber*)warpChannel
{
  PFLEvent* event = [[PFLEvent alloc] init];
  event.eventType = [NSNumber numberWithInteger:PFLEventTypeWarp];
  event.warpChannel = warpChannel;
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
    self.midiValue = [aDecoder decodeObjectForKey:@"midiValue"];
    self.puzzleFile = [aDecoder decodeObjectForKey:@"puzzleFile"];
    self.sampleFile = [aDecoder decodeObjectForKey:@"sampleFile"];
    self.sampleEvents = [aDecoder decodeObjectForKey:@"sampleEvents"];
    self.switchSenderChannel = [aDecoder decodeObjectForKey:@"switchSenderChannel"];
    self.synthType = [aDecoder decodeObjectForKey:@"synthType"];
    self.time = [aDecoder decodeObjectForKey:@"time"];
    self.warpChannel = [aDecoder decodeObjectForKey:@"warpChannel"];
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.eventType forKey:@"eventType"];
  [aCoder encodeObject:self.audioID forKey:@"audioID"];
  [aCoder encodeObject:self.direction forKey:@"direction"];
  [aCoder encodeObject:self.midiValue forKey:@"midiValue"];
  [aCoder encodeObject:self.puzzleFile forKey:@"puzzleFile"];
  [aCoder encodeObject:self.sampleFile forKey:@"sampleFile"];
  [aCoder encodeObject:self.sampleEvents forKey:@"sampleEvents"];
  [aCoder encodeObject:self.switchSenderChannel forKey:@"switchSenderChannel"];
  [aCoder encodeObject:self.synthType forKey:@"synthType"];
  [aCoder encodeObject:self.time forKey:@"time"];
  [aCoder encodeObject:self.warpChannel forKey:@"warpChannel"];
}

#pragma mark - Accesors

- (void)setDelegate:(id<PFLEventDelegate>)delegate
{
  _delegate = delegate;
  
  if ([self.sampleEvents count] > 0)
  {
    for (PFLEvent* event in self.sampleEvents)
    {
      event.delegate = self.delegate;
    }
  }
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