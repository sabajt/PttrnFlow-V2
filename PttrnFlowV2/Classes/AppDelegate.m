//
//  AppDelegate.m
//  PttrnFlowV2
//
//  Created by John Saba on 4/5/14.
//  Copyright John Saba 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzleSetLayer.h"

@implementation AppDelegate

+ (NSString*)applicationDocumentsDirectory
{
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(NO),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/30.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
//		CCSetupTabletScale2X: @(YES),
	}];
  
//  [[CCFileUtils sharedFileUtils] setEnableiPhoneResourcesOniPad:YES];
	
	return YES;
}

-(CCScene *)startScene
{
  // load sprite sheets
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"audioObjects.plist"];
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"userInterface.plist"];
  
  PFLPuzzleSet *puzzleSet = [PFLPuzzleSet puzzleSetFromResource:@"sys_set_0"];
  CCScene *scene = [PFLPuzzleSetLayer sceneWithPuzzleSet:puzzleSet];
  return scene;
}

@end
