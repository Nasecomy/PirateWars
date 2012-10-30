//
//  LostScene.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LostScene.h"
#import "Skin.h"
#import "GameSystem.h"

@implementation LostScene

-(void)onExit: (id) sender
{
	// cointinue button stil activ so lets give chanse to see lost scene again
	// D.V we shouldn't see lost scene, lets give chance to start again with succesfull level 
	//[[GameSystem sharedGame] saveGame];
	[[GameSystem sharedGame] finishLevel];
	[[GameSystem sharedGame] exitToMenu];
}

-(id)init
{
	if ([super init]) 
	{
		ASkin* bg = [ASkin skinWithName:@"LostSceneSkin"];
		[bg node].scale = 0.75;
		[bg node].position = CGPointMake(240,160);
		[self addChild:[bg node]];	
		
		MenuItemImage* exitMenuItem = [MenuItemImage itemFromNormalImage:@"Level_Batton_At.png" 
														   selectedImage:@"Level_Batton_At.png" 
																  target:self selector:@selector(onExit:)];
		exitMenuItem.position = ccp(460, 25);
		
		Menu* menu = [Menu menuWithItems:exitMenuItem, nil];
		
		menu.position = ccp(0, 0);
		[self addChild:menu];

		return self;
	}
	return nil;
}

-(void) dealloc
{
	[super dealloc];
}


@end
