//
//  BasicButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "CCSprite.h"

@class PFLBasicButton;

@protocol BasicButtonDelegate <NSObject>

- (void)basicButtonPressed:(PFLBasicButton *)sender;

@end

@interface PFLBasicButton : CCSprite

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName
                      offFrameName:(NSString *)offFrameName
                       onFrameName:(NSString *)onFrameName
                          delegate:(id<BasicButtonDelegate>)delegate;
- (id)initWithImage:(NSString *)image defaultColor:(CCColor *)defaultColor activeColor:(CCColor*)activeColor delegate:(id<BasicButtonDelegate>)delegate;

@end