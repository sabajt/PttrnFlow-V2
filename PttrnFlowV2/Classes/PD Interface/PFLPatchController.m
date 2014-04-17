//
//  MainSynth.m
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "PFLPatchController.h"
#import "PFLPuzzleLayer.h"
#import "PFLEvent.h"

@interface PFLPatchController ()

@property (strong, nonatomic) NSMutableDictionary *sampleKey;

@end

@implementation PFLPatchController

+ (PFLPatchController *)sharedMainSynth
{
    static PFLPatchController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PFLPatchController alloc] init];
    });
    return sharedInstance;
}

+ (void)mute:(BOOL)mute
{
    CCLOG(@"mute needs implementation");
}

#pragma mark - SoundEventReveiver

- (void)loadSamples:(NSArray *)samples
{
    for (NSString *sampleName in samples) {
        [[OALSimpleAudio sharedInstance] preloadEffect:sampleName];
    }
}

- (void)receiveEvents:(NSArray *)events
{
    if ((events == nil) || (events.count < 1)) {
        CCLOG(@"no events sent to synth");
        return;
    }
  
    for (PFLEvent *event in events) {
        
        if (event.eventType == PFLEventTypeSynth) {
            NSNumber *midiValue = @([event.midiValue integerValue]);
            // TODO: synth type needs to be an enum on event or basic model
            NSNumber *synthType = @0;
        }
        
        if (event.eventType == PFLEventTypeSample) {
            id sound = [[OALSimpleAudio sharedInstance] playEffect:event.file];
            if (!sound) {
                CCLOG(@"Error: sound for sample %@ could not be created", event.file);
            }
        }
        
        if(event.eventType == PFLEventTypeMultiSample) {
            
            // set up samples to be recieved with time delays
            for (PFLEvent *sampleEvent in event.sampleEvents) {
                CCActionCallBlock *action = [CCActionCallBlock actionWithBlock:^{
                    [self receiveEvents:@[sampleEvent]];
                }];
                CCActionSequence *seq = [CCActionSequence actions:[CCActionDelay actionWithDuration:[sampleEvent.time floatValue] * self.beatDuration], action, nil];
                [self runAction:seq];
            };
        }
        
        if (event.eventType == PFLEventTypeAudioStop) {;
        }
        
        if (event.eventType == PFLEventTypeExit) {
        }
    }
}

@end