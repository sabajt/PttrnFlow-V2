//
//  PFLAudioResponderTouchController.m
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "NSObject+PFLAudioResponderUtils.h"
#import "PFLAudioEventController.h"
#import "PFLAudioPadSprite.h"
#import "PFLAudioResponderStepController.h"
#import "PFLAudioResponderTouchController.h"
#import "PFLCoord.h"
#import "PFLEvent.h"

NSString* const kPFLAudioTouchDispatcherCoordKey = @"coord";
NSString* const kPFLAudioTouchDispatcherHitNotification = @"kPFLAudioTouchDispatcherHitNotification";

@interface PFLAudioResponderTouchController ()

@property (strong, nonatomic) NSMutableArray* responders;
@property (assign) CFMutableDictionaryRef trackingTouches;
@property (weak, nonatomic) PFLAudioEventController* audioEventController;

@end

@implementation PFLAudioResponderTouchController

- (id)initWithBeatDuration:(CGFloat)duration audioEventController:(PFLAudioEventController*)audioEventController
{
  self = [super init];
  if (self)
  {    
    self.audioEventController = audioEventController;
    self.contentSize = CGSizeMake(320, 568);
    self.userInteractionEnabled = YES;
    self.allowScrolling = YES;
    self.responders = [NSMutableArray array];
    self.trackingTouches = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    self.beatDuration = duration;
  }
  return self;
}

- (void)onEnter
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartSequence:) name:PFLNotificationStartSequence object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStopSequence:) name:PFLNotificationEndSequence object:nil];
}

- (void)onExit
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleStartSequence:(NSNotification*)notification
{
  self.userInteractionEnabled = NO;
}

- (void)handleStopSequence:(NSNotification*)notification
{
  self.userInteractionEnabled = YES;
}

- (void)addResponder:(id<PFLAudioResponder>)responder
{
  [self.responders addObject:responder];
}

- (void)clearResponders
{
  [self.responders removeAllObjects];
}

- (void)hitCell:(PFLCoord*)coord channel:(NSString *)channel
{
  // collect events from all hit cells
  NSArray* events = [self hitResponders:self.responders atCoord:coord];
  
  // block scrolling the puzzle if there are any events
  self.allowScrolling = (events.count == 0);
  
  // send events to pd
  [self.audioEventController receiveEvents:events];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:kPFLAudioTouchDispatcherHitNotification object:nil userInfo:@{kPFLAudioTouchDispatcherCoordKey : coord}];
}

// TODO: currently not being used
- (void)releaseCell:(PFLCoord*)cell channel:(NSString*)channel
{
  for (id<PFLAudioResponder> responder in self.responders)
  {
    if (([cell isEqualToCoord:[responder audioResponderCell]]) &&
        [responder respondsToSelector:@selector(audioRelease:)])
    {
      [responder audioResponderRelease:1];
    }
  }
}

- (void)changeToCell:(PFLCoord*)toCell fromCell:(PFLCoord*)fromCell channel:(NSString*)channel
{
  // don't do anything if responders at to cell
  NSArray* toCellResponders = [self responders:self.responders atCoord:toCell];
  if (toCellResponders.count > 0)
  {
      return;
  }
  
  // move any responders to available cell if audio pad is not static
  PFLAudioPadSprite* pad;
  NSArray* fromCellResponders = [self responders:self.responders atCoord:fromCell];
  if (fromCellResponders.count > 0)
  {
    NSInteger found = [fromCellResponders indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
      return [obj isKindOfClass:[PFLAudioPadSprite class]];
    }];
    if (found != NSNotFound) {
      pad = fromCellResponders[found];
    }
  }
  if (pad && !pad.isStatic && [toCell isCoordInGroup:self.areaCells])
  {
    for (CCNode<PFLAudioResponder>* node in fromCellResponders)
    {
      node.position = [toCell relativeMidpoint];
      [node setAudioResponderCell:toCell];
    }
  }
}

