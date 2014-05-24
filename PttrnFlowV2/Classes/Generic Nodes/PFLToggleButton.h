//
//  ToggleButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "CCSprite.h"

@interface PFLToggleButton : CCSprite

@property BOOL isOn;

@property (weak, nonatomic) id target;
@property (copy, nonatomic) NSString* touchBeganSelectorName;

- (id)initWithImage:(NSString *)image defaultColor:(CCColor *)defaultColor activeColor:(CCColor*)activeColor target:(id)target;

- (void)toggle;
- (void)toggleIgnoringTarget:(BOOL)ignoringTarget;

@end
