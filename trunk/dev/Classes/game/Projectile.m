//
//  Projectile.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameSystem.h"
#import "PhysicsSystem.h"
#import "Projectile.h"
#import "Skin.h"
#import "Ship.h"
#import "Shape.h"
#import "Hero.h"
#import "GameScene.h"
#import "Effect.h"
#import "Team.h"

#import "PhysicsSystem.h"
#define POWER_ 10

@implementation AProjectile

@synthesize shape;


static NSDictionary* projectileDatabase = nil;

+(void) loadProjectileDatabase:(NSString*)filename
{
	if(projectileDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"projectiles" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	projectileDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
															  format:&format
													errorDescription:&error];
	[projectileDatabase retain];
}


+(AProjectile*) projectileWithProperties:(NSDictionary*)properties
{
	return nil;
}

+(AProjectile*) projectileWithName:(NSString*)name
{
	NSDictionary* projectileProperties = [projectileDatabase objectForKey:name];
	if(projectileProperties!=nil)
	{
		NSString* projectileClassName = [projectileProperties objectForKey:@"class"];
		if(projectileClassName!=nil)
		{
			Class projectileClass = NSClassFromString(projectileClassName);
			if(projectileClass!=nil)
			{
				return [projectileClass projectileWithProperties: projectileProperties];
			}
		}			
	}
	return nil;	
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	self.position = pos;
	self.rotation = angle;
}


-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj
{
	if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{		
		AHero* hero = (AHero*)obj;
		
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		ATeam* nativeTeam = [hero nativeTeam];
		if(activeTeam == nativeTeam)
			return 0;
	}
	
	collisionCount++;
	if(collisionCount>2)
	{
		return 0;
	}
	
	damage = damage*2/3;

    if( [(NSObject*)obj isKindOfClass:[AShip class]])
    {
        [(AShip*)obj hitShip];
		return 1;
	}
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		AHero* hero = (AHero*)obj;
		
		if(hero.damege == YES)
			return 0;
		
		[hero damage:damage];
		[hero showLifeIndicator];
	}
	return 1;
}

-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point
{
	if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{		
		AHero* hero = (AHero*)obj;
		
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		ATeam* nativeTeam = [hero nativeTeam];
		if(activeTeam == nativeTeam)
			return 0;
	}
	
	collisionCount++;
	if(collisionCount>2)
	{
		return 0;
	}
	
	damage = damage*2/3;

	if( [(NSObject*)obj isKindOfClass:[AShip class]])  
	{
        [(AShip*)obj hitShip];
		return 1;
	}
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{		
		AHero* hero = (AHero*)obj;
		
		if(hero.damege == YES)
			return 0;

		[hero damage:damage];
		[self hitFromPoint:point];
		[hero showLifeIndicator];
	}
	return 1;
}


-(void) fireFromPoint: (CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power
{
}

-(void) hitFromPoint:(CGPoint)hp 
{
	
	ASkin* hitSkin = [ASkin skinWithName:@"BallHitSkin"];
	AnEffect* hitEffect = [[VisualEffect alloc] initWithSkin:hitSkin duration:0.32];
	
	[[GameSystem sharedGame].gameScene addEffect:hitEffect];
	hitEffect.position = hp;		
}

-(void)dealloc
{
	[shape physicsUnregister];	
	[shape release];
	[super dealloc];
}

@end


@implementation WarProjectile


+(WarProjectile*) projectileWithProperties:(NSDictionary*)properties
{
	return [[[WarProjectile alloc] initWithProperties:properties] autorelease];
}

-(WarProjectile*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* skinName = [properties objectForKey:@"skin"];
		NSString* shapeName = [properties objectForKey:@"shape"];
		defaultDamage = [[properties objectForKey:@"damage"] intValue];
		
		skin = [ASkin skinWithName:skinName];
		[self addChild:[skin node]];
		self.shape = [AShape shapeWithName:shapeName];
		
		return self;
	}
	return nil;
}


