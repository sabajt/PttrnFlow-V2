//
//  GameConstants.m
//  SequencerGame
//
//  Created by John Saba on 1/20/13.
//
//

#import "PFLGameConstants.h"

// sprite sheets
NSString *const kTextureKeySamplePads = @"samplePads";
NSString *const kTextureKeySynthPads = @"synthPads";
NSString *const kTextureKeyOther = @"other";
NSString *const kTextureKeyBackground = @"background";
NSString *const kTextureKeyAudioObjects = @"audioObjects";

// directions
NSString *const kDirectionUp = @"up";
NSString *const kDirectionRight = @"right";
NSString *const kDirectionDown = @"down";
NSString *const kDirectionLeft = @"left";

// size
NSInteger const PFLIPhoneRetinaScreenWidth = 640;
NSInteger const PFLIPadRetinaScreenWidth = 768;
CGFloat const kStatusBarHeight = 20.0;

// duration
CCTime const kTransitionDuration = 0.4;

// notifications
NSString *const kNotificationRemoveTickReponder = @"removeAudioResponder";
NSString *const kNotificationStartPan = @"startPan";
NSString *const kNotificationLockPan = @"lockPan";
NSString *const kNotificationUnlockPan = @"unlockPan";

// frame names
NSString *const kClearRectUILayer = @"clear_rect_uilayer.png";
NSString *const kClearRectAudioBatch = @"clear_rect_audio_batch.png";

@implementation PFLGameConstants

+ (CGFloat)gridUnit
{
  CGSize screenSize = [[CCDirector sharedDirector] designSize];
  if ((NSInteger)screenSize.width == PFLIPadRetinaScreenWidth)
  {
    return 68.0f * 2.0f;
  }
  else if ((NSInteger)screenSize.width == PFLIPhoneRetinaScreenWidth)
  {
    return 68.0f;
  }
  else
  {
    CCLOG(@"Warning: unsupported screen width: %f", screenSize.width);
    return 68.0f;
  }
}

+ (CGSize)gridUnitSize
{
  return CGSizeMake([PFLGameConstants gridUnit], [PFLGameConstants gridUnit]);
}

@end