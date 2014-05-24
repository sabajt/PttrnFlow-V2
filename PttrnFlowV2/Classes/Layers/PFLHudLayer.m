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

static BOOL isMuted;

NSString* const PFLNotificationToggleMute = @"PFLNotificationToggleMute";

@interface PFLHudLayer ()

@property (weak, nonatomic) PFLBasicButton* backButton;
@property (weak, nonatomic) PFLToggleButton* muteButton;
@property (copy, nonatomic) NSString* theme;

@end

@implementation PFLHudLayer

+ (BOOL)isMuted
{
  return isMuted;
}

- (id)initWithTheme:(NSString*)theme
{
  self = [super init];
  if (self)
  {
    self.contentSizeType = CCSizeTypeNormalized;
    self.contentSize = CGSizeMake(1.0f, 1.0f);
    self.theme = theme;
  }
  
  return self;
}

- (void)onEnter
{
  [super onEnter];
  
  // top left button panel
  CCSprite* topLeftControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_fill.png"];
  topLeftControlsPanel.color = [PFLColorUtils controlPanelFillWithTheme:self.theme];
  topLeftControlsPanel.anchorPoint = ccp(0.0f, 1.0f);
  topLeftControlsPanel.positionType = CCPositionTypeNormalized;
  topLeftControlsPanel.position = ccp(0.0f, 1.0f);
  [self addChild:topLeftControlsPanel];
  
  CCSprite* topLeftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_edge.png"];
  topLeftControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:self.theme];
  topLeftControlsPanelBorder.anchorPoint = ccp(0.0f, 1.0f);
  topLeftControlsPanelBorder.positionType = CCPositionTypeNormalized;
  topLeftControlsPanelBorder.position = topLeftControlsPanel.position;
  [self addChild:topLeftControlsPanelBorder];
  
  // back button
  PFLBasicButton* backButton = [[PFLBasicButton alloc] initWithImage:@"exit.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:self.theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:self.theme] target:self];
  backButton.touchEndedSelectorName = @"backButtonPressed";
  backButton.anchorPoint = ccp(0.5f, 0.5f);
  backButton.positionType = CCPositionTypeNormalized;
  backButton.position = ccp(0.5f, 0.5f);
  self.backButton = backButton;
  [topLeftControlsPanel addChild:backButton];
  
  // top right button panel
  CCSprite* topRightControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_fill.png"];
  topRightControlsPanel.flipX = YES;
  topRightControlsPanel.color = [PFLColorUtils controlPanelFillWithTheme:self.theme];
  topRightControlsPanel.anchorPoint = ccp(1.0f, 1.0f);
  topRightControlsPanel.positionType = CCPositionTypeNormalized;
  topRightControlsPanel.position = ccp(1.0f, 1.0f);
  [self addChild:topRightControlsPanel];
  
  CCSprite* topRightControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_edge.png"];
  topRightControlsPanelBorder.flipX = YES;
  topRightControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:self.theme];
  topRightControlsPanelBorder.anchorPoint = ccp(1.0f, 1.0f);
  topRightControlsPanelBorder.positionType = CCPositionTypeNormalized;
  topRightControlsPanelBorder.position = topRightControlsPanel.position;
  [self addChild:topRightControlsPanelBorder];
  
  // mute button
  PFLToggleButton* muteButton = [[PFLToggleButton alloc] initWithImage:@"speaker.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:self.theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:self.theme] target:self];
  muteButton.touchBeganSelectorName = @"muteButtonPressed";
  muteButton.anchorPoint = ccp(0.5f, 0.5f);
  muteButton.positionType = CCPositionTypeNormalized;
  muteButton.position = ccp(0.5f, 0.5f);
  self.muteButton = muteButton;
  [topRightControlsPanel addChild:muteButton];
  
  if (isMuted)
  {
    [muteButton toggleIgnoringTarget:YES];
  }
}

- (void)backButtonPressed
{
  if ([self.delegate respondsToSelector:@selector(backButtonPressed)])
  {
    [self.delegate backButtonPressed];
  }
}

- (void)muteButtonPressed
{
  isMuted = !isMuted;
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLNotificationToggleMute object:nil];
}

@end
