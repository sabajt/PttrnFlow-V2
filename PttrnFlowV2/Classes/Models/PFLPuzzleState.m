//
//  PFLPuzzleState.m
//  PttrnFlowV2
//
//  Created by John Saba on 4/26/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "AppDelegate.h"
#import "PFLAudioResponder.h"
#import "PFLCoord.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleState.h"
#import "PFLGlyph.h"
#import "PFLAudioResponderSprite.h"

@interface PFLPuzzleState ()

@property (copy, nonatomic) NSString* fileName;
@property (strong, nonatomic) NSMutableDictionary* glyphs;

@end

@implementation PFLPuzzleState

+ (instancetype)puzzleStateForPuzzle:(PFLPuzzle*)puzzle
{
  NSString* fileName = [NSString stringWithFormat:@"%@_state", puzzle.file];
  NSString* path = [[AppDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
  
  PFLPuzzleState* puzzleState = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  if (!puzzleState)
  {
    puzzleState = [[PFLPuzzleState alloc] init];
    puzzleState.fileName = fileName;
    [puzzleState updateWithGlyphs:puzzle.staticGlyphs];
  }
  else
  {
    puzzleState.fileName = fileName;
    [puzzleState archive];
  }
  
  return puzzleState;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super init];
  if (self)
  {
    self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
    self.glyphs = [aDecoder decodeObjectForKey:@"glyphs"];
    self.loopedEvents = [aDecoder decodeObjectForKey:@"loopedEvents"];
  }
  
  return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.fileName forKey:@"fileName"];
  [aCoder encodeObject:self.glyphs forKey:@"glyphs"];
  [aCoder encodeObject:self.loopedEvents forKey:@"loopedEvents"];
}

- (void)archive
{
  NSString* path = [[AppDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:self.fileName];
  BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:path];
  if (!success)
  {
    CCLOG(@"Warning: archive to path: '%@' unsuccesful!", path);
  }
}

#pragma mark - Public

- (NSMutableDictionary*)glyphStateForGid:(NSNumber*)gid
{
  return self.glyphs[gid];
}

- (void)updateWithGlyphs:(NSArray*)glyphs
{
  if (!self.glyphs)
  {
    self.glyphs = [NSMutableDictionary dictionary];
  }
  for (PFLGlyph* glyph in glyphs)
  {
    NSMutableDictionary* glyphState = [self glyphStateForGid:glyph.responderID];
    if (!glyphState)
    {
      glyphState = [NSMutableDictionary dictionary];
    }
    
    NSArray* cell = @[[NSNumber numberWithInteger:glyph.cell.x], [NSNumber numberWithInteger:glyph.cell.y]];
    glyphState[@"cell"] = cell;
    
    // default is always state 0 for stuff (hacky fix later)
    if (glyph.switchChannel)
    {
      glyphState[@"switch_state"] = @0;
    }
    
    self.glyphs[glyph.responderID] = glyphState;
  }
  [self archive];
}

- (void)updateWithAudioResponderSprites:(NSArray *)audioResponderSprites
{
  if (!self.glyphs)
  {
    self.glyphs = [NSMutableDictionary dictionary];
  }
  for (PFLAudioResponderSprite* responderSprite in audioResponderSprites)
  {
    NSMutableDictionary* glyphState = [self glyphStateForGid:responderSprite.responderID];
    if (!glyphState)
    {
      glyphState = [NSMutableDictionary dictionary];
    }
    
    NSArray* cell = @[[NSNumber numberWithInteger:responderSprite.cell.x], [NSNumber numberWithInteger:responderSprite.cell.y]];
    glyphState[@"cell"] = cell;
    
    if (responderSprite.switchState)
    {
      glyphState[@"switch_state"] = responderSprite.switchState;
    }
    
    self.glyphs[responderSprite.responderID] = glyphState;
  }
  [self archive];
}

- (BOOL)doesCurrentStateMatchAudioResponderSprites:(NSArray*)audioResponderSprites
{
  for (PFLAudioResponderSprite* responderSprite in audioResponderSprites)
  {
    NSMutableDictionary* glyphState = [self glyphStateForGid:responderSprite.responderID];
    if (!glyphState)
    {
      return NO;
    }
    
    NSArray* oldCellArray = glyphState[@"cell"];
    PFLCoord* oldCell = [PFLCoord coordWithX:[oldCellArray[0] integerValue] Y:[oldCellArray[1] integerValue]];
    if (![responderSprite.cell isEqualToCoord:oldCell])
    {
      return NO;
    }
    
    NSNumber* oldSwitchState = glyphState[@"switch_state"];
    if ((responderSprite.switchState) && ![responderSprite.switchState isEqualToNumber:oldSwitchState])
    {
      return NO;
    }
  }
  
  return YES;
}

@end
