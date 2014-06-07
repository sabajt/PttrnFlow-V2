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

@protocol PFLInventoryDelegate <NSObject>

- (void)inventoryItemMoved:(PFLDragNode*)node;
- (BOOL)inventoryItemDroppedOnBoard:(PFLDragNode*)node;

@end

@interface PFLPuzzleControlsLayer : CCNode <PFLDragNodeDelegate>

@property (weak, nonatomic) id<PFLInventoryDelegate>inventoryDelegate;

+ (CGSize)uiButtonUnitSize;
+ (BOOL)isRestoringInventoryItem;

- (id)initWithPuzzle:(PFLPuzzle *)puzzle;
- (void)restoreInventoryGlyphItem:(PFLGlyph*)glyph;

@end
