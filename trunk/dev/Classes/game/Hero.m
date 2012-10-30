//
//  Hero.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Hero.h"
#import "Skin.h"
#import "Shape.h"
#import "Team.h"
#import "Projectile.h"
#import "GameScene.h"
#import "GameSystem.h"
#import "LifeIndicator.h"
#import "Effect.h"
#import "Weapon.h"
#import "objcex.h"

@implementation AHero

@synthesize shape;
@synthesize nativeTeam;
@synthesize hasWarMode;
@synthesize helth;
@synthesize name;
@synthesize shipNum;
@synthesize damege;

static NSDictionary* heroDatabase = nil;

+(void) loadHeroDatabase:(NSString*)filename
{
	if(heroDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"heroes" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	heroDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
															  format:&format
													errorDescription:&error];
	[heroDatabase retain];
}


+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return nil;
}

+(AHero*) heroWithName:(NSString*)name
{
	NSDictionary* heroProperties = [heroDatabase objectForKey:name];
	if(heroProperties!=nil)
	{
		NSString* heroClassName = [heroProperties objectForKey:@"class"];
		if(heroClassName!=nil)
		{
			Class heroClass = NSClassFromString(heroClassName);
			if(heroClass!=nil)
			{
				AHero* h = [heroClass heroWithProperties: heroProperties];
				h.name = name;
				return h;
			}
		}			
	}
	return nil;	
}

-(void) setWeaponAngle: (CGFloat) angle
{

}

-(CGFloat) getWeaponAngle
{
	return 0;
}

-(CGPoint) getWeaponOffset
{
	return CGPointZero;
}


-(void) setWarMode
{
}

-(void) setPeaceMode
{
}

-(void) setSpeachMode
{
}

-(void) setBaseBody
{
}

-(void) makeSkinsUnvisible
{
}

-(void) setMoveMode
{
}

-(void) setIllMode
{
}

-(void) setLostMode
{
}

-(void) setIdleMode
{
}

-(void) showLifeIndicator
{
}

-(void) hideLifeIndicator
{
}

-(void) addHands
{
}

-(void) setFireMode
{
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	self.position = pos;
	self.rotation = angle;
}


/*-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj
{
	return 1;
}*/

-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point
{
	return 1;
}

-(void)damage:(int)damage
{
}

-(void) saveBerthPos
{
}

-(void) resetBerthPos
{
}

-(AWeapon*) getActiveWeapon
{
	return weapon;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	weapon = newWeapon;
}

/*-(void) setWeaponMode:(WeaponMode)newWeaponMode
{
	weaponMode = newWeaponMode;
}*/

-(CGPoint) getHeroPosition
{
	return CGPointZero;
}

-(void)dealloc
{
	[shape physicsUnregister];
	[shape release];
	[super dealloc];
}

-(void) setBowWeapon
{
	return;
}

-(void) setRocketWeapon
{
	return;
}

-(void) setBallWeapon
{
	return;
}

-(void) MoveToBasePos:(CGPoint)pos;
{
}

@end




@implementation WarHero

@synthesize lhandAnchor;
@synthesize rhandAnchor;


+(AHero*) heroWithProperties:(NSDictionary*)properties
{	
	return [[[WarHero alloc] initWithProperties:properties] autorelease];
}

