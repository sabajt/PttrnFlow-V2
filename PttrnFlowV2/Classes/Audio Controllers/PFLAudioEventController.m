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
#import "PFLHudLayer.h"

@interface PFLAudioEventController ()

@property (strong, nonatomic) NSMutableDictionary* sampleKey;

@end

@implementation PFLAudioEventController

+ (PFLAudioEventController *)audioEventController
{
  return [[self alloc] init];
}

- (void)onEnter
{
  [super onEnter];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleToggleMute) name:PFLNotificationToggleMute object:nil];
  
  self.mute = [PFLHudLayer isMuted];
}

- (void)onExit
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  [super onExit];
}

- (void)handleToggleMute
{
  self.mute = [PFLHudLayer isMuted];
}

- (void)loadSamples:(NSArray*)samples
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
    if ([event.eventType integerValue] == PFLEventTypeSample)
    {
      if (!self.mute)
      {
        id sound = [[OALSimpleAudio sharedInstance] playEffect:event.sampleFile];
        if (!sound)
        {
          CCLOG(@"Error: sound for sample %@ could not be created", event.sampleFile);
        }
      }
      
      if (event.delegate)
      {
        [event.delegate eventFired:event];
      }
    }
    
    if ([event.eventType integerValue] == PFLEventTypeMultiSample)
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
      
      // no need to call eventFired: (yet) on multisample, we just want the sample sub events to call eventFired:
    }
    
  }
}

@end