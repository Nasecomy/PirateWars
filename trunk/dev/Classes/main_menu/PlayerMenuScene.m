//
//  PlayerMenuScene.m
//  PiratesWar
//
//  Created by Vladimir Demkovich on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlayerMenuScene.h"
#import "HelpScreen.h"
#import "StartLoadingScene.h"
#import "GameSystem.h"
#import "GameScene.h"

#import "ServerListViewController.h"
#import "GameDebugViewController.h"

//static BOOL loaded = NO;
//static BOOL IsPopup = NO;

@interface PopupMenu : Layer
{
	

}
@end

@implementation PopupMenu

-(void) allowModeClick
{
	PlayerMenuScene* plscene = (PlayerMenuScene*)[self parent];
	[[plscene item1] setIsEnabled:YES];
	[[plscene item1] setIsEnabled:YES];
}

-(void) onContinue: (id) sender
{
	[[GameSystem sharedGame] showActivityIndicator];
	[self allowModeClick];
	
	//IsPopup = NO;
	//if(loaded==NO)
	{
		//loaded = YES;
		
		[[TextureMgr sharedTextureMgr] removeUnusedTextures];
		
		[[GameSystem sharedGame] loadResources];
		//[[GameSystem sharedGame] loadGame];
		[self schedule:@selector(doContinue:) interval:0.0];
		/*
			AGameScene * gs = [[GameSystem sharedGame] getScene];
			[[Director sharedDirector] replaceScene:gs];
		*/

	}
}

-(void) doContinue: (CGFloat)delta
{
	[self unschedule:@selector(doContinue:)];
	
    [[GameSystem sharedGame] loadGame];  
	[[GameSystem sharedGame].loadingView removeFromSuperview];
	[GameSystem sharedGame].loadingView  = nil;

}

-(void) onStartNewGame: (id) sender
{
	//IsPopup = NO;

    [self allowModeClick];
	
	self.position = ccp(0,500);
}

-(void) onExit: (id) sender
{
	[self allowModeClick];
	//IsPopup = NO;
	
	self.position = ccp(0,500);
}


-(void) dealloc
{
	[super dealloc];
}

- (id) init 
{
    if( [super init] )
	{	
		isTouchEnabled = YES;
		//IsPopup = YES;
		
		PlayerMenuScene* plscene = (PlayerMenuScene*)[self parent];
		
		[[plscene item1] setIsEnabled:NO];
		[[plscene item1] setIsEnabled:NO];
		
		Sprite * bg = [Sprite spriteWithFile:@"BackGr.png"];
        [self addChild:bg z:0];

		MenuItemImage *continueButton = [MenuItemImage itemFromNormalImage:@"continue.png" selectedImage:@"continue_pressed.png" target:self selector:@selector(onContinue:)];
		MenuItemImage *startNewButton = [MenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"start_pressed.png" target:self selector:@selector(onStartNewGame:)];
		MenuItemImage *exitButton = [MenuItemImage itemFromNormalImage:@"exit.png" selectedImage:@"exit.png" target:self selector:@selector(onExit:)];
		Menu *menu = [Menu menuWithItems: continueButton, startNewButton, exitButton, nil];
		[self addChild: menu];
		
		menu.position = ccp(0,0);
		continueButton.position = ccp(0, 0);
		startNewButton.position = ccp(0,-70);
		exitButton.position = ccp(120, 80);

		return self;
    }
    return nil;
}

- (BOOL)ccTouchesBegan:(NSMutableSet *)touches withEvent:(UIEvent *)event
{	
    return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    return kEventHandled;
}

@end


/////////////////////////////////////////////////////////////////////////////




@interface PopupOnStory : Layer
{
	
	
}
@end

@implementation PopupOnStory

-(void) allowModeClick
{
	PlayerMenuScene* plscene = (PlayerMenuScene*)[self parent];
	[[plscene item1] setIsEnabled:YES];
	[[plscene item1] setIsEnabled:YES];
}

-(void) onContinue: (id) sender
{
	[self allowModeClick];
	
		
	[[TextureMgr sharedTextureMgr] removeUnusedTextures];
		
	[[GameSystem sharedGame] loadResources];
	[[GameSystem sharedGame] loadGame];
}

