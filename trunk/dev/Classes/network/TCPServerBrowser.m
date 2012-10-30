//
//  TCPServerBrowser.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TCPServerBrowser.h"


@implementation TCPServerBrowser

@synthesize serverList;
@synthesize delegate;

- (id)init 
{
	serverList = [[NSMutableArray alloc] init];
	return self;
}

- (BOOL)startBrowse 
{
	if ( serviceBrowser != nil ) 
	{
		[self stopBrowse];
	}
	
	serviceBrowser = [[NSNetServiceBrowser alloc] init];

	if( serviceBrowser!=nil ) 
	{
		serviceBrowser.delegate = self;
		[serviceBrowser searchForServicesOfType:@"_pw._tcp." inDomain:@""];
		return YES;
	}
	
	return NO;
}

- (void)stopBrowse 
{
	if ( serviceBrowser != nil ) 
	{
		[serviceBrowser stop];
		[serviceBrowser release];
		serviceBrowser = nil;
		
		[serverList removeAllObjects];
	}
}

- (void)dealloc 
{
	if ( serverList != nil )
	{
		[serverList release];
		serverList = nil;
	}
	self.delegate = nil;
	[super dealloc];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing 
{
	if ( ![serverList containsObject:netService] ) 
	{
		[serverList addObject:netService];
		[delegate serverListDidChange];
	}
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing 
{
	[serverList removeObject:netService];
	[delegate serverListDidChange];
}

@end
