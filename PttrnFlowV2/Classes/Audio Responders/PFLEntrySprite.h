//
//  Entry.h
//  PttrnFlow
//
//  Created by John Saba on 2/2/14.
//
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"

@class PFLGlyph;

@interface PFLEntrySprite : CCSprite <PFLAudioResponder>

@property (copy, nonatomic) NSString* direction;

- (id)initWithGlyph:(PFLGlyph*)glyph;
- (id)initWithGlyph:(PFLGlyph*)glyph cell:(PFLCoord*)cell;

@end

