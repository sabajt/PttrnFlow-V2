//
//  PFLKeyframe.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@class PFLPuzzle;

@interface PFLKeyframe : NSObject

@property (strong, nonatomic) PFLPuzzle* puzzle;
@property (assign) NSInteger range;
@property (assign) NSInteger sourceIndex;
@property (assign) NSInteger targetIndex;

+ (PFLKeyframe*)keyframeWithJson:(NSDictionary*)json puzzle:(PFLPuzzle*)puzzle;
- (id)initWithObject:(NSDictionary*)object puzzle:(PFLPuzzle*)puzzle;

@end
