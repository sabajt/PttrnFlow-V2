//
//  Gear.m
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "PFLColorUtils.h"
#import "PFLGearSprite.h"
#import "PFLEvent.h"
#import "PFLAudioEventController.h"
#import "PFLPuzzle.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLSwitchReceiverAttributes.h"

@interface PFLGearSprite ()

@property (strong, nonatomic) NSMutableArray *audioUnits;
@property (strong, nonatomic) PFLEvent *multiSampleEvent;

@end

@implementation PFLGearSprite

- (instancetype)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell multiSample:(PFLMultiSample *)multiSample
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    self.color = self.defaultColor;
    
    // units (beats)
    self.audioUnits = [NSMutableArray array];
    for (PFLSample* sample in multiSample.samples)
    {
      // container
      CCSprite* container = [CCSprite spriteWithImageNamed:@"audio_box_empty.png"];
      container.rotation = 360.0f * [sample.time floatValue];
      container.position = ccp(self.contentSize.width / 2.0f, self.contentSize.height / 2.0f);
      
      // audio unit
      CCSprite* audioUnit = [CCSprite spriteWithImageNamed:@"audio_unit.png"];
      static CGFloat unitPadding = 4.0f;
      audioUnit.position = ccp(container.contentSize.width / 2, (container.contentSize.height - audioUnit.contentSize.height / 2) - unitPadding);
      audioUnit.color = [PFLColorUtils glyphDetailWithTheme:self.theme];
      
      [container addChild:audioUnit];
      [self addChild:container];

      [self.audioUnits addObject:audioUnit];
    }
    self.multiSampleEvent = [PFLEvent multiSampleEventWithAudioID:glyph.audioID puzzleFile:glyph.puzzle.file multiSample:multiSample];
  }
  return self;
}

#pragma mark - PFLAudioResponder

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  self.rotation = 0;
  
  // if we are a switch sender, we will handle hit animation when we process the switch
  if (![self.glyph.type isEqualToString:PFLGlyphTypeSwitchSender])
  {
    self.color = self.activeColor;
    CCActionTintTo* tint1 = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
    [self runAction:[CCActionEaseSineOut actionWithAction:tint1]];
    
    for (CCSprite* unit in self.audioUnits)
    {
      unit.color = self.activeColor;
      CCActionTintTo* tint2 = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
      [unit runAction:[CCActionEaseSineOut actionWithAction:tint2]];
    }
    
    CCActionRotateBy* rotate = [CCActionRotateBy actionWithDuration:beatDuration angle:-360.0f];
    [self runAction:[CCActionEaseSineOut actionWithAction:rotate]];
  }
  
  return self.multiSampleEvent;
}

- (void)audioResponderSwitchToState:(NSNumber*)state animated:(BOOL)animated senderCell:(PFLCoord*)senderCell
{
  if ([self.switchState isEqual:state])
  {
    return;
  }
  
  self.switchState = state;
  
  // TODO: handle active attribute
  
  [self stopAllActions];
  self.rotation = 0;

  CCTime beatDuration = self.glyph.puzzle.puzzleSet.beatDuration;
  
  if ([state isEqualToNumber:@0])
  {
    self.defaultColor = [PFLColorUtils glyphDetailWithTheme:self.theme];
  }
  else
  {
    self.defaultColor = [PFLColorUtils padWithTheme:self.theme isStatic:self.glyph.isStatic];
  }
  
  if (animated)
  {
    // if we are switching while being hit, change to active color first and animate hit length duration with rotation
    CCTime dur = beatDuration;
    if ([senderCell isEqualToCoord:self.cell])
    {
      self.color = self.activeColor;
      dur *= 2.0;
      
      CCActionRotateBy* rotate = [CCActionRotateBy actionWithDuration:beatDuration angle:-360.0f];
      [self runAction:[CCActionEaseSineOut actionWithAction:rotate]];
    }
    
    [self runAction:[CCActionEaseSineOut actionWithAction:[CCActionTintTo actionWithDuration:dur color:self.defaultColor]]];
    
    for (CCSprite* unit in self.audioUnits)
    {
      if ([senderCell isEqualToCoord:self.cell])
      {
        unit.color = self.activeColor;
      }
      [unit runAction:[CCActionEaseSineOut actionWithAction:[CCActionTintTo actionWithDuration:dur color:self.defaultColor]]];
    }
  }
  else
  {
    self.color = self.defaultColor;
    
    for (CCSprite* unit in self.audioUnits)
    {
      unit.color = self.defaultColor;
    }
  }
}
@end