-(WarProjectile*) initWithSkin: (ASkin*)s
{
	if([super init])
	{
		skin = s;
		[skin addToParent:self z:0];
		
	
		return self;
	}
	return nil;
}

-(void) fireFromPoint:(CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power
{
	[[[GameSystem sharedGame] gameScene] addProjectile:self];
	self.position = fp;
	
	ASkin* fireSkin = [ASkin skinWithName:@"GunSplashesSkin"];
	AnEffect* fireEffect = [[VisualEffect alloc] initWithSkin:fireSkin duration:0.32];

	
	//if ([[GameSystem sharedGame] activeTeam].teamSide ==  kRightSideTeam)
		//[fireSkin node].scaleX = -1;

	fireSkin.angle = 30 - angle;
		
	[[GameSystem sharedGame].gameScene addEffect:fireEffect];
	fireEffect.position = fp;		
	
	[shape applyVelocity:cpvmult(cpv(cos(angle*3.14/180), sin(angle*3.14/180)), 10+power*POWER_)];
	[shape applyAngularVelocity:10.0];

	[shape physicsRegister:self];
	
	collisionCount = 0;
	damage = defaultDamage;
	gotDown = NO;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	[super updatePosition:pos angle:angle];
	
	CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
	
	if(pos.x>240 && pos.x <= sceneSize.width-240)
	{
		[[GameSystem sharedGame].gameScene scrollTo: pos.x-240];
	}
	
	if(pos.y<30 && !gotDown)
	{
		ASkin* splashesSkin = [ASkin skinWithName:@"SeaSplashesSkin"];
		AnEffect* splashesEffect = [[VisualEffect alloc] initWithSkin:splashesSkin duration:0.125];
		[[GameSystem sharedGame].gameScene addEffect:splashesEffect];
		splashesEffect.position = pos;		
		gotDown = YES;
		
	}
	
	int sceneWidth = sceneSize.width;
	if(pos.x<-350 || pos.x>sceneWidth+350 || pos.y<-100)
	{
		[self.shape physicsUnregister];
		[[GameSystem sharedGame].gameScene removeProjectile:self];
		[[GameSystem sharedGame] strikeDidFinish];
	}
	
	/*if(pos.y<-500)
	 {
	 [self.shape physicsUnregister];
	 [[GameSystem sharedGame].gameScene removeProjectile:self];
	 [[GameSystem sharedGame] strikeDidFinish];
	 }*/
	
}

#if DEBUG_SHAPES
-(void) setShape:(AShape*)s
{
	[super setShape:s];
	if(s!=nil)
	{
		[self addChild:s z:100];
	}
}
#endif

@end


////////////////////////////////////////////////////////////////////////
@implementation BowProjectile


+(BowProjectile*) projectileWithProperties:(NSDictionary*)properties
{
	return [[[BowProjectile alloc] initWithProperties:properties] autorelease];
}

-(BowProjectile*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* skinName = [properties objectForKey:@"skin"];
		NSString* shapeName = [properties objectForKey:@"shape"];
		defaultDamage = [[properties objectForKey:@"damage"] intValue];
		
		skin = [ASkin skinWithName:skinName];
		[self addChild:[skin node]];
		self.shape = [AShape shapeWithName:shapeName];
		
		return self;
	}
	return nil;
}


-(BowProjectile*) initWithSkin: (ASkin*)s
{
	if([super init])
	{
		skin = s;
		[skin addToParent:self z:0];
		
		
		return self;
	}
	return nil;
}

