//
//  BackgroundLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/28/13.
//
//

#import "cocos2d.h"

@interface PFLPuzzleBackgroundLayer : CCNode

+ (PFLPuzzleBackgroundLayer *)backgroundLayerWithTheme:(NSString *)theme;
+ (PFLPuzzleBackgroundLayer *)backgroundLayerWithColor:(CCColor *)color;

@end
