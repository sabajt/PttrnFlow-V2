//
//  SequenceMenuCell.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "CCSprite.h"

@class PFLPuzzleSetCell;

@protocol PFLPuzzleSetCellDelegate <NSObject>

- (void)puzzleSetCellTouchUpInside:(PFLPuzzleSetCell *)cell index:(NSInteger)index;

@end


@interface PFLPuzzleSetCell : CCSprite

@property (weak, nonatomic) id<PFLPuzzleSetCellDelegate> menuCellDelegate;

-(id) initWithIndex:(NSInteger)index;

@end
