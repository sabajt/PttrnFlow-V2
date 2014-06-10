//
//  Entry.m
//  PttrnFlow
//
//  Created by John Saba on 2/2/14.
//
//

#import "PFLEntrySprite.h"
#import "NSString+PFLDegrees.h"
#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzle.h"

@interface PFLEntrySprite ()

@property (weak, nonatomic) CCSprite* detailSprite;
@property (strong, nonatomic) PFLEvent* event;

@end

@implementation PFLEntrySprite

- (id)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    self.color = self.defaultColor;
    self.direction = glyph.direction;
    self.rotation = [self.direction degrees];
    
    self.event = [PFLEvent directionEventWithDirection:self.direction];
    
    CCSprite* detailSprite = [CCSprite spriteWithImageNamed:@"entry_up.png"];
    self.detailSprite = detailSprite;
    detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    [self addChild:detailSprite];
    detailSprite.color = [PFLColorUtils specialGlyphDetailWithTheme:self.theme];
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
