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

@class PFLPuzzle;

@protocol PFLPuzzleControlsDelegate <NSObject>

- (void)startUserSequence;
- (void)stopUserSequence;

@end

@interface PFLPuzzleControlsLayer : CCNode <ToggleButtonDelegate, BasicButtonDelegate>

+ (CGSize)uiButtonUnitSize;

- (id)initWithPuzzle:(PFLPuzzle*)puzzle delegate:(id<PFLPuzzleControlsDelegate>)delegate;

@end
