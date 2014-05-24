//
//  PFLHudLayer.m
//  PttrnFlowV2
//
//  Created by John Saba on 5/24/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCSprite.h"
#import "PFLBasicButton.h"
#import "PFLColorUtils.h"
#import "PFLHudLayer.h"
#import "PFLToggleButton.h"

@interface PFLHudLayer ()

@property (weak, nonatomic) PFLBasicButton* exitButton;

@end

@implementation PFLHudLayer

- (id)initWithTheme:(NSString*)theme
{
  self = [super init];
  if (self)
  {
    self.contentSizeType = CCSizeTypeNormalized;
    self.contentSize = CGSizeMake(1.0f, 1.0f);
    
    // top left controls panel
    CCSprite* topLeftControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_fill.png"];
    topLeftControlsPanel.color = [PFLColorUtils controlPanelFillWithTheme:theme];
    topLeftControlsPanel.anchorPoint = ccp(0.0f, 1.0f);
    topLeftControlsPanel.positionType = CCPositionTypeNormalized;
    topLeftControlsPanel.position = ccp(0.0f, 1.0f);
    [self addChild:topLeftControlsPanel];
    
    CCSprite* topLeftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_edge.png"];
    topLeftControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:theme];
    topLeftControlsPanelBorder.anchorPoint = ccp(0.0f, 1.0f);
    topLeftControlsPanelBorder.positionType = CCPositionTypeNormalized;
    topLeftControlsPanelBorder.position = topLeftControlsPanel.position;
    [self addChild:topLeftControlsPanelBorder];
    
    // exit button
    PFLBasicButton* exitButton = [[PFLBasicButton alloc] initWithImage:@"exit.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] target:self];
    exitButton.anchorPoint = ccp(0.5f, 0.5f);
    exitButton.positionType = CCPositionTypeNormalized;
    exitButton.position = ccp(0.5f, 0.5f);
    exitButton.touchEndedSelectorName = @"backButtonPressed";
    self.exitButton = exitButton;
    [topLeftControlsPanel addChild:exitButton];
  }
  return self;
}

- (void)backButtonPressed
{
  if ([self.delegate respondsToSelector:@selector(backButtonPressed)])
  {
    [self.delegate backButtonPressed];
  }
}

@end
