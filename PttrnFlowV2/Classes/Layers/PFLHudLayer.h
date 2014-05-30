//
//  PFLHudLayer.h
//  PttrnFlowV2
//
//  Created by John Saba on 5/24/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCNode.h"

FOUNDATION_EXPORT NSString* const PFLNotificationToggleMute;

@protocol PFLHudLayerDelegate <NSObject>

@optional
- (void)backButtonPressed;

@end

@interface PFLHudLayer : CCNode

@property (weak, nonatomic) id<PFLHudLayerDelegate> delegate;

+ (BOOL)isMuted;
+ (CGFloat)accesoryBarHeight;

- (id)initWithTheme:(NSString*)theme contentMode:(BOOL)contentMode;

@end
