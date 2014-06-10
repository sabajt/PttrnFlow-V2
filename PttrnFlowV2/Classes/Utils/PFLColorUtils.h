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

+ (CCColor*)activeYellow;
+ (CCColor*)cream;
+ (CCColor*)darkCream;
+ (CCColor*)darkGray;
+ (CCColor*)darkPurple;
+ (CCColor*)defaultPurple;
+ (CCColor*)dimPurple;
+ (CCColor*)lightPurple;
+ (CCColor*)strawberry;
+ (CCColor*)translucentBlack;

#pragma mark - Theme

+ (CCColor*)audioPanelEdgeWithTheme:(NSString*)theme;
+ (CCColor*)audioPanelFillWithTheme:(NSString*)theme;
+ (CCColor*)backgroundWithTheme:(NSString*)theme;
+ (CCColor*)contentBackedButtonsDefaultWithTheme:(NSString*)theme;
+ (CCColor*)contentBackedButtonsActiveWithTheme:(NSString*)theme;
+ (CCColor*)controlPanelButtonsDefaultWithTheme:(NSString*)theme;
+ (CCColor*)controlPanelButtonsActiveWithTheme:(NSString*)theme;
+ (CCColor*)controlPanelFillWithTheme:(NSString*)theme;
+ (CCColor*)dropHighlightWithTheme:(NSString*)theme;
+ (CCColor*)glyphActiveWithTheme:(NSString*)theme;
+ (CCColor*)glyphDetailWithTheme:(NSString*)theme;
+ (CCColor*)padHighlightWithTheme:(NSString*)theme;
+ (CCColor*)padWithTheme:(NSString*)theme isStatic:(BOOL)isStatic;
+ (CCColor*)specialGlyphDetailWithTheme:(NSString*)theme;
+ (CCColor*)winLabelWithTheme:(NSString*)theme;

@end

