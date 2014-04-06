//
//  BackgroundLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/28/13.
//
//

#import "PFLPuzzleBackgroundLayer.h"
#import "PFLTileSprite.h"
#import "PFLColorUtils.h"
#import "PFLGameConstants.h"

@implementation PFLPuzzleBackgroundLayer

+ (PFLPuzzleBackgroundLayer *)backgroundLayerWithTheme:(NSString *)theme
{
//    PFLPuzzleBackgroundLayer *layer = [PFLPuzzleBackgroundLayer layerWithColor:ccc4BFromccc3B([PFLColorUtils backgroundWithTheme:theme])];
    
    PFLPuzzleBackgroundLayer *node = [PFLPuzzleBackgroundLayer backgroundLayerWithColor:[PFLColorUtils backgroundWithTheme:theme]];
    
    
//    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyBackground stringByAppendingString:@".png"]];
//    [layer addChild:batchNode];
//    
//    CCSprite *tempTile = [CCSprite spriteWithImageNamed:@"background_tile.png"];
//    NSInteger repeatHorizontal = (NSInteger)((layer.contentSize.width / tempTile.contentSize.width)) + 2;
//    NSInteger repeatVertical = (NSInteger)((layer.contentSize.height / tempTile.contentSize.height)) + 2;
//    
//    TileSprite *background1 = [[TileSprite alloc] initWithImage:@"background_tile.png" repeats:ccp(repeatHorizontal, repeatVertical) color1:[ColorUtils darkPurple] color2:[ColorUtils darkPurple]];
//    background1.position = ccp(layer.contentSize.width / 2, layer.contentSize.height / 2);
//    [batchNode addChild:background1];
    
    return node;
}

+ (PFLPuzzleBackgroundLayer *)backgroundLayerWithColor:(CCColor *)color
{
    // TODO: fix
    PFLPuzzleBackgroundLayer *node = [CCNodeColor nodeWithColor:color width:320 height:568];
    return node;
}

//- (void)tintToColor:(CCColor)color duration:(ccTime)duration
//{
//    CCTintTo *tint = [CCTintTo actionWithDuration:duration red:color.r green:color.g blue:color.b];
//    [self runAction:tint];
//}

@end
