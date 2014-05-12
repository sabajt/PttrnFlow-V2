//
//  PFLFonts.m
//  PttrnFlowV2
//
//  Created by John Saba on 4/29/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLFonts.h"
#import "PFLGameConstants.h"

@implementation PFLFonts

+ (CGFloat)controlsPanelFontSize
{
  static CGFloat standardFontSize = 20.0f;
  CGSize screenSize = [CCDirector sharedDirector].designSize;
  if ((NSInteger)screenSize.width == PFLIPadDesignWidth)
  {
    return standardFontSize * 2.0f;
  }
  else if ((NSInteger)screenSize.width == PFLIPhoneDesignWidth)
  {
    return standardFontSize;
  }
  else
  {
    CCLOG(@"Warning: unsupported screen size: %@", NSStringFromCGSize(screenSize));
    return standardFontSize;
  }
}

+ (CGFloat)winLabelFontSize
{
  return [PFLFonts controlsPanelFontSize];
}

@end
