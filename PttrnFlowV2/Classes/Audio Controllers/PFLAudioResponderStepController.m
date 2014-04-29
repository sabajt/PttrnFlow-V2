//
//  PFLAudioResponderStepController.m
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "PFLAudioResponder.h"
#import "PFLAudioResponderStepController.h"
#import "CCNode+PFLGrid.h"
#import "PFLAudioEventController.h"
#import "NSObject+PFLAudioResponderUtils.h"
#import "PFLEvent.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"

NSString* const PFLNotificationStartSequence = @"PFLNotificationStartSequence";
NSString* const PFLNotificationStepSequence = @"PFLNotificationStepSequence";
NSString* const PFLNotificationEndSequence = @"PFLNotificationEndSequence";

NSString* const kKeyCoord = @"coord";
NSString* const kKeyEmpty = @"empty";
NSString* const kKeyInBounds = @"inBounds";
NSString* const kKeyIndex = @"index";
NSString* const kKeyLoop = @"loop";

@interface PFLAudioResponderStepController ()

@property (strong, nonatomic) PFLPuzzle* puzzle;
@property (assign) NSInteger userSequenceIndex;
@property (assign) NSInteger solutionSequenceIndex;
@property (strong, nonatomic) NSMutableArray* responders;
@property (strong, nonatomic) PFLCoord* currentCell;
@property (copy, nonatomic) NSString* currentDirection;
@property (weak, nonatomic) PFLAudioEventController* audioEventController;

@end

@implementation PFLAudioResponderStepController

- (id)initWithPuzzle:(PFLPuzzle *)puzzle audioEventController:(PFLAudioEventController *)audioEventController
{
  self = [super init];
  if (self)
  {
    self.audioEventController = audioEventController;
    self.beatDuration = puzzle.puzzleSet.beatDuration;
    self.puzzle = puzzle;
    self.responders = [NSMutableArray array];
  }
  return self;
}

- (void)addResponder:(id<PFLAudioResponder>)responder
{
  [self.responders addObject:responder];
}

- (void)clearResponders
{
  [self.responders removeAllObjects];
}

- (void)stepUserSequence:(CCTime)dt
{
  BOOL inBounds = [self.currentCell isCoordInGroup:self.puzzle.area];
  
  NSArray* events = [self hitResponders:self.responders atCoord:self.currentCell];
  [self.audioEventController receiveEvents:events];
  
  BOOL loop = NO;
  for (PFLEvent* e in events)
  {
    if (e.eventType == PFLEventTypeDirection)
    {
      self.currentDirection = e.direction;
    }
    if (e.eventType == PFLEventTypeGoal)
    {
      loop = YES;
    }
  }
  
  NSDictionary* info = @{
    kKeyCoord : self.currentCell,
    kKeyEmpty : @(events.count == 0),
    kKeyInBounds : @(inBounds),
    kKeyIndex : @(self.userSequenceIndex),
    kKeyLoop : @(loop)
  };
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLNotificationStepSequence object:nil userInfo:info];
  
  if (!inBounds)
  {
    [self stopUserSequence];
    return;
  }

  if (loop)
  {
    self.userSequenceIndex = 0;
    self.currentCell = self.entry.cell;
  }
  else
  {
    self.currentCell = [self.currentCell stepInDirection:self.currentDirection];
    self.userSequenceIndex++;
  }
}

#pragma mark - PFLPuzzleControlsDelegate

- (void)startUserSequence
{
  self.userSequenceIndex = 0;
  self.currentCell = self.entry.cell;
  
  [self schedule:@selector(stepUserSequence:) interval:self.beatDuration];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLNotificationStartSequence object:nil userInfo:nil];
}

- (void)stopUserSequence
{
  [self unschedule:@selector(stepUserSequence:)];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:PFLNotificationEndSequence object:nil userInfo:nil];
}

@end
