//
//  MainSynth.m
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "PFLAudioEventController.h"
#import "PFLPuzzleLayer.h"
#import "PFLEvent.h"

@interface PFLAudioEventController ()

@property (strong, nonatomic) NSMutableDictionary *sampleKey;

@end

@implementation PFLAudioEventController

+ (PFLAudioEventController *)audioEventController
{
  return [[self alloc] init];
}

+ (void)mute:(BOOL)mute
{
    CCLOG(@"mute needs implementation");
}

#pragma mark - SoundEventReveiver

- (void)loadSamples:(NSArray *)samples
{
  for (NSString *sampleName in samples)
  {
    [[OALSimpleAudio sharedInstance] preloadEffect:sampleName];
  }
}

- (void)receiveEvents:(NSArray*)events
{
  if ((events == nil) || (events.count < 1))
  {
    CCLOG(@"no events sent to synth");
    return;
  }

  for (PFLEvent* event in events)
  {
    if (event.eventType == PFLEventTypeSynth)
    {
      NSNumber* midiValue = @([event.midiValue integerValue]);
      // TODO: synth type needs to be an enum on event or basic model
      NSNumber* synthType = @0;
    }
    
    if (event.eventType == PFLEventTypeSample)
    {
      id sound = [[OALSimpleAudio sharedInstance] playEffect:event.file];
      if (!sound)
      {
        CCLOG(@"Error: sound for sample %@ could not be created", event.file);
      }
    }
    
    if (event.eventType == PFLEventTypeMultiSample)
    {
      // set up samples to be recieved with time delays
      for (PFLEvent* sampleEvent in event.sampleEvents)
      {
        CCActionCallBlock *sampleBlock = [CCActionCallBlock actionWithBlock:^{
            [self receiveEvents:@[sampleEvent]];
        }];
        CCActionDelay* delay = [CCActionDelay actionWithDuration:[sampleEvent.time doubleValue] * self.beatDuration];
        CCActionSequence* seq = [CCActionSequence actionWithArray:@[delay, sampleBlock]];
        [self runAction:seq];
      };
    }
  }
}

@end