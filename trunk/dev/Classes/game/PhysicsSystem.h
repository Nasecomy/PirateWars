//
//  PhysicsSystem.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "chipmunk.h"
//#import "cocos2d.h"

@protocol PhysicsProtocol
-(void) updatePosition:(CGPoint)pos angle:(CGFloat)angle;
//-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj;
-(int) collisionDidDetectWithObject:(id<PhysicsProtocol>)obj atPoint:(CGPoint)point;
@end



@interface PhysicsSystem : NSObject
{
	CGPoint pContact;
}
@property (nonatomic) CGPoint pContact;

+(void) initSystem;
+(cpSpace*) worldSpace;

+(void) step: (CGFloat) delta;

+(void) safeObject:(NSObject*)obj;

+(void) addBody:(cpBody*)body;
+(void) removeBody:(cpBody*)body;
+(void) addShape:(cpShape*)shape staticShape:(BOOL)isStatic;
+(void) removeShape:(cpShape*)shape staticShape:(BOOL)isStatic;

@end