#pragma mark CCTargetedTouchDelegate

- (void)touchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self.parent touchBegan:touch withEvent:event];
  
  // get grid cell of touch
  CGPoint touchPosition = [touch locationInNode:self];

  PFLCoord* cell = [PFLCoord coordForRelativePosition:touchPosition];
  
  // track touch so we know which events / cell to associate
  CFIndex count = CFDictionaryGetCount(self.trackingTouches);
  NSString* channel = [NSString stringWithFormat:@"%ld", count];
  NSDictionary* touchInfo = @{ @"channel" : channel, @"x" : @(cell.x), @"y" : @(cell.y) };
  NSMutableDictionary* mutableTouchInfo = [NSMutableDictionary dictionaryWithDictionary:touchInfo];
  CFDictionaryAddValue(self.trackingTouches, (__bridge void *)(touch), (__bridge void *)(mutableTouchInfo));
  
  [self hitCell:cell channel:channel];
}

- (void)touchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self.parent touchMoved:touch withEvent:event];
  
  // get grid cell of touch
  CGPoint touchPosition = [touch locationInNode:self];
  
  PFLCoord *cell = [PFLCoord coordForRelativePosition:touchPosition];
  
  // get channel and last touched cell of this specific touch
  NSMutableDictionary* touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
  NSString* channel = [touchInfo objectForKey:@"channel"];
  NSNumber* x = touchInfo[@"x"];
  NSNumber* y = [touchInfo objectForKey:@"y"];
  PFLCoord* lastCell = [PFLCoord coordWithX:[x integerValue] Y:[y integerValue]];
  
  // if touch moved to a new cell, update info
  if (![cell isEqualToCoord:lastCell])
  {
    [touchInfo setObject:@(cell.x) forKey:@"x"];
    [touchInfo setObject:@(cell.y) forKey:@"y"];
    CFDictionaryReplaceValue(self.trackingTouches, (__bridge void *)(touch), (__bridge void *)(touchInfo));
    
    // process cell change
    [self changeToCell:cell fromCell:lastCell channel:channel];
    
    // TODO: hit / release will only be needed when working with PD synths later
//  [self releaseCell:lastCell channel:channel];
//  [self hitCell:cell channel:channel];
  }
}

- (void)touchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self.parent touchEnded:touch withEvent:event];

  // get channel
  NSMutableDictionary* touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
  NSString* channel = [touchInfo objectForKey:@"channel"];
  PFLEvent* audioStopEvent = [PFLEvent audioStopEventWithAudioID:nil];
  [self.audioEventController receiveEvents:@[audioStopEvent]];

  // get grid cell of touch
  //    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
  CGPoint touchPosition = [touch locationInNode:self];

  PFLCoord* cell = [PFLCoord coordForRelativePosition:touchPosition];
  [self releaseCell:cell channel:channel];

  CFDictionaryRemoveValue(self.trackingTouches, (__bridge void *)touch);

  self.allowScrolling = YES;
}

- (void)touchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self.parent touchCancelled:touch withEvent:event];
  
  // get channel
  NSMutableDictionary* touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
  NSString* channel = [touchInfo objectForKey:@"channel"];
  PFLEvent* audioStopEvent = [PFLEvent audioStopEventWithAudioID:nil];
  [self.audioEventController receiveEvents:@[audioStopEvent]];
  
  // get grid cell of touch
  CGPoint touchPosition = [touch locationInNode:self];

  PFLCoord* cell = [PFLCoord coordForRelativePosition:touchPosition];
  [self releaseCell:cell channel:channel];
  
  CFDictionaryRemoveValue(self.trackingTouches, (__bridge void *)touch);
  
  self.allowScrolling = YES;
}

- (BOOL)hitTestWithWorldPos:(CGPoint)pos
{
  return YES;
}

#pragma mark - ScrollLayerDelegate

- (BOOL)shouldScroll
{
  return self.allowScrolling;
}

@end
