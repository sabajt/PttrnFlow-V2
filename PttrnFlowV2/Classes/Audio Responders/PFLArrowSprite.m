//
//  Arrow.m
//  PttrnFlow
//
//  Created by John Saba on 1/20/14.
//
//

#import "PFLArrowSprite.h"
#import "NSString+PFLDegrees.h"
#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

@interface PFLArrowSprite ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (strong, nonatomic) CCColor *defaultColor;
@property (strong, nonatomic) CCColor *activeColor;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation PFLArrowSprite

- (id)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    NSString* theme = glyph.puzzle.puzzleSet.theme;
    self.defaultColor = [PFLColorUtils glyphDetailWithTheme:theme];
    self.activeColor = [PFLColorUtils glyphActiveWithTheme:theme];
    self.color = self.defaultColor;
    self.rotation = [glyph.direction degrees];
    
    self.event = [PFLEvent directionEventWithDirection:glyph.direction];
    
    CCSprite* detailSprite = [CCSprite spriteWithImageNamed:@"arrow_up.png"];
    self.detailSprite = detailSprite;
    detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    [self addChild:detailSprite];
    detailSprite.color = [PFLColorUtils padWithTheme:theme isStatic:glyph.isStatic];    
  }
  return self;
}

#pragma mark - PFLAudioResponder

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  self.color = self.activeColor;
  
  CCActionTintTo* tint = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
  [self runAction:[CCActionEaseSineOut actionWithAction:tint]];
  
  return self.event;
}

@end
