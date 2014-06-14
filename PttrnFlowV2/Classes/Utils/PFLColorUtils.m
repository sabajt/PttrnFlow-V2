//
//  ColorUtils.m
//  PttrnFlow
//
//  Created by John Saba on 2/4/13.
//
//

#import "PFLColorUtils.h"

NSString *const kPFLColorUtilsLightPurpleTheme = @"purple_light";

@implementation PFLColorUtils

#pragma mark - Colors

+ (CCColor*)activeYellow
{
  return [CCColor colorWithCcColor3b:ccc3(255, 212, 39)];
}

+ (CCColor*)cream
{
//    return ccc3(252, 251, 247); // original
  return [CCColor colorWithCcColor3b:ccc3(232, 231, 227)]; // darker
}

+ (CCColor*)darkCream
{
  return [CCColor colorWithCcColor3b:ccc3(222, 221, 217)];
}

+ (CCColor*)darkGray
{
  return [CCColor colorWithCcColor3b:ccc3(43, 43, 43)];
}

+ (CCColor*)darkPurple
{
  return [CCColor colorWithCcColor3b:ccc3(102, 77, 102)];
}

+ (CCColor*)defaultPurple
{
  return [CCColor colorWithCcColor3b:ccc3(157, 79, 140)];
}

+ (CCColor*)dimPurple
{
  return [CCColor colorWithCcColor3b:ccc3(155, 138, 159)];
}

+ (CCColor*)lightPurple
{
  return [CCColor colorWithCcColor3b:ccc3(227, 222, 238)];
}

+ (CCColor*)strawberry
{
  return [CCColor colorWithCcColor3b:ccc3(216, 65, 121)];
}

+ (CCColor*)translucentBlack
{
  return [CCColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
}

#pragma mark - Themes

+ (CCColor *)audioPanelEdgeWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils dimPurple];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)audioPanelFillWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils darkCream];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)backgroundWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils darkCream];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)contentBackedButtonsDefaultWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils dimPurple];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)contentBackedButtonsActiveWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils darkPurple];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)controlPanelButtonsDefaultWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils darkCream];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)controlPanelButtonsActiveWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils darkPurple];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)controlPanelFillWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils translucentBlack];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)dropHighlightWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils translucentBlack];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor *)glyphActiveWithTheme:(NSString *)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils activeYellow];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor*)glyphDetailWithTheme:(NSString*)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils darkCream];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor*)padHighlightWithTheme:(NSString*)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils darkPurple];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor*)padWithTheme:(NSString*)theme isStatic:(BOOL)isStatic
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    if (isStatic)
    {
      return [PFLColorUtils dimPurple];
    }
    return [PFLColorUtils defaultPurple];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor*)specialGlyphDetailWithTheme:(NSString*)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils strawberry];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

+ (CCColor*)winLabelWithTheme:(NSString*)theme
{
  if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme])
  {
    return [PFLColorUtils dimPurple];
  }
  CCLOG(@"Warning theme '%@' not recognized", theme);
  return [CCColor blackColor];
}

@end
