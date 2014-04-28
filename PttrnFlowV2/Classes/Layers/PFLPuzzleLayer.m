//
//  PFLPuzzleLayer.m
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PFLArrowSprite.h"
#import "PFLAudioPadSprite.h"
#import "PFLAudioResponderTouchController.h"
#import "PFLPuzzleBackgroundLayer.h"
#import "CCSprite+PFLEffects.h"
#import "PFLColorUtils.h"
#import "PFLCoord.h"
#import "PFLGearSprite.h"
#import "PFLEntrySprite.h"
#import "PFLGameConstants.h"
#import "PFLAudioEventController.h"
#import "PFLGeometry.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleLayer.h"
#import "PFLPuzzleControlsLayer.h"
#import "PFLAudioResponderStepController.h"
#import "PFLSynthSprite.h"
#import "PFLGlyph.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"
#import "PFLPuzzleSet.h"
#import "PFLGoalSprite.h"
#import "PFLPuzzleState.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, ZOrderAudioBatch)
{
    ZOrderAudioBatchPanelFill = 0,
    ZOrderAudioBatchPanelBorder,
    ZOrderAudioBatchPadBacklight,
    ZOrderAudioBatchPad,
    ZOrderAudioBatchGlyph
};

static CGFloat kPuzzleBoundsMargin = 10.0f;

@interface PFLPuzzleLayer ()

@property (weak, nonatomic) PFLPuzzleBackgroundLayer *backgroundLayer;
@property CGFloat beatDuration;
@property CGPoint gridOrigin; // TODO: using grid origin except for drawing debug grid?
@property PFLCoord *maxCoord;
@property (strong, nonatomic) PFLPuzzle *puzzle;
@property (strong, nonatomic) PFLPuzzleSet *puzzleSet;
@property CGRect puzzleBounds;
@property CGSize screenSize;
@property BOOL shouldDrawGrid; // debugging
@property (strong, nonatomic) PFLAudioEventController* audioEventController;
@property (strong, nonatomic) NSSet* audioResponders;

@end

@implementation PFLPuzzleLayer

#pragma mark - setup

+ (CCScene*)sceneWithPuzzle:(PFLPuzzle*)puzzle
{
  CCScene* scene = [CCScene node];
  
  // background
  PFLPuzzleBackgroundLayer *background = [PFLPuzzleBackgroundLayer backgroundLayerWithTheme:puzzle.puzzleSet.theme];
  background.contentSize = CGSizeMake(background.contentSize.width, background.contentSize.height);
  background.position = ccpSub(background.position, ccp(0.0f, 0.0f));
  [scene addChild:background];
  
  // gameplay layer
  static CGFloat controlBarHeight = 80.0f;
  PFLPuzzleLayer *puzzleLayer = [[PFLPuzzleLayer alloc] initWithPuzzle:puzzle background:background topMargin:controlBarHeight];
  [scene addChild:puzzleLayer];
  
  // controls layer
  PFLPuzzleControlsLayer* uiLayer = [[PFLPuzzleControlsLayer alloc] initWithPuzzle:puzzle delegate:puzzleLayer.sequenceDispatcher];
  [scene addChild:uiLayer z:1];
  
  return scene;
}

