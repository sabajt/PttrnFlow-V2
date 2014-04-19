//
//  PFLKeyframe.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLKeyframe.h"
#import "PFLPuzzle.h"

static NSString* const kRange = @"range";
static NSString* const kSourceIndex = @"source_index";
static NSString* const kTargetIndex = @"target_index";

@implementation PFLKeyframe

//+ (NSArray*)keyframesFromArray:(NSArray*)array puzzle:(PFLPuzzle*)puzzle
//{
//  NSMutableArray* keyframes = [NSMutableArray array];
//  for (NSDictionary* object in array)
//  {
//    [keyframes addObject:[[PFLKeyframe alloc] initWithObject:object puzzle:puzzle]];
//  }
//  return [NSArray arrayWithArray:keyframes];
//}

+ (PFLKeyframe*)keyframeWithJson:(NSDictionary*)json puzzle:(PFLPuzzle*)puzzle
{
  return [[PFLKeyframe alloc] initWithObject:json puzzle:puzzle];
}

- (id)initWithObject:(NSDictionary*)object puzzle:(PFLPuzzle*)puzzle
{
  self = [super init];
  if (self)
  {
    self.puzzle = puzzle;
    self.range = [object[kRange] integerValue];
    self.sourceIndex = [object[kSourceIndex] integerValue];
    self.targetIndex = [object[kTargetIndex] integerValue];
  }
  return self;
}

@end
