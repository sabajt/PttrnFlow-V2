//
//  ColorUtils.h
//  SequencerGame
//
//  Created by John Saba on 2/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

FOUNDATION_EXPORT NSString *const kPFLColorUtilsPurpleTheme;
FOUNDATION_EXPORT NSString *const kPFLColorUtilsLightPurpleTheme;

@interface PFLColorUtils : NSObject

+ (CCColor *)activeYellow;
+ (CCColor *)cream;
+ (CCColor *)darkCream;
+ (CCColor *)darkGray;
+ (CCColor *)darkPurple;
+ (CCColor *)defaultPurple;
+ (CCColor *)dimPurple;
+ (CCColor *)lightPurple;

#pragma mark - Theme

+ (CCColor *)audioPanelEdgeWithTheme:(NSString *)theme;
+ (CCColor *)audioPanelFillWithTheme:(NSString *)theme;
+ (CCColor *)backgroundWithTheme:(NSString *)theme;
+ (CCColor *)controlButtonsDefaultWithTheme:(NSString *)theme;
+ (CCColor *)controlButtonsActiveWithTheme:(NSString *)theme;
+ (CCColor *)controlPanelEdgeWithTheme:(NSString *)theme;
+ (CCColor *)controlPanelFillWithTheme:(NSString *)theme;
+ (CCColor *)glyphActiveWithTheme:(NSString *)theme;
+ (CCColor *)glyphDetailWithTheme:(NSString *)theme;
+ (CCColor *)padHighlightWithTheme:(NSString *)theme;
+ (CCColor *)padWithTheme:(NSString *)theme isStatic:(BOOL)isStatic;
+ (CCColor *)solutionButtonHighlightWithTheme:(NSString *)theme;

@end

