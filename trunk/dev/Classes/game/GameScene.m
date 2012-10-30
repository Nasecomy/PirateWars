//
//  GameScene.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "cocos2d.h"
#import "Ship.h"
#import "Shape.h"
#import "Skin.h"
#import "Projectile.h"
#import "PhysicsSystem.h"
#import "GameSystem.h"
#import "Effect.h"
#import "ManualAimLayer.h"

#import "GameHelperLayer.h"
#import "MiniMap.h"
#import "UpgradeHelperLayer.h"
#import "SpeachLayer.h"


@implementation AGameScene

@synthesize ship1Pos, ship2Pos;
@synthesize speachLayer;


static NSDictionary* sceneDatabase = nil;

+(void) loadSceneDatabase:(NSString*)filename
{
	if(sceneDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"scenes" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	sceneDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
															  format:&format
													errorDescription:&error];
	[sceneDatabase retain];
}


+(AGameScene*) sceneWithProperties:(NSDictionary*)properties
{
	return nil;
}

+(AGameScene*) sceneWithName:(NSString*)name
{
	NSDictionary* sceneProperties = [sceneDatabase objectForKey:name];
	if(sceneProperties!=nil)
	{
		NSString* sceneClassName = [sceneProperties objectForKey:@"class"];
		if(sceneClassName!=nil)
		{
			Class sceneClass = NSClassFromString(sceneClassName);
			if(sceneClass!=nil)
			{
				return [sceneClass sceneWithProperties: sceneProperties];
			}
		}			
	}
	return nil;	
}



-(void) physicsRegister
{
}

-(void) physicsUnregister
{
}

-(void) showAimLayer
{
}

-(void) hideAimLayer
{
}

-(ManualAimLayer*) getAimLayer
{
	return nil;
}

-(void) showExitButton:(BOOL)show
{
}

-(void) hideExitButton
{
}

-(void) showPauseButton
{
}

-(void) hidePauseButton
{
}

-(void)updateControls
{
}

-(void) updateAimerAngle:(int)angle power:(int)power
{
}

-(void) resetPowerGrow
{
}

-(void)updateAimerControls
{
}

-(void)move
{
	
	Action* a = [MoveBy actionWithDuration:5.0 position:ccp(500,0)];
	
	CocosNode* nodeCh = gameLayer;
	[nodeCh runAction:a];
}

-(void) setShips:(AShip*)ship1 ship2:(AShip*)ship2
{
	if(ship1!=nil)
	{
		//[gameLayer addChild:ship1];
		[ship1 addToParent:gameLayer z:100];
		ship1.position = ship1Pos;
	}
	if(ship2!=nil)
	{
		//[gameLayer addChild:ship2];
		ship2.position = ship2Pos;
	    //ship2.shipPos = ship2Pos;
		[ship2 addToParent:gameLayer z:100];
	}
}


-(void) addEffect:(AnEffect*)effect;
{
	[effect applyToParent:gameLayer];
}

-(void) addProjectile:(AProjectile*) projectile
{
}

-(void) addNode:(CocosNode*) tNode
{
}

-(void) removeProjectile:(AProjectile*) projectile
{
}

-(CGSize) size
{
	return CGSizeZero;
}

-(CGPoint) sceneCoordinate:(CocosNode*)parentNode point:(CGPoint)pos;
{
	CGPoint p = pos;
	
	if(parentNode!=gameLayer)
	{
		CGAffineTransform t = [parentNode nodeToParentTransform];
		
		CocosNode *n = parentNode.parent;
		while(n!=gameLayer && n!=nil)
		{
			t = CGAffineTransformConcat(t, [n nodeToParentTransform]);
			n = n.parent;
		}
		p = CGPointApplyAffineTransform(p, t);
	}
	
	return p;
}


-(CGPoint) localCoordinate:(CocosNode*)parentNode point:(CGPoint)point
{
	CGPoint p = point;
	
	if(parentNode!=gameLayer)
	{
		CGAffineTransform t = [parentNode nodeToParentTransform];
		
		CocosNode *n = parentNode.parent;
		while(n!=gameLayer && n!=nil)
		{
			t = CGAffineTransformConcat(t, [n nodeToParentTransform]);
			n = n.parent;
		}
		p = CGPointApplyAffineTransform(p, CGAffineTransformInvert(t));
	}
	
	return p;
}