- (id)initWithPuzzle:(PFLPuzzle*)puzzle background:(PFLPuzzleBackgroundLayer*)backgroundLayer topMargin:(CGFloat)topMargin;
{
  self = [super init];
  if (self)
  {
    self.ignoreTouchBounds = YES;
    self.screenSize = [[CCDirector sharedDirector] designSize];
    self.puzzle = puzzle;
    self.puzzleSet = puzzle.puzzleSet;
  
    self.beatDuration = puzzle.puzzleSet.beatDuration;
    PFLAudioEventController* audioEventController = [PFLAudioEventController audioEventController];
    self.audioEventController = audioEventController;
    [self addChild:audioEventController];
    audioEventController.beatDuration = self.beatDuration;
    audioEventController.mute = NO;
    
    // Sprite sheet batch nodes
    CCSpriteBatchNode* audioObjectsBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyAudioObjects stringByAppendingString:@".png"]];
    [self addChild:audioObjectsBatch];
    _audioObjectsBatchNode = audioObjectsBatch;

    // Setup
    self.backgroundLayer = backgroundLayer;
    self.maxCoord = [PFLCoord maxCoord:puzzle.area];
    self.contentSize = CGSizeMake((self.maxCoord.x + 1) * [PFLGameConstants gridUnit], (self.maxCoord.y + 1) * [PFLGameConstants gridUnit]);
    
    self.puzzleBounds = CGRectMake(kPuzzleBoundsMargin,
                                   (3 * [PFLPuzzleControlsLayer uiButtonUnitSize].height) + kPuzzleBoundsMargin,
                                   self.screenSize.width - (2 * kPuzzleBoundsMargin),
                                   self.screenSize.height - (4 * [PFLPuzzleControlsLayer uiButtonUnitSize].height) - (2 * kPuzzleBoundsMargin));
    
    if (self.contentSize.width >= self.puzzleBounds.size.width)
    {
      self.position = ccp(self.puzzleBounds.origin.x, self.position.y);
    }
    else
    {
      self.allowsScrollHorizontal = NO;
      CGFloat padding = self.puzzleBounds.size.width - self.contentSize.width;
      self.position = ccp(self.puzzleBounds.origin.x + (padding / 2), self.position.y);
    }
    
    if (self.contentSize.height >= self.puzzleBounds.size.height)
    {
      self.position = ccp(self.position.x, self.puzzleBounds.origin.y);
    }
    else
    {
      self.allowsScrollVertical = NO;
      CGFloat padding = self.puzzleBounds.size.height - self.contentSize.height;
      self.position = ccp(self.position.x, self.puzzleBounds.origin.y + (padding / 2));
    }
    self.scrollBoundsInPoints = CGRectMake(self.position.x,
                                           self.position.y,
                                           (self.screenSize.width - kPuzzleBoundsMargin) - self.position.x,
                                           (self.screenSize.height - kPuzzleBoundsMargin) - self.position.y);

    // audio touch dispatcher
    CGFloat beatDuration = self.beatDuration;
    PFLAudioResponderTouchController *audioResponderTouchController = [[PFLAudioResponderTouchController alloc] initWithBeatDuration:beatDuration audioEventController:self.audioEventController];
    audioResponderTouchController.positionType = self.positionType;
    audioResponderTouchController.contentSizeType = self.contentSizeType;
    audioResponderTouchController.contentSize = self.contentSize;
    self.audioResponderTouchController = audioResponderTouchController;
    [self addScrollDelegate:audioResponderTouchController];
    
    [audioResponderTouchController clearResponders];
    audioResponderTouchController.areaCells = puzzle.area;
    [self addChild:audioResponderTouchController];
    
    // sequence dispacher
    PFLAudioResponderStepController *sequenceDispatcher = [[PFLAudioResponderStepController alloc] initWithPuzzle:puzzle audioEventController:self.audioEventController];
    self.sequenceDispatcher = sequenceDispatcher;
    [sequenceDispatcher clearResponders];
    [self addChild:sequenceDispatcher];
    
    // create puzzle objects
    [self createBorderWithAreaCells:puzzle.area];
    [self createPuzzleObjects:puzzle];        
  }
  return self;
}

