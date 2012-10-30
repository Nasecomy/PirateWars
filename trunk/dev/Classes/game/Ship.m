//
//  Ship.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Ship.h"
#import "Hero.h"
#import "Skin.h"
#import "Shape.h"
#import "Projectile.h"
#import "GameSystem.h"


@implementation AShip

//@synthesize shape;
@synthesize name;

static NSDictionary* _shipDatabase = nil;

+(void) loadShipDatabase:(NSString*)filename
{
	if(_shipDatabase==nil)
	{	
		NSString *path = [[NSBundle mainBundle] pathForResource:@"ships" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:path];
		NSString *error = nil;
		NSPropertyListFormat format;
		_shipDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
													format:&format
													errorDescription:&error];
		[_shipDatabase retain];
	}
}

+(AShip*) shipWithProperties:(NSDictionary*)properties
{
	NSAssert(NO, @"Should never be used");
	return nil;	
}

+(AShip*) shipWithName:(NSString*)name
{
	NSDictionary* shipProperties = [_shipDatabase objectForKey:name];
	if(shipProperties!=nil)
	{
		NSString* shipClassName = [shipProperties objectForKey:@"class"];
		if(shipClassName!=nil)
		{
			Class shipClass = NSClassFromString(shipClassName);
			if(shipClass!=nil)
			{
				AShip* ship = [shipClass shipWithProperties: shipProperties];
				ship.name = name;
				return ship;
			}
		}			
	}
	return nil;	
}

-(void) setHero:(AHero*)hero pos:(int)pos
{
}

-(int) getBerthCount
{
	return 0;
}

-(CGPoint) getBerthPoint: (int)berth
{
	return CGPointMake(0,0);
}

-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle
{
	self.position = pos;
	self.rotation = angle;
}


-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj
{
	return 1;
}

-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point
{
	return 1;
}

-(void) physicsRegister
{
}

-(void) physicsUnregister
{
}

-(void) addToParent: (CocosNode*) parentNode z:(int)z 
{
}

-(void) setScaleX: (float)newScaleX
{
	[super setScaleX:newScaleX];
}

-(int) getPositionOffset: (AHero*) hero
{
	return 0;
}

-(void) hitShip
{
}

-(void)dealloc
{
	[name release];
	//[shape physicsUnregister];
	//[shape release];
	[super dealloc];
}

@end



//////////////////////////////////////////////////////////////////////////////////////
@implementation WarShip

@synthesize heroPointList;
@synthesize shape;

+(AShip*) shipWithProperties:(NSDictionary*)properties
{
	NSString* backSkinName = [properties objectForKey:@"back"];
	NSString* frontSkinName = [properties objectForKey:@"front"];
	NSString* shapeName = [properties objectForKey:@"shape"];
	
	NSMutableArray* points = [[NSMutableArray alloc] init];
	for(int i=0;;i++)
	{
		NSNumber* nx = [properties objectForKey:[NSString stringWithFormat:@"hx%d", i]];
		NSNumber* ny = [properties objectForKey:[NSString stringWithFormat:@"hy%d", i]];

		if(nx==nil || ny==nil)
			break;
		
		[points addObject:nx];
		[points addObject:ny];
	}
	
	ASkin* back = [ASkin skinWithName:backSkinName];
	ASkin* front = [ASkin skinWithName:frontSkinName];
	
	WarShip* ship = [[[WarShip alloc] initWithSkin:back front:front] autorelease];
	ship.heroPointList = points;
	[points release];
	
	ship.shape = [AShape shapeWithName:shapeName];
	
	return ship;	
}


-(WarShip*)initWithSkin:(ASkin*)back front:(ASkin*)front
{
	if([super init]!=nil)
	{
		backSkin = [back retain];
		frontSkin = [front retain];
		
		[backSkin addToParent:self z:1];
		[frontSkin addToParent:self z:3];
		backSkin.position = CGPointMake(0,0);
		frontSkin.position = CGPointMake(0,0);
	
		return self;
	}
	return nil;
}

-(void) setHero:(AHero*)hero pos:(int)berth
{
	if( berth < [self getBerthCount] )
	{
		[self addChild:hero z:2 tag:0];
		hero.position = [self getBerthPoint:berth];
		[hero saveBerthPos];

//		CGPoint shipPos = self.position;
//		CGPoint berthPos = [self getBerthPoint:berth];
//		[hero.shape setPosition: CGPointMake(shipPos.x+berthPos.x, shipPos.y+berthPos.y)];
	}
}

-(int) getBerthCount
{
	return [heroPointList count]/2;
}


