//
//  ATeam.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Team.h"
#import "Hero.h"
#import "Ship.h"
#import "Aimer.h"
#import "Weapon.h"
#import "Projectile.h"
#import "GameSystem.h"
#import "GameScene.h"
#import "Skin.h"
#import "Shape.h"
#import "cocos2d.h"
#import "objcex.h"
#import "Level.h"

@implementation ATeam

@synthesize teamSide;
@synthesize name;
@synthesize credits;

static NSDictionary* teamDatabase = nil;

+(void) loadTeamDatabase:(NSString*)filename
{
	if(teamDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"teams" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	teamDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													 mutabilityOption:NSPropertyListImmutable
															   format:&format
													 errorDescription:&error];
	[teamDatabase retain];
}


+(ATeam*) teamWithProperties:(NSDictionary*)teamProperties
{
	NSString* teamClassName = [teamProperties objectForKey:@"class"];
	if(teamClassName!=nil)
	{
		Class teamClass = NSClassFromString(teamClassName);
		if(teamClass!=nil)
		{
			ATeam* team = [teamClass teamWithProperties: teamProperties];
			team.name = @"RuntimeTeam";
			return team;
		}
	}
	return nil;
}

+(ATeam*) teamWithName:(NSString*)name
{
	NSDictionary* teamProperties = [teamDatabase objectForKey:name];
	if(teamProperties!=nil)
	{
		NSString* teamClassName = [teamProperties objectForKey:@"class"];
		if(teamClassName!=nil)
		{
			Class teamClass = NSClassFromString(teamClassName);
			if(teamClass!=nil)
			{
				ATeam* team = [teamClass teamWithProperties: teamProperties];
				team.name = name;
				return team;
			}
		}
	}
	return nil;	
}

+(NSDictionary*) propertiesWithTeamName:(NSString*)name
{
	return [teamDatabase objectForKey:name];
}

-(NSDictionary*) getTeamProperties
{
	return nil;
}

-(void) removeHero:(AHero*)hero
{
}

-(AShip*) getShip
{
	return nil;
}

-(void) setShip:(AShip*)ship
{
}

-(BOOL) isLost
{
	return NO;
}

-(AHero*) getActiveHero
{
	return nil;
}


-(NSString*) getActiveWeaponName
{
	return nil;
}

-(NSArray*) getHeroHelthArray
{
	return nil;
}

-(void) setHeroHelthArray:(NSArray*)helthArray
{
}

-(void) activate
{
}

-(void) activateLastScene
{
}

-(void) deactivate
{
}

-(void) fire
{
}

-(void) physicsRegister
{
}

-(void) physicsUnregister
{
}

-(void) selectWeapon:(NSString*)weaponName
{
}

-(int) getProjectileCountForWeapon:(NSString*)weaponName
{
	return 0;
}

-(void) setProjectileCountForWeapon:(NSString*)weaponName count:(int)count
{
}

-(void) putHeroesToShip:(AShip*) ship heroes:(NSMutableArray*)heroesArray
{
}

-(void) makeHeroesLost
{
}

-(AHero*) getHero:(int)iIndex
{
	return nil;
}

-(void) setActiveHero;
{
	activeHero = nil;
}

/*-(AWeapon*) getWeaponByName:(NSString*)weaponName
{
	return nil;
}*/

-(void) resetDamage
{
}

-(void)dealloc
{
	[name release];
	[super dealloc];
}

@end



@implementation WarTeam

+(WarTeam*) teamWithProperties:(NSDictionary*)properties
{
	return [[[WarTeam alloc] initWithProperties:properties] autorelease];
}