-(void) fireFromPoint:(CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power
{
	[[[GameSystem sharedGame] gameScene] addProjectile:self];
	self.position = fp;
	self.rotation = -angle;
	cpBody *body = [((PhysicShape*)self.shape) body];	
	cpBodySetAngle(body, -angle*3.14/180);
	
	[shape applyVelocity:cpvmult(cpv(cos(angle*3.14/180), sin(angle*3.14/180)), 10+power*POWER_)];		
	[shape applyAngularVelocity:0.4];
	
	[shape physicsRegister:self];
	
	collisionCount = 0;
	damage = defaultDamage;
	gotDown = NO;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	[super updatePosition:pos angle:-angle];
	
	CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
	
	if(pos.x>240 && pos.x <= sceneSize.width-240)
	{
		[[GameSystem sharedGame].gameScene scrollTo: pos.x-240];
	}
	
	if(pos.y<30 && !gotDown)
	{
		ASkin* splashesSkin = [ASkin skinWithName:@"SeaSplashesSkin"];
		AnEffect* splashesEffect = [[VisualEffect alloc] initWithSkin:splashesSkin duration:0.125];
		[[GameSystem sharedGame].gameScene addEffect:splashesEffect];
		splashesEffect.position = pos;		
		gotDown = YES;
		
	}
	
	int sceneWidth = sceneSize.width;
	if(pos.x<-350 || pos.x>sceneWidth+350 || pos.y<-100)
	{
		[self.shape physicsUnregister];
		[[GameSystem sharedGame].gameScene removeProjectile:self];
		[[GameSystem sharedGame] strikeDidFinish];
	}
	
	/*if(pos.y<-500)
	 {
	 [self.shape physicsUnregister];
	 [[GameSystem sharedGame].gameScene removeProjectile:self];
	 [[GameSystem sharedGame] strikeDidFinish];
	 }*/
	
}

-(void) hitFromPoint:(CGPoint)hp 
{
	
	ASkin* hitSkin = [ASkin skinWithName:@"BallHitSkin"];
	AnEffect* hitEffect = [[VisualEffect alloc] initWithSkin:hitSkin duration:0.32];
	
	[[GameSystem sharedGame].gameScene addEffect:hitEffect];
	hitEffect.position = hp;		
}

#if DEBUG_SHAPES
-(void) setShape:(AShape*)s
{
	[super setShape:s];
	if(s!=nil)
	{
		[self addChild:s z:100];
	}
}
#endif

@end


////////////////////////////////////////////////////////////////////////
@implementation BowProjectileNatalia

+(BowProjectileNatalia*) projectileWithProperties:(NSDictionary*)properties
{
	return [[[BowProjectileNatalia alloc] initWithProperties:properties] autorelease];
}

-(BowProjectileNatalia*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* skinName = [properties objectForKey:@"skin"];
		NSString* shapeName = [properties objectForKey:@"shape"];
		defaultDamage = [[properties objectForKey:@"damage"] intValue];
		
		skin = [ASkin skinWithName:skinName];
		[self addChild:[skin node]];
		self.shape = [AShape shapeWithName:shapeName];
		
		return self;
	}
	return nil;
}


-(BowProjectileNatalia*) initWithSkin: (ASkin*)s
{
	if([super init])
	{
		skin = s;
		[skin addToParent:self z:0];
		
		
		return self;
	}
	return nil;
}

-(void) hitFromPoint:(CGPoint)hp 
{
	
	ASkin* hitSkin = [ASkin skinWithName:@"BowHitSkinNatalia"];
	AnEffect* hitEffect = [[VisualEffect alloc] initWithSkin:hitSkin duration:0.32];
	
	[[GameSystem sharedGame].gameScene addEffect:hitEffect];
	hitEffect.position = hp;		
}

@end


////////////////////////////////////////////////////////////////////////
@implementation RocketProjectile

+(RocketProjectile*) projectileWithProperties:(NSDictionary*)properties
{
	return [[[RocketProjectile alloc] initWithProperties:properties] autorelease];
}

-(RocketProjectile*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* skinName = [properties objectForKey:@"skin"];
		NSString* shapeName = [properties objectForKey:@"shape"];
		defaultDamage = [[properties objectForKey:@"damage"] intValue];
		
		skin = [[ASkin skinWithName:skinName] retain];
		[self addChild:[skin node]];
		self.shape = [AShape shapeWithName:shapeName];
		
		return self;
	}
	return nil;
}


