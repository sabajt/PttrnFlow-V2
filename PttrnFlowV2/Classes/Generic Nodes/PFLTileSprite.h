//
//  TileSprite.h
//  PttrnFlow
//
//  Created by John Saba on 11/3/13.
//
//

#import "CCSprite.h"

@interface PFLTileSprite : CCSprite

- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats skip:(NSInteger)skip;
- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats color1:(CCColor *)color1 color2:(CCColor *)color2;
- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats color1:(CCColor *)color1 color2:(CCColor *)color2 skip:(NSInteger)skip;

@end
