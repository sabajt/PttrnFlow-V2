//
//  BasicButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "CCSprite.h"

@interface PFLBasicButton : CCSprite

@property (weak, nonatomic) id target;

@property (copy, nonatomic) NSString* touchBeganSelectorName;
@property (copy, nonatomic) NSString* touchEndedSelectorName;

- (id)initWithImage:(NSString *)image defaultColor:(CCColor *)defaultColor activeColor:(CCColor*)activeColor target:(id)target;

@end