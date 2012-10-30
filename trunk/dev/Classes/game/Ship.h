//
//  Ship.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "PhysicsSystem.h"


@class ASkin;
@class AHero;
@class AShape;

@interface AShip : CocosNode <PhysicsProtocol>
{
	//AShape* shape;
	NSString* name;
}

//@property (nonatomic, retain) AShape* shape;
@property (nonatomic, retain) NSString* name;

+(void) loadShipDatabase:(NSString*)filename;
+(AShip*) shipWithProperties:(NSDictionary*)properties;
+(AShip*) shipWithName:(NSString*)name;

-(void) setHero:(AHero*)hero pos:(int)pos;
-(int) getBerthCount;
-(CGPoint) getBerthPoint: (int)berth;
-(void) physicsRegister;
-(void) physicsUnregister;
-(void) addToParent: (CocosNode*) parentNode z:(int)z; 
-(void) setScaleX: (float)newScaleX;
-(int) getPositionOffset: (AHero*) hero;
-(void) hitShip; 
@end


@interface WarShip : AShip 
{
	AShape* shape;
	ASkin* backSkin;
	ASkin* frontSkin;
	
	NSArray* heroPointList;
}

@property (nonatomic, retain) AShape* shape;
@property (nonatomic, retain) NSArray* heroPointList;

-(WarShip*)initWithSkin:(ASkin*)back front:(ASkin*)front;
-(void) physicsRegister;
-(void) physicsUnregister;
@end



@interface MultiPlaformWarShip : AShip 
{
	NSMutableArray *warShips;
	NSMutableArray *positionsShift;
}

@property (nonatomic, retain) NSMutableArray* warShips;

-(MultiPlaformWarShip*)initWithSkins:(NSArray*)backs front:(NSArray*)fronts shape:(NSArray*)shapes points1:(NSArray*)points1 points2:(NSArray*)points2;
-(void) physicsRegister;
-(void) physicsUnregister;
-(MultiPlaformWarShip*)initShips;
-(void) addShip: (AShip*)ship shift:(NSNumber*)shiftShip;
@end

