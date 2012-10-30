//
//  AnAimer.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Aimer.h"
#import "GameSystem.h"
#import "GameScene.h"
#import "Hero.h"
#import "TCPConnectionPoint.h"
#import "Weapon.h"

@implementation AnAimer

+(AnAimer*) aimerWithName:(NSString*)aimerClassName
{
	if(aimerClassName!=nil)
	{
		Class aimerClass = NSClassFromString(aimerClassName);
		if(aimerClass!=nil)
		{
			return [[[aimerClass alloc] init] autorelease];
		}
	}			
	return nil;	
}

-(id)init
{
	if([super init])
	{
		angle = 0;
		power = 50;
		return self;
	}
	return nil;
}

-(void) takeAim
{
}

-(CGFloat) getAngle
{
	return angle;
}

-(CGFloat) getPower
{
	return power;
}

@end



@interface AimerScheduler : CocosNode
{
	id<AimerProtocol> aimerDelegate;
	NSArray* steps;
	float currAngle;
	int pointIndex;
	int dir;
}
-(id)initWithSteps:(NSArray*)aimerSteps  angle:(int)angle;
-(void) setDelegate:(id<AimerProtocol>)delegate;

@end


@implementation AimerScheduler

-(id)initWithSteps:(NSArray*)aimerSteps  angle:(int)angle
{
	if([super init])
	{
		steps = [aimerSteps retain];		
		currAngle = angle;	
		pointIndex = 0;
		dir = currAngle < [[steps objectAtIndex:0] intValue] ? 1 : -1;
		return self;
	}
	return nil;	
}

-(void) setDelegate:(id<AimerProtocol>)delegate
{
	aimerDelegate = delegate;
}

-(void) updateAimer: (CGFloat) delta
{
	if(delta>0.25)
		delta = 0.25;
	
	int point  = [[steps objectAtIndex:pointIndex] intValue];
	if( (dir>0 && currAngle>point) || (dir<0 && currAngle<point) )
	{
		if(pointIndex < [steps count]-1)
		{
			pointIndex++;
			point  = [[steps objectAtIndex:pointIndex] intValue];
			dir = currAngle < point ? 1 : -1;
		}
		else
		{
			[aimerDelegate didCompleteAiming];
			return;
		}
	}
	
	//float speed = 150;
	float speed = 50;
	currAngle += dir*speed*delta;	
	
	[aimerDelegate didChangeAngle:currAngle];
}

-(void) scheduleAimer
{
	[[GameSystem sharedGame].gameScene addChild:self];
	[self schedule:@selector(updateAimer:) interval:0.0];
}

-(void) unscheduleAimer
{
	[self unschedule:@selector(updateAimer:)];
	[[GameSystem sharedGame].gameScene removeChild:self  cleanup:YES];
}

-(void) dealloc
{	
	[steps release];
	[super dealloc];
}

@end


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

@implementation AIAimer

-(id) init
{
	if([super init])
	{
		return self;
	}
	return nil;
}



-(void) takeAim
{
	[GameSystem sharedGame].aimerDelegate = self;	
	
	//power = 60+rand()%35;
	power = 30+rand()%70;
	
	NSMutableArray* steps = [[[NSMutableArray alloc] init] autorelease];
	int stepCount = rand()%4 + 1;
	//int targetAngle = 30 + rand()%15;
	int targetAngle = 5 + rand()%15;
	int currAngle = 0;
	float distortion = 0.25 + stepCount*0.1;
	for(int i=0; i<stepCount; i++)
	{
		int dir = rand()%2 ? 1 : -1;
		int distance = targetAngle - currAngle;
		int point = targetAngle + dir*distance*distortion;
		[steps addObject:[NSNumber numberWithInt:point]];
		
		currAngle = point;
		distortion = distortion*0.7;		
	}
	
	scheduler = [[AimerScheduler alloc] initWithSteps:steps angle:angle];
	[scheduler setDelegate:self];
	[scheduler scheduleAimer];	
}

-(CGFloat) aimerAngle
{
	return [self getAngle];
}

-(CGFloat) aimerPower
{
	return [self getPower];
}



//  aimer protocol impl


-(void) didChangeAngle: (CGFloat) a
{
	angle = a;
	
 	AHero* hero = [[GameSystem sharedGame] getActiveHero];
	[hero setWeaponAngle: angle];
}

-(void) didChangePower: (CGFloat) p
{
}

-(void) didCompleteAiming
{
	[scheduler unscheduleAimer];
	[scheduler release];
	scheduler = nil;
	
	[[[GameSystem sharedGame] activeTeam] fire];
}


-(void) dealloc
{
	if(scheduler)
	{
		[scheduler unscheduleAimer];
		[scheduler release];
	}
	
	if(	[GameSystem sharedGame].aimerDelegate == self )
	{
		[GameSystem sharedGame].aimerDelegate = nil;	
	}
	[super dealloc];
}

@end


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////


@implementation ManualAimer

-(id) init
{
	angle = 0;
	power = 50;
	
	return self;
}

-(void) takeAim
{
	[GameSystem sharedGame].aimerDelegate = self;	
	[[GameSystem sharedGame] showAimControls];
	
	[[GameSystem sharedGame].gameScene updateAimerAngle:angle power:power];
	[[GameSystem sharedGame].gameScene updateAimerControls];
}