-(void) onStartNewGame: (id) sender
{	
    //[self allowModeClick];
	
	self.position = ccp(0,500);
	
	PlayerMenuScene* plscene = (PlayerMenuScene*)[self parent];
	[plscene LoadStoryGame];
}

-(void) onExit: (id) sender
{
	[self allowModeClick];
	
	self.position = ccp(0,500);
}


-(void) dealloc
{
	[super dealloc];
}

- (id) init 
{
    if( [super init] )
	{	
		isTouchEnabled = YES;
		
		PlayerMenuScene* plscene = (PlayerMenuScene*)[self parent];
		
		[[plscene item1] setIsEnabled:NO];
		[[plscene item1] setIsEnabled:NO];
		
		Sprite * bg = [Sprite spriteWithFile:@"BackGr.png"];
        [self addChild:bg z:0];
		
		MenuItemImage *continueButton = [MenuItemImage itemFromNormalImage:@"continue.png" selectedImage:@"continue_pressed.png" target:self selector:@selector(onContinue:)];
		MenuItemImage *startNewButton = [MenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"start_pressed.png" target:self selector:@selector(onStartNewGame:)];
		MenuItemImage *exitButton = [MenuItemImage itemFromNormalImage:@"exit.png" selectedImage:@"exit.png" target:self selector:@selector(onExit:)];
		Menu *menu = [Menu menuWithItems: continueButton, startNewButton, exitButton, nil];
		[self addChild: menu];
		
		menu.position = ccp(0,0);
		continueButton.position = ccp(0, 0);
		startNewButton.position = ccp(0,-70);
		exitButton.position = ccp(120, 80);
		
		return self;
    }
    return nil;
}

@end


/////////////////////////////////////////////////////////////////////////////




/////////////////////////////////////////////////////////////////////////////

@implementation PlayerMenuScene

@synthesize item1;
@synthesize item2;

- (id) init {
    self = [super init];
    if (self != nil) {
		
		Sprite * bg = [Sprite spriteWithFile:@"Main-Menu.png"];
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
        [self addChild:[PlayerMenuLayer node] z:1];
		
		
		/*MenuItemImage*/ item1 = [MenuItemImage itemFromNormalImage:@"Main-Menu_1_Off.png" selectedImage:@"Main-Menu_1_On.png" target:self selector:@selector(onStoryModeGame:)];
		/*MenuItemImage*/ item2 = [MenuItemImage itemFromNormalImage:@"Main-Menu_2_Off.png" selectedImage:@"Main-Menu_2_On.png" target:self selector:@selector(onWarModeGame:)];
		
		Menu *menu = [Menu menuWithItems: item1, item2, nil];
		
		CGSize s = [[Director sharedDirector] winSize];
		menu.position = ccp(s.width/2, s.height/2);
		
		//item1.position = ccp(s.width/2 - 70, s.height/2+20);
		//item2.position = ccp(s.width/2 + 45, s.height/2+ 45);
		
		item1.position = ccp(- 70, 20);
		item2.position = ccp( 45, 20);
		
		[self addChild: menu z:5];
		
		[item1 setIsEnabled:NO];
		[item2 setIsEnabled:NO];
		
		BOOL isSaved = [[NSUserDefaults standardUserDefaults] boolForKey:@"saved"];
		if(isSaved)
		{
			NSString* levelName = [[NSUserDefaults standardUserDefaults] objectForKey:@"savename"];
			if(levelName!=nil)
			{
				PopupMenu* popupMenu = [PopupMenu node]; //[[PopupMenu alloc] init];
				popupMenu.position = ccp(240, 160);
				[self addChild:popupMenu z:10];
				
			}
		}
		else {
			
			[item1 setIsEnabled:YES];
			[item2 setIsEnabled:YES];
		}

		
				
	}
	//loaded = NO;
    return self;
}

-(void) onStoryModeGame:(id) sender
{
	
	BOOL isSaved = [[NSUserDefaults standardUserDefaults] boolForKey:@"saved"];
	if(isSaved)
	{
		NSString* levelName = [[NSUserDefaults standardUserDefaults] objectForKey:@"savename"];
		if(levelName!=nil)
		{
			PopupOnStory* popupOnStory = [PopupOnStory node]; //[[PopupMenu alloc] init];
			popupOnStory.position = ccp(240, 160);
			[self addChild:popupOnStory z:10];
			
		}
	}
	else
        [self LoadStoryGame];
}

