//
//  PFLPuzzleSet.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLJsonUtils.h"
#import "PFLKeyframe.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

static NSString *const kBpm = @"bpm";
static NSString *const kFile = @"file";
static NSString *const kKeyframes = @"keyframes";
static NSString *const kLength = @"length";
static NSString *const kName = @"name";
static NSString *const kPuzzles = @"puzzles";
static NSString *const kTheme = @"theme";

@interface PFLPuzzleSet ()

@property (strong, nonatomic) NSArray *combinedSolutionEvents;

@end

@implementation PFLPuzzleSet

+ (PFLPuzzleSet *)puzzleSetFromResource:(NSString *)resource;
{
    return [[PFLPuzzleSet alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource]];
}

- (id)initWithJson:(NSDictionary *)json
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
    NSMutableArray* keyframes = [NSMutableArray array];

    NSArray* allPuzzlesJson = json[kPuzzles];
    for (NSDictionary* puzzleJson in allPuzzlesJson)
    {
      PFLPuzzle* puzzle = [PFLPuzzle puzzleFromResource:puzzleJson[kFile] puzzleSet:self];
      [puzzles addObject:puzzle];
      
      NSArray* keyframeJsonArray = puzzleJson[kKeyframes];
      for (NSDictionary* keyframeJson in keyframeJsonArray)
      {
        PFLKeyframe* keyframe = [PFLKeyframe keyframeWithJson:keyframeJson puzzle:puzzle];
        [keyframes addObject:keyframe];
      }
    }
    
    self.puzzles = [NSArray arrayWithArray:puzzles];
    self.keyframes = [NSArray arrayWithArray:keyframes];
  }
  return self;
}

- (NSArray*)combinedSolutionEvents
{
  if (!_combinedSolutionEvents)
  {
    NSMutableArray *combinedSolutionEvents = [NSMutableArray array];
    for (NSInteger i = 0; i < self.length; i++)
    {
      [combinedSolutionEvents addObject:[NSArray array]];
    }
    
    for (PFLKeyframe *keyframe in self.keyframes)
    {
      NSInteger s = keyframe.sourceIndex;
      for (NSInteger r = 0; r < keyframe.range; r++)
      {
        NSArray *events = [keyframe.puzzle solutionEvents][s];
        NSInteger t = keyframe.targetIndex + r;
        combinedSolutionEvents[t] = [combinedSolutionEvents[t] arrayByAddingObjectsFromArray:events];
        s++;
      }
    }
    
    _combinedSolutionEvents = [NSArray arrayWithArray:combinedSolutionEvents];
  }
  return _combinedSolutionEvents;
}

@end
