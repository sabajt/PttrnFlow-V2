//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "PFLAudioPadSprite.h"
#import "CCNode+PFLGrid.h"
#import "CCSprite+PFLEffects.h"
#import "PFLColorUtils.h"
#import "PFLGameConstants.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzle.h"

@interface PFLAudioPadSprite ()

@property (strong, nonatomic) CCSprite* highlightSprite;
@property (strong, nonatomic) PFLGlyph* glyph;

@end


@implementation PFLAudioPadSprite

- (id)initWithGlyph:(PFLGlyph *)glyph
{
  return [self initWithGlyph:glyph cell:nil];
}

- (id)initWithGlyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell
{
  self = [super initWithImageNamed:@"audio_box.png"];
  if (self)
  {
    self.glyph = glyph;
    self.isStatic = glyph.isStatic;
    self.color = [PFLColorUtils padWithTheme:glyph.puzzle.puzzleSet.theme isStatic:glyph.isStatic];

    // CCNode+Grid
    if (cell)
    {
      self.cell = cell;
    }
    else
    {
      self.cell = glyph.cell;
    }
    self.cellSize = [PFLGameConstants gridUnitSize];
  }
  return self;
}

#pragma mark - AudioResponder

- (NSNumber*)audioResponderID
{
  return self.glyph.responderID;
}

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  CCActionScaleTo* padScaleUp = [CCActionScaleTo actionWithDuration:beatDuration / 2.0f scale:1.2f];
  CCActionEaseSineIn* padEaseUp = [CCActionEaseSineIn actionWithAction:padScaleUp];
  CCActionScaleTo* padScaleDown = [CCActionScaleTo actionWithDuration:beatDuration / 2.0f scale:1.0f];
  CCActionEaseSineOut* padEaseDown = [CCActionEaseSineOut actionWithAction:padScaleDown];
  CCActionSequence* seq = [CCActionSequence actionWithArray:@[padEaseUp, padEaseDown]];
  [self runAction:seq];
  
  return nil;
}

- (PFLCoord*)audioResponderCell
{
  return self.cell;
}

@end
