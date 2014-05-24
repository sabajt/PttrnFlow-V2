//
//  SequenceUILayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"
#import "PFLToggleButton.h"

@class PFLAudioEventController, PFLPuzzle;

@protocol PFLPuzzleControlsDelegate <NSObject>

- (void)startUserSequence;
- (void)stopUserSequence;

@end

@interface PFLPuzzleControlsLayer : CCNode <ToggleButtonDelegate>

+ (CGSize)uiButtonUnitSize;

- (id)initWithPuzzle:(PFLPuzzle *)puzzle delegate:(id<PFLPuzzleControlsDelegate>)delegate audioEventController:(PFLAudioEventController*)audioEventController;

@end
