//
//  AudioPad.m
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "PFLAudioPadSprite.h"
#import "CCNode+PFLGrid.h"
#import "CCSprite+PFLEffects.h"
#import "PFLColorUtils.h"
#import "PFLGameConstants.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzle.h"

@interface PFLAudioPadSprite ()

@property (strong, nonatomic) CCSprite *highlightSprite;

@end


@implementation PFLAudioPadSprite

- (id)initWithGlyph:(PFLGlyph *)glyph
{
    self = [super initWithImageNamed:@"audio_box.png"];
    if (self) {
        self.isStatic = glyph.isStatic;
        self.color = [PFLColorUtils padWithTheme:glyph.puzzle.puzzleSet.theme isStatic:glyph.isStatic];

        // CCNode+Grid
        self.cell = glyph.cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

#pragma mark - AudioResponder

- (PFLEvent *)audioHit:(CGFloat)beatDuration
{
    CCActionScaleTo *padScaleUp = [CCActionScaleTo actionWithDuration:beatDuration / 2.0f scale:1.2f];
    CCActionEaseSineIn *padEaseUp = [CCActionEaseSineIn actionWithAction:padScaleUp];
    CCActionScaleTo *padScaleDown = [CCActionScaleTo actionWithDuration:beatDuration / 2.0f scale:1.0f];
    CCActionEaseSineOut *padEaseDown = [CCActionEaseSineOut actionWithAction:padScaleDown];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[padEaseUp, padEaseDown]];
    [self runAction:seq];
    
    return nil;
}

- (PFLCoord *)audioCell
{
    return self.cell;
}

@end