- (void)createBorderWithAreaCells:(NSArray*)areaCells
{
  static NSString *padBorderStraitEdge = @"pad_border_strait_edge.png";
  static NSString *padBorderStraitRightFill = @"pad_border_strait_right_fill.png";
  static NSString *padBorderCornerEdge = @"pad_border_corner_edge.png";
  static NSString *padBorderCornerInsideFill = @"pad_border_corner_inside_fill.png";
  static NSString *padBorderCornerOutsideFill = @"pad_border_corner_outside_fill.png";

  for (NSInteger x = -1; x <= self.maxCoord.x; x++)
  {
    for (NSInteger y = -1; y <= self.maxCoord.y; y++)
    {
      
      PFLCoord* cell = [PFLCoord coordWithX:x Y:y];
      
      // find neighbor corners
      PFLCoord *bottomleft = [PFLCoord coordWithX:x Y:y];
      PFLCoord *topLeft = [PFLCoord coordWithX:x Y:y + 1];
      PFLCoord *bottomRight = [PFLCoord coordWithX:x + 1 Y:y];
      PFLCoord *topRight = [PFLCoord coordWithX:x + 1 Y:y + 1];
      
      BOOL hasBottomLeft = [bottomleft isCoordInGroup:areaCells];
      BOOL hasTopLeft = [topLeft isCoordInGroup:areaCells];
      BOOL hasBottomRight = [bottomRight isCoordInGroup:areaCells];
      BOOL hasTopRight = [topRight isCoordInGroup:areaCells];
      
      // cell on every side, fill panel instead of border needed
      if (hasBottomLeft && hasTopLeft && hasBottomRight && hasTopRight)
      {
        CCSprite* padFill = [CCSprite spriteWithImageNamed:@"pad_fill.png"];
        padFill.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
        padFill.color = [PFLColorUtils audioPanelFillWithTheme:self.puzzle.puzzleSet.theme];
        [self.audioObjectsBatchNode addChild:padFill z:ZOrderAudioBatchPanelFill];
        continue;
      }
      // cell on no side, nothing needed
      if (!hasBottomLeft && !hasTopLeft && !hasBottomRight && !hasTopRight)
      {
        continue;
      }
      
      CCSprite* border1;
      CCSprite* fill1;
      CCSprite* border2;
      CCSprite* fill2;
      
      // strait edge vertical
      if (hasBottomLeft && hasTopLeft && !hasBottomRight && !hasTopRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderStraitEdge];
        fill1 = [CCSprite spriteWithImageNamed:padBorderStraitRightFill];
        fill1.scale *= -1;
      }
      else if (!hasBottomLeft && !hasTopLeft && hasBottomRight && hasTopRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderStraitEdge];
        fill1 = [CCSprite spriteWithImageNamed:padBorderStraitRightFill];
      }

      // strait edge horizontal
      else if (hasTopLeft && hasTopRight && !hasBottomLeft && !hasBottomRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderStraitEdge];
        border1.rotation = -90.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderStraitRightFill];
        fill1.rotation = -90.0f;
      }
      else if (!hasTopLeft && !hasTopRight && hasBottomLeft && hasBottomRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderStraitEdge];
        border1.rotation = 90.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderStraitRightFill];
        fill1.rotation = 90.0f;
      }

      // top left only
      else if (hasTopLeft && !hasTopRight && !hasBottomLeft && !hasBottomRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
      }
      else if (!hasTopLeft && hasTopRight && hasBottomLeft && hasBottomRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerOutsideFill];
      }
      
      // top right only
      else if (hasTopRight && !hasTopLeft && !hasBottomLeft && !hasBottomRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = 90.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
        fill1.rotation = 90.0f;
      }
      else if (!hasTopRight && hasTopLeft && hasBottomLeft && hasBottomRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = 90.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerOutsideFill];
        fill1.rotation = 90.0f;
      }
      
      // bottom left only
      else if (hasBottomLeft && !hasBottomRight && !hasTopLeft && !hasTopRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = -90.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
        fill1.rotation = -90.0f;
      }
      else if (!hasBottomLeft && hasBottomRight && hasTopLeft && hasTopRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = -90.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerOutsideFill];
        fill1.rotation = -90.0f;
      }
      
      // bottom right only
      else if (hasBottomRight && !hasBottomLeft && !hasTopLeft && !hasTopRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = 180.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
        fill1.rotation = 180.0f;
      }
      else if (!hasBottomRight && hasBottomLeft && hasTopLeft && hasTopRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = 180.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerOutsideFill];
        fill1.rotation = 180.0f;
      }

      // both bottom left and top right corner
      else if (hasBottomLeft && hasTopRight && !hasBottomRight && !hasTopLeft)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = -90.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
        fill1.rotation = -90.0f;
        
        border2 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border2.rotation = 90.0f;
        fill2 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
        fill2.rotation = 90.0f;
      }
      
      // both bottom right and top left cornerh
      else if (hasBottomRight && hasTopLeft && !hasBottomLeft && !hasTopRight)
      {
        border1 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        border1.rotation = 180.0f;
        fill1 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
        fill1.rotation = 180.0f;
        
        border2 = [CCSprite spriteWithImageNamed:padBorderCornerEdge];
        fill2 = [CCSprite spriteWithImageNamed:padBorderCornerInsideFill];
      }
      
      fill1.color = [PFLColorUtils audioPanelFillWithTheme:self.puzzle.puzzleSet.theme];
      fill1.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
      [self.audioObjectsBatchNode addChild:fill1 z:ZOrderAudioBatchPanelBorder];
      
      border1.color = [PFLColorUtils audioPanelEdgeWithTheme:self.puzzle.puzzleSet.theme];
      border1.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
      [self.audioObjectsBatchNode addChild:border1 z:ZOrderAudioBatchPanelBorder];
      
      if (border2 != nil)
      {
        fill2.color = [PFLColorUtils audioPanelFillWithTheme:self.puzzle.puzzleSet.theme];
        fill2.position = fill1.position;
        [self.audioObjectsBatchNode addChild:fill2 z:ZOrderAudioBatchPanelBorder];
        
        border2.color = [PFLColorUtils audioPanelEdgeWithTheme:self.puzzle.puzzleSet.theme];
        border2.position = border1.position;
        [self.audioObjectsBatchNode addChild:border2 z:ZOrderAudioBatchPanelBorder];
      }
    }
  }
}

