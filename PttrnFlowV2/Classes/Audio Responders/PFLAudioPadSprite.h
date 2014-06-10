//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "PFLAudioResponderSprite.h"

@class PFLGlyph, PFLCoord;

@interface PFLAudioPadSprite : PFLAudioResponderSprite

@property (assign) BOOL isStatic;

- (instancetype)initWithGlyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell;

@end
