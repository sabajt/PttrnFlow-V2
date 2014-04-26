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

NSString *const kNotificationStepUserSequence = @"stepUserSequence";
NSString *const kNotificationStepSolutionSequence = @"stepSolutionSequence";
NSString *const kNotificationEndUserSequence = @"endUserSequence";
NSString *const kNotificationEndSolutionSequence = @"endSolutionSequence";
NSString *const kKeyIndex = @"index";
NSString *const kKeyCoord = @"coord";
NSString *const kKeyCorrectHit = @"correctHit";
NSString *const kKeyEmpty = @"empty";

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

- (PFLCoord*)nextStep
{
  return [self nextStepInDirection:self.currentDirection currentCoord:self.currentCell];
}

- (PFLCoord*)nextStepInDirection:(NSString *)direction currentCoord:(PFLCoord*)currentCoord
{
  PFLCoord* maxCoord = [PFLCoord maxCoord:self.puzzle.area];
  PFLCoord* minCoord = [PFLCoord minCoord:self.puzzle.area];
  currentCoord = [currentCoord stepInDirection:direction];
  
  if (currentCoord.x > maxCoord.x)
  {
    currentCoord = [PFLCoord coordWithX:minCoord.x Y:currentCoord.y];
  }
  if (currentCoord.y > maxCoord.y)
  {
    currentCoord = [PFLCoord coordWithX:currentCoord.x Y:minCoord.y];
  }
  if (currentCoord.x < minCoord.x)
  {
    currentCoord = [PFLCoord coordWithX:maxCoord.x Y:currentCoord.y];
  }
  if (currentCoord.y < minCoord.y)
  {
    currentCoord = [PFLCoord coordWithX:currentCoord.x Y:maxCoord.y];
  }
  if ([currentCoord isCoordInGroup:self.puzzle.area])
  {
    return currentCoord;
  }
  return [self nextStepInDirection:direction currentCoord:currentCoord];
}

- (void)stepUserSequence:(CCTime)dt
{    
  if (self.userSequenceIndex >= self.puzzle.solutionEvents.count)
  {
    // use notification instead of stopUserSequence so SequenceControlsLayer can toggle button off
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEndUserSequence object:nil];
    return;
  }
  
  NSArray* events = [self hitResponders:self.responders atCoord:self.currentCell];
  [self.audioEventController receiveEvents:events];
  
  for (PFLEvent* e in events)
  {
    if (e.eventType == PFLEventTypeDirection)
    {
      self.currentDirection = e.direction;
    }
  }
  
  BOOL correctHit = NO;
  if ([[events audioEvents] hasSameNumberOfSameObjects:self.puzzle.solutionEvents[self.userSequenceIndex]])
  {
    CCLOG(@"hit");
    correctHit = YES;
  }
  else
  {
    CCLOG(@"miss");
  }
  
  NSDictionary* info = @{
    kKeyIndex : @(self.userSequenceIndex),
    kKeyCoord : self.currentCell,
    kKeyCorrectHit : @(correctHit),
    kKeyEmpty : @(events.count == 0)
  };
  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStepUserSequence object:nil userInfo:info];

  self.currentCell = [self nextStep];
  self.userSequenceIndex++;
}

#pragma mark - PFLPuzzleControlsDelegate

- (void)startUserSequence
{
  self.userSequenceIndex = 0;
  self.currentCell = self.entry.cell;
  self.currentDirection = self.entry.direction;
  [self schedule:@selector(stepUserSequence:) interval:self.beatDuration];
}

- (void)stopUserSequence
{
  [self unschedule:@selector(stepUserSequence:)];
}

@end
