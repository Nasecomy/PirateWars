//
//  Shape.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Shape.h"
#import "PhysicsSystem.h"
#import "GameScene.h"
#import "GameSystem.h"
#import "Ship.h"
#import "Hero.h"

@implementation AShape

static NSDictionary* shapeDatabase = nil;

+(void) loadShapeDatabase:(NSString*)filename
{
	if(shapeDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"shapes" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	shapeDatabase = [NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
															  format:&format
													errorDescription:&error];
	[shapeDatabase retain];
}

+(AShape*) shapeWithProperties:(NSDictionary*)properties
{
	return nil;
}

+(AShape*) shapeWithName:(NSString*)name
{
	NSDictionary* shapeProperties = [shapeDatabase objectForKey:name];
	if(shapeProperties!=nil)
	{
		NSString* shapeClassName = [shapeProperties objectForKey:@"class"];
		if(shapeClassName==nil)
			shapeClassName = @"PhysicShape";
		
		Class shapeClass = NSClassFromString(shapeClassName);
		if(shapeClass!=nil)
		{
			return [shapeClass shapeWithProperties: shapeProperties];
		}
	}
	return nil;
}

-(void) physicsRegister:(id<PhysicsProtocol>)obj
{
}

-(void) physicsUnregister;
{
}

-(void)setPosition:(CGPoint)pos
{
}

-(CGPoint)getPosition
{
	return CGPointMake(0,0);
}

-(void)applyVelocity:(cpVect)v
{
}

-(void)applyAngularVelocity:(CGFloat)w
{
}

@end


@protocol ShapeBuilder
+(cpShape*)shapeWithProperties:(NSDictionary*)properties body:(cpBody*)body;
@end

@interface circleShapeBuilder: NSObject<ShapeBuilder>
{
}
@end

@implementation circleShapeBuilder

+(cpShape*)shapeWithProperties:(NSDictionary*)properties body:(cpBody*)body
{
	CGFloat x = [[properties objectForKey:@"x"] floatValue];
	CGFloat y = [[properties objectForKey:@"y"] floatValue];
	CGFloat r = [[properties objectForKey:@"r"] floatValue];
	
	cpShape *shape = cpCircleShapeNew(body, r, cpv(x, y));
	if(shape!=NULL)
	{
		shape->e = [[properties objectForKey:@"e"] floatValue]; // Elasticity
		shape->u = [[properties objectForKey:@"u"] floatValue]; // Friction
		shape->collision_type = [[properties objectForKey:@"ct"] intValue];
	}
	return shape;
}

@end


@interface polygonShapeBuilder: NSObject<ShapeBuilder>
{
}
@end

@implementation polygonShapeBuilder

+(cpShape*)shapeWithProperties:(NSDictionary*)properties body:(cpBody*)body
{
	NSArray* pointArray = [properties objectForKey:@"points"];
	if(pointArray!=nil && [pointArray count]>1 && [pointArray count]%2==0)
	{
		int pointNum = [pointArray count]/2;
		CGPoint* points = (CGPoint*)malloc(sizeof(CGPoint)*pointNum);
		for(int i=0; i<pointNum; i++)
		{
			CGFloat x = [[pointArray objectAtIndex:i*2] floatValue];
			CGFloat y = [[pointArray objectAtIndex:i*2+1] floatValue];
			points[i] = CGPointMake(x,y);			
		}
		
		CGFloat ox = [[properties objectForKey:@"ox"] floatValue];
		CGFloat oy = [[properties objectForKey:@"oy"] floatValue];
		CGPoint offset = CGPointMake(ox,oy);
		
		cpShape *shape = cpPolyShapeNew(body, pointNum, points, offset);
		free(points);
		if(shape!=NULL)
		{
			shape->e = [[properties objectForKey:@"e"] floatValue]; // Elasticity
			shape->u = [[properties objectForKey:@"u"] floatValue]; // Friction
			shape->collision_type = [[properties objectForKey:@"ct"] intValue];
			return shape;
		}
	}	
	return NULL;
}

@end




@implementation PhysicShape

@synthesize staticShape;
@synthesize body;

+(AShape*) shapeWithProperties:(NSDictionary*)properties
{
	CGFloat m = [[properties objectForKey:@"m"] floatValue];
	CGFloat i = [[properties objectForKey:@"i"] floatValue];
	BOOL isStaticShape = [[properties objectForKey:@"static"] boolValue];
	if(isStaticShape)
	{
		m = i = INFINITY;
	}
	
	cpBody* body = cpBodyNew(m,INFINITY /* i*/);
	
	NSArray* shapePropArray = [properties objectForKey:@"shapes"];
	
	if(shapePropArray!=nil && [shapePropArray count]>0)
	{
		cpShape** shapes = (cpShape**)malloc(sizeof(cpShape*)*[shapePropArray count]);
		int shapeCount = 0;	
		
		for(NSDictionary* shapeProp in shapePropArray)
		{
			NSString* shapeClassType = [shapeProp objectForKey:@"type"];
			if(shapeClassType!=nil)
			{
				NSString* builderClassName = [NSString stringWithFormat:@"%@ShapeBuilder", shapeClassType];
				Class shapeBuilderClass = NSClassFromString(builderClassName);
				if(shapeBuilderClass!=nil)
				{
					cpShape* shape = [shapeBuilderClass shapeWithProperties:shapeProp body:body];
					if(shape!=NULL)
					{
						shapes[shapeCount] = shape;
						shapeCount++;						
					}
				}
			}			
		}
		
		if(shapeCount>0)
		{
			PhysicShape* shape = [[self alloc] initWithBody:body shapes:shapes shapeCount:shapeCount];
			[shape autorelease];
			shape.staticShape = isStaticShape;
			return shape;	
		}
		else
		{
			free(shapes);
		}
	}	
	else
	{
		PhysicShape* shape = [[self alloc] initWithBody:body shapes:NULL shapeCount:0];
		[shape autorelease];
		shape.staticShape = isStaticShape;
		return shape;	
	}
	return nil;	
}

-(PhysicShape*)initWithBody:(cpBody*)b shapes:(cpShape**)s shapeCount:(int)count
{
	if([super init]!=nil)
	{
		body = b;
		shapes = s;
		shapeCount = count;	
		physicsRegistered = NO;
		return self;
	}
	return nil;
}

-(void)setPosition:(CGPoint)pos
{
	body->p = pos;
}

-(CGPoint)getPosition
{
	return body->p;
}

-(void)applyVelocity:(cpVect)v
{
	body->v = v;
}

-(void)applyAngularVelocity:(CGFloat)w
{
	body->w = w;
}

-(void) physicsRegister:(id<PhysicsProtocol>)obj
{
	if(physicsRegistered)
		return;
	physicsRegistered = YES;
	
	CocosNode* parentNode = [(CocosNode*)obj parent];
	CGPoint localPos = [(CocosNode*)obj position];
	CGPoint objPos = [[GameSystem sharedGame].gameScene sceneCoordinate:parentNode point:localPos];
	body->p = objPos;
	
	if(!staticShape)
	{
		// Add body to the space
		[PhysicsSystem addBody:body];
		
		// Add shapes to the space
		for(int i=0; i<shapeCount; i++)
		{
			shapes[i]->data = obj;
			[PhysicsSystem addShape:shapes[i] staticShape:NO];
		}
	}
	else
	{
		// Add shapes to the space
		for(int i=0; i<shapeCount; i++)
		{
			[PhysicsSystem addShape:shapes[i] staticShape:YES];
		}
	}
	
	[PhysicsSystem safeObject:self];
	
#if DEBUG_SHAPES
	if( [parent class] == [WarShip class] /*|| [parent class] == [MultiPlaformWarShip class]*/)
	{
		self.scaleX=parent.scaleX;
	}
	else if( [parent class] == [WarHero class] )
	{
		self.scaleX=parent.parent.scaleX;
	}
#endif
	
}

-(void) physicsUnregister;
{
	if(!physicsRegistered)
		return;
	physicsRegistered = NO;
	
	if(!staticShape)
	{
		// Remove body from the space
		[PhysicsSystem removeBody:body];
	}
	
	// Remove shapes from the space
	for(int i=0; i<shapeCount; i++)
	{
		[PhysicsSystem removeShape:shapes[i] staticShape:staticShape];
	}
}


-(void)dealloc
{
	if(shapes)
	{
		for(int i=0; i<shapeCount; i++)
		{
			if(shapes[i])
			{
				cpShapeFree(shapes[i]);
			}
		}
		free(shapes);		
	}
	
	if(body)
	{
		cpBodyFree(body);
	}

	[super dealloc];
}

#if DEBUG_SHAPES
-(void) draw
{
	if(shapeCount>0)
	{
		glLineWidth(3);
		if(self.scaleX<0)
		{
			glColor4ub(255, 0, 0, 255);			
		}
		else
		{
			glColor4ub(0, 255, 0, 255);
		}

		for(int i=0; i<shapeCount; i++)
		{
			if(shapes[i])
			{
				if(shapes[i]->klass->type == CP_CIRCLE_SHAPE)
				{
					cpCircleShape* s = (cpCircleShape*)shapes[i];
					drawCircle( ccp(s->c.x,  s->c.y), s->r, 0, 20, NO);
				}
				else if(shapes[i]->klass->type == CP_POLY_SHAPE)
				{
					cpPolyShape* s = (cpPolyShape*)shapes[i];
					drawPoly( s->verts, s->numVerts, YES);
				}
				else if(shapes[i]->klass->type == CP_SEGMENT_SHAPE)
				{
					
				}
			}
		}
		
		glLineWidth(5);
		glColor4ub(255, 255, 255, 255);
		drawCircle( ccp(0,  0), 3, 0, 10, NO);
	}
}
#endif



@end