-(RocketProjectile*) initWithSkin: (ASkin*)s
{
	if([super init])
	{
		skin = s;
		[skin addToParent:self z:0];
		
		
		return self;
	}
	return nil;
}

-(void) fireFromPoint:(CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power
{
	[skin setVisibility:YES];
	
	[[[GameSystem sharedGame] gameScene] addProjectile:self];
	self.position = fp;
	
	ASkin* fireSkin = [ASkin skinWithName:@"GunSplashesSkin"];
	AnEffect* fireEffect = [[VisualEffect alloc] initWithSkin:fireSkin duration:0.32];
	
	
	//if ([[GameSystem sharedGame] activeTeam].teamSide ==  kRightSideTeam)
	//[fireSkin node].scaleX = -1;
	
	fireSkin.angle = 30 - angle;
	
	[[GameSystem sharedGame].gameScene addEffect:fireEffect];
	fireEffect.position = fp;		
	
	[shape applyVelocity:cpvmult(cpv(cos(angle*3.14/180), sin(angle*3.14/180)), 10+power*POWER_)];
	[shape applyAngularVelocity:0.0];
	
	[shape physicsRegister:self];
	
	collisionCount = 0;
	damage = defaultDamage;
	gotDown = NO;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	[super updatePosition:pos angle:angle];
	
	CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
	
	if(pos.x>240 && pos.x <= sceneSize.width-240)
	{
		[[GameSystem sharedGame].gameScene scrollTo: pos.x-240];
	}
	
	if(pos.y<30 && !gotDown)
	{
		if(collisionCount==0)
		{
			ASkin* splashesSkin = [ASkin skinWithName:@"SeaSplashesSkin"];
			AnEffect* splashesEffect = [[VisualEffect alloc] initWithSkin:splashesSkin duration:0.125];
			[[GameSystem sharedGame].gameScene addEffect:splashesEffect];
			splashesEffect.position = pos;
		}		
		gotDown = YES;
		
	}
	
	int sceneWidth = sceneSize.width;
	if(pos.x<-350 || pos.x>sceneWidth+350 || pos.y<-100)
	{
		[self.shape physicsUnregister];
		[[GameSystem sharedGame].gameScene removeProjectile:self];
		[[GameSystem sharedGame] strikeDidFinish];
	}
	
	/*if(pos.y<-500)
	{
		[self.shape physicsUnregister];
		[[GameSystem sharedGame].gameScene removeProjectile:self];
		[[GameSystem sharedGame] strikeDidFinish];
	}*/
}

-(void) hitFromPoint:(CGPoint)hp 
{
	
	ASkin* hitSkin = [ASkin skinWithName:@"RocketHitSkin"];
	AnEffect* hitEffect = [[VisualEffect alloc] initWithSkin:hitSkin duration:0.32];
	
	[[GameSystem sharedGame].gameScene addEffect:hitEffect];
	hitEffect.position = hp;	
	
	[skin setVisibility:NO];
}


/*-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj
{
	if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{		
		AHero* hero = (AHero*)obj;
		
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		ATeam* nativeTeam = [hero nativeTeam];
		if(activeTeam == nativeTeam)
			return 0;
	}
	
	collisionCount++;
	if(collisionCount>1)
	{
		return 0;
	}
	
	damage = damage*2/3;

	if( [(NSObject*)obj isKindOfClass:[AShip class]] )
	{
	}
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		AHero* hero = (AHero*)obj;
		
		if(hero.damege == YES)
			return 0;
		
		[hero damage:damage];
		[hero showLifeIndicator];
	}
	return 1;
}*/

/*-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point
{
	if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{		
		AHero* hero = (AHero*)obj;
		
		ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
		ATeam* nativeTeam = [hero nativeTeam];
		if(activeTeam == nativeTeam)
			return 0;
	}
	
	collisionCount++;
	if(collisionCount>1)
	{
		return 0;
	}
	
	damage = damage*2/3;

	if( [(NSObject*)obj isKindOfClass:[AShip class]] )
	{
		[self hitFromPoint:point];
	}
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		AHero* hero = (AHero*)obj;
		[hero damage:damage];
		[hero showLifeIndicator];
		[self hitFromPoint:point];
	}
	return 1;
}*/

#if DEBUG_SHAPES
-(void) setShape:(AShape*)s
{
	[super setShape:s];
	if(s!=nil)
	{
		[self addChild:s z:100];
	}
}
#endif

@end




////////////////////////////////////////////////////////////////////////
@implementation KnifeProjectile


+(KnifeProjectile*) projectileWithProperties:(NSDictionary*)properties
{
	return [[[KnifeProjectile alloc] initWithProperties:properties] autorelease];
}

-(KnifeProjectile*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* skinName = [properties objectForKey:@"skin"];
		NSString* shapeName = [properties objectForKey:@"shape"];
		defaultDamage = [[properties objectForKey:@"damage"] intValue];
		
		skin = [ASkin skinWithName:skinName];
		[self addChild:[skin node]];
		self.shape = [AShape shapeWithName:shapeName];
		
		return self;
	}
	return nil;
}


