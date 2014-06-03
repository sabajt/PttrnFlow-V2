//
//  PFLDragNode.h
//  PttrnFlowV2
//
//  Created by John Saba on 6/1/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCNode.h"

@class PFLDragNode, PFLGlyph, PFLPuzzle;

@protocol PFLDragNodeDelegate <NSObject>

- (void)dragNode:(PFLDragNode*)dragNode touchBegan:(UITouch*)touch;
- (void)dragNode:(PFLDragNode*)dragNode touchMoved:(UITouch*)touch;
- (void)dragNode:(PFLDragNode*)dragNode touchEnded:(UITouch *)touch;
- (void)dragNode:(PFLDragNode*)dragNode touchCancelled:(UITouch*)touch;

@end

@interface PFLDragNode : CCNode

@property (weak, nonatomic) id<PFLDragNodeDelegate> delegate;
@property (strong, nonatomic) PFLGlyph* glyph;

- (instancetype)initWithGlyph:(PFLGlyph*)glyph theme:(NSString*)theme puzzle:(PFLPuzzle*)puzzle;

@end
