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

- (instancetype)initWithGlyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell
{
  self = [super initWithImageNamed:@"audio_box.png" glyph:glyph cell:cell];
  if (self)
  {
    self.isStatic = glyph.isStatic;
    
    if ([glyph.type isEqualToString:PFLGlyphTypeEntry] || [glyph.type isEqualToString:PFLGlyphTypeGoal])
    {
      self.color = [PFLColorUtils specialGlyphDetailWithTheme:self.theme];
    }
    else
    {
      self.color = [PFLColorUtils padWithTheme:self.theme isStatic:glyph.isStatic];
    }
    
    if (glyph.switchReceiverAttributes && glyph.switchChannel)
    {
      static CGFloat channelIconPadding = 0.0f;
      
      CCSprite* iconContainer = [CCSprite spriteWithImageNamed:@"audio_box_switch.png"];
      iconContainer.anchorPoint = ccp(1.0f, 1.0f);
      iconContainer.position = ccp(self.contentSize.width - channelIconPadding, self.contentSize.height - channelIconPadding);
      iconContainer.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      [self addChild:iconContainer];
      
      CCSprite* containerBorder = [CCSprite spriteWithImageNamed:@"audio_box_switch_border.png"];
      containerBorder.position = ccp(iconContainer.contentSize.width / 2.0f, iconContainer.contentSize.height / 2.0f);
      containerBorder.color = [PFLColorUtils padWithTheme:self.theme isStatic:glyph.isStatic];
      [iconContainer addChild:containerBorder];
      
      CCSprite* channelIcon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"switch_receiver_%i.png", [glyph.switchChannel integerValue] + 1]];
      channelIcon.position = containerBorder.position;
      channelIcon.color = containerBorder.color;
      [iconContainer addChild:channelIcon];
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
