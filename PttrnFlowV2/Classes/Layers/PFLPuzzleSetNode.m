//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLPuzzleSetNode.h"
#import "PFLPuzzleLayer.h"
#import "PFLPuzzle.h"
#import "PFLAudioResponderTouchController.h"
#import "PFLPuzzleSet.h"
#import "PFLTransitionSlide.h"
#import "PFLPuzzleBackgroundLayer.h"
#import "PFLColorUtils.h"

@interface PFLPuzzleSetNode ()

@property (strong, nonatomic) PFLPuzzleSet *puzzleSet;

@end

@implementation PFLPuzzleSetNode

+ (CCScene *)sceneWithPuzzleSet:(PFLPuzzleSet *)puzzleSet leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding
{
    CCScene *scene = [CCScene node];
    
    // background
    PFLPuzzleBackgroundLayer *background = [PFLPuzzleBackgroundLayer backgroundLayerWithColor:[PFLColorUtils controlPanelFillWithTheme:puzzleSet.theme]];
    background.contentSize = CGSizeMake(background.contentSize.width + leftPadding + rightPadding, background.contentSize.height);
    background.position = ccpSub(background.position, ccp(leftPadding, 0.0f));
    [scene addChild:background];
    
    PFLPuzzleSetNode *menuLayer = [[PFLPuzzleSetNode alloc] initWithPuzzleSet:puzzleSet];
    [scene addChild:menuLayer];
    return scene;
}

- (id)initWithPuzzleSet:(PFLPuzzleSet *)puzzleSet
{
    self = [super initWithSize:CGSizeMake(320, 568)];
    if (self) {
        self.puzzleSet = puzzleSet;
        self.allowsScrollHorizontal = NO;
        
        // create and layout cells
        CGSize sideMargins = CGSizeMake(50, 50);
        CGSize padding = CGSizeMake(20, 20);
        int i = 0;
        for (PFLPuzzle *puzzle in self.puzzleSet.puzzles) {
            PFLPuzzleSetCell *cell = [[PFLPuzzleSetCell alloc] initWithIndex:i];
            cell.propogateTouch = YES;
            cell.anchorPoint = ccp(0.5, 0.5);
            CGFloat yPosition = sideMargins.height + ((i * cell.contentSize.height) + (i * padding.height));
            cell.position = ccp(self.contentSize.width / 2, yPosition);
            cell.menuCellDelegate = self;
            [self addChild:cell];
            i++;
        }
    };
    return self;
}

#pragma mark SequenceMenuCellDelegate

- (void)puzzleSetCellTouchUpInside:(PFLPuzzleSetCell *)cell index:(NSInteger)index
{
    CCScene *scene = [PFLPuzzleLayer sceneWithPuzzle:self.puzzleSet.puzzles[index] leftPadding:80.0f rightPadding:0.0f];
//    id transitionScene = [[PFLTransitionSlide alloc] initWithDuration:kTransitionDuration scene:scene above:NO forwards:YES leftPadding:0.0f rightPadding:80.0f];
//    [[CCDirector sharedDirector] replaceScene:transitionScene];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
