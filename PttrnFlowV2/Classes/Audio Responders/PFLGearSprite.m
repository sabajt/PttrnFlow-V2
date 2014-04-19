//
//  Gear.m
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "PFLColorUtils.h"
#import "CCNode+PFLGrid.h"
#import "PFLGearSprite.h"
#import "PFLEvent.h"
#import "PFLAudioEventController.h"
#import "PFLPuzzle.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"

@interface PFLGearSprite ()

@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;
@property (strong, nonatomic) NSMutableArray *audioUnits;
@property (strong, nonatomic) PFLEvent *multiSampleEvent;

@end

@implementation PFLGearSprite

- (id)initWithGlyph:(PFLGlyph *)glyph multiSample:(PFLMultiSample *)multiSample
{
    self = [super initWithImageNamed:@"audio_circle.png"];
    if (self) {;
        NSString *theme = glyph.puzzle.puzzleSet.theme;
        self.defaultColor = [PFLColorUtils glyphDetailWithTheme:theme];
        self.activeColor = [PFLColorUtils glyphActiveWithTheme:theme];
        self.color = self.defaultColor;
        
        // CCNode+Grid
        self.cell = glyph.cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        
        // units (beats)
        self.audioUnits = [NSMutableArray array];
        for (PFLSample *sample in multiSample.samples) {
            
            // container
            CCSprite *container = [CCSprite spriteWithImageNamed:@"audio_box_empty.png"];
            container.rotation = 360.0f * [sample.time floatValue];
            container.position = ccp(self.contentSize.width / 2.0f, self.contentSize.height / 2.0f);
            
            // audio unit
            CCSprite *audioUnit = [CCSprite spriteWithImageNamed:@"audio_unit.png"];
            static CGFloat unitPadding = 4.0f;
            audioUnit.position = ccp(container.contentSize.width / 2, (container.contentSize.height - audioUnit.contentSize.height / 2) - unitPadding);
            audioUnit.color = [PFLColorUtils glyphDetailWithTheme:theme];
            
            // unit symbol
            CCSprite *unitSymbol = [CCSprite spriteWithImageNamed:sample.image];
            unitSymbol.color = [PFLColorUtils padWithTheme:theme isStatic:glyph.isStatic];
            CGFloat symbolPadding = 2.0f;
            unitSymbol.position = ccp(audioUnit.contentSize.width / 2.0f, audioUnit.contentSize.height / 2.0f + symbolPadding);
            
            [audioUnit addChild:unitSymbol];
            [container addChild:audioUnit];
            [self addChild:container];

            [self.audioUnits addObject:audioUnit];
        }
        self.multiSampleEvent = [PFLEvent multiSampleEventWithAudioID:glyph.audioID multiSample:multiSample];
    }
    return self;
}

#pragma mark - AudioResponder

- (PFLCoord *)audioCell
{
    return self.cell;
}

- (PFLEvent *)audioHit:(CGFloat)beatDuration
{
    self.color = self.activeColor;
    CCActionTintTo *tint1 = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
    [self runAction:[CCActionEaseSineOut actionWithAction:tint1]];
    
    for (CCSprite *unit in self.audioUnits) {
        unit.color = self.activeColor;
        CCActionTintTo *tint2 = [CCActionTintTo actionWithDuration:beatDuration * 2.0 color:self.defaultColor];
        [unit runAction:[CCActionEaseSineOut actionWithAction:tint2]];
    }
    
    CCActionRotateBy *rotate = [CCActionRotateBy actionWithDuration:beatDuration angle:360.0f];
    [self runAction:[CCActionEaseSineOut actionWithAction:rotate]];
    
    return self.multiSampleEvent;
}

@end
