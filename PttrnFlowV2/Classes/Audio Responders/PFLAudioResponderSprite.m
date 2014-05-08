//
//  PFLAudioResponderSprite.m
//  PttrnFlowV2
//
//  Created by John Saba on 5/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLAudioResponderSprite.h"

@implementation PFLAudioResponderSprite

- (instancetype)initWithImageNamed:(NSString*)imageName glyph:(PFLGlyph *)glyph cell:(PFLCoord *)cell
{
  self = [super initWithImageNamed:imageName];
  if (self)
  {
    self.glyph = glyph;
    self.cell  = cell;
  }
  return self;
}

#pragma mark - PFLAudioResponder

- (PFLCoord*)audioResponderCell
{
  return self.cell;
}

- (void)setAudioResponderCell:(PFLCoord *)coord
{
  self.cell = coord;
}

- (NSNumber*)audioResponderID
{
  return self.glyph.responderID;
}

- (PFLEvent*)audioResponderHit:(CGFloat)beatDuration
{
  CCLOG(@"Warning: audio responder hit needs implementation");
  return nil;
}

@end
