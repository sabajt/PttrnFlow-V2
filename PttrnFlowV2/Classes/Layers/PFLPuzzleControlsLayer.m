//
//  SequenceUILayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "PFLAudioEventController.h"
#import "PFLAudioResponderStepController.h"
#import "PFLAudioResponderTouchController.h"
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
#import "PFLGlyph.h"

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
@property PFLDragNode* restoringInventoryItem;

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
  
    // play button
    PFLToggleButton* playButton = [[PFLToggleButton alloc] initWithImage:@"play.png" defaultColor:[PFLColorUtils controlPanelButtonsDefaultWithTheme:self.theme] activeColor:[PFLColorUtils controlPanelButtonsActiveWithTheme:self.theme] target:self];
    playButton.anchorPoint = ccp(0.5f, 0.5f);
    playButton.positionType = CCPositionTypeNormalized;
    CGFloat xPos = (bottomPanel.contentSizeInPoints.width / 9.0f) / bottomPanel.contentSizeInPoints.width;
    playButton.position = ccp(xPos, 0.5f);
    playButton.touchBeganSelectorName = @"playButtonPressed";
    self.playButton = playButton;
    [bottomPanel addChild:playButton];
    
    NSInteger i = 0;
    for (PFLGlyph* glyph in self.puzzle.inventoryGlyphs)
    {
      [self createInventoryGlyphItem:glyph index:i];
      i++;
    }
  }
  return self;
}

- (void)createInventoryGlyphItem:(PFLGlyph*)glyph index:(NSInteger)i
{
  PFLDragNode* dragNode = [[PFLDragNode alloc] initWithGlyph:glyph theme:self.theme puzzle:self.puzzle];
  dragNode.delegate = self;
  dragNode.position = ccp(((i + 1) * dragNode.contentSize.width) + dragNode.contentSize.width / 2.0f, self.bottomPanel.contentSizeInPoints.height / 2.0f);
  [self addChild:dragNode];
}

- (void)restoreInventoryGlyphItem:(PFLGlyph*)glyph
{  
  PFLDragNode* dragNode = [[PFLDragNode alloc] initWithGlyph:glyph theme:self.theme puzzle:self.puzzle];
  self.restoringInventoryItem = dragNode;
  dragNode.delegate = self;
  [self addChild:dragNode];
}

#pragma mark - Scene management

- (void)onEnter
{
  [super onEnter];
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  
  [notificationCenter addObserver:self selector:@selector(handleForwardTouchControllerMoved:) name:PFLForwardTouchControllerMovedNotification object:nil];
  [notificationCenter addObserver:self selector:@selector(handleForwardTouchControllerEnded:) name:PFLForwardTouchControllerEndedNotification object:nil];
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

#pragma mark - Forwarded touch controller touches

- (void)handleForwardTouchControllerMoved:(NSNotification*)notification
{
  if (self.restoringInventoryItem)
  {
    UITouch* touch = notification.userInfo[PFLForwardTouchControllerTouchKey];
    CGPoint position = [self convertToWorldSpace:touch.locationInWorld];
    self.restoringInventoryItem.position = position;
  }
}

- (void)handleForwardTouchControllerEnded:(NSNotification*)notification
{
  if (self.restoringInventoryItem)
  {
    UITouch* touch = notification.userInfo[PFLForwardTouchControllerTouchKey];
    CGPoint position = [self convertToWorldSpace:touch.locationInWorld];
    self.restoringInventoryItem.position = position;
  }
  self.restoringInventoryItem = nil;
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
