//
//  PFLGlyph.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLGlyph.h"
#import "PFLCoord.h"
#import "PFLSwitchReceiverAttributes.h"

NSString* const PFLGlyphTypeNone = @"none";
NSString* const PFLGlyphTypeArrow = @"arrow";
NSString* const PFLGlyphTypeEntry = @"entry";
NSString* const PFLGlyphTypeGoal = @"goal";
NSString* const PFLGlyphTypeSwitchSender = @"switch_sender";
NSString* const PFLGlyphTypeWarp = @"warp";

@implementation PFLGlyph

- (id)initWithObject:(NSDictionary*)object puzzle:(PFLPuzzle*)puzzle isStatic:(BOOL)isStatic
{
  self = [super init];
  if (self)
  {
    self.puzzle = puzzle;

    self.responderID = object[@"responder_id"];
    self.audioID = object[@"audio_id"];
    self.direction = object[@"direction"];
    self.type = object[@"type"];
    
    self.switchChannel = object[@"switch_channel"];
    NSArray* switchReceiver = object[@"switch_receiver"];
    if (switchReceiver)
    {
      PFLSwitchReceiverAttributes* attributesState1 = [[PFLSwitchReceiverAttributes alloc] initWithJson:switchReceiver[0]];
      PFLSwitchReceiverAttributes* attributesState2 = [[PFLSwitchReceiverAttributes alloc] initWithJson:switchReceiver[1]];
      self.switchReceiverAttributes = @[attributesState1, attributesState2];
    }
    
    self.isStatic = isStatic;
    if (isStatic)
    {
      NSArray *cell = object[@"cell"];
      self.cell = [PFLCoord coordWithX:[cell[0] integerValue] Y:[cell[1] integerValue]];
    }
    
    self.warpChannel = object[@"warp_channel"];
  }
  return self;
}

@end
