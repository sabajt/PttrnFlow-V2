//
//  PFLAudioResponderSprite.h
//  PttrnFlowV2
//
//  Created by John Saba on 5/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"

@class PFLGlyph, PFLCoord;

FOUNDATION_EXPORT NSString* const PFLSwitchSenderHitNotification;
FOUNDATION_EXPORT NSString* const PFLSwitchChannelKey;
FOUNDATION_EXPORT NSString* const PFLSwitchStateKey;
FOUNDATION_EXPORT NSString* const PFLSwitchCoordKey;

@interface PFLAudioResponderSprite : CCSprite <PFLAudioResponder>

@property BOOL active;
@property (strong, nonatomic) PFLCoord* cell;
@property (strong, nonatomic) PFLGlyph* glyph;
@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;
@property (copy, nonatomic) NSString* theme;
@property (strong, nonatomic) NSNumber* switchState;
@property (strong, nonatomic) NSNumber* responderID;

- (instancetype)initWithImageNamed:(NSString*)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell;

@end
