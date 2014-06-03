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

static NSString* const kResponderID = @"responder_id";
static NSString* const kAudioID = @"audio_id";
static NSString* const kCell = @"cell";
static NSString* const kDirection = @"direction";
static NSString* const kStatic = @"static";
static NSString* const kType = @"type";

@implementation PFLGlyph

- (id)initWithObject:(NSDictionary*)object puzzle:(PFLPuzzle*)puzzle isStatic:(BOOL)isStatic
{
  self = [super init];
  if (self)
  {
    self.puzzle = puzzle;

    self.responderID = object[kResponderID];
    self.audioID = object[kAudioID];
    self.direction = object[kDirection];
    self.type = object[kType];
    
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
      NSArray *cell = object[kCell];
      self.cell = [PFLCoord coordWithX:[cell[0] integerValue] Y:[cell[1] integerValue]];
    }
  }
  return self;
}

@end
