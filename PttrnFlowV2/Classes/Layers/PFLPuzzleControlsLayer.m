//
//  SequenceUILayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "PFLPuzzleControlsLayer.h"
#import "PFLColorUtils.h"
#import "PFLTileSprite.h"
#import "PFLGameConstants.h"
#import "PFLAudioResponderStepController.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzleSetLayer.h"

static NSInteger const kRowLength = 8;

@interface PFLPuzzleControlsLayer ()

@property (weak, nonatomic) CCSpriteBatchNode *uiBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *transitionBatchNode;

@property (weak, nonatomic) id<PFLPuzzleControlsDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *solutionButtons;
@property (strong, nonatomic) NSMutableArray *solutionFlags;
@property (weak, nonatomic) PFLPuzzle *puzzle;

// size and positions
@property (assign) NSInteger steps;

// buttons
@property (weak, nonatomic) PFLToggleButton *speakerButton;
@property (weak, nonatomic) PFLToggleButton *playButton;
@property (weak, nonatomic) PFLBasicButton *exitButton;

@end

@implementation PFLPuzzleControlsLayer

+ (CGSize)uiButtonUnitSize
{
  CGSize screenSize = [CCDirector sharedDirector].designSize;
  if ((NSInteger)screenSize.width == PFLIPadRetinaScreenWidth)
  {
    return CGSizeMake(100.0f, 100.0f);
  }
  else if ((NSInteger)screenSize.width == PFLIPhoneRetinaScreenWidth)
  {
    return CGSizeMake(50.0f, 50.0f);
  }
  else
  {
    CCLOG(@"Warning: unsupported screen size: %@", NSStringFromCGSize(screenSize));
    return CGSizeMake(50.0f, 50.0f);
  }
}

+ (CGFloat)uiTimelineStepWidth
{
  CGSize screenSize = [CCDirector sharedDirector].designSize;
  return screenSize.width / 8.0f;
}

+ (CCSprite*)uiLeftControlPanelWithTheme:(NSString*)theme
{
  CCSprite* leftControlsPanel;
  CCSprite* leftControlsPanelBorder;
  CGSize screenSize = [CCDirector sharedDirector].designSize;
  if ((NSInteger)screenSize.width == PFLIPadRetinaScreenWidth)
  {
    leftControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_left_fill_extended.png"];
    leftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_left_edge_extended.png"];
  }
  else
  {
    leftControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_left_fill.png"];
    leftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_left_edge.png"];
  }
  leftControlsPanel.color = [PFLColorUtils controlPanelFillWithTheme:theme];
  leftControlsPanel.anchorPoint = ccp(0, 0);
  
  leftControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:theme];
  leftControlsPanelBorder.anchorPoint = ccp(0, 0);
  leftControlsPanelBorder.position = ccp(0, 0);
  [leftControlsPanel addChild:leftControlsPanelBorder];

  return leftControlsPanel;
}

+ (CCSprite*)uiLeftDashedLineWithTheme:(NSString*)theme
{
  CGFloat width = [PFLPuzzleControlsLayer uiTimelineStepWidth] * 2.0f;
  CCSprite* temp = [CCSprite spriteWithImageNamed:@"rounded_dash.png"];
  NSInteger repeats = (width / temp.contentSize.width);
  PFLTileSprite* line = [[PFLTileSprite alloc] initWithImage:@"rounded_dash.png" repeats:ccp(repeats / 2, 1) color1:[PFLColorUtils controlPanelEdgeWithTheme:theme] color2:nil skip:1];
  
  return line;
}

