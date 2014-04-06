//
//  PFLSolutionButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/15/14.
//
//

#import "CCSprite.h"

@class PFLSolutionButton;

@protocol PFLSolutionButtonDelegate <NSObject>

- (void)solutionButtonPressed:(PFLSolutionButton *)button;

@end

@interface PFLSolutionButton : CCSprite

@property (assign) NSInteger index;
@property (assign) BOOL isDisplaced;

- (id)initWithPlaceholderImage:(NSString *)placeholderImage size:(CGSize)size index:(NSInteger)index defaultColor:(CCColor *)defaultColor activeColor:(CCColor *)activeColor delegate:(id<PFLSolutionButtonDelegate>)delegate;
- (void)press;
- (void)animateCorrectHit:(BOOL)correct;
- (void)reset;

@end
