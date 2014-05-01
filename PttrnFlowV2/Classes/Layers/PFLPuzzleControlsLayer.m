//
//  SequenceUILayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "PFLAudioEventController.h"
#import "PFLAudioResponderStepController.h"
#import "PFLColorUtils.h"
#import "PFLFonts.h"
#import "PFLGameConstants.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleControlsLayer.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzleSetLayer.h"
#import "PFLTileSprite.h"

@interface PFLPuzzleControlsLayer ()

@property (weak, nonatomic) CCSpriteBatchNode* uiBatchNode;

@property (weak, nonatomic) PFLPuzzle* puzzle; // TOOD: should this be a strong ref?
@property (weak, nonatomic) id<PFLPuzzleControlsDelegate> delegate;
@property (strong, nonatomic) PFLAudioEventController* audioEventController;

@property (weak, nonatomic) PFLToggleButton* playButton;
@property (weak, nonatomic) PFLToggleButton* speakerButton;
@property (weak, nonatomic) PFLBasicButton* exitButton;
@property (weak, nonatomic) CCLabelTTF* countDownLabel;

@property NSInteger steps;
@property NSInteger currentStep;

@end

@implementation PFLPuzzleControlsLayer

+ (CGSize)uiButtonUnitSize
{
  CGSize screenSize = [CCDirector sharedDirector].designSize;
  if ((NSInteger)screenSize.width == PFLIPadDesignWidth)
  {
    return CGSizeMake(100.0f, 100.0f);
  }
  else if ((NSInteger)screenSize.width == PFLIPhoneDesignWidth)
  {
    return CGSizeMake(50.0f, 50.0f);
  }
  else
  {
    CCLOG(@"Warning: unsupported screen size: %@", NSStringFromCGSize(screenSize));
    return CGSizeMake(50.0f, 50.0f);
  }
}

- (id)initWithPuzzle:(PFLPuzzle *)puzzle delegate:(id<PFLPuzzleControlsDelegate>)delegate audioEventController:(PFLAudioEventController*)audioEventController
{
  self = [super init];
  if (self)
  {
    self.audioEventController = audioEventController;
    self.contentSize = [[CCDirector sharedDirector] viewSize];
    self.puzzle = puzzle;
    NSString* theme = puzzle.puzzleSet.theme;
    self.delegate = delegate;
    self.steps = puzzle.solutionEvents.count;
    
    // batch node
    CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:@"userInterface.png"];
    
    self.uiBatchNode = uiBatch;
    [self addChild:uiBatch];
    
    // top left controls panel
    CCSprite* topLeftControlsPanel = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_fill.png"];
    topLeftControlsPanel.color = [PFLColorUtils controlPanelFillWithTheme:theme];
    topLeftControlsPanel.anchorPoint = ccp(0, 1);
    topLeftControlsPanel.position = ccp(0, self.contentSize.height);
    [self.uiBatchNode addChild:topLeftControlsPanel];
    
    CCSprite* topLeftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_edge.png"];
    topLeftControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:theme];
    topLeftControlsPanelBorder.anchorPoint = ccp(0, 1);
    topLeftControlsPanelBorder.position = topLeftControlsPanel.position;
    [self.uiBatchNode addChild:topLeftControlsPanelBorder];
    
    // exit button
    PFLBasicButton* exitButton = [[PFLBasicButton alloc] initWithImage:@"exit.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] delegate:self];
    self.exitButton = exitButton;
    exitButton.position = ccp([PFLPuzzleControlsLayer uiButtonUnitSize].height / 2.0f, self.contentSize.height - topLeftControlsPanel.contentSize.height / 2.0f);
    [self.uiBatchNode addChild:exitButton];
    
    // bottom left controls panel
    CCSprite* bottomLeftControlsPanelFill = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_fill.png"];
    bottomLeftControlsPanelFill.rotation = -90.0f;
    bottomLeftControlsPanelFill.color = [PFLColorUtils controlPanelFillWithTheme:theme];
    bottomLeftControlsPanelFill.position = ccp(bottomLeftControlsPanelFill.contentSize.width / 2.0f, bottomLeftControlsPanelFill.contentSize.height / 2.0f);
    [self.uiBatchNode addChild:bottomLeftControlsPanelFill];
    
    CCSprite* bottomLeftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_edge.png"];
    bottomLeftControlsPanelBorder.rotation = -90.0f;
    bottomLeftControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:theme];
    bottomLeftControlsPanelBorder.position = bottomLeftControlsPanelFill.position;
    [self.uiBatchNode addChild:bottomLeftControlsPanelBorder];
  
    // play button
    PFLToggleButton* playButton = [[PFLToggleButton alloc] initWithImage:@"play.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] delegate:self];
    self.playButton = playButton;
    playButton.position = ccp([PFLPuzzleControlsLayer uiButtonUnitSize].width / 2.0f, [PFLPuzzleControlsLayer uiButtonUnitSize].height / 2.0f);
    [self.uiBatchNode addChild:playButton];
    
    // speaker button
    PFLToggleButton* speakerButton = [[PFLToggleButton alloc] initWithImage:@"speaker.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] delegate:self];
    self.speakerButton = speakerButton;
    speakerButton.position = ccp([PFLPuzzleControlsLayer uiButtonUnitSize].width * 1.5f, [PFLPuzzleControlsLayer uiButtonUnitSize].height / 2.0f);
    [self.uiBatchNode addChild:speakerButton];
    
    // count down ui
    CCLabelTTF* countDownLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", @(self.steps)] fontName:@"ArialRoundedMTBold" fontSize:[PFLFonts controlsPanelFontSize]];
    self.countDownLabel = countDownLabel;
    countDownLabel.color = [PFLColorUtils controlButtonsDefaultWithTheme:theme];
    countDownLabel.anchorPoint = ccp(0.5f, 0.5f);
    countDownLabel.position = ccp([PFLPuzzleControlsLayer uiButtonUnitSize].width * 2.5f, [PFLPuzzleControlsLayer uiButtonUnitSize].height / 2.0f);
    [self addChild:countDownLabel];
  }
  return self;
}

