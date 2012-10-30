//
//  PhysicsSystem.m
//  PirateWars
//
//  Created by v on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSystem.h"
#import "GameSystem.h"
#import "cocos2d.h"

@implementation PhysicsSystem

static cpSpace* _space = NULL;

static int shapeCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);
static void eachShape(void *ptr, void* unused);
static void performShapeCtrls();

@synthesize pContact;

static NSMutableSet* _objectSafer = nil;

+(void) initSystem
{
	if(_space==NULL)
	{
		_objectSafer = [[NSMutableSet alloc] init];
		
		cpInitChipmunk();
		// Create a space object  
		_space = cpSpaceNew();  
		
		// Define a gravity vector  
		_space->gravity = cpv(0, -300);  	
		
		//cpSpaceResizeStaticHash(space, 400, 40);
		//cpSpaceResizeActiveHash(space, 100, 600);
		_space->elasticIterations = 5;
		
		//cpSpaceAddCollisionPairFunc(_space, 0, 0, &shapeCollision, NULL);
		cpSpaceSetDefaultCollisionPairFunc(_space, shapeCollision, NULL);
	}
}

+(cpSpace*) worldSpace
{
	if(_space==NULL)
	{
		[self initSystem];
	}
	return _space;
}

+(void) safeObject:(NSObject*)obj
{
	if(obj!=nil)
	{
		[_objectSafer addObject:obj];
	}
}

+(void) updateSafer
{
	NSMutableSet* objForDeleting = nil;
	
	for(NSObject* obj in _objectSafer)
	{
		if([obj retainCount]==1)
		{
			if(objForDeleting == nil)
				objForDeleting = [[NSMutableSet alloc] init];

			[objForDeleting addObject:obj];
		}
	}
	
	if(objForDeleting!=nil)
	{
		[_objectSafer minusSet:objForDeleting];
		[objForDeleting release];
	}	
 
}

+(void) step: (CGFloat) delta
{
	cpFloat dt = delta;
	
	cpSpaceStep(_space, dt < 0.25 ? dt : 0.25);
	
	cpSpaceHashEach(_space->activeShapes, &eachShape, nil);
	//cpSpaceHashEach(_space->staticShapes, &eachShape, nil);
	
	performShapeCtrls();
	[self updateSafer];
	
//	static cpFloat t=0;
//	t+=dt;
	
//	int dx = 100 - ((int)(t*260))%200;

//	_space->gravity = cpv(dx*2, -300);
	
	
}

static void eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	id<PhysicsProtocol> obj = shape->data;
	if(obj!=nil)
	{
		cpBody *body = shape->body;
		cpVect pos = cpv( body->p.x, body->p.y);
		CGFloat angle = (float) CC_RADIANS_TO_DEGREES( -body->a );
		[obj updatePosition:pos angle:angle];
	}
}

static int shapeCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	id<PhysicsProtocol>objA = a->data;
	id<PhysicsProtocol>objB = b->data;
	
	if(objA!=nil)
	{
		return [objA collisionDidDetectWithObject: objB atPoint:contacts->p];
		//return [objA collisionDidDetectWithObject: objB];
	}
	//else 
		if(objB!=nil)
	{
		return [objB collisionDidDetectWithObject: objA atPoint:contacts->p];
		//return [objB collisionDidDetectWithObject: objA];
	}
	return 1;
}



typedef enum
	{
		kShapeToAdd,
		kShapeToDel,
		kBodyToAdd,
		kBodyToDel,
	} CtrlType;


struct ShapeCtrl
{
	CtrlType ctrlType;
	union
	{
		struct
		{
			cpBody* body;
		} body;
		struct
		{
			cpShape* shape;
			BOOL isStaticShape;
		} shape;
	}data;	
};

#define MAX_SHAPE_CTRL 100

static struct ShapeCtrl shapeCtrls[MAX_SHAPE_CTRL];
static int shapeCtrlNum = 0;

+(void) addBody:(cpBody*)body
{
	assert(shapeCtrlNum<MAX_SHAPE_CTRL);
	shapeCtrls[shapeCtrlNum].ctrlType = kBodyToAdd;
	shapeCtrls[shapeCtrlNum].data.body.body = body;
	shapeCtrlNum++;
}

+(void) removeBody:(cpBody*)body
{
	assert(shapeCtrlNum<MAX_SHAPE_CTRL);
	shapeCtrls[shapeCtrlNum].ctrlType = kBodyToDel;
	shapeCtrls[shapeCtrlNum].data.body.body = body;
	shapeCtrlNum++;
}

+(void) addShape:(cpShape*)shape staticShape:(BOOL)isStatic
{
	assert(shapeCtrlNum<MAX_SHAPE_CTRL);
	shapeCtrls[shapeCtrlNum].ctrlType = kShapeToAdd;
	shapeCtrls[shapeCtrlNum].data.shape.shape = shape;
	shapeCtrls[shapeCtrlNum].data.shape.isStaticShape = isStatic;
	shapeCtrlNum++;
}

+(void) removeShape:(cpShape*)shape staticShape:(BOOL)isStatic
{
	assert(shapeCtrlNum<MAX_SHAPE_CTRL);
	shapeCtrls[shapeCtrlNum].ctrlType = kShapeToDel;
	shapeCtrls[shapeCtrlNum].data.shape.shape = shape;
	shapeCtrls[shapeCtrlNum].data.shape.isStaticShape = isStatic;
	shapeCtrlNum++;
	shape->data = NULL;
}

static void performShapeCtrls()
{
	BOOL needsRehashStatic = NO;
	int i;
	for(i=0; i<shapeCtrlNum; i++)
	{
		switch (shapeCtrls[i].ctrlType)
		{
			case kBodyToAdd:
				cpSpaceAddBody(_space, shapeCtrls[i].data.body.body);
				break;
			case kBodyToDel:
				cpSpaceRemoveBody(_space, shapeCtrls[i].data.body.body);
				break;
			case kShapeToAdd:
				if(!shapeCtrls[i].data.shape.isStaticShape)
					cpSpaceAddShape(_space, shapeCtrls[i].data.shape.shape);
				else
				{
					cpSpaceAddStaticShape(_space, shapeCtrls[i].data.shape.shape);
					needsRehashStatic = YES;
				}
				break;
			case kShapeToDel:
				if(!shapeCtrls[i].data.shape.isStaticShape)
					cpSpaceRemoveShape(_space, shapeCtrls[i].data.shape.shape);
				else
					cpSpaceRemoveStaticShape(_space, shapeCtrls[i].data.shape.shape);
				break;
		}
	}
	
	if(needsRehashStatic)
	{
		cpSpaceRehashStatic(_space);
	}
	
	shapeCtrlNum = 0;
}

@end
