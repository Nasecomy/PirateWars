//
//  PlayerMenuScene.h
//  PiratesWar
//
//  Created by Vladimir Demkovich on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface PlayerMenuScene : Scene 
{
	int gameLoadingType;
	//UIImageView* loadingView;
	
	MenuItemImage* item1;
	MenuItemImage* item2;
}
@property (nonatomic, assign) MenuItemImage *item1;
@property (nonatomic, assign) MenuItemImage *item2;
-(void) LoadStoryGame;

@end

@interface PlayerMenuLayer : Layer 
{
	//UIImageView* loadingView;
	//int gameLoadingType;
}

@end