-(void) scrollTo: (CGFloat)pos
{
	bgLayer1.position = CGPointMake(-pos, 0.0);
	gameLayer.position = CGPointMake(-pos, 0.0);
	bgLayer2.position = CGPointMake(-pos, 0.0);
	speachLayer.position = CGPointMake(-pos, 0.0);
}

-(void) moveTo: (CGFloat)pos
{
	bgLayer1.position = CGPointMake(bgLayer1.position.x-pos, bgLayer1.position.y);
	gameLayer.position = CGPointMake(gameLayer.position.x-pos, gameLayer.position.y);
	bgLayer2.position = CGPointMake(bgLayer2.position.x-pos, bgLayer2.position.y);
	speachLayer.position = CGPointMake(speachLayer.position.x-pos, speachLayer.position.y);
}

-(CGFloat) getPosition
{
	return gameLayer.position.x; 
}

-(void)updateMiniMapHeroLifes:(NSArray*)helthArray1 lifes:(NSArray*)helthArray2
{
}

-(void)dealloc
{
	[name release];
	[super dealloc];
}



@end


@implementation WarScene

@synthesize helperLayer;

+(WarScene*) sceneWithProperties:(NSDictionary*)properties
{
	return [[[WarScene alloc] initWithProperties:properties] autorelease];	
}

-(WarScene*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* backSkinName = [properties objectForKey:@"front"];
		NSString* frontSkinName = [properties objectForKey:@"back"];
		NSString* shapeName = [properties objectForKey:@"shape"];
		
		int sp1x = [[properties objectForKey:@"sp1x"] intValue];
		int sp1y = [[properties objectForKey:@"sp1y"] intValue];
		int sp2x = [[properties objectForKey:@"sp2x"] intValue];
		int sp2y = [[properties objectForKey:@"sp2y"] intValue];
		ship1Pos = CGPointMake(sp1x, sp1y);
		ship2Pos = CGPointMake(sp2x, sp2y);
		
		bgLayer1 = [[ASkin skinWithName:backSkinName] node];
		bgLayer2 = [[ASkin skinWithName:frontSkinName] node];
		
		gameLayer = [CocosNode node];
		aimLayer = [ManualAimLayer node];	
		//aimLayer = [AutomaticAimLayer node];

		helperLayer = [GameHelperLayer node];
		sceneShape = [[AShape shapeWithName:shapeName] retain];
		speachLayer = [SpeachLayer node];
		
		[self addChild:bgLayer1 z:1];		
		[self addChild:gameLayer z:2];
		[self addChild:bgLayer2 z:3];
		[self addChild:aimLayer z:4];
		[self addChild:helperLayer z:5];
		[self addChild:speachLayer z:6];
		
		[self hideAimLayer];
		
		NSDictionary* minimapProp = [properties objectForKey:@"minimap"];
		MiniMap* minimap = [[[MiniMap alloc] initWithProperties:minimapProp] autorelease];
		[helperLayer setMiniMap:minimap];	
	
		
		CGSize screenSize = [[Director sharedDirector] winSize];
		CGSize sceneSize = [self size];
		[self scrollTo:(sceneSize.width-screenSize.width)];	
		
		return self;
	}
	return nil;
}

-(void) updatePhysicsStep: (CGFloat) delta
{
	[PhysicsSystem step:delta*0.8];

}

/*
-(void) moveShape:(int)delta
{
	if(direction>0)
		tick++;
	else
		tick--;
	
	
	if(fabs(tick) >10)
		direction *= -1;
	
	CGPoint scPos = [sceneShape getPosition];
	[sceneShape setPosition: CGPointMake(scPos.x, scPos.y + tick) ];
}*/

-(void) physicsRegister
{
	[self schedule:@selector(updatePhysicsStep:) interval:0.0];	
	
	[sceneShape physicsRegister:nil];
	//[self schedule: @selector(moveShape:) interval: 0.3f];	
#if DEBUG_SHAPES
	[bgLayer2 addChild:sceneShape z:100];
#endif
}

-(void) physicsUnregister
{
	//[self unschedule: @selector(moveShape:)];
	[self unschedule:@selector(updatePhysicsStep:)];
	[sceneShape physicsUnregister];
}

