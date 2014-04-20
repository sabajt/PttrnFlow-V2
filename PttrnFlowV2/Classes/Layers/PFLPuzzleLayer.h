//
//  PFLPuzzleLayer.h
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PFLScrollNode.h"
#import "PFLPuzzleControlsLayer.h"

@class PdDispatcher, PFLAudioResponderStepController, PFLAudioResponderTouchController;

@interface PFLPuzzleLayer : PFLScrollNode

@property (weak, nonatomic) PFLAudioResponderStepController *sequenceDispatcher;
@property (weak, nonatomic) PFLAudioResponderTouchController *audioResponderTouchController;

@property (weak, nonatomic) CCSpriteBatchNode *audioObjectsBatchNode;

+ (CCScene *)sceneWithPuzzle:(PFLPuzzle *)puzzle;

@end