-(WarHero*)initWithProperties:(NSDictionary*)properties
{
	if([super init]!=nil)
	{
		NSString* baseSkinName = [properties objectForKey:@"base"];
		NSString* moveSkinName = [properties objectForKey:@"move"];
		NSString* illSkinName = [properties objectForKey:@"ill"];
		NSString* bodySkinName = [properties objectForKey:@"body"];
		NSString* leftHandSkinName = [properties objectForKey:@"lhand"];
		NSString* rightHandSkinName = [properties objectForKey:@"rhand"];
		NSString* shapeName = [properties objectForKey:@"shape"];
		NSString* lostSkinName = [properties objectForKey:@"lost"];
		
		NSString* mouthSkinName = [properties objectForKey:@"mouth"];
		//NSString* idleSkinName = [properties objectForKey:@"idle"];
		
		int lhx = [[properties objectForKey:@"lhandx"] intValue];
		int lhy = [[properties objectForKey:@"lhandy"] intValue];
		
		int rhx = [[properties objectForKey:@"rhandx"] intValue];
		int rhy = [[properties objectForKey:@"rhandy"] intValue];
		
		hasWarMode = [[properties objectForKey:@"warmode"] boolValue];
		
		baseSkin = [[ASkin skinWithName:baseSkinName] retain];
		moveSkin = [[ASkin skinWithName:moveSkinName] retain];
		bodySkin = [[ASkin skinWithName:bodySkinName] retain];
		leftHandSkin = [[ASkin skinWithName:leftHandSkinName] retain];
		rightHandSkin = [[ASkin skinWithName:rightHandSkinName] retain];
		illSkin = [[ASkin skinWithName:illSkinName] retain];
		lostSkin = [[ASkin skinWithName:lostSkinName] retain];
		mouthSkin = [[ASkin skinWithName:mouthSkinName] retain];
		//idleSkin = [[ASkin skinWithName:idleSkinName] retain];
		
		[baseSkin addToParent:self z:1];
		[moveSkin addToParent:self z:1];
		[illSkin addToParent:self z:1];
		[lostSkin addToParent:self z:1];
		[mouthSkin addToParent:self z:1];
		//[idleSkin addToParent:self z:1];
		
		[bodySkin addToParent:self z:2];
		//[leftHandSkin addToParent:self z:2];
		//[rightHandSkin addToParent:self z:2];		
		
		//[speachSkin addToParent:self z:3];
		
		[self makeSkinsUnvisible];

		
		[self setBaseBody];
		
		lifeIndicator = [[LifeIndicator alloc] init];
		[self addChild:lifeIndicator z:4 tag:1];
		lifeIndicator.position = ccp(0,150);
		[lifeIndicator setVisible:NO];
		
		helth = 100;
		
		lhandAnchor = CGPointMake(lhx, lhy);
		rhandAnchor = CGPointMake(rhx, rhy);
		
		leftHandSkin.position = lhandAnchor;
		rightHandSkin.position = rhandAnchor;
	
		self.shape = [AShape shapeWithName:shapeName];
		

		return self;		
	}	
	return nil;
}



-(void) setPeaceMode
{
	heroMode = baseMode;
	[self makeSkinsUnvisible];
	[baseSkin setVisibility:YES];
}


-(void) setTimerForIdleSkin:(int)delta
{
	if ( !(heroMode==baseMode || heroMode==bodyMode) )
		return;
	
	//heroMode = idleMode;
	[self makeSkinsUnvisible];
	
	NSString* idleSkinName = [NSString stringWithFormat:@"%@IdleSkin", name];
	ASkin* idleSkin = [ASkin skinWithName:idleSkinName];
	
	AnEffect* idleEffect = [[VisualEffect alloc] initWithSkin:idleSkin duration:1.3];	
	[idleEffect applyToParent:self];
	
	[self schedule: @selector(setTimerForStopIdle:) interval: 1.3f];
	
}


-(void) setTimerForStopIdle:(int)delta
{
	[self unschedule: @selector(setTimerForStopIdle:)];
	
	if (heroMode==baseMode)
		[self setPeaceMode];
	
	if (heroMode==bodyMode)
	   [self setWarMode];
	
}


-(void) addHands
{
	if(nativeTeam.teamSide==kLeftSideTeam) 
	{
		[leftHandSkin addToParent:self z:1];
		[rightHandSkin addToParent:self z:3];	
	}
	else
	{
		[leftHandSkin addToParent:self z:3];
		[rightHandSkin addToParent:self z:1];	
	}		
}

-(void) damage:(int)damage
{
	if(damege)
		return;
	
	helth -=damage;
	if(helth<=0)
	{
		helth = 0;
		[nativeTeam removeHero:self];
		[parent removeChild:self cleanup:YES];
	}
	[self setIllMode];
	
	damage = YES;
}

-(void) setWarMode
{
	heroMode = bodyMode;
	[self makeSkinsUnvisible];
	[bodySkin setVisibility:YES];
	[leftHandSkin setVisibility:YES];
	[rightHandSkin setVisibility:YES];
}

-(void) setFireMode
{	
	[self schedule: @selector(setForPeaceSkin:) interval: 0.5f];	
}

-(void) setForPeaceSkin:(int)delta
{
	[self unschedule: @selector(setForPeaceSkin:)];
	[self setPeaceMode];
}



