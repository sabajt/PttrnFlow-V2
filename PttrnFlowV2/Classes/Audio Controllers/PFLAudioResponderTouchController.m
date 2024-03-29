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
#import "PFLGlyph.h"
#import "PFLPuzzleControlsLayer.h"

NSString* const kPFLAudioTouchDispatcherCoordKey = @"coord";
NSString* const kPFLAudioTouchDispatcherHitNotification = @"kPFLAudioTouchDispatcherHitNotification";

NSString* const PFLForwardTouchControllerMovedNotification = @"PFLForwardTouchControllerMovedNotification";
NSString* const PFLForwardTouchControllerEndedNotification = @"PFLForwardTouchControllerEndedNotification";
NSString* const PFLForwardTouchControllerTouchKey = @"PFLForwardTouchControllerTouchKey";

@interface PFLAudioResponderTouchController ()

@property (strong, nonatomic) NSMutableArray* responders;
@property (assign) CFMutableDictionaryRef trackingTouches;
@property (weak, nonatomic) PFLAudioEventController* audioEventController;
@property BOOL hasStartedUsesSequence;

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
  self.hasStartedUsesSequence = YES;
}

- (void)handleStopSequence:(NSNotification*)notification
{
  self.hasStartedUsesSequence = NO;
}

- (void)addResponder:(id<PFLAudioResponder>)responder
{
  [self.responders addObject:responder];
}

- (void)removeResponder:(id<PFLAudioResponder>)responder
{
  [self.responders removeObject:responder];
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
    if ([responder respondsToSelector:@selector(audioResponderCell)] &&
        ([cell isEqualToCoord:[responder audioResponderCell]]) &&
        [responder respondsToSelector:@selector(audioRelease:)])
    {
      [responder audioResponderRelease:1];
    }
  }
}

- (void)changeToCell:(PFLCoord*)toCell fromCell:(PFLCoord*)fromCell channel:(NSString*)channel
{
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
  if (pad && !pad.isStatic)
  {
    if ([toCell isCoordInGroup:self.areaCells])
    {
      // pop glyph off if responders at TO cell
      NSArray* toCellResponders = [self responders:self.responders atCoord:toCell];
      if (toCellResponders.count > 0)
      {
        [self.touchControllerDelegate glyphNodeDraggedOffBoardFromCell:fromCell];
        return;
      }
      
      // move any non-static responders to available cell
      for (CCNode<PFLAudioResponder>* node in fromCellResponders)
      {
        if ([node respondsToSelector:@selector(setAudioResponderCell:)])
        {
          node.position = [toCell relativeMidpoint];
          [node setAudioResponderCell:toCell];
        }
      }
    }
    // pop glyph off if dragged off area
    else
    {
      [self.touchControllerDelegate glyphNodeDraggedOffBoardFromCell:fromCell];
    }
  }
}

#pragma mark CCTargetedTouchDelegate

- (void)touchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self.parent touchBegan:touch withEvent:event];
  
  CGPoint touchPosition = [touch locationInNode:self];
  PFLCoord* cell = [PFLCoord coordForRelativePosition:touchPosition];
  
  // find if we touched an entry sprite before processing any hits so we can
  // start / stop the sequence instead of processing ourselves
  for (id<PFLAudioResponder> responder in self.responders)
  {
    if ([responder respondsToSelector:@selector(audioResponderCell)] &&
        [[responder audioResponderCell] isEqualToCoord:cell] &&
        [responder isKindOfClass:[PFLAudioResponderSprite class]])
    {
      PFLAudioResponderSprite* audioResponderSprite = (PFLAudioResponderSprite*)responder;
      if ([audioResponderSprite.glyph.type isEqualToString:PFLGlyphTypeEntry])
      {
        if (self.hasStartedUsesSequence) 
        {
          [self.controlEntryDelegate stopUserSequence];
          return;
        }
        else
        {
          [self.controlEntryDelegate startUserSequence];
          return;
        }
      }
    }
  }
  if (self.hasStartedUsesSequence)
  {
    return;
  }
  
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
  
  if (self.hasStartedUsesSequence)
  {
    return;
  }
  
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
    if (![PFLPuzzleControlsLayer isRestoringInventoryItem])
    {
      [self changeToCell:cell fromCell:lastCell channel:channel];
    }
    
    // TODO: hit / release will only be needed when working with PD synths later
//  [self releaseCell:lastCell channel:channel];
//  [self hitCell:cell channel:channel];
  }
  
  // broadcast forward touch
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLForwardTouchControllerMovedNotification object:nil userInfo:@{PFLForwardTouchControllerTouchKey : touch}];
}

- (void)touchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self.parent touchEnded:touch withEvent:event];
  
  if (self.hasStartedUsesSequence)
  {
    return;
  }

  // get channel
  NSMutableDictionary* touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
  NSString* channel = [touchInfo objectForKey:@"channel"];
  PFLEvent* audioStopEvent = [PFLEvent audioStopEventWithAudioID:nil puzzleFile:nil];
  [self.audioEventController receiveEvents:@[audioStopEvent]];

  // get grid cell of touch
  CGPoint touchPosition = [touch locationInNode:self];

  PFLCoord* cell = [PFLCoord coordForRelativePosition:touchPosition];
  [self releaseCell:cell channel:channel];

  CFDictionaryRemoveValue(self.trackingTouches, (__bridge void *)touch);

  self.allowScrolling = YES;
  
  // broadcast forward touch
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLForwardTouchControllerEndedNotification object:nil userInfo:@{PFLForwardTouchControllerTouchKey : touch}];
}

- (void)touchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
  [self.parent touchCancelled:touch withEvent:event];
  
  if (self.hasStartedUsesSequence)
  {
    return;
  }
  
  // get channel
  NSMutableDictionary* touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
  NSString* channel = [touchInfo objectForKey:@"channel"];
  PFLEvent* audioStopEvent = [PFLEvent audioStopEventWithAudioID:nil puzzleFile:nil];
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
