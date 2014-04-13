//
//  ToggleButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "CCSprite.h"

@class PFLToggleButton;

@protocol ToggleButtonDelegate <NSObject>

- (void)toggleButtonPressed:(PFLToggleButton *)sender;

@end

@interface PFLToggleButton : CCSprite

@property BOOL isOn;

- (id)initWithPlaceholderImage:(NSString *)placeholderImage offImage:(NSString *)offImage onImage:(NSString *)onImage delegate:(id<ToggleButtonDelegate>)delegate;
- (id)initWithImage:(NSString *)image defaultColor:(CCColor *)defaultColor activeColor:(CCColor*)activeColor delegate:(id<ToggleButtonDelegate>)delegate;
- (void)toggle;

@end
