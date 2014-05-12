//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "PFLAudioPadSprite.h"
#import "CCSprite+PFLEffects.h"
#import "PFLColorUtils.h"
#import "PFLGameConstants.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzle.h"

@interface PFLAudioPadSprite ()

@property (strong, nonatomic) CCSprite* highlightSprite;

@end


@implementation PFLAudioPadSprite

- (instancetype)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    self.isStatic = glyph.isStatic;
    self.color = [PFLColorUtils padWithTheme:self.theme isStatic:glyph.isStatic];
    
    if (glyph.switchReceiverAttributes && glyph.switchChannel)
    {
      static CGFloat channelIconPadding = 4.0f;
      CCSprite* channelIcon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"switch_receiver_%i.png", [glyph.switchChannel integerValue] + 1]];
      channelIcon.anchorPoint = ccp(1.0f, 1.0f);
      channelIcon.position = ccp(self.contentSize.width - channelIconPadding, self.contentSize.height - channelIconPadding);
      channelIcon.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      [self addChild:channelIcon];
    }
  }
  return self;
}

#pragma mark - PFLAudioResponder

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

@end
