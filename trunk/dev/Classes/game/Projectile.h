//
//  Projectile.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "PhysicsSystem.h"

@class ASkin;
@class AShape;

@interface AProjectile : CocosNode <PhysicsProtocol>
{
	AShape* shape;	
	int collisionCount;
	int damage;
	int defaultDamage;	
	ASkin* skin;
	BOOL gotDown;
}

@property (nonatomic, retain) AShape* shape;

+(void) loadProjectileDatabase:(NSString*)filename;
+(AProjectile*) projectileWithName:(NSString*)name;

-(void) fireFromPoint:(CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power;
-(void) hitFromPoint:(CGPoint)hp; 
@end


@interface WarProjectile : AProjectile 
{
}

+(WarProjectile*) projectileWithProperties:(NSDictionary*)properties;
-(WarProjectile*) initWithProperties:(NSDictionary*)properties;
-(WarProjectile*) initWithSkin: (ASkin*)s;
-(void) fireFromPoint:(CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power;

@end

@interface BowProjectile : AProjectile 
{
}

+(BowProjectile*) projectileWithProperties:(NSDictionary*)properties;
-(BowProjectile*) initWithProperties:(NSDictionary*)properties;
-(BowProjectile*) initWithSkin: (ASkin*)s;
-(void) fireFromPoint:(CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power;
-(void) hitFromPoint:(CGPoint)hp; 
@end

@interface BowProjectileNatalia : BowProjectile 
{
}
+(BowProjectileNatalia*) projectileWithProperties:(NSDictionary*)properties;
-(BowProjectileNatalia*) initWithProperties:(NSDictionary*)properties;
-(BowProjectileNatalia*) initWithSkin: (ASkin*)s;
-(void) hitFromPoint:(CGPoint)hp; 
@end

@interface RocketProjectile : AProjectile 
{
}

+(RocketProjectile*) projectileWithProperties:(NSDictionary*)properties;
-(RocketProjectile*) initWithProperties:(NSDictionary*)properties;
-(RocketProjectile*) initWithSkin: (ASkin*)s;
-(void) hitFromPoint:(CGPoint)hp; 
@end

@interface KnifeProjectile : AProjectile 
{
}

+(KnifeProjectile*) projectileWithProperties:(NSDictionary*)properties;
-(KnifeProjectile*) initWithProperties:(NSDictionary*)properties;
-(KnifeProjectile*) initWithSkin: (ASkin*)s;
-(void) hitFromPoint:(CGPoint)hp; 
@end


