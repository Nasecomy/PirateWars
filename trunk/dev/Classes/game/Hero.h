//
//  Hero.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "PhysicsSystem.h"
#import "Effect.h"

@class ASkin;
@class AShape;
@class ATeam;
@class LifeIndicator;
@class AWeapon;

typedef enum eHeroMode
 {
	 baseMode,
	 moveMode,
	 illMode,
	 bodyMode,
	 lostMode,
	 idleMode,
	 speachMode,
	 bowMode,
	 rocketMode,
	 ballMode,
 }HeroMode;


@interface AHero : CocosNode <PhysicsProtocol>  
{
	AShape* shape;
	int helth;
	ATeam* nativeTeam;
	BOOL hasWarMode;
	AWeapon* weapon;
	NSString* name;
	HeroMode heroMode;
	int shipNum;
	BOOL damege;	
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) AShape* shape;
@property (nonatomic, assign) ATeam* nativeTeam;
@property (nonatomic, assign) BOOL hasWarMode;
@property (nonatomic, assign) int helth;
@property (nonatomic, assign) int shipNum;
@property (nonatomic) BOOL damege;

+(void) loadHeroDatabase:(NSString*)filename;
+(AHero*) heroWithProperties:(NSDictionary*)properties;
+(AHero*) heroWithName:(NSString*)name;

-(void) setWarMode;
-(void) setPeaceMode;
-(void) setIllMode;
-(void) setMoveMode;
-(void) setLostMode;
-(void) setIdleMode;
-(void) showLifeIndicator;
-(void) hideLifeIndicator;
-(void) setSpeachMode;
-(void) setBaseBody;
-(void) makeSkinsUnvisible;

-(void) setWeaponAngle: (CGFloat) angle;
-(CGFloat) getWeaponAngle;
-(CGPoint) getWeaponOffset;

-(void) damage:(int)damage;

-(void) saveBerthPos;
-(void) resetBerthPos;
-(AWeapon*) getActiveWeapon;
-(void) setActiveWeapon:(AWeapon*)newWeapon;
-(void) addHands;
-(void) setFireMode;
-(CGPoint) getHeroPosition;
//-(void) setWeaponMode:(WeaponMode)newWeaponMode;
-(void) setBowWeapon;
-(void) setRocketWeapon;
-(void) setBallWeapon;
-(void) MoveToBasePos:(CGPoint)pos;
@end


@interface WarHero : AHero
{
	ASkin* baseSkin;
	ASkin* moveSkin;
	ASkin* illSkin;
	ASkin* bodySkin;
	ASkin* leftHandSkin;
	ASkin* rightHandSkin;
	ASkin* lostSkin;	
	ASkin* mouthSkin;
	//ASkin* idleSkin;
	CGPoint lhandAnchor;
	CGPoint rhandAnchor;
	CGPoint berthPos;
	LifeIndicator* lifeIndicator;	

}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(WarHero*)initWithProperties:(NSDictionary*)properties;

//-(WarHero*)initWithSkin:(ASkin*)base move:(ASkin*)move ill:(ASkin*)ill body:(ASkin*)body leftHandSkin:(ASkin*)left rightHandSkin:(ASkin*) right lostSkin:(ASkin*)lost
//			   idleSkin:(ASkin*)idle speachSkin:(ASkin*)speach mouthSkin:(ASkin*)mouth baseName:(NSString*)baseName;

//-(void) setTimerForIdleSkin:(int)delta;
//-(void) setTimerForPeaceSkin:(int)delta;


@property (nonatomic, assign) CGPoint lhandAnchor;
@property (nonatomic, assign) CGPoint rhandAnchor;

@end




@interface PrincessHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(PrincessHero*)initWithProperties:(NSDictionary*)properties;


@end



@interface BillHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(BillHero*)initWithProperties:(NSDictionary*)properties;

@end


@interface MunikHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(MunikHero*)initWithProperties:(NSDictionary*)properties;

@end

@interface LukHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(LukHero*)initWithProperties:(NSDictionary*)properties;

@end

@interface KarlHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(KarlHero*)initWithProperties:(NSDictionary*)properties;

@end

@interface MargoHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(MargoHero*)initWithProperties:(NSDictionary*)properties;

@end


@interface EnrikeoHero : WarHero
{
	ASkin* leftHandCanon;
	ASkin* rightHandCanon;
	CGPoint lhandCanonAnchor;
	CGPoint rhandCanonAnchor;
	ASkin* leftHandBow;
	ASkin* rightHandBow;
	CGPoint lhandBowAnchor;
	CGPoint rhandBowAnchor;
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(EnrikeoHero*)initWithProperties:(NSDictionary*)properties;

@end


@interface DandyHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(DandyHero*)initWithProperties:(NSDictionary*)properties;

@end


@interface SolderHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(SolderHero*)initWithProperties:(NSDictionary*)properties;

@end


@interface HelperHero : WarHero
{
	
}

+(AHero*) heroWithProperties:(NSDictionary*)properties;
-(HelperHero*)initWithProperties:(NSDictionary*)properties;

@end