-(void) addProjectile:(AProjectile*) projectile
{
	[gameLayer addChild:projectile z:-1];	
}

-(void) addNode:(CocosNode*) tNode
{
	[bgLayer1 addChild:tNode];
}

-(void) removeProjectile:(AProjectile*) projectile
{
	[gameLayer removeChild:projectile cleanup:YES];
}

-(void) showAimLayer
{
	[aimLayer setVisible:YES];
}

-(ManualAimLayer*) getAimLayer
{
	return aimLayer;
}

-(void) hideAimLayer
{
	[aimLayer setVisible:NO];
}

-(void) showExitButton:(BOOL)show
{
	[helperLayer showExitButton:show];
}

-(void) hideExitButton
{
	[helperLayer showExitButton:NO];
}

-(void) showPauseButton
{
	[helperLayer showPauseButton:YES];
}

-(void) hidePauseButton
{
	[helperLayer showPauseButton:NO];
}

-(void)updateMiniMapHeroLifes:(NSArray*)helthArray1 lifes:(NSArray*)helthArray2
{
	[helperLayer.miniMap updateHeroLifes:helthArray1 lifes:helthArray2];
}

-(void) updateAimerAngle:(int)angle power:(int)power
{
	[(ManualAimLayer*)aimLayer updateAngle:angle];
	[(ManualAimLayer*)aimLayer updatePower:power];
}

-(void) resetPowerGrow
{
	aimLayer.powerGrow = YES;
}

-(void)updateAimerControls
{
	[aimLayer updateControls];
}

-(CGSize) size
{
	int lv = [[GameSystem sharedGame] level];
	
	if(lv<3)
		return CGSizeMake(1500,320);
	else
		return CGSizeMake(1580,320);
		//return CGSizeMake(1610,320);
}

-(void) dealloc
{
	[sceneShape release];
	[super dealloc];
	
	[PhysicsSystem step:0.0];
}

@end

///////////////////////////////////////////////////////////////

@implementation UpgradeScene

+(UpgradeScene*) sceneWithProperties:(NSDictionary*)properties
{
	return [[[UpgradeScene alloc] initWithProperties:properties] autorelease];	
}

-(UpgradeScene*) initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* backSkinName = [properties objectForKey:@"front"];
		NSString* frontSkinName = [properties objectForKey:@"back"];
		
		/*int sp1x = [[properties objectForKey:@"sp1x"] intValue];
		int sp1y = [[properties objectForKey:@"sp1y"] intValue];
		ship1Pos = ship2Pos = CGPointMake(sp1x, sp1y);*/
		
		int sp1x = [[properties objectForKey:@"sp1x"] intValue];
		int sp1y = [[properties objectForKey:@"sp1y"] intValue];
		//int sp2x = [[properties objectForKey:@"sp2x"] intValue];
		//int sp2y = [[properties objectForKey:@"sp2y"] intValue];
		ship1Pos = CGPointMake(sp1x, sp1y);
		//ship2Pos = CGPointMake(sp2x, sp2y);
		ship2Pos = ship1Pos;
		
		bgLayer1 = [[ASkin skinWithName:backSkinName] node];
		bgLayer2 = [[ASkin skinWithName:frontSkinName] node];
		gameLayer = [CocosNode node];
		helperLayer = [UpgradeHelperLayer node];
		
		[self addChild:bgLayer1 z:1];
		[self addChild:gameLayer z:2];
		[self addChild:bgLayer2 z:3];
		[self addChild:helperLayer z:5];
		
		return self;
	}
	return nil;
}

-(void)showUpgradeShip
{
	downgradeShip.visible = NO;
	upgradeShip.visible = YES;
}

-(void)showDowngradeShip
{
	downgradeShip.visible = YES;
	upgradeShip.visible = NO;
}

-(void) setShips:(AShip*)ship1 ship2:(AShip*)ship2
{
	[super setShips:ship1 ship2:ship2];
	downgradeShip = ship1;
	upgradeShip = ship2;
	[self showDowngradeShip];
}

-(CGSize) size
{
	return CGSizeMake(480,320);
}

-(void) dealloc
{
	[super dealloc];
}

@end










