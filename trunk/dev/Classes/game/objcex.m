//
//  objcex.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "objcex.h"

@implementation NSXPoint

@synthesize point;

-(id)initWithPoint:(CGPoint)p
{
	[super init];
	point = p;
	return self;
}

+(id)pointWithPoint:(CGPoint)p
{
	return [[[NSXPoint alloc] initWithPoint:p] autorelease];
}

-(void)dealloc
{
	[super dealloc];
}

@end

