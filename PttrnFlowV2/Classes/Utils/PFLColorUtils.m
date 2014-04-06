//
//  ColorUtils.m
//  PttrnFlow
//
//  Created by John Saba on 2/4/13.
//
//

#import "PFLColorUtils.h"

NSString *const kPFLColorUtilsPurpleTheme = @"purple";
NSString *const kPFLColorUtilsLightPurpleTheme = @"purple_light";

@implementation PFLColorUtils

#pragma mark - Colors

+ (CCColor *)activeYellow
{
    return [CCColor colorWithCcColor3b:ccc3(255, 212, 39)];
}

+ (CCColor *)cream
{
//    return ccc3(252, 251, 247); // original
    return [CCColor colorWithCcColor3b:ccc3(232, 231, 227)]; // darker
}

+ (CCColor *)darkCream
{
    return [CCColor colorWithCcColor3b:ccc3(222, 221, 217)];
}

+ (CCColor *)darkGray
{
    return [CCColor colorWithCcColor3b:ccc3(43, 43, 43)];
}

+ (CCColor *)darkPurple
{
    return [CCColor colorWithCcColor3b:ccc3(102, 77, 102)];
}

+ (CCColor *)defaultPurple
{
    return [CCColor colorWithCcColor3b:ccc3(157, 79, 140)];
}

+ (CCColor *)dimPurple
{
    return [CCColor colorWithCcColor3b:ccc3(155, 138, 159)];
}

+ (CCColor *)lightPurple
{
    return [CCColor colorWithCcColor3b:ccc3(227, 222, 238)];
}

#pragma mark - Themes

+ (CCColor *)audioPanelEdgeWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)audioPanelFillWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)backgroundWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkGray];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
//        return [PFLColorUtils lightPurple];
        return [PFLColorUtils darkCream];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)controlButtonsDefaultWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)controlButtonsActiveWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)controlPanelEdgeWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)controlPanelFillWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)glyphActiveWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)glyphDetailWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)padHighlightWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)padWithTheme:(NSString *)theme isStatic:(BOOL)isStatic
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        if (isStatic) {
            return [PFLColorUtils dimPurple];
        }
        return [PFLColorUtils defaultPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        if (isStatic) {
            return [PFLColorUtils dimPurple];
        }
        return [PFLColorUtils defaultPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

+ (CCColor *)solutionButtonHighlightWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return [CCColor blackColor];
}

@end
