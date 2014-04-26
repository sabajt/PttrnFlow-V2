//
//  PFLGlyph.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLGlyph.h"
#import "PFLCoord.h"

NSString* const PFLGlyphTypeNone = @"none";
NSString* const PFLGlyphTypeArrow = @"arrow";
NSString* const PFLGlyphTypeEntry = @"entry";
NSString* const PFLGlyphTypeGoal = @"goal";

static NSString* const kAudio = @"audio";
static NSString* const kCell = @"cell";
static NSString* const kDirection = @"direction";
static NSString* const kStatic = @"static";
static NSString* const kType = @"type";

@implementation PFLGlyph

- (id)initWithObject:(NSDictionary*)object puzzle:(PFLPuzzle*)puzzle
{
  self = [super init];
  if (self)
  {
    self.puzzle = puzzle;

    self.audioID = object[kAudio];
    NSArray *cell = object[kCell];
    self.cell = [PFLCoord coordWithX:[cell[0] integerValue] Y:[cell[1] integerValue]];
    self.direction = object[kDirection];
    self.isStatic = [object[kStatic] boolValue];
    self.type = object[kType];
  }
  return self;
}

@end
