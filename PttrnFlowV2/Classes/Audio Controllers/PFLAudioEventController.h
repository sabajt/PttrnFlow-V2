//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "cocos2d.h"

@interface PFLAudioEventController : CCNode <AVAudioPlayerDelegate>

@property CGFloat beatDuration;
@property BOOL mute;

+ (PFLAudioEventController*)audioEventController;

- (void)loadSamples:(NSArray*)samples;
- (void)receiveEvents:(NSArray*)events;

@end
