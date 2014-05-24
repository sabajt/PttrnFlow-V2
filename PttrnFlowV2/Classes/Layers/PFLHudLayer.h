//
//  PFLHudLayer.h
//  PttrnFlowV2
//
//  Created by John Saba on 5/24/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCNode.h"

@protocol PFLHudLayerDelegate <NSObject>

@optional
- (void)backButtonPressed;
- (void)muteButtonPressed;

@end

@interface PFLHudLayer : CCNode

@property (weak, nonatomic) id<PFLHudLayerDelegate> delegate;

- (id)initWithTheme:(NSString*)theme;

@end
