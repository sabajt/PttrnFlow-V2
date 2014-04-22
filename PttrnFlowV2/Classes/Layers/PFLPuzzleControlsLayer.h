//
//  SequenceUILayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"
#import "PFLToggleButton.h"
#import "PFLBasicButton.h"
#import "PFLSolutionButton.h"

@class PFLPuzzle;

@protocol PFLPuzzleControlsDelegate <NSObject>

- (void)startUserSequence;
- (void)stopUserSequence;
- (void)startSolutionSequence;
- (void)stopSolutionSequence;
- (void)playSolutionIndex:(NSInteger)index;

@end

@interface PFLPuzzleControlsLayer : CCNode <ToggleButtonDelegate, BasicButtonDelegate, PFLSolutionButtonDelegate>

+ (CGSize)uiButtonUnitSize;
+ (CGFloat)uiTimelineStepWidth;

- (id)initWithPuzzle:(PFLPuzzle*)puzzle delegate:(id<PFLPuzzleControlsDelegate>)delegate;

@end
