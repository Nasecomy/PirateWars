//
//  ManualAimLayer.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ManualAimLayer.h"
#import "GameSystem.h"
#import "Hero.h"
#import "Aimer.h"
#import "Team.h"
#import "GameHelperLayer.h"
#import "GameScene.h"

#define USE_EASY_AIMER 0

@implementation ManualAimLayer

@synthesize isLayerEnabled;
@synthesize powerGrow;

static const int spriteSizeWidth = 51;
static const int spriteSizeHeight = 176;


-(void) setBowCount:(int)bows
{
	[bowCountLabel setString:[NSString stringWithFormat: bows > 0 ? @"%d" : @" ", bows]];
	bowMenuItem.isEnabled = bows > 0;
}

-(void) setRocketCount:(int)rockets
{
	[rocketCountLabel setString:[NSString stringWithFormat: rockets > 0 ? @"%d" : @" ", rockets]];
	rocketMenuItem.isEnabled = rockets > 0;
}

-(void) setSelectedStone
{
	stoneSelectedSprite.visible = YES;
	bowSelectedSprite.visible = NO;
	rocketSelectedSprite.visible = NO;
}

-(void) setSelectedBow
{
	stoneSelectedSprite.visible = NO;
	bowSelectedSprite.visible = YES;
	rocketSelectedSprite.visible = NO;
}

-(void) setSelectedRocket
{
	stoneSelectedSprite.visible = NO;
	bowSelectedSprite.visible = NO;
	rocketSelectedSprite.visible = YES;
}

-(void)updateControls
{
	ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
	if(activeTeam!=nil)
	{
		int bows = [activeTeam getProjectileCountForWeapon:@"BowWeapon"];
		
		[self setBowCount:bows];
		int rockets = [activeTeam getProjectileCountForWeapon:@"RocketWeapon"];
		[self setRocketCount:rockets];
		
		NSString* activeWeaponName = [activeTeam getActiveWeaponName];
		if( [activeWeaponName compare:@"BallWeapon"] == NSOrderedSame )
		{
			[self setSelectedStone];
		}
		else if( [activeWeaponName compare:@"BowWeapon"] == NSOrderedSame)
		{
			[self setSelectedBow];
		}	
		else if( [activeWeaponName compare:@"RocketWeapon"] == NSOrderedSame)
		{
			[self setSelectedRocket];
		}
	}	
}

-(void)onWeaponStone:(id)sender
{
	if(isLayerEnabled)
	{
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		if(activeTeam!=nil)
		{
			[activeTeam selectWeapon:@"BallWeapon"];
		}
	}
}

-(void)onWeaponBow:(id)sender
{
	if(isLayerEnabled)
	{
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		int bows = [activeTeam getProjectileCountForWeapon:@"BowWeapon"];
		if(activeTeam!=nil && bows > 0)
		{
			[activeTeam selectWeapon:@"BowWeapon"];
		}
	}
}

-(void)onWeaponRocket:(id)sender
{
	if(isLayerEnabled)
	{
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		int rockets = [activeTeam getProjectileCountForWeapon:@"RocketWeapon"];
		if(activeTeam!=nil && rockets > 0)
		{
			[activeTeam selectWeapon:@"RocketWeapon"];
		}
	}
}

