//
//  PFLGoal.m
//  PttrnFlowV2
//
//  Created by John Saba on 4/24/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCNode+PFLGrid.h"
#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLGoalSprite.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

@interface PFLGoalSprite ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (strong, nonatomic) CCColor *defaultColor;
@property (strong, nonatomic) CCColor *activeColor;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation PFLGoalSprite

- (id)initWithGlyph:(PFLGlyph*)glyph
{
  self = [super initWithImageNamed:@"glyph_circle.png"];
  if (self)
  {
    self.event = [PFLEvent goalEvent];

    NSString* theme = glyph.puzzle.puzzleSet.theme;
    self.defaultColor = [PFLColorUtils glyphDetailWithTheme:theme];
    self.activeColor = [PFLColorUtils glyphActiveWithTheme:theme];
    self.color = self.defaultColor;
    
    CCSprite* detailSprite = [CCSprite spriteWithImageNamed:@"goal.png"];
    self.detailSprite = detailSprite;
    detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    [self addChild:detailSprite];
    detailSprite.color = [PFLColorUtils padWithTheme:theme isStatic:glyph.isStatic];
    
    // CCNode+Grid
    self.cell = glyph.cell;
    self.cellSize = [PFLGameConstants gridUnitSize];
  }
  return self;
}

#pragma mark - AudioResponder

- (PFLCoord*)audioCell
{
  return self.cell;
}

- (PFLEvent*)audioHit:(CGFloat)beatDuration
{
  self.color = self.activeColor;
  
  CCActionTintTo* tint = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
  [self runAction:[CCActionEaseSineOut actionWithAction:tint]];
  
  return self.event;
}

@end
