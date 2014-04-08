//
//  Synth.m
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "PFLSynthSprite.h"
#import "CCNode+PFLGrid.h"
#import "PFLColorUtils.h"
#import "PFLEvent.h"

@interface PFLSynthSprite ()

@property (strong, nonatomic) CCColor* defaultColor;
@property (strong, nonatomic) CCColor* activeColor;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation PFLSynthSprite

- (id)initWithCell:(PFLCoord *)cell
           audioID:(NSNumber *)audioID
             synth:(NSString *)synth
              midi:(NSNumber *)midi
             image:(NSString *)image
         decorator:(NSString *)decorator
{
    self = [super initWithImageNamed:image];
    if (self) {
        self.defaultColor = [PFLColorUtils cream];
        self.activeColor = [PFLColorUtils activeYellow];
        self.color = self.defaultColor;
        
        self.event = [PFLEvent synthEventWithAudioID:audioID midiValue:[midi stringValue] synthType:synth];
        
        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
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
//    CCTintTo *tint = [CCTintTo actionWithDuration:beatDuration red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    CCActionTintTo *tint = [CCActionTintTo actionWithDuration:beatDuration color:self.defaultColor];
    [self runAction:[CCActionEaseSineOut actionWithAction:tint]];
    
    return self.event;
}

@end