-(id) init
{
	if([super init])
	{
		isTouchEnabled = YES;
        isLayerEnabled = YES;

		Label* angleLabel = [Label labelWithString:@"Angle" fontName:@"Arial" fontSize:18];
		[self addChild: angleLabel z:1];
		[angleLabel setPosition: ccp(370, 280)];
		[angleLabel setRGB:85 :140 :195];

		Label* powerLabel = [Label labelWithString:@"Power" fontName:@"Arial" fontSize:18];
		[self addChild: powerLabel z:1];
		[powerLabel setPosition: ccp(450, 280)];
		//[powerLabel setString:@""];
		[powerLabel setRGB:85 :140 :195];
		
		angleValue = [Label labelWithString:@"0%" fontName:@"Arial" fontSize:18];
		[self addChild: angleValue z:1];
		[angleValue setPosition: ccp(380, 250)];
		[angleValue setRGB:255 :255 :255];
		
		powerValue = [Label labelWithString:@"0%" fontName:@"Arial" fontSize:18];
		[self addChild: powerValue z:1];
		[powerValue setPosition: ccp(460, 250)];
		[powerValue setRGB:255 :255 :255];
		

		
		Sprite *sprite = [Sprite spriteWithFile: @"Level_Button_Fire.png"];
		[self addChild: sprite z:1];
		[sprite setPosition: ccp(460, 25)];
		
		powerGrow = TRUE;
		
		AtlasSpriteManager* atlasManager = [AtlasSpriteManager spriteManagerWithFile:@"Progress_Bar.png" capacity:1];
		powSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, spriteSizeWidth, spriteSizeHeight) spriteManager: atlasManager];
		powSprite.anchorPoint = CGPointMake(0,0);
		
		[atlasManager addChild:powSprite z:0 tag:0];
		
		[self addChild:atlasManager z:0];
		atlasManager.position = CGPointMake(420, 60);
		
		
		
		stoneMenuItem = [MenuItemSprite 
						 itemFromNormalSprite:[Sprite spriteWithFile:@"Battons_Weapon_Stone_2.png"] 
						 selectedSprite:[Sprite spriteWithFile:@"Battons_Weapon_Stone_3.png"] 
						 disabledSprite:[Sprite spriteWithFile:@"Battons_Weapon_Stone_1.png"]
						 target:self selector:@selector(onWeaponStone:)];
		stoneMenuItem.position = ccp(0, 0);
		stoneSelectedSprite = [Sprite spriteWithFile:@"Battons_Weapon_Stone_3.png"];
		stoneSelectedSprite.anchorPoint = ccp(0,0);
		//stoneSelectedSprite.visible = NO;
		[stoneMenuItem addChild:stoneSelectedSprite];
		
		bowMenuItem = [MenuItemSprite
					   itemFromNormalSprite:[Sprite spriteWithFile:@"Battons_Weapon_Bow&Arrows_2.png"] 
					   selectedSprite:[Sprite spriteWithFile:@"Battons_Weapon_Bow&Arrows_3.png"] 
					   disabledSprite:[Sprite spriteWithFile:@"Battons_Weapon_Bow&Arrows_1.png"]
					   target:self selector:@selector(onWeaponBow:)];
		bowMenuItem.position = ccp(75, 0);
		bowSelectedSprite = [Sprite spriteWithFile:@"Battons_Weapon_Bow&Arrows_3.png"];
		bowSelectedSprite.anchorPoint = ccp(0,0);
		//bowSelectedSprite.visible = NO;
		[bowMenuItem addChild:bowSelectedSprite];
		bowCountLabel = [Label labelWithString:@"2" fontName:@"Arial" fontSize:16];
		bowCountLabel.position = ccp(44, 10);
		[bowMenuItem addChild:bowCountLabel];
		
		rocketMenuItem = [MenuItemSprite 
						  itemFromNormalSprite:[Sprite spriteWithFile:@"Battons_Weapon_ArtilleryCanon_2.png"] 
						  selectedSprite:[Sprite spriteWithFile:@"Battons_Weapon_ArtilleryCanon_3.png"] 
						  disabledSprite:[Sprite spriteWithFile:@"Battons_Weapon_ArtilleryCanon_1.png"]
						  target:self selector:@selector(onWeaponRocket:)];
		rocketMenuItem.position = ccp(150, 0);
		rocketSelectedSprite = [Sprite spriteWithFile:@"Battons_Weapon_ArtilleryCanon_3.png"];
		rocketSelectedSprite.anchorPoint = ccp(0,0);
		//rocketSelectedSprite.visible = NO;
		[rocketMenuItem addChild:rocketSelectedSprite];
		rocketCountLabel = [Label labelWithString:@"3" fontName:@"Arial" fontSize:16];
		rocketCountLabel.position = ccp(44, 10);
		[rocketMenuItem addChild:rocketCountLabel];
		
		weapons = [Menu menuWithItems:stoneMenuItem, bowMenuItem, rocketMenuItem, nil];
		weapons.position = ccp(50, 260);
		[self addChild:weapons];
		
		
		[self setSelectedStone];
		[self setBowCount:0];
		[self setRocketCount:0];
		
		return self;
	}
	return nil;
}	

-(void) updateAngle:(int)angle
{
	[angleValue setString:[NSString stringWithFormat:@"%d", angle]];
}

