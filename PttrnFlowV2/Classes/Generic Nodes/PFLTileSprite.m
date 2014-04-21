//
//  TileSprite.m
//  PttrnFlow
//
//  Created by John Saba on 11/3/13.
//
//

#import "PFLTileSprite.h"
#import "PFLGameConstants.h"

@implementation PFLTileSprite

- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats skip:(NSInteger)skip;
{
  return [self initWithImage:image repeats:repeats color1:nil color2:nil skip:skip];
}

- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats color1:(CCColor *)color1 color2:(CCColor *)color2
{
  return [self initWithImage:image repeats:repeats color1:color1 color2:color2 skip:0];
}

- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats color1:(CCColor *)color1 color2:(CCColor *)color2 skip:(NSInteger)skip
{
  self = [super initWithImageNamed:image];
  if (self)
  {
    self.opacity = 0.0;
    CCSprite *tileSprite = [CCSprite spriteWithImageNamed:image];
    self.contentSize = CGSizeMake(tileSprite.contentSize.width * repeats.x * (skip + 1), tileSprite.contentSize.height * repeats.y * (skip + 1));
    
    for (int x = 0; x < repeats.x; x++)
    {
      for (int y = 0; y < repeats.y; y++)
      {
        CCSprite *spr = [CCSprite spriteWithImageNamed:image];
        spr.anchorPoint = ccp(0, 0);
        spr.position = ccp(x * spr.contentSize.width * (skip + 1), y * spr.contentSize.height * (skip + 1));
        [self addChild:spr];
        
        if (x % 2 == 0)
        {
          if (y % 2 == 0)
          {
            if (color1)
            {
              spr.color = color1;
            }
            else if (color2)
            {
              spr.color = color2;
            }
          }
          else
          {
            if (color2)
            {
              spr.color = color2;
            }
            else if (color1)
            {
              spr.color = color1;
            }
          }
        }
        else
        {
          if (y % 2 == 0)
          {
            if (color2)
            {
              spr.color = color2;
            }
            else if (color1)
            {
              spr.color = color1;
            }
          }
          else
          {
            if (color1)
            {
              spr.color = color1;
            }
            else if (color2)
            {
              spr.color = color2;
            }
          }
        }
      }
    }
  }
  return self;
}

@end
