//
//  PFLDragNode.m
//  PttrnFlowV2
//
//  Created by John Saba on 6/1/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCSprite.h"
#import "NSString+PFLDegrees.h"
#import "PFLColorUtils.h"
#import "PFLDragNode.h"
#import "PFLGameConstants.h"
#import "PFLGlyph.h"
#import "PFLMultiSample.h"
#import "PFLPuzzle.h"
#import "PFLSample.h"
#import "PFLSwitchReceiverAttributes.h"
#import "PFLPuzzleSet.h"

@interface PFLDragNode ()

@property (copy, nonatomic) NSString* theme;
@property (weak, nonatomic) CCSprite* audioPad;
@property (strong, nonatomic) NSNumber* switchState;
@property (copy, nonatomic) NSString* direction;

@end

@implementation PFLDragNode

- (instancetype)initWithGlyph:(PFLGlyph*)glyph theme:(NSString*)theme puzzle:(PFLPuzzle*)puzzle
{
  self = [super init];
  if (self)
  {
    self.glyph = glyph;
    self.userInteractionEnabled = YES;
    self.contentSize = [PFLGameConstants gridUnitSize];
    self.anchorPoint = ccp(0.5f, 0.5f);
    self.theme = theme;
    
    CGPoint center = ccp(self.contentSize.width / 2.0f, self.contentSize.height / 2.0f);
    
    // audio pad
    NSString* audioPadName = @"audio_box.png";
    if (glyph.switchReceiverAttributes)
    {
      audioPadName = @"audio_box_switch.png";
    }
    CCSprite* audioPad = [CCSprite spriteWithImageNamed:audioPadName];
    audioPad.color = [PFLColorUtils padWithTheme:theme isStatic:NO];
    audioPad.position = center;
    self.audioPad = audioPad;
    [self addChild:audioPad];
    
    if (glyph.audioID)
    {
      id object = puzzle.audio[[glyph.audioID integerValue]];
      if ([object isKindOfClass:[PFLMultiSample class]])
      {
        CCSprite* audioCircle = [CCSprite spriteWithImageNamed:@"audio_circle.png"];
        audioCircle.color = [PFLColorUtils glyphDetailWithTheme:theme];
        audioCircle.position = center;
        [self addChild:audioCircle];
        
        PFLMultiSample* multiSample = (PFLMultiSample*)object;
        for (PFLSample* sample in multiSample.samples)
        {
          // container
          CCSprite* container = [CCSprite spriteWithImageNamed:@"audio_box_empty.png"];
          container.rotation = 360.0f * [sample.time floatValue];
          container.position = center;
          
          // audio unit
          CCSprite* audioUnit = [CCSprite spriteWithImageNamed:@"audio_unit.png"];
          static CGFloat unitPadding = 4.0f;
          audioUnit.position = ccp(container.contentSize.width / 2.0f, (container.contentSize.height - audioUnit.contentSize.height / 2.0f) - unitPadding);
          audioUnit.color = [PFLColorUtils glyphDetailWithTheme:theme];
          
          [container addChild:audioUnit];
          [self addChild:container];
        }
      }
    }

    // direction arrow
    if ([glyph.type isEqualToString:PFLGlyphTypeArrow])
    {
      CCSprite* glyphCircle = [CCSprite spriteWithImageNamed:@"glyph_circle.png"];
      glyphCircle.position = center;
      glyphCircle.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      
      CCSprite* arrowSprite = [CCSprite spriteWithImageNamed:@"arrow_up.png"];
      arrowSprite.position = center;
      arrowSprite.color = [PFLColorUtils padWithTheme:self.theme isStatic:NO];
      arrowSprite.rotation = [glyph.direction degrees];
      [self addChild:arrowSprite];
    }

    // switch sender
    if ([glyph.type isEqualToString:PFLGlyphTypeSwitchSender])
    {
      CCSprite* glyphCircle = [CCSprite spriteWithImageNamed:@"glyph_circle.png"];
      glyphCircle.position = center;
      glyphCircle.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      
      CCSprite* senderSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"switch_sender_%i.png", [glyph.switchChannel integerValue] + 1]];
      senderSprite.position = center;
      senderSprite.color = [PFLColorUtils padWithTheme:self.theme isStatic:NO];
      senderSprite.rotation = [glyph.direction degrees];
      [self addChild:senderSprite];
    }

    // switch reciever
    if (glyph.switchReceiverAttributes && glyph.switchChannel)
    {
      static CGFloat channelIconPadding = 4.0f;
      CCSprite* channelIcon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"switch_receiver_%i.png", [glyph.switchChannel integerValue] + 1]];
      channelIcon.anchorPoint = ccp(1.0f, 1.0f);
      channelIcon.position = ccp(audioPad.contentSizeInPoints.width - channelIconPadding, audioPad.contentSizeInPoints.height - channelIconPadding);
      channelIcon.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      [audioPad addChild:channelIcon];
    }
    
    // warp
    if ([glyph.type isEqualToString:PFLGlyphTypeWarp])
    {
      CCSprite* glyphCircle = [CCSprite spriteWithImageNamed:@"glyph_circle.png"];
      glyphCircle.position = center;
      glyphCircle.color = [PFLColorUtils glyphDetailWithTheme:self.theme];

      CCSprite* warpSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"warp_%i.png", [glyph.warpChannel integerValue] + 1]];
      warpSprite.position = center;
      warpSprite.color = [PFLColorUtils padWithTheme:self.theme isStatic:NO];
      [self addChild:warpSprite];
    }
    
    // switch state
    // TOOD: might need to load saved state?
    if (glyph.switchReceiverAttributes)
    {
      [self audioResponderSwitchToState:@0 animated:NO senderCell:nil];
    }

  }
  return self;
}

- (CGSize)visualSize
{
  return self.audioPad.contentSize;
}

#pragma mark - PFLAudioResponder

- (void)audioResponderSwitchToState:(NSNumber*)state animated:(BOOL)animated senderCell:(PFLCoord*)senderCell
{
  
}
//{
//  if ([self.switchState isEqual:state])
//  {
//    return;
//  }
//  
//  self.switchState = state;
//  PFLSwitchReceiverAttributes* attributes = self.glyph.switchReceiverAttributes[[state integerValue]];
//  
//  [self stopAllActions];
//  CCTime beatDuration = self.glyph.puzzle.puzzleSet.beatDuration;
//  
//  if ([self.glyph.type isEqualToString:PFLGlyphTypeArrow])
//  {
//    // direction
//    self.direction = attributes.direction;
//    if (self.direction)
//    {
//      if (animated)
//      {
//        CCActionRotateTo* rotate = [CCActionRotateTo actionWithDuration:beatDuration angle:[self.direction degrees]];
//        [self runAction:[CCActionEaseBackInOut actionWithAction:rotate]];
//      }
//      else
//      {
//        self.rotation = [self.direction degrees];
//      }
//    }
//  }
//}

#pragma mark - CCResponder

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self.delegate dragNode:self touchBegan:touch];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self.delegate dragNode:self touchMoved:touch];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self.delegate dragNode:self touchEnded:touch];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
  [self.delegate dragNode:self touchCancelled:touch];
}

@end
