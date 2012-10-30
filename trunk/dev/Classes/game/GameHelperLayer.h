//
//  GameHelperLayer.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MiniMap;

@interface GameHelperLayer : Layer 
{
	MiniMap* miniMap;
	
	Menu* exitButton;
	Menu* pauseButton;
	
	CocosNode* menuBar;

/*	
	Menu* weapons;
	MenuItemSprite *stoneMenuItem;
	MenuItemSprite *bowMenuItem;
	MenuItemSprite *rocketMenuItem;
	Sprite* stoneSelectedSprite;
	Sprite* bowSelectedSprite;
	Sprite* rocketSelectedSprite;
	Label* bowCountLabel;	
	Label* rocketCountLabel;
*/ 
}

@property (nonatomic, readonly) MiniMap* miniMap;
-(void)setMiniMap:(MiniMap*)miniMap;
-(void) showExitButton:(BOOL)show;
-(void) showPauseButton:(BOOL)show;
-(void) showMenuBar:(BOOL)show;
-(BOOL) miniMapIsVisible;
-(void) makeLevelTextUnVisible;
/*
-(void)updateControls;

-(void) setBowCount:(int)bows;
-(void) setRocketCount:(int)rockets;
-(void) setSelectedStone;
-(void) setSelectedBow;
-(void) setSelectedRocket;
*/

@end