- (id)initWithPuzzle:(PFLPuzzle *)puzzle delegate:(id<PFLPuzzleControlsDelegate>)delegate
{
  self = [super init];
  if (self)
  {
    self.contentSize = [[CCDirector sharedDirector] viewSize];
    self.puzzle = puzzle;
    NSString *theme = puzzle.puzzleSet.theme;
    self.delegate = delegate;
    
    NSInteger steps = 4;
    self.steps = steps;
    
    // batch node
    CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:@"userInterface.png"];
    
    self.uiBatchNode = uiBatch;
    [self addChild:uiBatch];
    
    CCSpriteBatchNode *transitionBatch = [CCSpriteBatchNode batchNodeWithFile:@"transitions.png"];
    self.transitionBatchNode = transitionBatch;
    [self addChild:transitionBatch];
    [self createTransitionPadding];
    
    // right controls panel
    CCSprite *rightControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_right_bottom_fill.png"];
    rightControlsPanel.color = [PFLColorUtils controlPanelFillWithTheme:theme];
    rightControlsPanel.anchorPoint = ccp(0, 0);
    
    CCSprite *rightControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_right_bottom_edge.png"];
    rightControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:theme];
    rightControlsPanelBorder.anchorPoint = ccp(0, 0);
    
    if (steps >= kRowLength)
    {
      rightControlsPanel.position = ccp(rightControlsPanel.contentSize.width - self.contentSize.width, 0);
    }
    else
    {
      CGFloat xOffset = (rightControlsPanel.contentSize.width - self.contentSize.width) + ([PFLPuzzleControlsLayer uiTimelineStepWidth] * (kRowLength - steps));
      rightControlsPanel.position = ccp(-xOffset, 0);
    }
    rightControlsPanelBorder.position = rightControlsPanel.position;
    
    [self.uiBatchNode addChild:rightControlsPanel];
    [self.uiBatchNode addChild:rightControlsPanelBorder];
    
    // left controls panel
    CCSprite* leftControlsPanel = [PFLPuzzleControlsLayer uiLeftControlPanelWithTheme:theme];
    leftControlsPanel.position = ccp(0, -[PFLPuzzleControlsLayer uiButtonUnitSize].height);
    [self.uiBatchNode addChild:leftControlsPanel];
    
    // dashed line
    CCSprite* line = [PFLPuzzleControlsLayer uiLeftDashedLineWithTheme:self.puzzle.puzzleSet.theme];
    line.anchorPoint = ccp(0, 0);
    line.position = ccp(0, [PFLPuzzleControlsLayer uiButtonUnitSize].height - line.contentSize.height / 2.0f); // TODO: adjust based on seq len
    [self.uiBatchNode addChild:line z:1];
    
    // top left controls panel corner
    CCSprite *topLeftControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_fill.png"];
    topLeftControlsPanel.color = [PFLColorUtils controlPanelFillWithTheme:theme];
    topLeftControlsPanel.anchorPoint = ccp(0, 1);
    topLeftControlsPanel.position = ccp(0, self.contentSize.height);
    [self.uiBatchNode addChild:topLeftControlsPanel];
    
    CCSprite *topLeftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_edge.png"];
    topLeftControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:theme];
    topLeftControlsPanelBorder.anchorPoint = ccp(0, 1);
    topLeftControlsPanelBorder.position = topLeftControlsPanel.position;
    [self.uiBatchNode addChild:topLeftControlsPanelBorder];
    
    // speaker (solution sequence) button
    PFLToggleButton *speakerButton = [[PFLToggleButton alloc] initWithImage:@"speaker.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] delegate:self];
    self.speakerButton = speakerButton;
    speakerButton.position = ccp(
      [PFLPuzzleControlsLayer uiTimelineStepWidth] / 2,
      ([PFLPuzzleControlsLayer uiButtonUnitSize].height * 2.0f) - ([PFLPuzzleControlsLayer uiButtonUnitSize].height / 2.0f)
    ); // TODO: FIX ME LATER
    [self.uiBatchNode addChild:speakerButton];
    
    // play (user sequence) button
    PFLToggleButton *playButton = [[PFLToggleButton alloc] initWithImage:@"play.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] delegate:self];
    self.playButton = playButton;
    playButton.position = ccp(speakerButton.position.x + [PFLPuzzleControlsLayer uiTimelineStepWidth], speakerButton.position.y);
    [self.uiBatchNode addChild:playButton];
    
    // exit button
    PFLBasicButton *exitButton = [[PFLBasicButton alloc] initWithImage:@"exit.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] delegate:self];
    self.exitButton = exitButton;
    exitButton.position = ccp([PFLPuzzleControlsLayer uiTimelineStepWidth] / 2, self.contentSize.height - 25);
    [self.uiBatchNode addChild:exitButton];
    
    // solution buttons
    self.solutionButtons = [NSMutableArray array];
    self.solutionFlags = [NSMutableArray array];
    for (NSInteger i = 0; i < steps; i++)
    {
      PFLSolutionButton *solutionButton = [[PFLSolutionButton alloc] initWithPlaceholderImage:@"clear_rect_uilayer.png" size:CGSizeMake(40.0f, 40.0f) index:i defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils solutionButtonHighlightWithTheme:theme] delegate:self];
      [self.solutionButtons addObject:solutionButton];
      solutionButton.position = ccp(
        (i * [PFLPuzzleControlsLayer uiTimelineStepWidth]) + ([PFLPuzzleControlsLayer uiTimelineStepWidth] / 2),
        [PFLPuzzleControlsLayer uiButtonUnitSize].height / 2
      );
      [self addChild:solutionButton];
    }
  }
  return self;
}

