//
//  GameHelperLayer.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameSystem.h"
#import "GameHelperLayer.h"
#import "MiniMap.h"
#import "HelpScreen.h"
#import "Team.h"
#import "ManualAimLayer.h"
#import "GameScene.h"
#import "Skin.h"

enum {
	klevelLabel = 1,
	kshotsLabel = 2,
	kmouseLabel = 3,
	kboard = 4,
};


@interface MenuBar : CocosNode
{
	
}

@end




@implementation MenuBar

-(void)onPlay: (id) sender
{
	[(GameHelperLayer*)parent showMenuBar:NO];
}

-(void)onSound: (id) sender
{
	[[GameSystem sharedGame] setSound: ![[GameSystem sharedGame] getSound] ];
}

-(void)onHelp: (id) sender
{
	//[[GameSystem sharedGame] saveGame];	
	[[Director sharedDirector] resume];
	//[[GameSystem sharedGame] finishLevel];
	HelpScene * gs = [HelpScene node];
	gs.IsReturnToGame = YES;
	[[Director sharedDirector] replaceScene:gs];
	return;		
}

-(void)onExit: (id) sender
{
	[[Director sharedDirector] resume];
	[[GameSystem sharedGame] saveGame];	
	[[GameSystem sharedGame] finishLevel];
	[[GameSystem sharedGame] exitToMenu];
}

-(id)init
{
	if([super init])
	{
		Sprite* bg = [Sprite spriteWithFile:@"Pause_Bar.png"];
		bg.anchorPoint = ccp(0,0);
		[self addChild:bg];
		
		MenuItemImage* playMenuItem = [MenuItemImage itemFromNormalImage:@"Level_Batton_Play.png" 
															selectedImage:@"Level_Batton_Play.png" 
																   target:self selector:@selector(onPlay:)];
		/*MenuItemImage* soundMenuItem = [MenuItemImage itemFromNormalImage:@"Button_Sound_On_Inactive.png" 
														   selectedImage:@"Button_Sound_On_Pressure.png" 
																  target:self selector:@selector(onSound:)];*/
		
		MenuItemToggle *soundMenuItem = [MenuItemToggle itemWithTarget:self selector:@selector(onSound:) items:
								 [MenuItemImage itemFromNormalImage:@"Button_Sound_Off_Inactive.png" selectedImage:@"Button_Sound_Off_Pressure.png"],
								 [MenuItemImage itemFromNormalImage:@"Button_Sound_On_Inactive.png" selectedImage:@"Button_Sound_On_Pressure.png"],nil];
		
		if([[GameSystem sharedGame] getSound])
			[soundMenuItem setSelectedIndex:1];
		
		MenuItemImage* helpMenuItem = [MenuItemImage itemFromNormalImage:@"Button_Helpt_Inactive.png" 
														   selectedImage:@"Button_Help_Pressure.png" 
																  target:self selector:@selector(onHelp:)];
		MenuItemImage* exitMenuItem = [MenuItemImage itemFromNormalImage:@"Button_Exit_Inactive.png" 
														   selectedImage:@"Button_Exit_Pressure.png" 
																  target:self selector:@selector(onExit:)];
		playMenuItem.position = ccp(27,30);
		soundMenuItem.position = ccp(27,105);
		helpMenuItem.position = ccp(27,190);
		exitMenuItem.position = ccp(27,270);
		
		Menu* menu = [Menu menuWithItems:playMenuItem,soundMenuItem,helpMenuItem,exitMenuItem, nil];
		menu.position = ccp(0,0);
		[self addChild:menu z:1];
		
		
		return self;
	}
	return nil;
}




@end





@implementation GameHelperLayer

@synthesize miniMap;

-(void)onExit: (id) sender
{
	[[GameSystem sharedGame] finishLevel];
	[[GameSystem sharedGame] startUpgrade];
}