-(WarTeam*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		credits = [[properties objectForKey:@"credits"] intValue];
		
		NSString* shipName = [properties objectForKey:@"ship"];
		NSString* teamSideString = [properties objectForKey:@"side"];
		NSString* aimerClassName = [properties objectForKey:@"aimer"];
	
		ship = [[AShip shipWithName:shipName] retain];
		
		teamSide = ([teamSideString compare:@"right"]==NSOrderedSame) ? kRightSideTeam : kLeftSideTeam;
		aimer = [[AnAimer aimerWithName:aimerClassName] retain];

		NSArray* heroArray = [properties objectForKey:@"heroes"];
		heroes = [[NSMutableArray alloc] init];
		for(NSString* heroName in heroArray)
			[self addHeroWithName:heroName];
		
		
		NSArray* weaponArray = [properties objectForKey:@"weapons"];
		/*NSMutableDictionary* weaponsMutableDictionary = [[NSMutableDictionary alloc] init];
		for(NSDictionary* weaponDict in weaponArray)
		{
			NSString* weaponName = [weaponDict objectForKey:@"name"];
			AWeapon* weapon = [AWeapon weaponWithName:weaponName];
			if(weapon!=nil)
			{
				weapon.projectileCount = [[weaponDict objectForKey:@"projectiles"] intValue];
				[weaponsMutableDictionary setObject:weapon forKey:weaponName];
				if(activeWeapon==nil && weapon.projectileCount != 0)
					activeWeapon = weaponName;
			}
		}
		weapons1 = [[NSMutableDictionary alloc] initWithDictionary:weaponsMutableDictionary];*/
		
        //weapons1 = [[NSMutableDictionary alloc] init];
		weapons1 = [[NSMutableDictionary dictionary] retain];
		
		for(NSDictionary* weaponDict in weaponArray)
		{
			NSString* weaponName = [weaponDict objectForKey:@"name"];
			AWeapon* weapon = [AWeapon weaponWithName:weaponName];
			if(weapon!=nil)
			{
				weapon.projectileCount = [[weaponDict objectForKey:@"projectiles"] intValue];
				[weapons1 setObject:weapon forKey:weaponName];
				if(activeWeapon==nil && weapon.projectileCount != 0)
					activeWeapon = weaponName;
			}
		}
		
		NSArray* heroHelthArray = [properties objectForKey:@"health"];
		if(heroHelthArray!=nil)
		{
			[self setHeroHelthArray:heroHelthArray];
		}	
		
		if(teamSide == kRightSideTeam)
		{
			ship.scaleX = -ship.scaleX;			
		}
		
		activeHero = nil;
		return self;
	}
	return nil;
}

-(NSDictionary*) getTeamProperties
{
	NSMutableDictionary* teamProp = [[[NSMutableDictionary alloc] init] autorelease];
	
	[teamProp setObject:[NSNumber numberWithInt:credits] forKey:@"credits"];
	
	[teamProp setObject:@"WarTeam" forKey:@"class"];
	[teamProp setObject: (teamSide==kRightSideTeam) ? @"right" : @"left" forKey:@"side"];
	[teamProp setObject:ship.name forKey:@"ship"];
	NSString* aimerClassName = NSStringFromClass([aimer class]);
	[teamProp setObject: aimerClassName forKey:@"aimer"];
	
	NSMutableArray* heroNameArray = [[NSMutableArray alloc] init];
	NSMutableArray* heroHealthArray = [[NSMutableArray alloc] init];
	
	for(NSDictionary* heroDict in heroes)
	{
		AHero* hero = [heroDict objectForKey:@"hero"];
		[heroHealthArray addObject:[NSNumber numberWithInt:hero.helth]];
		NSString* heroName = [heroDict objectForKey:@"name"];
		[heroNameArray addObject:heroName];
	}
	[teamProp setObject:heroNameArray forKey:@"heroes"];

	
	[teamProp setObject:heroHealthArray forKey:@"health"];
	[heroNameArray release];
	[heroHealthArray release];
	
	NSMutableArray* weaponArray = [[NSMutableArray alloc] init];
	for(NSString*  weaponName in weapons1)
	{
		AWeapon* weapon = [[weapons1 objectForKey:weaponName] retain];
		NSMutableDictionary* weaponDict = [[NSMutableDictionary alloc] init];
		[weaponDict setObject:weaponName forKey:@"name"];
		[weaponDict setObject:[NSNumber numberWithInt:weapon.projectileCount] forKey:@"projectiles"];
		[weaponArray addObject:weaponDict];
		[weaponDict release];
	}
		
	[teamProp setObject:weaponArray forKey:@"weapons"];
	[weaponArray release];

	return teamProp;
}


-(void) physicsRegister
{
	[ship physicsRegister];

	for(NSDictionary* heroDict in heroes)
	{
		AHero* hero = [heroDict objectForKey:@"hero"];
		[hero.shape physicsRegister:hero];
	}		
}

-(void) physicsUnregister
{
	//[ship.shape physicsUnregister];
	[ship physicsUnregister];
	
	for(NSDictionary* heroDict in heroes)
	{
		AHero* hero = [heroDict objectForKey:@"hero"];
		[hero.shape physicsUnregister];
	}		
}