- (void)createTransitionPadding
{
  CCSprite *fill = [CCSprite spriteWithImageNamed:@"puzzle_left_transition_padding_568_a_fill.png"];
  fill.color = [PFLColorUtils controlPanelFillWithTheme:self.puzzle.puzzleSet.theme];
  fill.anchorPoint = ccp(1, 0);
  fill.position = ccp(0, 0);
  //    fill.position = ccp(-fill.contentSize.width, 0.0f);
  [self.transitionBatchNode addChild:fill];
  
  CCSprite *edge = [CCSprite spriteWithImageNamed:@"puzzle_left_transition_padding_568_a_edge.png"];
  edge.color = [PFLColorUtils controlPanelEdgeWithTheme:self.puzzle.puzzleSet.theme];
  edge.anchorPoint = ccp(1, 0);
  edge.position = ccp(0, 0);
  //    edge.position = ccp(-edge.contentSize.width, 0.0f);
  [self.transitionBatchNode addChild:edge];
}

// TODO: if this becomes a custom animation (crossfade?) will probably need to use with a completion callback
- (void)resetSolutionButtons
{
  for (PFLSolutionButton *button in self.solutionButtons)
  {
    if (button.isDisplaced)
    {
      [button reset];
    }
  }
  
  for (CCSprite *flag in self.solutionFlags)
  {
    [flag removeFromParentAndCleanup:YES];
  }
  [self.solutionFlags removeAllObjects];
}

#pragma mark - Scene management

- (void)onEnter
{
  [super onEnter];
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self selector:@selector(handleStepUserSequence:) name:kNotificationStepUserSequence object:nil];
  [notificationCenter addObserver:self selector:@selector(handleStepSolutionSequence:) name:kNotificationStepSolutionSequence object:nil];
  [notificationCenter addObserver:self selector:@selector(handleEndUserSequence:) name:kNotificationEndUserSequence object:nil];
  [notificationCenter addObserver:self selector:@selector(handleEndSolutionSequence:) name:kNotificationEndSolutionSequence object:nil];
}

- (void)onExit
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super onExit];
}

#pragma mark - Notifications

- (void)handleStepUserSequence:(NSNotification*)notification
{
  NSInteger index = [notification.userInfo[kKeyIndex] integerValue];
  BOOL correct = [notification.userInfo[kKeyCorrectHit] boolValue];
  
  PFLSolutionButton *button = self.solutionButtons[index];
  [button animateCorrectHit:correct];
  
  CGFloat  offset = 6.0f;
  NSString *flagName = @"x.png";
  if (correct)
  {
    offset *= -1.0f;
    flagName = @"check.png";
  }
  
  // create and animate solution flag (check or x)
  CCSprite *flag = [CCSprite spriteWithImageNamed:flagName];
  [self.solutionFlags addObject:flag];
  [self.uiBatchNode addChild:flag];
  flag.color = [PFLColorUtils controlButtonsDefaultWithTheme:self.puzzle.puzzleSet.theme];
  flag.position = ccp(button.position.x, button.contentSize.height / 2);
  flag.opacity = 0.0f;
  CCActionMoveTo *flagMoveTo = [CCActionMoveTo actionWithDuration:1.0f position:ccp(flag.position.x, (button.contentSize.height / 2) + offset)];
  CCActionEaseElasticOut *flagEase = [CCActionEaseElasticOut actionWithAction:flagMoveTo];
  [flag runAction:flagEase];
  CCActionFadeIn *flagFadeIn = [CCActionFadeIn actionWithDuration:0.5f];
  [flag runAction:flagFadeIn];
}

// SequenceDispatcher needs us to press the solution button
- (void)handleStepSolutionSequence:(NSNotification*)notification
{
  PFLSolutionButton *button = self.solutionButtons[[notification.userInfo[kKeyIndex] integerValue]];
  [button press];
}

// SequenceDispatcher needs us to toggle off the the play button
- (void)handleEndUserSequence:(NSNotification*)notification
{
  [self.playButton toggle];
}

// SequenceDispatcher needs us to toggle off the the speaker button
- (void)handleEndSolutionSequence:(NSNotification*)notification
{
  [self.speakerButton toggle];
}

#pragma mark - ToggleButtonDelegate

- (void)toggleButtonPressed:(PFLToggleButton*)sender
{
  if ([sender isEqual:self.speakerButton])
  {
    if (self.speakerButton.isOn)
    {
      [self.delegate startSolutionSequence];
    }
    else
    {
      [self.delegate stopSolutionSequence];
    }
  }
  else if ([sender isEqual:self.playButton])
  {
    if (self.playButton.isOn)
    {
      [self resetSolutionButtons];
      [self.delegate startUserSequence];
    }
    else
    {
      [self.delegate stopUserSequence];
    }
  }
}

#pragma mark - BasicButtonDelegate

- (void)basicButtonPressed:(PFLBasicButton *)sender
{
  if ([sender isEqual:self.exitButton])
  {
    CCScene *scene = [PFLPuzzleSetLayer sceneWithPuzzleSet:self.puzzle.puzzleSet];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.33f];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:transition];
  }
}

#pragma mark - SolutionButtonDelegate

- (void)solutionButtonPressed:(PFLSolutionButton *)button
{
  [self.delegate playSolutionIndex:button.index];
}

@end
