//
//  PFLPuzzleSet.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLJsonUtils.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

static NSString* const kBpm = @"bpm";
static NSString* const kFile = @"file";
static NSString* const kLength = @"length";
static NSString* const kName = @"name";
static NSString* const kPuzzleIndex = @"puzzle_index";
static NSString* const kTheme = @"theme";

@interface PFLPuzzleSet ()

@property (strong, nonatomic) NSArray *combinedSolutionEvents;

@end

@implementation PFLPuzzleSet

+ (PFLPuzzleSet*)puzzleSetFromResource:(NSString*)resource;
{
    return [[PFLPuzzleSet alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource]];
}

- (id)initWithJson:(NSDictionary*)json
{
  self = [super init];
  if (self)
  {
    self.beatDuration = (1.0f / ([json[kBpm] floatValue] / 60.0f));
    self.bpm = [json[kBpm] integerValue];
    self.length = [json[kLength] integerValue];
    self.name = json[kName];
    self.theme = json[kTheme];
    
    NSMutableArray* puzzles = [NSMutableArray array];
    NSArray* puzzleIndex = json[kPuzzleIndex];
    for (NSString* file in puzzleIndex)
    {
      PFLPuzzle* puzzle = [PFLPuzzle puzzleFromResource:file puzzleSet:self];
      [puzzles addObject:puzzle];
    }
    
    self.puzzles = [NSArray arrayWithArray:puzzles];
  }
  return self;
}

@end
