//
//  PFLPuzzle.m
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import "PFLCoord.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLJsonUtils.h"
#import "PFLMultiSample.h"
#import "PFLPuzzle.h"
#import "PFLSample.h"

static NSString* const kArea = @"area";
static NSString* const kAudio = @"audio";
static NSString* const kGlyphs = @"glyphs";
static NSString* const kMidi = @"midi";
static NSString* const kName = @"name";
static NSString* const kSamples = @"samples";
static NSString* const kSolution = @"solution";
static NSString* const kSynth = @"synth";
static NSString* const kUid = @"uid";

@implementation PFLPuzzle

+ (PFLPuzzle*)puzzleFromResource:(NSString*)resource puzzleSet:(PFLPuzzleSet*)puzzleSet
{
    return [[PFLPuzzle alloc] initWithJson:[PFLJsonUtils deserializeJsonObjectResource:resource] puzzleSet:puzzleSet];
}

- (id)initWithJson:(NSDictionary*)json puzzleSet:(PFLPuzzleSet*)puzzleSet
{
  self = [super init];
  if (self)
  {
    self.area = [PFLCoord coordsFromArrays:json[kArea]];
    self.name = json[kName];
    self.puzzleSet = puzzleSet;
    self.uid = json[kUid];
    
    // audio models
    NSMutableArray* audio = [NSMutableArray array];
    for (NSDictionary* a in json[kAudio])
    {
      NSArray* s = a[kSamples];
      if (s)
      {
        NSArray *samples = [PFLSample samplesFromArray:s];
        PFLMultiSample *multiSample = [[PFLMultiSample alloc] initWithSamples:samples];
        [audio addObject:multiSample];
      }
    }
    self.audio = [NSArray arrayWithArray:audio];
    
    // glyph models
    NSMutableArray* glyphs = [NSMutableArray array];
    for (NSDictionary* g in json[kGlyphs])
    {
      PFLGlyph* glyph = [[PFLGlyph alloc] initWithObject:g puzzle:self];
      [glyphs addObject:glyph];
    }
    self.glyphs = [NSArray arrayWithArray:glyphs];
  }
  return self;
}

// TODO: will need something like this in puzzle state, but supporting dynamic seq
//    // solution events
//    NSMutableArray* solutionEvents = [NSMutableArray array];
//    for (NSArray* s in json[kSolution])
//    {
//      NSMutableArray* events = [NSMutableArray array];
//      for (NSNumber* audioID in s)
//      {
//        id object = self.audio[[audioID integerValue]];
//        id event;
//        if ([object isKindOfClass:[PFLMultiSample class]])
//        {
//          event = [PFLEvent multiSampleEventWithAudioID:audioID multiSample:(PFLMultiSample*)object];
//        }
//        [events addObject:event];
//      }
//      [solutionEvents addObject:events];
//    }
//    self.solutionEvents = [NSArray arrayWithArray:solutionEvents];

@end