-(CGPoint) getBerthPoint: (int)berth
{
	if( berth < [self getBerthCount] )
	{
		CGFloat x = [[heroPointList objectAtIndex:berth*2] floatValue];
		CGFloat y = [[heroPointList objectAtIndex:berth*2+1] floatValue];
		return CGPointMake(x,y);
	}
	return CGPointMake(0,0);
}

-(void) dealloc
{
	[shape physicsUnregister];
	[shape release];
	[backSkin release];
	[frontSkin release];
	[heroPointList release];
	[super dealloc];
}

/*-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj
{
	if([(NSObject*)obj isKindOfClass: [AProjectile class]] )
	{
		return [(AProjectile*)obj collisionDidDetectWithObject:self];
	}	
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		return [(AHero*)obj collisionDidDetectWithObject:self];
	}
	return 1;
}*/

-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point
{
	if([(NSObject*)obj isKindOfClass: [AProjectile class]] )
	{
		return [(AProjectile*)obj collisionDidDetectWithObject:self atPoint:point];
	}	
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		return [(AHero*)obj collisionDidDetectWithObject:self atPoint:point];
	}
	return 1;
	
}

-(void) physicsRegister
{
	[shape physicsRegister:self];
}

-(void) physicsUnregister
{
	[shape physicsUnregister];
}

-(void) addToParent: (CocosNode*) parentNode z:(int)z; 
{
	[parentNode addChild:self];
}

-(int) getPositionOffset: (AHero*) hero
{
	return 0;
}

-(void) hitShip
{
	CocosNode* skinfront = [frontSkin node];
	CocosNode* skinback = [backSkin node];
	
	
	int pos = [frontSkin position].y;
	
	id action1 = [MoveTo actionWithDuration:0.2 position:ccp(0, pos-20)];
	id action2 = [MoveTo actionWithDuration:0.2 position:ccp(0, pos)];
	
	id action3 = [MoveTo actionWithDuration:0.2 position:ccp(0, pos-20)];
	id action4 = [MoveTo actionWithDuration:0.2 position:ccp(0, pos)];
	
	[skinback runAction:[Sequence actionOne:action1 two:action2]];
	[skinfront runAction:[Sequence actionOne:action3 two:action4]];
}

#if DEBUG_SHAPES
-(void) setShape:(AShape*)s
{
	//[super setShape:s];
	shape = [s retain];
	
	if(s!=nil)
	{
		//s.scaleX = self.scaleX;		
		[self addChild:s z:100];
	}
}
#endif


@end



//////////////////////////////////////////////////////////////////////////////////////
@implementation MultiPlaformWarShip

@synthesize warShips;


+(AShip*) shipWithProperties:(NSDictionary*)properties
{		
	MultiPlaformWarShip* multiShip = [[MultiPlaformWarShip alloc] initShips];
	
	NSArray* shipProps = [properties objectForKey:@"ships"];
	
	for(NSDictionary*  shipDic in shipProps)
	{
		NSString* backSkinName = [shipDic objectForKey:@"back"];
		NSString* frontSkinName = [shipDic objectForKey:@"front"];
		NSString* shapeName = [shipDic objectForKey:@"shape"];
		
		NSMutableArray* points = [[NSMutableArray alloc] init];
		for(int i=0;;i++)
		{
			NSNumber* nx = [shipDic objectForKey:[NSString stringWithFormat:@"hx%d", i]];
			NSNumber* ny = [shipDic objectForKey:[NSString stringWithFormat:@"hy%d", i]];
			
			if(nx==nil || ny==nil)
				break;
			
			[points addObject:nx];
			[points addObject:ny];
		}
		
		ASkin* back = [ASkin skinWithName:backSkinName];
		ASkin* front = [ASkin skinWithName:frontSkinName];
		
		WarShip* ship = [[[WarShip alloc] initWithSkin:back front:front] autorelease];
		ship.heroPointList = points;
		[points release];
		
		ship.shape = [AShape shapeWithName:shapeName];
		
		NSNumber* shiftShip = [shipDic objectForKey:@"spx"];
		[multiShip addShip:ship shift:shiftShip];
	}

	return multiShip;	
}

-(MultiPlaformWarShip*)initShips
{
	if([super init]!=nil)
	{		
		warShips = [[NSMutableArray alloc] init];		
		positionsShift = [[NSMutableArray alloc] init];
		return self;
	}
	return nil;
}

-(void) addShip: (AShip*)ship shift:(NSNumber*)shiftShip
{		
	[warShips addObject:ship];
	[positionsShift addObject:shiftShip];
}