-(void) updatePower:(int)power
{
	[powerValue setString:[NSString stringWithFormat:@"%d", power]];	
	[powSprite setTextureRect:CGRectMake(0, spriteSizeHeight - spriteSizeHeight*power/100, spriteSizeWidth, spriteSizeHeight*power/100)];	
}

-(void) updatePowerOnTimer:(int)delta
{	
#if !USE_EASY_AIMER	
	
	CGFloat power_ = [[GameSystem sharedGame].aimerDelegate aimerPower];
	
	if(powerGrow)	
		power_ += 3;	
	else
	    power_ -= 3;
	
	if(power_ > 100)
	{
	    power_ = 100;
	    powerGrow = FALSE;
	}
	
	if(power_ < 1)
	{
	    power_ = 1;
	    powerGrow = TRUE;
	}
	
	[self updatePower:power_];
    [[GameSystem sharedGame].aimerDelegate didChangePower:power_];
	
#endif	
}

- (BOOL)ccTouchesMoved:(NSMutableSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint point = [touch locationInView: [touch view]];
    point =  [[Director sharedDirector] convertCoordinate: point];
	
    
	CGPoint point0 = [touch previousLocationInView:[touch view]];
    point0 =  [[Director sharedDirector] convertCoordinate: point0];
	
	WarScene* wscene =  (WarScene*)([GameSystem sharedGame].gameScene);
	
	
	if( ![[wscene helperLayer] miniMapIsVisible]  )
	{
		if(point.x < 400)
		{
			CGFloat angle0 = [[GameSystem sharedGame].aimerDelegate aimerAngle];
			CGFloat angle = (point.y - point0.y)*0.5;
			[self updateAngle:angle0+angle];
			[[GameSystem sharedGame].aimerDelegate didChangeAngle:angle0+angle];
		}
		
	}
	else 
	{
		if(point.x < 230)
		{
			CGFloat angle0 = [[GameSystem sharedGame].aimerDelegate aimerAngle];
			CGFloat angle = (point.y - point0.y)*0.5;
			[self updateAngle:angle0+angle];
			[[GameSystem sharedGame].aimerDelegate didChangeAngle:angle0+angle];
		}
	}

#if USE_EASY_AIMER	
	else
	{
		CGFloat y = point.y;
		if(y<60) 
			y = 60;
		if(y>310) 
			y=310;
		
		CGFloat power = (y - 60)*0.6;
		if(power>100) 
			power = 100;
		
		[self updatePower:power];
		[[GameSystem sharedGame].aimerDelegate didChangePower:power];
	}
#endif
	
	return YES;	
}

-(void)showControls:(BOOL)show
{
    if(!show)
	{
		bowMenuItem.isEnabled = show;
		rocketMenuItem.isEnabled = show;
		stoneMenuItem.isEnabled = show;	
		
		stoneSelectedSprite.visible = show;
		bowSelectedSprite.visible = show;
		rocketSelectedSprite.visible = show;
	}
	else 
	{
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		int bows, rockets = 0; 
		if(activeTeam!=nil)
		{
			bows = [activeTeam getProjectileCountForWeapon:@"BowWeapon"];
			rockets = [activeTeam getProjectileCountForWeapon:@"RocketWeapon"];
		}
		
		bowMenuItem.isEnabled = bows > 0;
		rocketMenuItem.isEnabled = rockets > 0;
		stoneMenuItem.isEnabled = YES;	
		
		stoneSelectedSprite.visible = YES;
		bowSelectedSprite.visible = NO;
		rocketSelectedSprite.visible = NO;		
	}


}

- (BOOL)ccTouchesBegan:(NSMutableSet *)touches withEvent:(UIEvent *)event
{		
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    point =  [[Director sharedDirector] convertCoordinate: point];
	
	if([self visible] == YES)
	{
		if(point.x > 445 && point.y < 42)
		     [self schedule: @selector(updatePowerOnTimer:) interval: 0.02f];
	}
	
	return YES;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(!isLayerEnabled)
			return NO;	
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    point =  [[Director sharedDirector] convertCoordinate: point];
	
	if([self visible] == YES)
	{
	    if(point.x > 445 && point.y < 42)
	    {
			[[GameSystem sharedGame].aimerDelegate didCompleteAiming];
	        [self unschedule: @selector(updatePowerOnTimer:)];
	    }
	}
	
	return YES;	
}

-(void) dealloc
{
	[super dealloc];
}


@end
