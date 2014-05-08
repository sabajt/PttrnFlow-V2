//
//  Gear.h
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "PFLAudioResponderSprite.h"

@class PFLMultiSample;

@interface PFLGearSprite : PFLAudioResponderSprite

- (instancetype)initWithImageNamed:(NSString *)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell multiSample:(PFLMultiSample*)multiSample;

@end
