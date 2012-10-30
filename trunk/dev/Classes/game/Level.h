//
//  Level.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGameScene;
@class ATeam;
@class AShip;
@class ASkin;

@interface ALevel : NSObject 
{

}

+(void) loadLevelDatabase:(NSString*)filename;
+(ALevel*) levelWithName:(NSString*)name;

-(AGameScene*) loadGameScene;
-(ATeam*) loadTeam1;
-(ATeam*) loadTeam2;
-(NSDictionary*) team1Properties;
-(NSDictionary*) team2Properties;

-(AGameScene*) loadUpgradeScene;
-(AShip*) loadUpgradeShip;

@end


@interface GameLevel : ALevel 
{
	NSString* gameSceneName;
	NSString* team1Name;
	NSString* team2Name;
	NSString* upgradeSceneName;
	NSString* upgradeShipName;
	NSArray* upgradeWeapons;
	NSDictionary* speachesProp;
}

+(GameLevel*) levelWithProperties:(NSDictionary*)properties;
-(GameLevel*) initWithProperties:(NSDictionary*)properties;
-(NSDictionary*) getSpeachesProp;
@end
