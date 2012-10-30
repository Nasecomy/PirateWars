//
//  PirateWarsAppDelegate.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 11/12/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "PirateWarsAppDelegate.h"
#import "cocos2d.h"
#import "GameSystem.h"
#import "StartLoadingScene.h"


@implementation PirateWarsAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[application setStatusBarHidden:YES animated:NO];
	application.idleTimerDisabled = YES;
	
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
	
	// must be called before any othe call to the director
	//[Director useFastDirector];
	
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[Director sharedDirector] setAnimationInterval:1.0/60];
	[[Director sharedDirector] setDisplayFPS:YES];
	
	[Texture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// create an openGL view inside a window
    [[Director sharedDirector] attachInWindow:window];
    [window makeKeyAndVisible];
	
	StartLoadingScene * ms = [StartLoadingScene node];	
    [[Director sharedDirector] runWithScene:ms];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[[GameSystem sharedGame] saveGame];
	[[GameSystem sharedGame] stopPlaying];
}


- (void)dealloc 
{
    [super dealloc];
}


@end
