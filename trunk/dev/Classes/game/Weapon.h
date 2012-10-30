//
//  Weapon.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "Hero.h"

@class AProjectile;

@interface AWeapon : CocosNode 
{
	int projectileCount;
	NSString* wname;
}

@property (nonatomic) int projectileCount;
@property (nonatomic, assign) NSString* wname;

+(void) loadWeaponDatabase:(NSString*)filename;
+(AWeapon*) weaponWithName:(NSString*)name;

-(void) fireFromPoint: (CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power;
-(NSString*) getWeaponName;
-(void) setNewWepon:(AHero*)hero;
@end


@interface WarWeapon: AWeapon 
{
	AProjectile* projectile;
	CGPoint firePointOffset;
}
+(WarWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name;
-(WarWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name;
-(id) initWithProjectile:(AProjectile*) projectile;

@end


@interface  BowWeapon: WarWeapon 
{

}
+(BowWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name;
-(BowWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name;
//-(id) initWithProjectile:(AProjectile*) projectile;
@end

@interface  BowWeaponNatalia: WarWeapon 
{
	
}
+(BowWeaponNatalia*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name;
-(BowWeaponNatalia*) initWithProperties:(NSDictionary*)properties name:(NSString*)name;
//-(id) initWithProjectile:(AProjectile*) projectile;
@end

@interface  RocketWeapon: WarWeapon 
{
	
}
+(RocketWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name;
-(RocketWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name;
//-(id) initWithProjectile:(AProjectile*) projectile;
@end

@interface  BallWeapon: WarWeapon 
{
	
}
+(BallWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name;
-(BallWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name;
//-(id) initWithProjectile:(AProjectile*) projectile;
@end