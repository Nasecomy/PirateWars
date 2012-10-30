//
//  Weapon.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"
#import "Projectile.h"
#import "GameSystem.h"
#import "GameScene.h"
#import "Shape.h"
#import "PhysicsSystem.h"

@implementation AWeapon

@synthesize projectileCount;
@synthesize wname;

static NSDictionary* weaponDatabase = nil;

+(void) loadWeaponDatabase:(NSString*)filename
{
	if(weaponDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"weapons" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	weaponDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
															  format:&format
													errorDescription:&error];
	[weaponDatabase retain];
}


+(AWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	return nil;
}

+(AWeapon*) weaponWithName:(NSString*)name
{
	NSDictionary* weaponProperties = [weaponDatabase objectForKey:name];
	if(weaponProperties!=nil)
	{
		NSString* weaponClassName = [weaponProperties objectForKey:@"class"];
		if(weaponClassName!=nil)
		{
			Class weaponClass = NSClassFromString(weaponClassName);
			if(weaponClass!=nil)
			{
				return [weaponClass weaponWithProperties: weaponProperties name:name];
			}
		}			
	}
	return nil;	
}

-(void) fireFromPoint: (CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power
{
}

-(NSString*) getWeaponName
{
		return nil;	
}

-(void) setNewWepon:(AHero*)hero
{
		return ;
}

@end



@implementation WarWeapon


+(WarWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	return [[[WarWeapon alloc] initWithProperties:properties name:name] autorelease];
}

-(WarWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	if([super init])
	{
		wname = name;
		NSString* projectileName = [properties objectForKey:@"projectile"];
		CGFloat fpx = [[properties objectForKey:@"fpx"] floatValue];
		CGFloat fpy = [[properties objectForKey:@"fpy"] floatValue];
		
		projectile = [[AProjectile projectileWithName:projectileName] retain];
		firePointOffset = CGPointMake(fpx, fpy);		

		return self;
	}
	return nil;
}

-(NSString*) getWeaponName
{
	return wname;
}

-(id) initWithProjectile:(AProjectile*) p
{
	if([super init])
	{
		projectile = p;
		[projectile retain];
		
		return self;
	}
	return nil;
}

-(void) fireFromPoint: (CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power
{
	[projectile fireFromPoint:fp angle:angle power:power];
}

-(void) dealloc
{
	[projectile release];
	[super dealloc];
}


@end


@implementation BowWeapon

+(BowWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	return [[[BowWeapon alloc] initWithProperties:properties name:name] autorelease];
}

-(BowWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	if( [super initWithProperties:properties name:name]!=nil )
	{		
		return self;
	}
	return nil;
}

-(void) setNewWepon:(AHero*)hero
{
	[hero setBowWeapon];
}

@end



@implementation BowWeaponNatalia

+(BowWeaponNatalia*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	return [[[BowWeaponNatalia alloc] initWithProperties:properties name:name] autorelease];
}

-(BowWeaponNatalia*) initWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	if( [super initWithProperties:properties name:name]!=nil )
	{		
		return self;
	}
	return nil;
}

-(void) setNewWepon:(AHero*)hero
{
}

@end


@implementation RocketWeapon

+(RocketWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	return [[[RocketWeapon alloc] initWithProperties:properties name:name] autorelease];
}

-(RocketWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	if( [super initWithProperties:properties name:name]!=nil )
	{		
		return self;
	}
	return nil;
}

-(void) setNewWepon:(AHero*)hero
{
	[hero setRocketWeapon];
}

@end


@implementation BallWeapon

+(BallWeapon*) weaponWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	return [[[BallWeapon alloc] initWithProperties:properties name:name] autorelease];
}

-(BallWeapon*) initWithProperties:(NSDictionary*)properties name:(NSString*)name 
{
	if( [super initWithProperties:properties name:name]!=nil )
	{		
		return self;
	}
	return nil;
}


-(void) setNewWepon:(AHero*)hero
{
	[hero setBallWeapon];
}

@end