-(void) setIllMode
{
	heroMode = illMode;
	[self makeSkinsUnvisible];
	[illSkin setVisibility:YES];	
}

-(void) setMoveMode
{
	heroMode = illMode;
	[self makeSkinsUnvisible];
	[moveSkin setVisibility:YES];	
}

/*-(void) MoveToBasePos:(CGPoint)pos
{
	CocosNode *s = [moveSkin node];
	[s stopAllActions];
	CocosNode* par = [self parent];
	CGPoint objPos = [[GameSystem sharedGame].gameScene sceneCoordinate:par point:pos];
	
	CGPoint posActive = [self getHeroPosition];
	
	[self setMoveMode];
	[s runAction: [MoveTo actionWithDuration:0 position:posActive]];
	[s runAction: [MoveTo actionWithDuration:2 position:pos]];
	
}*/

-(void) setLostMode
{
	heroMode = illMode;
	[self makeSkinsUnvisible];
	[lostSkin setVisibility:YES];	
}

-(void) setSpeachMode
{
	heroMode = speachMode;
	[self makeSkinsUnvisible];
	
	[mouthSkin setVisibility:YES];
	
	[self schedule: @selector(setTimerForBaseSkin:) interval: 1.5f];
}

-(void) setTimerForBaseSkin:(int)delta
{
	[self makeSkinsUnvisible];
	[self unschedule: @selector(setTimerForBaseSkin:)];
	[self setPeaceMode];
}

-(void) setBaseBody
{
	//[self makeSkinsUnvisible];
	[baseSkin setVisibility:YES];
}

-(void) makeSkinsUnvisible
{
	[baseSkin setVisibility:NO];
	[moveSkin setVisibility:NO];
	[illSkin setVisibility:NO];
	[lostSkin setVisibility:NO];	
	//[idleSkin setVisibility:NO];
	//[speachSkin setVisibility:NO];
	[mouthSkin setVisibility:NO];
	
	[bodySkin setVisibility:NO];
	[leftHandSkin setVisibility:NO];
	[rightHandSkin setVisibility:NO];
	
	//[self unschedule: @selector(setTimerForIdleSkin:)];
	//[self unschedule: @selector(setTimerForPeaceSkin:)];
}


-(void) showLifeIndicator
{
	lifeIndicator.scaleX = [self parent].scaleX;// (nativeTeam.teamSide==kLeftSideTeam) ? 1 : -1;
	[lifeIndicator setLifeValue:helth];
	[lifeIndicator setVisible:YES];
}

-(void) hideLifeIndicator
{
	[lifeIndicator setVisible:NO];
}

-(void) setWeaponAngle: (CGFloat) angle
{
	leftHandSkin.angle = -angle;
	rightHandSkin.angle = -angle;	
}

-(CGFloat) getWeaponAngle
{	
	if(rightHandSkin!=nil)
		return -rightHandSkin.angle;
	return -leftHandSkin.angle;
}

-(CGPoint) getWeaponOffset
{
	CGFloat weaponOffset = 112;
	CGFloat weaponAngle = 3.14*[self getWeaponAngle]/180;
	return CGPointMake(rhandAnchor.x + weaponOffset*cos(weaponAngle), rhandAnchor.y + weaponOffset*sin(weaponAngle));
}

-(void) saveBerthPos
{
	berthPos = [self position];
}

-(void) resetBerthPos
{
	[self setPosition:berthPos];
	[self setRotation:0];
}

-(void) dealloc
{
	[self unschedule: @selector(setTimerForIdleSkin:)];
	[baseSkin release];
	[moveSkin release];
	[illSkin release];
	[bodySkin release];
	[lostSkin release];	
	//[idleSkin release];
	//[speachSkin release];
	[mouthSkin release];
	[leftHandSkin release];
	[rightHandSkin release];
	[lifeIndicator release];
	[super dealloc];
}

