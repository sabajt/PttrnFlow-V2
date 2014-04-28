//
//  PFLGoal.h
//  PttrnFlowV2
//
//  Created by John Saba on 4/24/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"

@class PFLGlyph;

@interface PFLGoalSprite : CCSprite <PFLAudioResponder>

- (id)initWithGlyph:(PFLGlyph*)glyph;
- (id)initWithGlyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell;

@end
