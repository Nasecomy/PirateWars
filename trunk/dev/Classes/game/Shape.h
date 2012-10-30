//
//  Shape.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsSystem.h"
#import "GameSystem.h"

#if DEBUG_SHAPES
@interface AShape :  CocosNode
#else
@interface AShape :  NSObject
#endif
{

}

+(void) loadShapeDatabase:(NSString*)filename;
+(AShape*) shapeWithProperties:(NSDictionary*)properties;
+(AShape*) shapeWithName:(NSString*)name;

-(void) physicsRegister:(id<PhysicsProtocol>)obj;
-(void) physicsUnregister;

-(void)setPosition:(CGPoint)pos;
-(CGPoint)getPosition;
-(void)applyVelocity:(cpVect)v;
-(void)applyAngularVelocity:(CGFloat)w;
//-(void)initPhysics;

@end



@interface PhysicShape: AShape 
{
	cpBody* body;
	cpShape** shapes;
	int shapeCount;
	BOOL staticShape;
	BOOL physicsRegistered;
}

@property (nonatomic, assign) BOOL staticShape;
@property (nonatomic, readonly) cpBody* body;

-(PhysicShape*)initWithBody:(cpBody*)body shapes:(cpShape**)shapes shapeCount:(int)count;


@end