-(void) resetHeroes
{
	for(NSDictionary* heroDict in heroes)
	{
		AHero* hero = [heroDict objectForKey:@"hero"];
		if(hero!=nil)
		{
			[hero setPeaceMode];
			[hero hideLifeIndicator];		
			//[hero.shape physicsUnregister];
			
			//NSXPoint* defPos = [heroDict objectForKey:@"pos"];
			//hero.position = defPos.point;
			//[hero.shape physicsRegister:hero];
		}
	}	
}

-(void) resetDamage
{
	for(NSDictionary* heroDict in heroes)
	{
		AHero* hero = [heroDict objectForKey:@"hero"];
		if(hero!=nil)
			hero.damege = NO;
	}	
}


-(void) makeHeroesLost
{
	for(NSDictionary* heroDict in heroes)
	{
		AHero* hero = [heroDict objectForKey:@"hero"];
		if(hero!=nil)
			[hero setLostMode];
	}	
}


-(void) activate
{
	[aimer takeAim];
	
	[self resetHeroes];
	
	[[GameSystem sharedGame].gameScene resetPowerGrow];
	
	[[GameSystem sharedGame] setActiveHero];
	AHero* activeHero_ = [[GameSystem sharedGame] getActiveHero];
	[activeHero_ setWarMode];
	
	AWeapon* w =  [[weapons1 objectForKey:activeWeapon] retain];
	//AWeapon* w = [self getWeaponByName:activeWeapon];
	[activeHero_ setActiveWeapon:w];
	[w setNewWepon:activeHero_];
	
	[activeHero_ setWeaponAngle: [aimer getAngle]];
	
	if(teamSide == kLeftSideTeam)
	{
		[[GameSystem sharedGame].gameScene scrollTo:0];
	}
	else	
	{
		CGSize screenSize = [[Director sharedDirector] winSize];
		CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
		//[[GameSystem sharedGame].gameScene scrollTo:sceneSize.width-screenSize.width];
		
		
		AHero* hero = [self getActiveHero];
		if(hero!=nil)
		{
            int pos = cpfmin( sceneSize.width-screenSize.width, [hero getHeroPosition].x - screenSize.width/2);
			[[GameSystem sharedGame].gameScene scrollTo:pos];
		}
		
		/*Action* a = [MoveBy actionWithDuration:5.0 position:ccp(500,0)];
		
		CocosNode* nodeCh = [GameSystem sharedGame].gameScene;
		[nodeCh runAction:a];*/
		//[[GameSystem sharedGame].gameScene move];
	}
}


-(void) activateLastScene
{	
	[self resetHeroes];	

	if(teamSide == kLeftSideTeam)
	{
		[[GameSystem sharedGame].gameScene scrollTo:0];
	}
	else 
	{
		CGSize screenSize = [[Director sharedDirector] winSize];
		CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
		[[GameSystem sharedGame].gameScene scrollTo:sceneSize.width-screenSize.width];
	}
}

-(void) deactivate
{
	[self resetHeroes];
}


-(void) fire
{
	AHero* hero = [self getActiveHero];
	if(hero==nil)
	{
		return;
	}
	
	ATeam* inactiveTeam_ = [[GameSystem sharedGame] inactiveTeam];
	[inactiveTeam_ resetDamage];
	
	CGPoint heroPos = hero.position;
	CGPoint shipPos = ship.position;
	int offset = [ship getPositionOffset:hero];
	
	CGPoint weaponPoint = [hero getWeaponOffset];
	
	AWeapon* w = [hero getActiveWeapon];
	
	if(teamSide == kLeftSideTeam)
	{
		[[GameSystem sharedGame] setShotsUsed];
		CGPoint firePoint = CGPointMake(heroPos.x+shipPos.x+weaponPoint.x, heroPos.y+shipPos.y+weaponPoint.y);
		CGFloat angle = [aimer getAngle];
		CGFloat power = [aimer getPower];
		
		[w fireFromPoint:firePoint angle:angle power:power];
	}
	else
	{
		CGPoint firePoint = CGPointMake(-heroPos.x+shipPos.x-weaponPoint.x + offset, heroPos.y+shipPos.y+weaponPoint.y);
		CGFloat angle = 180-[aimer getAngle];
		CGFloat power = [aimer getPower];
		[w fireFromPoint:firePoint angle:angle power:power];
	}
	
	if( [activeWeapon compare:[w getWeaponName]] == NSOrderedSame )
	{
		int projectiles = [self getProjectileCountForWeapon:activeWeapon];
		if(projectiles>0)
		{
			[self setProjectileCountForWeapon:activeWeapon count:projectiles-1];
		}
	}

}

