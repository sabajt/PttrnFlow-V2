//
//  PFLGlyphState.m
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

@interface PFLPuzzleState ()

@property (copy, nonatomic) NSString* fileName;
@property (strong, nonatomic) NSMutableDictionary* glyphs;

@end

@implementation PFLPuzzleState

+ (instancetype)puzzleStateForPuzzle:(PFLPuzzle*)puzzle
{
  NSString* fileName = [NSString stringWithFormat:@"puzzleState%@", puzzle.uid];
  NSString* path = [[AppDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
  
  PFLPuzzleState* puzzleState = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  if (!puzzleState)
  {
    puzzleState = [[PFLPuzzleState alloc] init];
    puzzleState.fileName = fileName;
    [puzzleState updateWithGlyphs:puzzle.glyphs];
  }
  else
  {
    puzzleState.fileName = [NSString stringWithFormat:@"puzzleState%@", puzzle.uid];
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
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.fileName forKey:@"fileName"];
  [aCoder encodeObject:self.glyphs forKey:@"glyphs"];
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

// Create PFLGlyphs with the only info needed for puzzle state from audio responders
- (NSArray*)glyphsFromAudioResponders:(NSArray*)audioResponders
{
  NSMutableArray* updatedGlyphs = [NSMutableArray array];
  
  for (id<PFLAudioResponder> audioResponder in audioResponders)
  {
    if (![audioResponder respondsToSelector:@selector(audioResponderID)])
    {
      continue;
    }
    
    PFLGlyph* updateGlyph = [[PFLGlyph alloc] initWithObject:nil puzzle:nil];
    updateGlyph.responderID = [audioResponder audioResponderID];
    updateGlyph.cell = [audioResponder audioResponderCell];
    
    if ([audioResponder respondsToSelector:@selector(audioResponderDirection)])
    {
      updateGlyph.direction = [audioResponder audioResponderDirection];
    }
    
    [updatedGlyphs addObject:updateGlyph];
  }
  
  return [NSArray arrayWithArray:updatedGlyphs];
}

#pragma mark - Public

- (NSMutableDictionary*)glyphStateForGid:(NSNumber*)gid
{
  return self.glyphs[gid];
}

- (void)updateWithAudioResponders:(NSArray*)audioResponders
{
  [self updateWithGlyphs:[self glyphsFromAudioResponders:audioResponders]];
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
    if (glyph.direction)
    {
      glyphState[@"direction"] = glyph.direction;
    }
    self.glyphs[glyph.responderID] = glyphState;
  }
  [self archive];
}

- (BOOL)doesCurrentStateMatchAudioResponders:(NSArray*)audioResponders
{
  return [self doesCurrentStateMatchGlyphs:[self glyphsFromAudioResponders:audioResponders]];
}

- (BOOL)doesCurrentStateMatchGlyphs:(NSArray*)glyphs
{
  for (PFLGlyph* glyph in glyphs)
  {
    NSMutableDictionary* glyphState = [self glyphStateForGid:glyph.responderID];
    if (!glyphState)
    {
      return NO;
    }
    
    NSArray* oldCellArray = glyphState[@"cell"];
    PFLCoord* oldCell = [PFLCoord coordWithX:[oldCellArray[0] integerValue] Y:[oldCellArray[1] integerValue]];
    if (![glyph.cell isEqualToCoord:oldCell])
    {
      return NO;
    }
    
    if ((glyph.direction) && ![glyph.direction isEqualToString:glyphState[@"direction"]])
    {
      return NO;
    }
  }
  
  return YES;
}

@end
