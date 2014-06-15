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

@property (nonatomic, weak) CCSprite* highlightSprite;
@property (nonatomic, weak) CCSprite* switchIconContainer;
@property (nonatomic, weak) CCSprite* switchContainerBorder;
@property (nonatomic, weak) CCSprite* switchChannelLabel;

@end


@implementation PFLAudioPadSprite

- (instancetype)initWithGlyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell
{
  self = [super initWithImageNamed:@"audio_box.png" glyph:glyph cell:cell];
  if (self)
  {
    self.isStatic = glyph.isStatic;
    [self resetColor];
    
    if (glyph.switchReceiverAttributes && glyph.switchChannel)
    {
      static CGFloat channelIconPadding = 0.0f;
      
      CCSprite* iconContainer = [CCSprite spriteWithImageNamed:@"audio_box_switch.png"];
      iconContainer.anchorPoint = ccp(1.0f, 1.0f);
      iconContainer.position = ccp(self.contentSize.width - channelIconPadding, self.contentSize.height - channelIconPadding);
      iconContainer.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      self.switchIconContainer = iconContainer;
      [self addChild:iconContainer];
      
      CCSprite* containerBorder = [CCSprite spriteWithImageNamed:@"audio_box_switch_border.png"];
      containerBorder.position = ccp(iconContainer.contentSize.width / 2.0f, iconContainer.contentSize.height / 2.0f);
      containerBorder.color = [PFLColorUtils padWithTheme:self.theme isStatic:glyph.isStatic];
      self.switchContainerBorder = containerBorder;
      [iconContainer addChild:containerBorder];
      
      CCSprite* channelIcon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"switch_receiver_%i.png", [glyph.switchChannel integerValue] + 1]];
      channelIcon.position = containerBorder.position;
      channelIcon.color = containerBorder.color;
      self.switchChannelLabel = channelIcon;
      [iconContainer addChild:channelIcon];
    }
  }
  return self;
}

- (void)resetColor
{
  if ([self.glyph.type isEqualToString:PFLGlyphTypeEntry] || [self.glyph.type isEqualToString:PFLGlyphTypeGoal])
  {
    // no switch states for entries and goals for now
    self.color = [PFLColorUtils specialPadWithTheme:self.theme];
  }
  else
  {
    // audio pad sprite
    self.color = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
    
    // switch colors
    if ([self.switchState isEqual:@0])
    {
      self.switchIconContainer.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      self.switchContainerBorder.color = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
      self.switchChannelLabel.color = self.switchContainerBorder.color;
    }
    else
    {
      self.switchIconContainer.color = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
      self.switchContainerBorder.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      self.switchChannelLabel.color = self.switchContainerBorder.color;
    }
  }
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

- (void)audioResponderSwitchToState:(NSNumber*)state animated:(BOOL)animated senderCell:(PFLCoord *)senderCell
{
  if ([self.switchState isEqualToNumber:state])
  {
    return;
  }
  
  self.switchState = state;
  CCTime beatDuration = self.glyph.puzzle.puzzleSet.beatDuration;
  
  CCActionCallBlock* updateImage;
  CCColor* switchContainerColor;
  CCColor* containerBorderColor;
  
  if ([state isEqualToNumber:@0])
  {
    updateImage = [CCActionCallBlock actionWithBlock:^{
      [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"audio_box.png"]];
      self.color = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
    }];
    
    switchContainerColor = [PFLColorUtils glyphDetailWithTheme:self.theme];
    containerBorderColor = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
  }
  else
  {
    updateImage = [CCActionCallBlock actionWithBlock:^{
      [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"audio_box_border.png"]];
      self.color = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
    }];
    
    switchContainerColor = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
    containerBorderColor = [PFLColorUtils glyphDetailWithTheme:self.theme];
  }
  
  if (animated)
  {
    CCActionEaseSineOut* fadeOut = [CCActionEaseSineOut actionWithAction:[CCActionFadeOut actionWithDuration:beatDuration / 2.0]];
    CCActionEaseSineOut* fadeIn = [CCActionEaseSineOut actionWithAction:[CCActionFadeIn actionWithDuration:beatDuration / 2.0]];
    [self runAction:[CCActionSequence actionWithArray:@[fadeOut, updateImage, fadeIn]]];
   
    CCActionEaseSineOut* tintSwitchContainer = [CCActionEaseSineOut actionWithAction:[CCActionTintTo actionWithDuration:beatDuration color:switchContainerColor]];
    [self.switchIconContainer runAction:tintSwitchContainer];
    
    CCActionEaseSineOut* tintContainerBorder = [CCActionEaseSineOut actionWithAction:[CCActionTintTo actionWithDuration:beatDuration color:containerBorderColor]];
    [self.switchContainerBorder runAction:tintContainerBorder];
    
    CCActionEaseSineOut* tintChannelLabel = [CCActionEaseSineOut actionWithAction:[CCActionTintTo actionWithDuration:beatDuration color:containerBorderColor]];
    [self.switchChannelLabel runAction:tintChannelLabel];
  }
  else
  {
    [self runAction:updateImage];
    [self resetColor];
  }
}

@end
