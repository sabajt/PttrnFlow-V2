//
//  Entry.m
//  PttrnFlow
//
//  Created by John Saba on 2/2/14.
//
//

#import "PFLEntrySprite.h"
#import "NSString+PFLDegrees.h"
#import "CCNode+PFLGrid.h"
#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzle.h"

@interface PFLEntrySprite ()

@property (weak, nonatomic) CCSprite* detailSprite;
@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;
@property (strong, nonatomic) PFLEvent* event;
@property (strong, nonatomic) PFLGlyph* glyph;

@end

@implementation PFLEntrySprite

- (id)initWithGlyph:(PFLGlyph*)glyph
{
  return [self initWithGlyph:glyph cell:nil];
}

- (id)initWithGlyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell
{
  self = [super initWithImageNamed:@"glyph_circle.png"];
  if (self)
  {
    self.glyph = glyph;
    NSString* theme = glyph.puzzle.puzzleSet.theme;
    self.defaultColor = [PFLColorUtils glyphDetailWithTheme:theme];
    self.activeColor = [PFLColorUtils glyphActiveWithTheme:theme];
    self.color = self.defaultColor;
    self.direction = glyph.direction;
    self.rotation = [self.direction degrees];
    
    self.event = [PFLEvent directionEventWithDirection:self.direction];
    
    CCSprite* detailSprite = [CCSprite spriteWithImageNamed:@"entry_up.png"];
    self.detailSprite = detailSprite;
    detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    [self addChild:detailSprite];
    detailSprite.color = [PFLColorUtils padWithTheme:theme isStatic:glyph.isStatic];
    
    // CCNode+Grid
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

- (PFLCoord*)audioResponderCell
{
  return self.cell;
}

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  self.color = self.activeColor;
  CCActionTintTo* tint = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
  [self runAction:[CCActionEaseSineOut actionWithAction:tint]];
  
  return self.event;
}

@end
