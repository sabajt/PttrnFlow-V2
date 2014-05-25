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
#import "PFLBasicButton.h"
#import "PFLToggleButton.h"

@interface PFLPuzzleControlsLayer ()

@property (weak, nonatomic) CCSpriteBatchNode* uiBatchNode;

@property (weak, nonatomic) PFLPuzzle* puzzle; // TOOD: should this be a strong ref?
@property (weak, nonatomic) id<PFLPuzzleControlsDelegate> delegate;
@property (strong, nonatomic) PFLAudioEventController* audioEventController;

@property (weak, nonatomic) PFLToggleButton* playButton;
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
    
//    // batch node
//    CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:@"userInterface.png"];
//    
//    self.uiBatchNode = uiBatch;
//    [self addChild:uiBatch];
//    
//    // bottom left controls panel
//    CCSprite* bottomLeftControlsPanelFill = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_fill.png"];
//    bottomLeftControlsPanelFill.rotation = -90.0f;
//    bottomLeftControlsPanelFill.color = [PFLColorUtils controlPanelFillWithTheme:theme];
//    bottomLeftControlsPanelFill.position = ccp(bottomLeftControlsPanelFill.contentSize.width / 2.0f, bottomLeftControlsPanelFill.contentSize.height / 2.0f);
//    [self.uiBatchNode addChild:bottomLeftControlsPanelFill];
//    
//    CCSprite* bottomLeftControlsPanelBorder = [CCSprite spriteWithImageNamed:@"controls_panel_top_left_edge.png"];
//    bottomLeftControlsPanelBorder.rotation = -90.0f;
//    bottomLeftControlsPanelBorder.color = [PFLColorUtils controlPanelEdgeWithTheme:theme];
//    bottomLeftControlsPanelBorder.position = bottomLeftControlsPanelFill.position;
//    [self.uiBatchNode addChild:bottomLeftControlsPanelBorder];
    
    CCNode* buttonAnchor = [CCNode node];
    buttonAnchor.anchorPoint = ccp(0.0f, 0.0f);
    buttonAnchor.positionType = CCPositionTypeNormalized;
    buttonAnchor.position = ccp(0.0f, 0.0f);
    buttonAnchor.contentSize = CGSizeMake(50.0f, 50.0f);
    [self addChild:buttonAnchor];
  
    // play button
    PFLToggleButton* playButton = [[PFLToggleButton alloc] initWithImage:@"play.png" defaultColor:[PFLColorUtils controlButtonsDefaultWithTheme:theme] activeColor:[PFLColorUtils controlButtonsActiveWithTheme:theme] target:self];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.5f, 0.5f);
    playButton.touchBeganSelectorName = @"playButtonPressed";
    self.playButton = playButton;
    [buttonAnchor addChild:playButton];
  }
  return self;
}

#pragma mark - Scene management

- (void)onEnter
{
  [super onEnter];
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self selector:@selector(handleEndSequence:) name:PFLNotificationEndSequence object:nil];
}

- (void)onExit
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super onExit];
}

#pragma mark - Sequence

- (void)handleStepUserSequence:(NSNotification*)notification
{
  self.currentStep++;
}

- (void)handleEndSequence:(NSNotification*)notification
{
  if (self.playButton.isOn)
  {
    [self.playButton toggleIgnoringTarget:YES];
  }
}

- (void)playButtonPressed
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

@end
