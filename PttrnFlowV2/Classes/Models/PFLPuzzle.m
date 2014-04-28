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
static NSString* const kLoopLength = @"loop_length";
static NSString* const kMidi = @"midi";
static NSString* const kName = @"name";
static NSString* const kSamples = @"samples";
static NSString* const kSynth = @"synth";
static NSString* const kUid = @"uid";

@interface PFLPuzzle ()

@property (strong, nonatomic) NSArray* solutionEvents;

@end

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
    self.loopLength = json[kLoopLength];
    self.name = json[kName];
    self.puzzleSet = puzzleSet;
    self.uid = json[kUid];
    
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

// TODO: something like this will now be used on the state models for a dynamic solution
//- (NSArray*)solutionEvents
//{
//  if (!_solutionEvents)
//  {
//    NSMutableArray* solutionEvents = [NSMutableArray array];
//    for (NSArray* s in self.solution)
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
//    _solutionEvents = [NSArray arrayWithArray:solutionEvents];
//  }
//  return _solutionEvents;
//}

@end
