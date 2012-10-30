//
//  ManualAimLayer.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface ManualAimLayer : Layer 
{
	AtlasSprite *powSprite;
	
	Label* powerValue;
	Label* angleValue;
	
	BOOL powerGrow;
	
	Menu* weapons;
	MenuItemSprite *stoneMenuItem;
	MenuItemSprite *bowMenuItem;
	MenuItemSprite *rocketMenuItem;
	Sprite* stoneSelectedSprite;
	Sprite* bowSelectedSprite;
	Sprite* rocketSelectedSprite;
	Label* bowCountLabel;	
	Label* rocketCountLabel;
	BOOL isLayerEnabled;
}
@property (nonatomic) BOOL isLayerEnabled;
@property (nonatomic) BOOL powerGrow;

-(void) updatePower:(int)power;
-(void) updateAngle:(int)angle;

-(void)updateControls;
-(void)showControls:(BOOL)show;
@end