-(CGPoint) getHeroPosition
{
	//CGPoint localPos = self.position;
	CGPoint localPos = [(CocosNode*)self position];
	CocosNode* par = [self parent];
	CGPoint objPos = [[GameSystem sharedGame].gameScene sceneCoordinate:par point:localPos];
	return objPos;
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	int sceneSize = [[GameSystem sharedGame].gameScene size].width;
	if(pos.x<-20 || pos.x>sceneSize+20 || pos.y<-20)
	{
		[self setIllMode];
		[nativeTeam removeHero:self];
		[parent removeChild:self cleanup:YES];
	}
	else
	{
		CGPoint localPos = [[GameSystem sharedGame].gameScene localCoordinate:parent point:pos];
		self.position = localPos;
		self.rotation = parent.scaleX>0 ? angle : -angle;
	}
	
}



-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point
{
	if( [(NSObject*)obj isKindOfClass:[AProjectile class]] )
	{
		//int ret = [(WarProjectile*)obj collisionDidDetectWithObject:self atPoint:point];
		int ret = [(AProjectile*)obj collisionDidDetectWithObject:self atPoint:point];
		return helth > 0 ? ret : 0;
	}
	
	if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		AHero* hero = (AHero*)obj;
		[hero damage:2];
		[self damage:2];
		[hero showLifeIndicator];
		
		return helth > 0 ? 1 : 0;
	}
	
	return helth > 0 ? 1 : 0;
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


@implementation PrincessHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[PrincessHero alloc] initWithProperties:properties] autorelease];
}

-(PrincessHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 40.0f];
		weapon = [[AWeapon weaponWithName:@"BowWeaponNatalia"] retain];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end




@implementation BillHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[BillHero alloc] initWithProperties:properties] autorelease];
}

-(BillHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 18.0f];
		weapon = [[AWeapon weaponWithName:@"KnifeWeapon"] retain];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end


@implementation MunikHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[MunikHero alloc] initWithProperties:properties] autorelease];
}

-(MunikHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 28.0f];
		weapon = [[AWeapon weaponWithName:@"SwordWeapon"] retain];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end



@implementation LukHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[LukHero alloc] initWithProperties:properties] autorelease];
}

-(LukHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 26.0f];
		weapon = [[AWeapon weaponWithName:@"SwordWeapon"] retain];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end


@implementation KarlHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[KarlHero alloc] initWithProperties:properties] autorelease];
}

-(KarlHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 24.0f];
		weapon = [[AWeapon weaponWithName:@"AxeWeapon"] retain];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end


@implementation MargoHero


+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[MargoHero alloc] initWithProperties:properties] autorelease];
}

-(MargoHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 22.0f];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end


@implementation EnrikeoHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[EnrikeoHero alloc] initWithProperties:properties] autorelease];
}

-(EnrikeoHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		 NSString* EnrikeoLeftHandCanon = [properties objectForKey:@"lhandcanon"];
		 NSString* EnrikeoRightHandCanon = [properties objectForKey:@"rhandcanon"];
		 
		 leftHandCanon = [[ASkin skinWithName:EnrikeoLeftHandCanon] retain];
		 rightHandCanon = [[ASkin skinWithName:EnrikeoRightHandCanon] retain];
		 
		 int lhxc = [[properties objectForKey:@"lhandx_canon"] intValue];
		 int lhyc = [[properties objectForKey:@"lhandy_canon"] intValue];
		 
		 int rhxc = [[properties objectForKey:@"rhandx_canon"] intValue];
		 int rhyc = [[properties objectForKey:@"rhandy_canon"] intValue];
		 
		 lhandCanonAnchor = CGPointMake(lhxc, lhyc);
		 rhandCanonAnchor = CGPointMake(rhxc, rhyc);
		 
		 leftHandCanon.position = lhandCanonAnchor;
		 rightHandCanon.position = rhandCanonAnchor;
		
		[leftHandCanon addToParent:self z:1];
		[rightHandCanon addToParent:self z:3];
		
		[leftHandCanon setVisibility:NO];
		[rightHandCanon setVisibility:NO];
		
	
		NSString* EnrikeoLeftHandBow = [properties objectForKey:@"lhandbow"];
		NSString* EnrikeoRightHandBow = [properties objectForKey:@"rhandbow"];
		
		leftHandBow = [[ASkin skinWithName:EnrikeoLeftHandBow] retain];
		rightHandBow = [[ASkin skinWithName:EnrikeoRightHandBow] retain];
		
		int lhxb = [[properties objectForKey:@"lhandx_bow"] intValue];
		int lhyb = [[properties objectForKey:@"lhandy_bow"] intValue];
		
		int rhxb = [[properties objectForKey:@"rhandx_bow"] intValue];
		int rhyb = [[properties objectForKey:@"rhandy_bow"] intValue];
		
		lhandBowAnchor = CGPointMake(lhxb, lhyb);
		rhandBowAnchor = CGPointMake(rhxb, rhyb);
		
		leftHandBow.position = lhandBowAnchor;
		rightHandBow.position = rhandBowAnchor;
		
		[leftHandBow addToParent:self z:1];
		[rightHandBow addToParent:self z:3];
		
		[leftHandBow setVisibility:NO];
		[rightHandBow setVisibility:NO];
		
		[self schedule: @selector(setTimerForIdleSkin:) interval: 20.0f];
		
		return self;
	}
	return nil;
}


