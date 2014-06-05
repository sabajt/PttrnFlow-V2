//
//  SequenceUILayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"
#import "PFLDragNode.h"

@class PFLAudioEventController, PFLPuzzle;

@protocol PFLPuzzleControlsDelegate <NSObject>

- (void)startUserSequence;
- (void)stopUserSequence;

@end

@protocol PFLInventoryDelegate <NSObject>

- (void)inventoryItemMoved:(PFLDragNode*)node;
- (BOOL)inventoryItemDroppedOnBoard:(PFLDragNode*)node;

@end

@interface PFLPuzzleControlsLayer : CCNode <PFLDragNodeDelegate>

@property (weak, nonatomic) id<PFLInventoryDelegate>inventoryDelegate;

+ (CGSize)uiButtonUnitSize;

- (id)initWithPuzzle:(PFLPuzzle *)puzzle delegate:(id<PFLPuzzleControlsDelegate>)delegate audioEventController:(PFLAudioEventController*)audioEventController;
- (void)restoreInventoryGlyphItem:(PFLGlyph*)glyph;

@end
