//
//  SequenceMenuCell.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "CCSprite9Slice.h"
#import "PFLEvent.h"

@class PFLPuzzleSetCell, PFLPuzzle;

@protocol PFLPuzzleSetCellDelegate <NSObject>

- (void)puzzleSetCellTouchUpInside:(PFLPuzzleSetCell*)cell index:(NSInteger)index;

@end

@interface PFLPuzzleSetCell : CCSprite9Slice <PFLEventDelegate>

@property (weak, nonatomic) id<PFLPuzzleSetCellDelegate> menuCellDelegate;
@property BOOL propogateTouch;
@property (strong, nonatomic) PFLPuzzle* puzzle;

- (id)initWithPuzzle:(PFLPuzzle *)puzzle cellIndex:(NSInteger)cellIndex;

@end
