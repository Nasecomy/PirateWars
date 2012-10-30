//
//  EventResponder.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EventResponder.h"


@implementation EventResponder


static EventResponder* _sharedEventResponderPtr = nil;

+(EventResponder*)sharedResponder
{
	if (!_sharedEventResponderPtr)
		[[self alloc] init];
	
	return _sharedEventResponderPtr;
}

+(id) alloc
{
	NSAssert(_sharedEventResponderPtr == nil, @"Attempted to allocate a second instance of a singleton.");
	return _sharedEventResponderPtr = [super alloc];
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
	return UINT_MAX; //denotes an object that cannot be released
}

- (void)release 
{
	// never release
}

- (id)autorelease 
{
	return self;
}




@end
