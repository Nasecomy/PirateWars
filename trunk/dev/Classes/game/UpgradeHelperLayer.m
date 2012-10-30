//
//  UpgadeHelperLayer.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UpgradeHelperLayer.h"
#import "GameSystem.h"
#import "Team.h"


@implementation UpgradeHelperLayer


static const int maxRockets = 6;
static const int maxBows = 5;


-(void) updateCreditsValue
{
	[creditsValue setString:[NSString stringWithFormat:@"%d", credits]];
}

-(void) updateRocketValue
{
	[rocketValue setString:[NSString stringWithFormat:@"%d", rockets]];
}

-(void) updateBowValue
{
	[bowValue setString:[NSString stringWithFormat:@"%d", bows]];
}

-(void) updateShipValue
{
	[shipValue setString: newShip ? @"√" : @"0" ];
	
	if(newShip)
	{
		[[GameSystem sharedGame] onUpgradeShip];
	}
	else
	{
		[[GameSystem sharedGame] onDowngradeShip];
	}
}

-(void)onRocket: (id) sender
{
	if( rockets<maxRockets && credits>=rocketPrice )
	{
		credits -= rocketPrice;
		rockets++;
	}
	else
	{
		credits += rockets*rocketPrice - minRockets*rocketPrice;		
		rockets = minRockets;
	}
	
	[self updateRocketValue];
	[self updateCreditsValue];
}

-(void)onBow: (id) sender
{
	if( bows<maxBows && credits>=bowPrice )
	{
		credits -= bowPrice;
		bows++;
	}
	else
	{
		credits += bows*bowPrice - minBows*bowPrice;		
		bows = minBows;
	}
	
	[self updateBowValue];
	[self updateCreditsValue];
}

-(void)onShip: (id) sender
{
	if(newShip)
	{
		newShip = NO;
		credits += shipPrice;
	}
	else if(credits>=shipPrice)
	{
		newShip = YES;
		credits -=shipPrice;				
	}
	else
	{
		return;
	}

	[self updateShipValue];
	[self updateCreditsValue];
}



-(void)onExit: (id) sender
{
	[[GameSystem sharedGame] completeUpgrade:credits bows:bows rockets:rockets ship:newShip];
	// Demkovich
	//[[GameSystem sharedGame] saveGame];
}



-(id)init
{
	if([super init])
	{
		ATeam* team = [[GameSystem sharedGame] activeTeam];

		credits = team.credits;
		rockets = minRockets = [team getProjectileCountForWeapon:@"RocketWeapon"];
		bows = minBows = [team getProjectileCountForWeapon:@"BowWeapon"];
		newShip = NO;
		
		rocketPrice = 200;
		bowPrice = 100;
		shipPrice = 1000;
		
		Sprite* bg = [Sprite spriteWithFile:@"Select_Upgrade.png"];
		bg.anchorPoint = ccp(0.5 ,1.0);
		bg.position = ccp(240, 320);
		[self addChild:bg];
		
		MenuItemImage* rocketButton = [MenuItemImage itemFromNormalImage:@"Button_Upgrade_Artil_Down.png" 
														 selectedImage:@"Button_Upgrade_Artil_Up.png" 
																target:self selector:@selector(onRocket:)];
		rocketButton.position = ccp(130, 100);
		
		MenuItemImage* bowButton = [MenuItemImage itemFromNormalImage:@"Button_Upgrade_Bow_Down.png" 
														   selectedImage:@"Button_Upgrade_Bow_Up.png" 
																  target:self selector:@selector(onBow:)];
		bowButton.position = ccp(130, 200);
		
		
		MenuItemImage* shipButton = [MenuItemImage itemFromNormalImage:@"Button_Upgrade_Ship_Down.png" 
														selectedImage:@"Button_Upgrade_Ship_Up.png" 
															   target:self selector:@selector(onShip:)];
		shipButton.position = ccp(300, 150);
		
		int level = [[GameSystem sharedGame] level];
		if(level < 2)
		    shipButton.isEnabled  = NO;
		
		MenuItemImage* exitButton = [MenuItemImage itemFromNormalImage:@"Level_Batton_At.png" 
														 selectedImage:@"Level_Batton_At.png" 
																target:self selector:@selector(onExit:)];
		exitButton.position = ccp(460, 20);
		
		Menu* menu = [Menu menuWithItems:rocketButton, bowButton, shipButton,  exitButton, nil];
		menu.position = ccp(0,0);
		[self addChild:menu z:1];
		
		
		Label* rocketPriceLabel = [Label labelWithString:[NSString stringWithFormat:@"%d", rocketPrice] fontName:@"Arial" fontSize:14];
		[rocketPriceLabel setPosition: ccp(151, 90)];
		[rocketPriceLabel setRGB:255 :255 :0];
		[self addChild: rocketPriceLabel z:2];
		
		Label* bowPriceLabel = [Label labelWithString:[NSString stringWithFormat:@"%d", bowPrice] fontName:@"Arial" fontSize:14];
		[bowPriceLabel setPosition: ccp(152, 192)];
		[bowPriceLabel setRGB:255 :255 :0];
		[self addChild: bowPriceLabel z:2];

		Label* shipPriceLabel = [Label labelWithString:[NSString stringWithFormat:@"%d", shipPrice] fontName:@"Arial" fontSize:14];
		[shipPriceLabel setPosition: ccp(334, 141)];
		[shipPriceLabel setRGB:255 :255 :0];
		[self addChild: shipPriceLabel z:2];
		
		
		creditsValue = [Label labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:18];
		[creditsValue setPosition: ccp(240, 268)];
		[creditsValue setRGB:55 :100 :0];
		[self addChild: creditsValue z:2];
		
		rocketValue = [Label labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:14];
		[rocketValue setPosition: ccp(168, 116)];
		[rocketValue setRGB:255 :255 :255];
		[self addChild: rocketValue z:2];
		
		bowValue = [Label labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:14];
		[bowValue setPosition: ccp(168, 216)];
		[bowValue setRGB:255 :255 :255];
		[self addChild: bowValue z:2];
		
		shipValue = [Label labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:16];
		[shipValue setPosition: ccp(367, 180)];
		[shipValue setRGB:255 :255 :255];
		[self addChild: shipValue z:2];
		
		
		[self updateCreditsValue];
		[self updateRocketValue];
		[self updateBowValue];
		//[self updateShipValue];
		
	
		helperLayer = [GameHelperLayer node];
		[self addChild:helperLayer z:5];
		[helperLayer makeLevelTextUnVisible];
		
		return self;
	}
	return nil;
}



-(void) dealloc
{
	[super dealloc];
}


@end