-(MultiPlaformWarShip*)initWithSkins:(NSArray*)backs front:(NSArray*)fronts shape:(NSArray*)shapes points1:(NSArray*)points1 points2:(NSArray*)points2
{
	if([super init]!=nil)
	{		
		int iSize = MAX([backs count], [fronts count]);
		warShips = [[NSMutableArray alloc] init];
		
		for(int i=0; i<iSize; i++)
		{
            ASkin* bskin = [backs objectAtIndex:i];
			ASkin* fskin = [fronts objectAtIndex:i];
			AShape* ashape = [shapes objectAtIndex:i];
			
			WarShip* ship = [[[WarShip alloc] initWithSkin:bskin front:fskin] autorelease];
			[warShips addObject:ship];
					
			if(i==0)
			{
				ship.heroPointList = [points1 retain];
				ship.shape = ashape; 
				[points1 release];
			}
			else 
			{
			   ship.heroPointList = [points2 retain];
			   [points2 release];
	    	}
			
		}
		
		return self;
	}
	return nil;
}

-(void) setScaleX: (float)newScaleX
{
	for(int i=0; i<[warShips count]; i++)
	{
		WarShip* wsh = [warShips objectAtIndex:i];
		wsh.scaleX = -wsh.scaleX;	
	}
}

-(void) setHero:(AHero*)hero pos:(int)berth
{
	int currentBert = 0;
		
	for(int i=0; i<[warShips count]; i++)
	{
		WarShip* wsh = [warShips objectAtIndex:i];
		
		if(berth < ([wsh getBerthCount] + currentBert))
		{
		   [wsh setHero:hero pos:(berth - currentBert)];
			hero.shipNum = i;
		    break;	
		}
		else
			currentBert += [wsh getBerthCount];
	}

}

-(int) getBerthCount
{
	int iBertCount = 0;
	
	for(int i=0; i<[warShips count]; i++)
	{
		WarShip* wsh = [warShips objectAtIndex:i];
		iBertCount += [wsh getBerthCount];
	}
	
	return iBertCount;
}


-(CGPoint) getBerthPoint: (int)berth
{
	
	for(int i=0; i<[warShips count]-1; i++)
	{
		berth < [self getBerthCount] ;
		WarShip* wsh = [warShips objectAtIndex:i];
		
		berth < [wsh getBerthCount] ;
		NSArray* pts = [wsh heroPointList];
		CGFloat x = [[pts objectAtIndex:berth*2] floatValue];
		CGFloat y = [[pts objectAtIndex:berth*2+1] floatValue];
		return CGPointMake(x,y);
	}
	
	/*if( berth < [self getBerthCount] )
	{
		CGFloat x = [[heroPointList objectAtIndex:berth*2] floatValue];
		CGFloat y = [[heroPointList objectAtIndex:berth*2+1] floatValue];
		return CGPointMake(x,y);
	}*/
	return CGPointMake(0,0);
}

-(void) dealloc
{	
	for(int i=0; i<[warShips count]; i++)
	{
		WarShip* wsh = [warShips objectAtIndex:i];
		[wsh dealloc];
	}
	
	[super dealloc];
}

/*
-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj
{
	if([(NSObject*)obj isKindOfClass: [AProjectile class]] )
	{
		return [(AProjectile*)obj collisionDidDetectWithObject:self];
	}	
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		return [(AHero*)obj collisionDidDetectWithObject:self];
	}
	return 1;
}*/

-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point
{
	if([(NSObject*)obj isKindOfClass: [AProjectile class]] )
	{
		return [(AProjectile*)obj collisionDidDetectWithObject:self atPoint:point];
	}	
	else if( [(NSObject*)obj isKindOfClass:[AHero class]] )
	{
		return [(AHero*)obj collisionDidDetectWithObject:self  atPoint:point];
	}
	return 1;
	
}

-(void) physicsRegister
{		
	for(int i=0; i<[warShips count]; i++)
	{
		WarShip* wsh = [warShips objectAtIndex:i];
		[wsh physicsRegister];
	}
		
}

-(void) addToParent: (CocosNode*) parentNode z:(int)z 
{

		for(int i=0; i< [warShips count]; i++)
		{
	        WarShip* wsh = [warShips objectAtIndex:i];
			CGPoint gp = CGPointMake([self position].x + [(NSNumber *) [positionsShift objectAtIndex:i] floatValue],
									 [self position].y);
			wsh.position = gp;
			//wsh.shipPos = gp;
	        [wsh addToParent:parentNode z:100];
		}
}

-(int) getPositionOffset: (AHero*) hero
{
	int pos = hero.shipNum;
	return [(NSNumber *) [positionsShift objectAtIndex:pos] floatValue];
}

-(void) physicsUnregister
{	
	for(AShip*  ship in warShips)
		[ship physicsUnregister];
}

#if DEBUG_SHAPES
-(void) setShapes:(NSMutableArray*)s
{
	if(s!=nil)
	{			
		for(AShape* sh in s)
			[self addChild:sh z:100];		
	}
}
#endif


@end


