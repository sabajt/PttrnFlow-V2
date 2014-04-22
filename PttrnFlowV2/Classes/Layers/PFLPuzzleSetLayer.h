//
//  SequenceMenuLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLScrollNode.h"
#import "PFLPuzzleSetCell.h"

@class PFLPuzzleSet;

@interface PFLPuzzleSetLayer : PFLScrollNode <PFLPuzzleSetCellDelegate>

@property (strong, nonatomic) NSArray* mapNames;

+ (CCScene*)sceneWithPuzzleSet:(PFLPuzzleSet*)puzzle;

@end