-(void) LoadStoryGame
{	
	[[GameSystem sharedGame] showActivityIndicator];
	gameLoadingType = kStoryModeGame;
	[self schedule:@selector(doLoadGame:) interval:0.0];
}

-(void) onWarModeGame:(id) sender
{
	//if(loaded==NO && !IsPopup)
	{
		//loaded = YES;
		
		[[TextureMgr sharedTextureMgr] removeUnusedTextures];
		[[GameSystem sharedGame] loadResources];
		
		UIViewController *viewController = [[ServerListViewController alloc] init];
		[[[Director sharedDirector] openGLView] addSubview:viewController.view];
		[viewController.view setTransform: CGAffineTransformMakeRotation(3.1415/2) ];
		viewController.view.frame = CGRectMake(0,0, 320, 480);
	}
}

-(void) doLoadGame: (CGFloat)delta
{
	[self unschedule:@selector(doLoadGame:)];
	
	if(gameLoadingType == kStoryModeGame)
	{
		[[TextureMgr sharedTextureMgr] removeUnusedTextures];
		[[GameSystem sharedGame] loadResources];
		[[GameSystem sharedGame] startNewGame:kStoryModeGame];
		
		[[GameSystem sharedGame].loadingView removeFromSuperview];
		[GameSystem sharedGame].loadingView  = nil;
	}
}

@end




/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

@implementation PlayerMenuLayer


- (id) init {
    self = [super init];
    if (self != nil) {
        isTouchEnabled = NO;
		
		Sprite * bg = [Sprite spriteWithFile:@"Main-Menu.png"];
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
		
    	MenuItemImage *item4 = [MenuItemImage itemFromNormalImage:@"Button_Help_Inactive.png" selectedImage:@"Button_Help_Pressure.png" target:self selector:@selector(onHelp:)];
		
		MenuItemToggle *item3 = [MenuItemToggle itemWithTarget:self selector:@selector(menuOnSound:) items:
								 [MenuItemImage itemFromNormalImage:@"Button_Sound_Off_Inactive.png" selectedImage:@"Button_Sound_Off_Pressure.png"],
								 [MenuItemImage itemFromNormalImage:@"Button_Sound_On_Inactive.png" selectedImage:@"Button_Sound_On_Pressure.png"],
								 nil];
		if([[GameSystem sharedGame] getSound])
			[item3 setSelectedIndex:1];
				 
		Menu *menu = [Menu menuWithItems: item3, item4, nil];
		
		CGSize s = [[Director sharedDirector] winSize];
		menu.position = CGPointZero;
		
		item3.position = ccp(s.width/2 - 200, 30);
		item4.position = ccp(s.width/2 + 200, 30);
	
		[self addChild: menu];
		
		
	    [MenuItemFont setFontSize:20];
	    [MenuItemFont setFontName:@"Helvetica"];
        MenuItemFont *debugLevelButton = [MenuItemFont itemFromString:@"Debug level" target:self selector:@selector(onDebugLevel:)];
        Menu *menuLevelButton = [Menu menuWithItems:debugLevelButton, nil];
        [menuLevelButton alignItemsVertically];
		menuLevelButton.position = ccp(150, 50);
        [self addChild:menuLevelButton z:1];
		
		}
	//loaded = NO;
    return self;

}

-(void) menuOnSound: (id) sender
{
	[[GameSystem sharedGame] setSound: ![[GameSystem sharedGame] getSound] ];
}

-(void) onDebugLevel:(id) sender
{
	//if(loaded==NO)
	{
		//loaded = YES;
		
		[[TextureMgr sharedTextureMgr] removeUnusedTextures];
		[[GameSystem sharedGame] loadResources];
		
		UIViewController *viewController = [[GameDebugViewController alloc] init];
		[[[Director sharedDirector] openGLView] addSubview:viewController.view];
		[viewController.view setTransform: CGAffineTransformMakeRotation(3.1415/2) ];
		viewController.view.frame = CGRectMake(0,0, 320, 480);
	}
}


-(void) onHelp:(id) sender
{
	HelpScene * gs = [HelpScene node];
	gs.IsReturnToGame = NO;
	[[Director sharedDirector] replaceScene:gs];
	return;	
}	

@end