- (void)createPuzzleObjects:(PFLPuzzle*)puzzle
{
  NSArray* glyphs = puzzle.glyphs;
  PFLPuzzleState* puzzleState = [PFLPuzzleState puzzleStateForPuzzle:puzzle];
  NSMutableArray* allSampleNames = [NSMutableArray array];
  
  for (PFLGlyph* glyph in glyphs)
  {
    // cell is the only mandatory field to create an audio pad (empty pad can be used as a puzzle object to just take up space)
    if (!glyph.cell)
    {
      CCLOG(@"SequenceLayer createPuzzleObjects error: 'cell' must not be null on audio pads");
      return;
    }
    PFLCoord* cell;
    NSDictionary* glyphState = [puzzleState glyphStateForGid:glyph.responderID];
    if (glyphState)
    {
      NSArray* cellArray = glyphState[@"cell"];
      cell = [PFLCoord coordWithX:[cellArray[0] integerValue] Y:[cellArray[1] integerValue]];
    }
    else
    {
      cell = glyph.cell;
    }
    CGPoint cellCenter = [cell relativeMidpoint];
    
    // audio pad sprite
    PFLAudioPadSprite* audioPad = [[PFLAudioPadSprite alloc] initWithGlyph:glyph cell:cell];
    [self addAudioResponder:audioPad];

    audioPad.position = cellCenter;
    [self.audioResponderTouchController addResponder:audioPad];
    [self.sequenceDispatcher addResponder:audioPad];
    [self.audioObjectsBatchNode addChild:audioPad z:ZOrderAudioBatchPad];
    
    if (glyph.audioID)
    {
      id object = puzzle.audio[[glyph.audioID integerValue]];
      if ([object isKindOfClass:[PFLMultiSample class]])
      {
        PFLMultiSample* multiSample = (PFLMultiSample*)object;
        PFLGearSprite* gear = [[PFLGearSprite alloc] initWithGlyph:glyph multiSample:multiSample cell:cell];
        [self.audioResponderTouchController addResponder:gear];
        [self.sequenceDispatcher addResponder:gear];
        [self addAudioResponder:gear];
        gear.position = cellCenter;
        [self.audioObjectsBatchNode addChild:gear z:ZOrderAudioBatchGlyph];
        
        for (PFLSample* sample in multiSample.samples)
        {
          [allSampleNames addObject:sample.file];
        }
      }
    }
    
    // direction arrow
    if ([glyph.type isEqualToString:PFLGlyphTypeArrow])
    {
      PFLArrowSprite* arrow = [[PFLArrowSprite alloc] initWithGlyph:glyph cell:cell];
      [self.audioResponderTouchController addResponder:arrow];
      [self.sequenceDispatcher addResponder:arrow];
      [self addAudioResponder:arrow];
      arrow.position = cellCenter;
      [self.audioObjectsBatchNode addChild:arrow z:ZOrderAudioBatchGlyph];
    }
    
    // entry point
    else if ([glyph.type isEqualToString:PFLGlyphTypeEntry])
    {
      PFLEntrySprite* entry = [[PFLEntrySprite alloc] initWithGlyph:glyph cell:cell];
      [self.audioResponderTouchController addResponder:entry];
      [self.sequenceDispatcher addResponder:entry];
      self.sequenceDispatcher.entry = entry;
      [self addAudioResponder:entry];
      entry.position = cellCenter;
      [self.audioObjectsBatchNode addChild:entry z:ZOrderAudioBatchGlyph];
    }
    
    // goal
    else if ([glyph.type isEqualToString:PFLGlyphTypeGoal])
    {
      PFLGoalSprite* goal = [[PFLGoalSprite alloc] initWithGlyph:glyph cell:cell];
      [self.audioResponderTouchController addResponder:goal];
      [self.sequenceDispatcher addResponder:goal];
      [self addAudioResponder:goal];
      goal.position = cellCenter;
      [self.audioObjectsBatchNode addChild:goal z:ZOrderAudioBatchGlyph];
    }
  }
  [self.audioEventController loadSamples:allSampleNames];
}

