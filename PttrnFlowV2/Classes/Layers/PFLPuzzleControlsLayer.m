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
@property (weak, nonatomic) id<PFLPuzzleControlsDelegate> controlsDelegate;
@property (strong, nonatomic) PFLAudioEventController* audioEventController;
@property (copy, nonatomic) NSString* theme;

@property (weak, nonatomic) PFLToggleButton* playButton;
@property (weak, nonatomic) CCLabelTTF* countDownLabel;
@property (weak, nonatomic) CCNodeColor* bottomPanel;

@property NSInteger steps;
@property NSInteger currentStep;

@property CGPoint lastDraggedItemPosition;

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
    self.controlsDelegate = delegate;
    self.steps = puzzle.solutionEvents.count;
    self.theme = puzzle.puzzleSet.theme;
    
    // bottom panel
    CCNodeColor* bottomPanel = [CCNodeColor nodeWithColor:[PFLColorUtils controlPanelFillWithTheme:self.theme]];
    bottomPanel.anchorPoint = ccp(0.0f, 0.0f);
    bottomPanel.position = ccp(0.0f, 0.0f);
    bottomPanel.contentSize = CGSizeMake(self.contentSizeInPoints.width, [PFLGameConstants gridUnit]);

    self.bottomPanel = bottomPanel;
    [self addChild:bottomPanel];
    
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
    
//    CCNode* buttonAnchor = [CCNode node];
//    buttonAnchor.anchorPoint = ccp(0.0f, 0.0f);
//    buttonAnchor.positionType = CCPositionTypeNormalized;
//    buttonAnchor.position = ccp(0.0f, 0.0f);
//    buttonAnchor.contentSize = CGSizeMake(50.0f, 50.0f);
//    [self addChild:buttonAnchor];
  
    // play button
    PFLToggleButton* playButton = [[PFLToggleButton alloc] initWithImage:@"play.png" defaultColor:[PFLColorUtils controlPanelButtonsDefaultWithTheme:self.theme] activeColor:[PFLColorUtils controlPanelButtonsActiveWithTheme:self.theme] target:self];
    playButton.anchorPoint = ccp(0.5f, 0.5f);
    playButton.positionType = CCPositionTypeNormalized;
    CGFloat xPos = (bottomPanel.contentSizeInPoints.width / 9.0f) / bottomPanel.contentSizeInPoints.width;
    playButton.position = ccp(xPos, 0.5f);
    playButton.touchBeganSelectorName = @"playButtonPressed";
    self.playButton = playButton;
    [bottomPanel addChild:playButton];
    
    [self createInventoryObjects];
  }
  return self;
}

- (void)createInventoryObjects
{
  NSInteger i = 0;
  
  for (PFLGlyph* glyph in self.puzzle.inventoryGlyphs)
  {
    PFLDragNode* dragNode = [[PFLDragNode alloc] initWithGlyph:glyph theme:self.theme puzzle:self.puzzle];
    dragNode.delegate = self;
    dragNode.position = ccp(((i + 1) * dragNode.contentSize.width) + dragNode.contentSize.width / 2.0f, self.bottomPanel.contentSizeInPoints.height / 2.0f);
    [self addChild:dragNode];
    i++;
  }
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
    [self.controlsDelegate startUserSequence];
  }
  else
  {
    [self.controlsDelegate stopUserSequence];
  }
}

#pragma mark - PFLDragNodeDelegate

- (void)dragNode:(PFLDragNode *)dragNode touchBegan:(UITouch *)touch
{
  self.lastDraggedItemPosition = dragNode.position;
}

- (void)dragNode:(PFLDragNode*)dragNode touchMoved:(UITouch*)touch
{
  dragNode.position = [self convertToWorldSpace:touch.locationInWorld];
  [self.inventoryDelegate inventoryItemMoved:dragNode];
}

- (void)dragNode:(PFLDragNode *)dragNode touchEnded:(UITouch *)touch
{
  dragNode.position = [self convertToWorldSpace:touch.locationInWorld];
  
  if (!self.inventoryDelegate)
  {
    CCLOG(@"Warning: no inventory delegate set.");
    return;
  }
  
  if ([self.inventoryDelegate inventoryItemDroppedOnBoard:dragNode])
  {
    [dragNode removeFromParentAndCleanup:YES];
  }
  else
  {
    CCActionEaseSineOut* move =[CCActionEaseSineOut actionWithAction:[CCActionMoveTo actionWithDuration:0.08f position:self.lastDraggedItemPosition]];
    [dragNode runAction:move];
  }
}

- (void)dragNode:(PFLDragNode *)dragNode touchCancelled:(UITouch *)touch
{
  
}

@end
