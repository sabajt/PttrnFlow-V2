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
  
  CCNode* headerAnchor = [CCNode node];
  headerAnchor.anchorPoint = ccp(0.0f, 1.0f);
  headerAnchor.positionType = CCPositionTypeNormalized;
  headerAnchor.position = ccp(0.0f, 1.0f);
  headerAnchor.contentSize = CGSizeMake(self.contentSizeInPoints.width, 50.0f);
  [self addChild:headerAnchor];
  
  // back button
  PFLBasicButton* backButton = [[PFLBasicButton alloc] initWithImage:@"exit.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:self.theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:self.theme] target:self];
  backButton.touchEndedSelectorName = @"backButtonPressed";
  backButton.anchorPoint = ccp(0.0f, 0.5f);
  backButton.position = ccp(4.0f, headerAnchor.contentSizeInPoints.height / 2.0f);
  self.backButton = backButton;
  [headerAnchor addChild:backButton];
  
  // mute button
  PFLToggleButton* muteButton = [[PFLToggleButton alloc] initWithImage:@"speaker.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:self.theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:self.theme] target:self];
  muteButton.touchBeganSelectorName = @"muteButtonPressed";
  muteButton.anchorPoint = ccp(1.0f, 0.5f);
  muteButton.position = ccp(headerAnchor.contentSizeInPoints.width - 4.0f, headerAnchor.contentSizeInPoints.height / 2.0f);
  self.muteButton = muteButton;
  [headerAnchor addChild:muteButton];
  
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
