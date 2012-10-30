//
//  ATeam.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum eTeamSideType 
{
	kLeftSideTeam,
	kRightSideTeam,	
}TeamSideType;

/*typedef enum eTeamMode 
{
	baseMode,
	moveMode,
	illMode,
	bodyMode,
	lostMode,
	idleMode,
	speachMode,	
}TeamMode;*/

@class AShip;
@class AHero;
@class AnAimer;
@class AWeapon;

@interface ATeam : NSObject
{
	TeamSideType teamSide;
	NSString* name;
	int credits;
	AHero* activeHero;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic, readonly) TeamSideType teamSide;
@property (nonatomic, assign) int credits;

+(void) loadTeamDatabase:(NSString*)filename;
+(ATeam*) teamWithName:(NSString*)name;
+(ATeam*) teamWithProperties:(NSDictionary*)properties;
+(NSDictionary*) propertiesWithTeamName:(NSString*)name;
-(NSDictionary*) getTeamProperties;

-(void) physicsRegister;
-(void) physicsUnregister;

-(BOOL) isLost;
-(AShip*) getShip;
-(void) setShip:(AShip*)ship;
-(AHero*) getActiveHero; 
-(NSString*) getActiveWeaponName;

-(void) activate;
-(void) activateLastScene;
-(void) deactivate;
-(void) fire;

-(void) removeHero:(AHero*)hero;

-(void) setHeroHelthArray:(NSArray*)helthArray;
-(NSArray*) getHeroHelthArray;

-(void) selectWeapon:(NSString*)weaponName;

-(int) getProjectileCountForWeapon:(NSString*)weaponName;
-(void) setProjectileCountForWeapon:(NSString*)weaponName count:(int)count;

-(void) putHeroesToShip:(AShip*)ship heroes:(NSMutableArray*)heroesArray;
-(void) makeHeroesLost;
-(AHero*) getHero:(int)iIndex;
-(void) setActiveHero;
//-(AWeapon*) getWeaponByName:(NSString*)weaponName;
-(void) resetDamage;
@end


@interface WarTeam: ATeam
{
	NSMutableDictionary* weapons1;
	NSString* activeWeapon;
	AShip* ship;
	AShip* upgradedShip;
	NSMutableArray* heroes;
	AnAimer* aimer;
}

+(WarTeam*) teamWithProperties:(NSDictionary*)properties;
-(WarTeam*) initWithProperties:(NSDictionary*)properties;
//-(void) addHero:(AHero*)hero;
-(void) addHeroWithName:(NSString*)name;

@end


