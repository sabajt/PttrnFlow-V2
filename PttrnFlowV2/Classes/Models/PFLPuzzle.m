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
    self.area = [PFLCoord coordsFromArrays:json[@"area"]];
    self.name = json[@"name"];
    self.puzzleSet = puzzleSet;
    self.file = json[@"file"];
    
    // audio models
    NSMutableArray* audio = [NSMutableArray array];
    for (NSDictionary* a in json[@"audio"])
    {
      NSArray* s = a[@"samples"];
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
    for (NSDictionary* g in json[@"glyphs"])
    {
      PFLGlyph* glyph = [[PFLGlyph alloc] initWithObject:g puzzle:self];
      [glyphs addObject:glyph];
    }
    self.glyphs = [NSArray arrayWithArray:glyphs];
  }
  return self;
}

@end
