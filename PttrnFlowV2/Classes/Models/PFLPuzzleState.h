//
//  PFLGlyphState.h
//  PttrnFlowV2
//
//  Created by John Saba on 4/26/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFLPuzzle;

@interface PFLPuzzleState : NSObject <NSCoding>

@property (strong, nonatomic) NSArray* loopedEvents;

+ (instancetype)puzzleStateForPuzzle:(PFLPuzzle*)puzzle;

- (void)archive;
- (NSMutableDictionary*)glyphStateForGid:(NSNumber*)gid;
- (void)updateWithAudioResponderSprites:(NSArray*)audioResponderSprites;
- (BOOL)doesCurrentStateMatchAudioResponderSprites:(NSArray*)audioResponderSprites;

@end