#pragma mark - Scene management

- (void)onEnter
{
  [super onEnter];
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self selector:@selector(handleStepUserSequence:) name:PFLNotificationStepSequence object:nil];
}

- (void)onExit
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super onExit];
}

#pragma mark - Sequence

- (void)handleStepUserSequence:(NSNotification*)notification
{
  if (self.currentStep >= self.steps)
  {
    self.currentStep = 0;
  }
  
  self.currentStep++;
  BOOL isCorrect = [notification.userInfo[kKeyIsCorrect] boolValue];
  self.countDownLabel.string = [NSString stringWithFormat:@"%i", self.currentStep];
  if (!isCorrect)
  {
    self.countDownLabel.string = [self.countDownLabel.string stringByAppendingString:@"X"];
    [self.playButton toggleIgnoringDelegate:YES];
  }
}

- (void)stepSolutionSequence
{
  if (self.currentStep >= self.steps)
  {
    self.currentStep = 0;
  }
  
  NSArray* events = self.puzzle.solutionEvents[self.currentStep];
  [self.audioEventController receiveEvents:events];

  self.currentStep++;
  self.countDownLabel.string = [NSString stringWithFormat:@"%i", self.currentStep];
}

#pragma mark - ToggleButtonDelegate

- (void)toggleButtonPressed:(PFLToggleButton*)sender
{
  if ([sender isEqual:self.playButton])
  {
    self.currentStep = 0;
    
    if (self.playButton.isOn)
    {
      [self.delegate startUserSequence];
    }
    else
    {
      [self.delegate stopUserSequence];
    }
  }
  else if ([sender isEqual:self.speakerButton])
  {
    self.currentStep = 0;
    
    if (self.speakerButton.isOn)
    {
      [self schedule:@selector(stepSolutionSequence) interval:self.puzzle.puzzleSet.beatDuration];
    }
    else
    {
      [self unschedule:@selector(stepSolutionSequence)];
    }
  }
}

#pragma mark - BasicButtonDelegate

- (void)basicButtonPressed:(PFLBasicButton *)sender
{
  if ([sender isEqual:self.exitButton])
  {
    CCScene* scene = [PFLPuzzleSetLayer sceneWithPuzzleSet:self.puzzle.puzzleSet];
    CCTransition* transition = [CCTransition transitionCrossFadeWithDuration:0.33f];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:transition];
  }
}

@end
