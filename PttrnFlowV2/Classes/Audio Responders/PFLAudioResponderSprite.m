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

- (void)handleSwitchHit:(NSNotification*)notification
{
  NSNumber* switchChannel = notification.userInfo[PFLSwitchChannelKey];
  NSNumber* switchState = notification.userInfo[PFLSwitchStateKey];
  if ([switchChannel isEqualToNumber:self.glyph.switchChannel] &&
      [self respondsToSelector:@selector(audioResponderSwitchToState:)])
  {
    [self audioResponderSwitchToState:[switchState integerValue]];
  }
  else
  {
    CCLOG(@"Warning: glyph with switch receiver attributes does not implement audioResponderSwitchState:channel:");
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
