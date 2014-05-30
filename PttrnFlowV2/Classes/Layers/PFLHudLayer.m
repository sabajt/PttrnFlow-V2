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
#import "PFLGameConstants.h"
#import "PFLHudLayer.h"
#import "PFLToggleButton.h"

static BOOL isMuted;

NSString* const PFLNotificationToggleMute = @"PFLNotificationToggleMute";

@interface PFLHudLayer ()

@property (weak, nonatomic) PFLBasicButton* backButton;
@property (weak, nonatomic) PFLToggleButton* muteButton;
@property (copy, nonatomic) NSString* theme;
@property BOOL isContentMode;

@end

@implementation PFLHudLayer

#pragma mark - Class methods

+ (BOOL)isMuted
{
  return isMuted;
}

+ (CGFloat)accesoryBarHeight
{
  CGSize screenSize = [[CCDirector sharedDirector] designSize];
  if ((NSInteger)screenSize.width == PFLIPadDesignWidth)
  {
    return 50.0f * 2.0f;
  }
  else if ((NSInteger)screenSize.width == PFLIPhoneDesignWidth)
  {
    return 50.0f;
  }
  else
  {
    CCLOG(@"Warning: unsupported screen width: %f", screenSize.width);
    return 50.0f;
  }
}

#pragma mark - Setup

- (id)initWithTheme:(NSString*)theme contentMode:(BOOL)isContentMode
{
  self = [super init];
  if (self)
  {
    self.contentSizeType = CCSizeTypeNormalized;
    self.contentSize = CGSizeMake(1.0f, 1.0f);
    self.theme = theme;
    self.isContentMode = isContentMode;
  }
  return self;
}

- (void)onEnter
{
  [super onEnter];
  
  CCColor* headerColor = [PFLColorUtils controlPanelFillWithTheme:self.theme];
  CCColor* headerButtonDefaultColor = [PFLColorUtils controlPanelButtonsDefaultWithTheme:self.theme];
  CCColor* headerButtonActiveColor = [PFLColorUtils controlPanelButtonsActiveWithTheme:self.theme];
  if (self.isContentMode)
  {
    headerColor = [CCColor clearColor];
    headerButtonDefaultColor = [PFLColorUtils contentBackedButtonsDefaultWithTheme:self.theme];
    headerButtonActiveColor = [PFLColorUtils contentBackedButtonsActiveWithTheme:self.theme];
  }

  // header 
  CCNode* headerAnchor = [CCNodeColor nodeWithColor:headerColor];
  headerAnchor.anchorPoint = ccp(0.0f, 1.0f);
  headerAnchor.positionType = CCPositionTypeNormalized;
  headerAnchor.position = ccp(0.0f, 1.0f);
  headerAnchor.contentSize = CGSizeMake(self.contentSizeInPoints.width, [PFLHudLayer accesoryBarHeight]);
  [self addChild:headerAnchor];
  
  // back button
  PFLBasicButton* backButton = [[PFLBasicButton alloc] initWithImage:@"exit.png" defaultColor:headerButtonDefaultColor activeColor:headerButtonActiveColor target:self];
  backButton.touchEndedSelectorName = @"backButtonPressed";
  backButton.anchorPoint = ccp(0.0f, 0.5f);
  backButton.position = ccp(4.0f, [PFLHudLayer accesoryBarHeight] / 2.0f);
  self.backButton = backButton;
  [headerAnchor addChild:backButton];
  
  // mute button
  PFLToggleButton* muteButton = [[PFLToggleButton alloc] initWithImage:@"speaker.png" defaultColor:headerButtonDefaultColor activeColor:headerButtonActiveColor target:self];
  muteButton.touchBeganSelectorName = @"muteButtonPressed";
  muteButton.anchorPoint = ccp(1.0f, 0.5f);
  muteButton.position = ccp(headerAnchor.contentSizeInPoints.width - 4.0f, [PFLHudLayer accesoryBarHeight] / 2.0f);
  self.muteButton = muteButton;
  [headerAnchor addChild:muteButton];

  if (isMuted)
  {
    [muteButton toggleIgnoringTarget:YES];
  }
}

#pragma mark - Buttons

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