/*-(void) setTimerForIdleSkin:(int)delta
{
    [super setTimerForIdleSkin:delta];
}*/


-(void) setWeaponAngle: (CGFloat) angle
{
	leftHandSkin.angle = -angle;
	rightHandSkin.angle = -angle;	
	
	leftHandBow.angle = -angle;
	rightHandBow.angle = -angle;
	
	leftHandCanon.angle = -angle;
	rightHandCanon.angle = -angle;
}


-(void) makeSkinsUnvisible
{
	[baseSkin setVisibility:NO];
	[moveSkin setVisibility:NO];
	[illSkin setVisibility:NO];
	[lostSkin setVisibility:NO];	
	//[idleSkin setVisibility:NO];
	//[speachSkin setVisibility:NO];
	[mouthSkin setVisibility:NO];
	
	[bodySkin setVisibility:NO];
	
	[leftHandSkin setVisibility:NO];
	[rightHandSkin setVisibility:NO];
	
	[leftHandBow setVisibility:NO];
	[rightHandBow setVisibility:NO];
	
	[leftHandCanon setVisibility:NO];
	[rightHandCanon setVisibility:NO];
	
	//[self unschedule: @selector(setTimerForIdleSkin:)];
	//[self unschedule: @selector(setTimerForPeaceSkin:)];
}

-(void) setWarMode
{
	heroMode = bodyMode;
	[self makeSkinsUnvisible];
	[bodySkin setVisibility:YES];
	//[self makeHandsUnvisible];
	
	AWeapon* w = [self getActiveWeapon];
		
	if([w isKindOfClass:[BowWeapon class]])
	{
		[leftHandBow setVisibility:YES];
	    [rightHandBow setVisibility:YES];
		return;
	}
	
	if([w isKindOfClass:[RocketWeapon class]])
	{
		[leftHandCanon setVisibility:YES];
		[rightHandCanon setVisibility:YES];
		return;
	}
	
	if([w isKindOfClass:[BallWeapon class]])
	{
		[leftHandSkin setVisibility:YES];
		[rightHandSkin setVisibility:YES];
		return;
	}
	
	[leftHandSkin setVisibility:YES];
	[rightHandSkin setVisibility:YES];
}


-(void) setBowWeapon;
{
	heroMode = bowMode;
	[self setWarMode];
}

-(void) setRocketWeapon
{
	heroMode = rocketMode;
	[self setWarMode];
}

-(void) setBallWeapon
{
	heroMode = ballMode;
	[self setWarMode];
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end


//---------------------------------------------------------

@implementation DandyHero


+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[DandyHero alloc] initWithProperties:properties] autorelease];
}

-(DandyHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 30.0f];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end



//---------------------------------------------------------
@implementation SolderHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[SolderHero alloc] initWithProperties:properties] autorelease];
}

-(SolderHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 30.0f];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end


//---------------------------------------------------------
@implementation HelperHero

+(AHero*) heroWithProperties:(NSDictionary*)properties
{
	return [[[HelperHero alloc] initWithProperties:properties] autorelease];
}

-(HelperHero*)initWithProperties:(NSDictionary*)properties
{
	if( [super initWithProperties:properties]!=nil )
	{
		[self schedule: @selector(setTimerForIdleSkin:) interval: 30.0f];
		return self;
	}
	return nil;
}

-(void) setActiveWeapon:(AWeapon*)newWeapon
{
	// do not change the weapon
}

-(void)dealloc
{
	[weapon release];
	[super dealloc];
}

@end

