//
//  Level.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Level.h"
#import "GameScene.h"
#import "Team.h"
#import "Ship.h"


@implementation ALevel

static NSDictionary* levelDatabase = nil;

+(void) loadLevelDatabase:(NSString*)filename
{
	if(levelDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	levelDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
															  format:&format
													errorDescription:&error];
	[levelDatabase retain];
}


+(ALevel*) levelWithProperties:(NSDictionary*)properties
{
	return nil;
}

+(ALevel*) levelWithName:(NSString*)name
{
	NSDictionary* levelProperties = [levelDatabase objectForKey:name];
	if(levelProperties!=nil)
	{
		NSString* levelClassName = [levelProperties objectForKey:@"class"];
		if(levelClassName==nil)
			levelClassName = @"GameLevel";

		Class levelClass = NSClassFromString(levelClassName);
		if(levelClass!=nil)
		{
			return [levelClass levelWithProperties: levelProperties];
		}
	}
	return nil;	
}

-(AGameScene*) loadGameScene
{
	return nil;
}

-(ATeam*) loadTeam1
{
	return nil;
}

-(ATeam*) loadTeam2
{
	return nil;
}

-(NSDictionary*) team1Properties
{
	return nil;
}

-(NSDictionary*) team2Properties
{
	return nil;
}

-(AGameScene*) loadUpgradeScene
{
	return nil;
}

-(AShip*) loadUpgradeShip
{
	return nil;
}

@end




@implementation GameLevel


+(GameLevel*) levelWithProperties:(NSDictionary*)properties
{
	return [[[GameLevel alloc] initWithProperties:properties] autorelease];
}

-(GameLevel*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		gameSceneName = [[properties objectForKey:@"scene"] retain];
		team1Name = [[properties objectForKey:@"team1"] retain];
		team2Name = [[properties objectForKey:@"team2"] retain];

		NSDictionary* upgradeProp = [properties objectForKey:@"upgrade"];
		upgradeSceneName = [[upgradeProp objectForKey:@"scene"] retain];
		upgradeShipName = [[upgradeProp objectForKey:@"ship"] retain];
		upgradeWeapons = [[upgradeProp objectForKey:@"weapons"] retain];
		
		speachesProp = [[properties objectForKey:@"speaches"] retain];
		
		return self;
	}
	return nil;
}

-(AGameScene*) loadGameScene
{
	return [AGameScene sceneWithName:gameSceneName];
}

-(ATeam*) loadTeam1
{
	return [ATeam teamWithName:team1Name];
}

-(ATeam*) loadTeam2
{
	return [ATeam teamWithName:team2Name];
}

-(NSDictionary*) team1Properties
{
	return [ATeam propertiesWithTeamName:team1Name];
}

-(NSDictionary*) team2Properties
{
	return [ATeam propertiesWithTeamName:team2Name];
}

-(NSDictionary*) getSpeachesProp
{
	return speachesProp;
}

-(AGameScene*) loadUpgradeScene
{
	return [AGameScene sceneWithName:upgradeSceneName];
}

-(AShip*) loadUpgradeShip
{
	return [AShip shipWithName:upgradeShipName];
}



-(void) dealloc
{
	[gameSceneName release];
	[team1Name release];
	[team2Name release];
	[upgradeSceneName release];
	[upgradeShipName release];
	[upgradeWeapons release];
	[super dealloc];
}

@end