-(KnifeProjectile*) initWithSkin: (ASkin*)s
{
	if([super init])
	{
		skin = s;
		[skin addToParent:self z:0];
		
		
		return self;
	}
	return nil;
}

-(void) fireFromPoint:(CGPoint)fp angle:(CGFloat)angle power:(CGFloat)power
{
	AHero* activeHero = [[GameSystem sharedGame] getActiveHero];
    [activeHero setFireMode];
	
	[[[GameSystem sharedGame] gameScene] addProjectile:self];
	self.position = fp;
	self.rotation = -angle;
	cpBody *body = [((PhysicShape*)self.shape) body];	
	cpBodySetAngle(body, -angle*3.14/180);
	
	[shape applyVelocity:cpvmult(cpv(cos(angle*3.14/180), sin(angle*3.14/180)), 10+power*POWER_)];		
	[shape applyAngularVelocity:-0.6];
	
	[shape physicsRegister:self];
	
	collisionCount = 0;
	damage = defaultDamage;
	gotDown = NO;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	[super updatePosition:pos angle:-angle];
	
	CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
	
	if(pos.x>240 && pos.x <= sceneSize.width-240)
	{
		[[GameSystem sharedGame].gameScene scrollTo: pos.x-240];
	}
	
	if(pos.y<30 && !gotDown)
	{
		ASkin* splashesSkin = [ASkin skinWithName:@"SeaSplashesSkin"];
		AnEffect* splashesEffect = [[VisualEffect alloc] initWithSkin:splashesSkin duration:0.125];
		[[GameSystem sharedGame].gameScene addEffect:splashesEffect];
		splashesEffect.position = pos;		
		gotDown = YES;
		
	}
	
	int sceneWidth = sceneSize.width;
	if(pos.x<-350 || pos.x>sceneWidth+350 || pos.y<-100)
	{
		[self.shape physicsUnregister];
		[[GameSystem sharedGame].gameScene removeProjectile:self];
		[[GameSystem sharedGame] strikeDidFinish];
	}
	
	/*if(pos.y<-500)
	 {
	 [self.shape physicsUnregister];
	 [[GameSystem sharedGame].gameScene removeProjectile:self];
	 [[GameSystem sharedGame] strikeDidFinish];
	 }*/
	
}

-(void) hitFromPoint:(CGPoint)hp 
{
	
	ASkin* hitSkin = [ASkin skinWithName:@"BallHitSkin"];
	AnEffect* hitEffect = [[VisualEffect alloc] initWithSkin:hitSkin duration:0.32];
	
	[[GameSystem sharedGame].gameScene addEffect:hitEffect];
	hitEffect.position = hp;		
}

#if DEBUG_SHAPES
-(void) setShape:(AShape*)s
{
	[super setShape:s];
	if(s!=nil)
	{
		[self addChild:s z:100];
	}
}
#endif

@end

