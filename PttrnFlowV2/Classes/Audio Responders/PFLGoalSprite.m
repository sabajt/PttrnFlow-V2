//
//  PFLGoal.m
//  PttrnFlowV2
//
//  Created by John Saba on 4/24/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLGoalSprite.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

@interface PFLGoalSprite ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation PFLGoalSprite

- (instancetype)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName glyph:glyph cell:cell];
  if (self)
  {
    self.event = [PFLEvent goalEvent];
    self.color = self.defaultColor;
    
    CCSprite* detailSprite = [CCSprite spriteWithImageNamed:@"goal.png"];
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