-(void) addHeroWithName:(NSString*)heroName heroes:(NSMutableArray*)heroArray ship:(AShip*)targetShip
{
	if( [targetShip getBerthCount] > [heroArray count] )
	{
		AHero* hero = [AHero heroWithName:heroName];
		if(hero!=nil)
		{
			[targetShip setHero:hero pos:[heroArray count] ];
			hero.nativeTeam = self;
			
			[hero addHands];
		
			
			NSMutableDictionary* heroDict = [[NSMutableDictionary alloc] init];
			[heroDict setObject:heroName forKey:@"name"];
			[heroDict setObject:hero forKey:@"hero"];
			[heroDict setObject:[NSXPoint pointWithPoint:hero.position] forKey:@"pos"];
			[heroArray addObject:heroDict];
			[heroDict release];
		}
	}
}



-(void) addHeroWithName:(NSString*)heroName
{
	[self addHeroWithName:heroName heroes:heroes ship:ship];
}

-(void) putHeroesToShip:(AShip*) targetShip heroes:(NSMutableArray*)heroesArray
{
	NSMutableArray* tmpHeroesArray = (heroesArray!=nil) ? heroesArray : [[NSMutableArray alloc] init];
	
	for(NSDictionary* heroDict in heroes)
	{
		NSString* heroName = [heroDict objectForKey:@"name"];
		[self addHeroWithName:heroName heroes:tmpHeroesArray ship:targetShip];		
	}

	if(heroesArray!=tmpHeroesArray)
	{
		[tmpHeroesArray release];
	}
}

-(void) removeHero:(AHero*)hero
{
	for(NSMutableDictionary* heroDict in heroes)
	{
		AHero* h = [heroDict objectForKey:@"hero"];
		if(h!=nil && h == hero)
		{
			[hero.shape physicsUnregister];
			hero.nativeTeam = nil;
			[heroDict  removeObjectForKey:@"hero"];
			break;
		}		
	}
}

-(BOOL) isLost
{
	for(NSMutableDictionary* heroDict in heroes)
	{
		AHero* h = [heroDict objectForKey:@"hero"];
		if(h!=nil )
			return NO;		
	}
	
	return YES;	
			
	//return [self getActiveHero] == nil;
}

-(AShip*) getShip
{
	return ship;
}

-(void) setShip:(AShip*)newShip
{
	NSMutableArray* newHeroes = [[NSMutableArray alloc] init];
	[self putHeroesToShip:newShip heroes:newHeroes];
	
	[ship release];
	ship = [newShip retain];

	[heroes release];
	heroes = newHeroes;
}

-(NSString*) getActiveWeaponName
{
	return activeWeapon;
}

-(AHero*) getActiveHero
{
	/*if(teamSide==kRightSideTeam)
	{
		for(NSDictionary* heroDict in heroes)
		{
			AHero* hero = [heroDict objectForKey:@"hero"];
			if(hero.hasWarMode )
				return hero;
		}		
	}
	else
	{	
		for(int i=[heroes count]-1; i>=0; i--)
		{
			NSDictionary* heroDict = [heroes objectAtIndex:i];
			AHero* hero = [heroDict objectForKey:@"hero"];
			if(hero.hasWarMode )
				return hero;
		}
	}*/	
	
			
	return activeHero;
}

-(void) setActiveHero
{
    activeHero = nil;
	
	if(teamSide==kRightSideTeam)
	{		
		NSMutableArray* heroes_ = [[NSMutableArray alloc] init];
		
		for(NSDictionary* heroDict in heroes)
		{
			AHero* hero = [heroDict objectForKey:@"hero"];
			if(hero.hasWarMode )
				[heroes_ addObject:hero];
		}
		
		int ihero = rand() % ([heroes_ count]);
		activeHero = [heroes_ objectAtIndex:ihero];
	}
	else
	{	
		for(NSDictionary* heroDict in heroes)
		{
			activeHero = [heroDict objectForKey:@"hero"];
			if(activeHero.hasWarMode )
				break;
			else 
				activeHero = nil;			

		}		
	}			
	
}