- (void)animateBacklight:(PFLCoord*)coord
{
  CCSprite* highlightSprite = [CCSprite spriteWithImageNamed:@"audio_box_highlight.png"];
      
  highlightSprite.color = [PFLColorUtils padHighlightWithTheme:self.puzzle.puzzleSet.theme];
  highlightSprite.position = [coord relativeMidpoint];
  [self.audioObjectsBatchNode addChild:highlightSprite z:ZOrderAudioBatchPadBacklight];
  
  [highlightSprite backlight:self.beatDuration completion:^{
      [highlightSprite removeFromParentAndCleanup:YES];
  }];
}

- (void)addAudioResponder:(id<PFLAudioResponder>)responder
{
  if (!self.audioResponders)
  {
    self.audioResponders = [NSSet set];
  }
  self.audioResponders = [self.audioResponders setByAddingObject:responder];
}

#pragma mark - scene management

- (void)onEnter
{
  [super onEnter];
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self selector:@selector(handleStepUserSequence:) name:PFLNotificationStepSequence object:nil];
  [notificationCenter addObserver:self selector:@selector(handleaudioResponderTouchControllerHit:) name:kPFLAudioTouchDispatcherHitNotification object:nil];
  [self setupDebug];
}

- (void)onExit
{
  [self savePuzzleState];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super onExit];
}

#pragma mark - State

- (void)savePuzzleState
{
  NSMutableArray* updatedGlyphs = [NSMutableArray array];
  
  for (id<PFLAudioResponder> audioResponder in self.audioResponders)
  {
    if (![audioResponder respondsToSelector:@selector(audioResponderID)])
    {
      continue;
    }
    
    PFLGlyph* updateGlyph = [[PFLGlyph alloc] initWithObject:nil puzzle:nil];
    updateGlyph.responderID = [audioResponder audioResponderID];
    updateGlyph.cell = [audioResponder audioResponderCell];
    
    if ([audioResponder respondsToSelector:@selector(audioResponderDirection)])
    {
      updateGlyph.direction = [audioResponder audioResponderDirection];
    }
    
    [updatedGlyphs addObject:updateGlyph];
  }
  
  PFLPuzzleState* puzzleState = [PFLPuzzleState puzzleStateForPuzzle:self.puzzle];
  [puzzleState updateWithGlyphs:[NSArray arrayWithArray:updatedGlyphs]];
}

#pragma mark - Notifications

- (void)handleStepUserSequence:(NSNotification*)notification
{
  PFLCoord* coord = notification.userInfo[kKeyCoord];
  if ([coord isCoordInGroup:self.puzzle.area])
  {
    [self animateBacklight:coord];
  }
}

- (void)handleaudioResponderTouchControllerHit:(NSNotification*)notification
{
  PFLCoord* coord = notification.userInfo[kPFLAudioTouchDispatcherCoordKey];
  if ([coord isCoordInGroup:self.puzzle.area])
  {
    [self animateBacklight:coord];
  }
}

#pragma mark - debug methods

// edit debugging options here
- (void)setupDebug
{
  // draw grid as defined in our tile map -- does not neccesarily coordinate with gameplay
  // warning: enabling makes many calls to draw cycle -- large maps will lag
  self.shouldDrawGrid = NO;
  
  // layer size reporting:
  // [self.scheduler scheduleSelector:@selector(reportS ize:) forTarget:self interval:0.3 paused:NO repeat:kCCRepeatForever delay:0];
  
  // // draw bounding box over puzzle layer content box
  // CCSprite *rectSprite = [CCSprite rectSpriteWithSize:CGSizeMake(self.contentSize.width, self.contentSize.height) color:ccRED];
  // rectSprite.anchorPoint = ccp(0, 0);
  // rectSprite.position = ccp(0, 0);
  // rectSprite.opacity = 100;
  // [self addChild:rectSprite];
}

- (void)reportSize:(CCTime)deltaTime
{
  CCLOG(@"\n\n--debug------------------------");
  CCLOG(@"seq layer content size: %@", NSStringFromCGSize(self.contentSize));
  CCLOG(@"seq layer bounding box: %@", NSStringFromCGRect(self.boundingBox));
  CCLOG(@"seq layer position: %@", NSStringFromCGPoint(self.position));
  CCLOG(@"seq layer scale: %g", self.scale);
  CCLOG(@"--end debug------------------------\n");
}

//- (void)draw
//{
//    // grid
//    if (self.shouldDrawGrid) {
//        ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
//        [GridUtils drawGridWithSize:self.maxCoord unitSize:kSizeGridUnit origin:_gridOrigin];
//    }
//}

@end