-(void)onPause: (id) sender
{	
	[self showMenuBar:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{	
	[[Director sharedDirector] resume];
}

-(id)init
{
	if([super init])
	{
		isTouchEnabled = YES;
		
		MenuItemImage* exitMenuItem = [MenuItemImage itemFromNormalImage:@"Button_Exit_Pressure.png" 
											 selectedImage:@"Button_Exit_Pressure.png" 
													target:self selector:@selector(onExit:)];
		exitButton = [Menu menuWithItems:exitMenuItem, nil];
		exitButton.position = ccp(460, 20);
		[self addChild: exitButton];
		[exitButton retain];
		
		MenuItemImage* pauseMenuItem = [MenuItemImage itemFromNormalImage:@"Level_Button_Pause.png" 
											 selectedImage:@"Level_Button_Pause.png" 
													target:self selector:@selector(onPause:)];
		pauseButton = [Menu menuWithItems:pauseMenuItem, nil];
		pauseButton.position = ccp(20, 25);
		[self addChild: pauseButton];
		[pauseButton retain];

		[self showExitButton:NO];
		
		menuBar = [MenuBar node];
		menuBar.position =ccp(0,-320);
		[self addChild:menuBar];
		
		
		/*ASkin* tSkin = [[ASkin skinWithName:@"LevelParsSkin"] retain];
		CocosNode* nodeCh = (CocosNode*)tSkin;
		[self addChild:(CocosNode*)tSkin z:-1 tag:kboard];	*/
		MenuItemImage* bar = [MenuItemImage itemFromNormalImage:@"Battle_Lost_clear.png" 
														   selectedImage:@"Battle_Lost_clear.png" 
																  target:self selector:nil];
		bar.position = ccp(250, 290);
		
		[self addChild: bar z:-1 tag:kboard];
		
		Label* levelLabel = [Label labelWithString:[NSString stringWithFormat:@"LEVEL %d", [[GameSystem sharedGame] getCurrentLevel]] fontName:@"Arial-BoldMT" fontSize:24];
		[self addChild:levelLabel z:10 tag:klevelLabel];
		[levelLabel setPosition: ccp(140, 290)];
		[levelLabel setRGB:248 :248 :0];
		
		Label* shotsLabel = [Label labelWithString:[NSString stringWithFormat:@"par:6 shots", [[GameSystem sharedGame] getCurrentLevel]] fontName:@"CourierNewPS-BoldItalicMT" fontSize:24];
		[self addChild:shotsLabel z:10 tag:kshotsLabel];
		[shotsLabel setPosition: ccp(320, 290)];
		[shotsLabel setRGB:248 :248 :248];
		
		Label* mouseLabel = [Label labelWithString:[NSString stringWithFormat:@"tap to start", [[GameSystem sharedGame] getCurrentLevel]] fontName:@"CourierNewPS-BoldItalicMT" fontSize:18];
		[self addChild:mouseLabel z:10 tag:kmouseLabel];
		[mouseLabel setPosition: ccp(240, 260)];
		[mouseLabel setRGB:248 :248 :0];
		
		
		
		return self;
	}
	return nil;
}

-(void) makeLevelTextUnVisible
{	
	Label* level = (Label*) [self getChildByTag:klevelLabel];
	level.visible = NO;
	
	Label* shots = (Label*) [self getChildByTag:kshotsLabel];	
	shots.visible = NO;
	
	Label* mouse = (Label*) [self getChildByTag:kmouseLabel];	
	mouse.visible = NO;
	
	MenuItemImage* board = (MenuItemImage*) [self getChildByTag:kboard];
	//[board setVisibility:NO];
	board.visible = NO;
}

-(void) showExitButton:(BOOL)show
{
	if(exitButton.visible != show)
	{
		if(show)
		{
			[self addChild:exitButton];			
		}
		else
		{
			[self removeChild:exitButton cleanup:YES];
		}
		exitButton.visible = show;
	}
}

-(void) showPauseButton:(BOOL)show
{
	if(pauseButton.visible != show)
	{
		if(show)
		{
			[self addChild:pauseButton];			
		}
		else
		{
			[self removeChild:pauseButton cleanup:YES];
		}
		pauseButton.visible = show;
	}
}

-(void) showingCallback
{
	[[Director sharedDirector] pause];
}

-(void) hidingCallback
{
	[self showPauseButton:YES];
}


-(void) showMenuBar:(BOOL)show
{
	BOOL menuBarIsVisible = (menuBar.position.y > -160);
	if(menuBarIsVisible != show)
	{
		if(show)
		{
			miniMap.visible = NO;
			[self showPauseButton:NO];
			id showAction = [MoveTo actionWithDuration:0.1 position:ccp(0, 0)];
			id endAction = [CallFunc actionWithTarget:self selector: @selector(showingCallback)];
			[menuBar runAction:[Sequence actionOne:showAction two:endAction]];	
			   
			[[GameSystem sharedGame] setTimeUsed];
			
			ManualAimLayer* mnLayer = [[GameSystem sharedGame].gameScene getAimLayer];
			mnLayer.isLayerEnabled = NO;
			[mnLayer showControls:NO];
		}
		else
		{
			miniMap.visible = YES;
			[[Director sharedDirector] resume];
			id hideAction = [MoveTo actionWithDuration:0.1 position:ccp(0, -320)];
			id endAction = [CallFunc actionWithTarget:self selector: @selector(hidingCallback)];
			[menuBar runAction:[Sequence actionOne:hideAction two:endAction]];	
			
			[[GameSystem sharedGame] setStartTime];
			
			ManualAimLayer* mnLayer = [[GameSystem sharedGame].gameScene getAimLayer];
			mnLayer.isLayerEnabled = YES;
			[mnLayer showControls:YES];
		}
	}
}

-(void)setMiniMap:(MiniMap*)mm
{
	miniMap = mm;
	[self addChild:miniMap];
	miniMap.anchorPoint = ccp(0, 0);
	miniMap.position = ccp(0, 310);
}

-(void) showMiniMap
{
	id showMapAction = [MoveTo actionWithDuration:0.1 position:ccp(0,320-90)];
	[miniMap runAction:showMapAction];
}

-(void) hideMiniMap
{
	id hideMapAction = [MoveTo actionWithDuration:0.1 position:ccp(0,310)];
	[miniMap runAction:hideMapAction];
}

-(BOOL) miniMapIsVisible
{
	return miniMap.position.y < 300;
}


- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
		
	CGPoint point = [touch locationInView: [touch view]];
	point =  [[Director sharedDirector] convertCoordinate: point];
	
	BOOL menuBarIsVisible = (menuBar.position.y > -160);	
	if(point.x > 35)
	{	
		if(menuBarIsVisible)
		    return kEventHandled;
		else
		{
			if(point.y > 300)
			{
				[[GameSystem sharedGame] updateMiniMap];
				[self showMiniMap];
				return YES;
			}		
			return NO;
		}
	}
		
	return NO;
}


- (BOOL)ccTouchesMoved:(NSMutableSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint point = [touch locationInView: [touch view]];
    point =  [[Director sharedDirector] convertCoordinate: point];
	
	BOOL menuBarIsVisible = (menuBar.position.y > -160);
	if(point.x > 35)
	{	
		if(menuBarIsVisible)
		    return kEventHandled;
		else
			return NO;
	}
	
	
	return NO;	
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint point = [touch locationInView: [touch view]];
	point =  [[Director sharedDirector] convertCoordinate: point];

	if([self miniMapIsVisible])
	{
		[self hideMiniMap];			
		return YES;
	}
	
	return NO;
}


-(void) dealloc
{
	[pauseButton release];
	[exitButton release];
	[super dealloc];
}

@end