-(AHero*) getHero:(int)iIndex
{
	if(iIndex<[heroes count])
	{		
		NSDictionary* heroDict = [heroes objectAtIndex:iIndex];
		AHero* hero = [heroDict objectForKey:@"hero"];
			return hero;
	}
	
	return nil;
}


-(NSArray*) getHeroHelthArray
{
	NSMutableArray* helthArray = [[[NSMutableArray alloc] init] autorelease];
	//if(teamSide==kRightSideTeam)
	{
		for(NSDictionary* heroDict in heroes)
		{
			AHero* hero = [heroDict objectForKey:@"hero"];
			[helthArray addObject:[NSNumber numberWithInt:hero.helth]];
		}		
	}
	/*
	else
	{
		for(int i=[heroes count]-1; i>=0; i--)
		{
			NSDictionary* heroDict = [heroes objectAtIndex:i];
			AHero* hero = [heroDict objectForKey:@"hero"];
			[helthArray addObject:[NSNumber numberWithInt:hero.helth]];
		}		
	}
	*/
	return helthArray;
}

-(void) setHeroHelthArray:(NSArray*)helthArray
{
	int i = 0;
	for(NSDictionary* heroDict in heroes)
	{
		AHero* hero = [heroDict objectForKey:@"hero"];
		int helth = i < [helthArray count] ? [[helthArray objectAtIndex:i] intValue] : 0; 
		hero.helth  = helth;
		if(helth<=0)
		{
			[self removeHero:hero];
			[hero.parent removeChild:hero cleanup:YES];
		}
		i++;
	}		
}

-(void) selectWeapon:(NSString*)weaponName
{
	AWeapon* w = [[weapons1 objectForKey:weaponName] retain];
	//AWeapon* w = [self getWeaponByName:weaponName];
	if( w!=nil )
	{
		activeWeapon = weaponName;
		
		[[GameSystem sharedGame].gameScene updateAimerControls];
		
		AHero* h = [self getActiveHero];
		[h setActiveWeapon:w];
        [w setNewWepon:h];
	}
}

-(int) getProjectileCountForWeapon:(NSString*)weaponName
{
	AWeapon* weapon = [[weapons1 objectForKey:weaponName] retain];
	//AWeapon* weapon = [self getWeaponByName:weaponName];
	return weapon.projectileCount;
}

/*-(AWeapon*) getWeaponByName:(NSString*)weaponName
{
	for(int i=0; i<[weapons1 count]; i++)
	{
		AWeapon* weapon = [weapons1 objectAtIndex:i];
		if ([weapon.wname compare:weaponName]==NSOrderedSame ) {
			return weapon;
		}

	}
	return nil;
}*/

-(void) setProjectileCountForWeapon:(NSString*)weaponName count:(int)count
{
	AWeapon* weapon = [[weapons1 objectForKey:weaponName] retain];
	weapon.projectileCount = count;
	/*if(count>0)
	{
		weapon = [AWeapon weaponWithName:weaponName];
		weapon.projectileCount = count;
		if(weapon!=nil)
		{
			NSMutableDictionary* weaponsMutableDictionary = [NSMutableDictionary dictionaryWithDictionary:weapons1];
			[weaponsMutableDictionary setObject:weapon forKey:weaponName];
			[weapons1 release];
			weapons1 = weaponsMutableDictionary;
		}
	}	*/
	//weapon.projectileCount = count;
	
	//weapon = [[weapons1 objectForKey:weaponName] retain];
	//int t = weapon.projectileCount;
	
	if(count==0 && [weaponName compare:activeWeapon]==NSOrderedSame )
	{
		for( NSString* w in weapons1 )
		{
			if( [self getProjectileCountForWeapon:w]==-1 )
			{
				[self selectWeapon:w];
				break;
			}
		}
		
		/*for(int i=0; i<[weapons1 count]; i++)
		{
			AWeapon* weapon = [weapons1 objectAtIndex:i];
			if( [self getProjectileCountForWeapon:weapon.wname]==-1 )
			{
				[self selectWeapon:weapon.wname];
				break;
			}
			
		}*/
	}
}

-(void) dealloc
{
	[ship release];
	[aimer release];
	[heroes release];
	//[weapons release];
	[super dealloc];
}

@end
