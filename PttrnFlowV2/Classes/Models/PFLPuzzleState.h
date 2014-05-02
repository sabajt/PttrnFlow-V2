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

+ (instancetype)puzzleStateForPuzzle:(PFLPuzzle*)puzzle;

- (NSMutableDictionary*)glyphStateForGid:(NSNumber*)gid;

- (void)updateWithAudioResponders:(NSArray*)audioResponders;
- (void)updateWithGlyphs:(NSArray*)glyphs;

- (BOOL)doesCurrentStateMatchAudioResponders:(NSArray*)audioResponders;
- (BOOL)doesCurrentStateMatchGlyphs:(NSArray*)glyphs;

@end
