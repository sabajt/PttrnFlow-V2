//
//  SequenceMenuCell.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "CCSprite9Slice.h"

@class PFLPuzzleSetCell, PFLPuzzle;

@protocol PFLPuzzleSetCellDelegate <NSObject>

- (void)puzzleSetCellTouchUpInside:(PFLPuzzleSetCell*)cell index:(NSInteger)index;

@end

@interface PFLPuzzleSetCell : CCSprite9Slice

@property (weak, nonatomic) id<PFLPuzzleSetCellDelegate> menuCellDelegate;
@property BOOL propogateTouch;

- (id)initWithPuzzle:(PFLPuzzle *)puzzle cellIndex:(NSInteger)cellIndex;

@end