-(CGFloat) getAngle
{
	return angle;
}

-(CGFloat) getPower
{
    //return [[[GameSystem sharedGame].gameScene getAimLayer] getPower];
	return power;
}



//  aimer protocol impl


-(CGFloat) aimerAngle
{
	return [self getAngle];
}

-(CGFloat) aimerPower
{
	return [self getPower];
}


-(void) didChangeAngle: (CGFloat) a
{
	angle = a;
	
	if(angle > 60)
		angle = 60;
	if(angle < 0)
		angle = 0;
	
 	AHero* hero = [[GameSystem sharedGame] getActiveHero];
	[hero setWeaponAngle: angle];
	
	[[GameSystem sharedGame].gameScene updateAimerAngle:angle power:power];
}

-(void) didChangePower: (CGFloat) p
{	
	power = p;
}

-(void) didCompleteAiming
{
	[GameSystem sharedGame].aimerDelegate = nil;
	//[[GameSystem sharedGame] hideAimControls];
	[[[GameSystem sharedGame] activeTeam] fire];
}

-(void) dealloc
{
	if(	[GameSystem sharedGame].aimerDelegate == self )
	{
		[GameSystem sharedGame].aimerDelegate = nil;	
	}
	[super dealloc];
}

@end



/////////////////////////////////////////////////////////////////////

@implementation NetworkMasterAimer

+(NSDictionary*) packetAimWithAngle:(int)a power:(int)p
{
	NSMutableDictionary* packet = [[[NSMutableDictionary alloc] init] autorelease];
	[packet setObject:@"aimer" forKey:@"type"];
	[packet setObject:@"aim" forKey:@"cmd"];
	[packet setObject:[NSNumber numberWithInt:a] forKey:@"angle"];
	[packet setObject:[NSNumber numberWithInt:p] forKey:@"power"];
	return packet;
}

+(NSDictionary*) packetFire
{
	NSMutableDictionary* packet = [[[NSMutableDictionary alloc] init] autorelease];
	[packet setObject:@"aimer" forKey:@"type"];
	[packet setObject:@"fire" forKey:@"cmd"];
	return packet;
}

-(void) didChangeAngle: (CGFloat) a
{
	[super didChangeAngle:a];
	
	NSDictionary* packet = [NetworkMasterAimer packetAimWithAngle:angle power:power];
	[[GameSystem sharedGame].connectionPoint sendNetworkPacket:packet];
}

-(void) didChangePower: (CGFloat) p
{
	[super didChangePower:p];
	
	NSDictionary* packet = [NetworkMasterAimer packetAimWithAngle:angle power:power];
	[[GameSystem sharedGame].connectionPoint sendNetworkPacket:packet];
}

-(void) didCompleteAiming
{
	[super didCompleteAiming];
	
	NSDictionary* packetAim = [NetworkMasterAimer packetAimWithAngle:angle power:power];
	[[GameSystem sharedGame].connectionPoint sendNetworkPacket:packetAim];
	
	NSDictionary* packetFire = [NetworkMasterAimer packetFire];
	[[GameSystem sharedGame].connectionPoint sendNetworkPacket:packetFire];
}

@end



@implementation NetworkSlaveAimer

-(id) init
{
	if([super init])
	{
		return self;
	}
	return nil;
}


+(void)translateNetworkPacket:(NSDictionary*)packet
{
	NSString* packetType = [packet valueForKey:@"type"];
	if( [packetType compare:@"aimer"] == NSOrderedSame )
	{
		NSString* cmd = [packet valueForKey:@"cmd"];
		if( [cmd compare:@"aim"]==NSOrderedSame )
		{
			int angle = [[packet valueForKey:@"angle"] intValue];
			int power = [[packet valueForKey:@"power"] intValue];
			[[GameSystem sharedGame].aimerDelegate didChangeAngle:angle];
			[[GameSystem sharedGame].aimerDelegate didChangePower:power];
		}
		else if( [cmd compare:@"fire"]==NSOrderedSame )
		{
			[[GameSystem sharedGame].aimerDelegate didCompleteAiming];
		}
	}	
}

-(void) takeAim
{
	[GameSystem sharedGame].aimerDelegate = self;	
	[[GameSystem sharedGame].gameScene updateAimerAngle:angle power:power];
}


//  aimer protocol impl

-(CGFloat) aimerAngle
{
	return [self getAngle];
}

-(CGFloat) aimerPower
{
	return [self getPower];
}


-(void) didChangeAngle: (CGFloat) a
{
	angle = a;
	
 	AHero* hero = [[GameSystem sharedGame] getActiveHero];
	[hero setWeaponAngle: angle];
}

-(void) didChangePower: (CGFloat) p
{
	power = p;
}

-(void) didCompleteAiming
{
	[GameSystem sharedGame].aimerDelegate = nil;
	[[[GameSystem sharedGame] activeTeam] fire];
}

-(void) dealloc
{
	if(	[GameSystem sharedGame].aimerDelegate == self )
	{
		[GameSystem sharedGame].aimerDelegate = nil;	
	}
	[super dealloc];
}

@end

