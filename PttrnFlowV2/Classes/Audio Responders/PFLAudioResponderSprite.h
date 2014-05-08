//
//  PFLAudioResponderSprite.h
//  PttrnFlowV2
//
//  Created by John Saba on 5/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"
#import "PFLCoord.h"
#import "PFLGlyph.h"

@interface PFLAudioResponderSprite : CCSprite <PFLAudioResponder>

@property (strong, nonatomic) PFLCoord* cell;
@property (strong, nonatomic) PFLGlyph* glyph;

- (instancetype)initWithImageNamed:(NSString*)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell;

@end
