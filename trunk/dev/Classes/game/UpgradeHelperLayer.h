//
//  UpgadeHelperLayer.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "GameHelperLayer.h"

@interface UpgradeHelperLayer : Layer 
{
	Label* creditsValue;
	Label* shipValue;
	Label* rocketValue;
	Label* bowValue;
	
	int rocketPrice;
	int bowPrice;
	int shipPrice;
	
	int credits;
	int rockets;
	int minRockets;
	int bows;
	int minBows;
	BOOL newShip;
	GameHelperLayer* helperLayer;
	int rc;
}

@end
