//
//  PFLAudioResponderSprite.m
//  PttrnFlowV2
//
//  Created by John Saba on 5/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLAudioResponderSprite.h"
#import "PFLColorUtils.h"
#import "PFLGlyph.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"
#import "PFLSwitchReceiverAttributes.h"
#import "PFLSwitchSenderSprite.h"

NSString* const PFLSwitchSenderHitNotification = @"PFLSwitchSenderHitNotification";
NSString* const PFLSwitchChannelKey = @"PFLSwitchChannelKey";
NSString* const PFLSwitchStateKey = @"PFLSwitchStateKey";
NSString* const PFLSwitchCoordKey = @"PFLSwitchCoordKey";

@implementation PFLAudioResponderSprite

- (instancetype)initWithImageNamed:(NSString*)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName];
  if (self)
  {
    self.active = YES;
    self.glyph = glyph;
    self.cell  = cell;
    self.theme = glyph.puzzle.puzzleSet.theme;
    self.defaultColor = [PFLColorUtils glyphDetailWithTheme:self.theme];
    self.activeColor = [PFLColorUtils glyphActiveWithTheme:self.theme];
    self.responderID = glyph.responderID;
  }
  return self;
}

- (void)onEnter
{
  [super onEnter];
  
  if (self.glyph.switchReceiverAttributes || [self.glyph.type isEqualToString:PFLGlyphTypeSwitchSender])
  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchHit:) name:PFLSwitchSenderHitNotification object:nil];
  }
}

- (void)onExit
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super onExit];
}

- (void)handleSwitchHit:(NSNotification*)notification
{
  if (![self respondsToSelector:@selector(audioResponderSwitchToState:animated:senderCell:)])
  {
    return;
  }
  
  NSNumber* switchChannel = notification.userInfo[PFLSwitchChannelKey];
  NSNumber* switchState = notification.userInfo[PFLSwitchStateKey];
  PFLCoord* senderCell = notification.userInfo[PFLSwitchCoordKey];
  
  if ([switchChannel isEqualToNumber:self.glyph.switchChannel])
  {
    [self audioResponderSwitchToState:switchState animated:YES senderCell:senderCell];
  }
}

#pragma mark - PFLAudioResponder

- (PFLCoord*)audioResponderCell
{
  return self.cell;
}

- (void)setAudioResponderCell:(PFLCoord *)coord
{
  self.cell = coord;
}

- (NSNumber*)audioResponderID
{
  return self.glyph.responderID;
}

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  CCLOG(@"Warning: audio responder hit needs implementation");
  return nil;
}

@end
