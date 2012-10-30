//
//  MainWindowController.m
//  tcptest
//
//  Created by Vladimir Demkovich on 9/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"



@interface MainWindowController()
@end

static NSString* testServerName = @"pw test server";

@implementation MainWindowController


- (id) init
{
	[super init];
	
	return self;
}


- (void) awakeFromNib
{
	[connected setStringValue: @" status: no connection " ];
}

-(IBAction) onStartServer:(id)sender
{
	[server stop];
	[server release];
	
	
	server = [[TCPServer alloc] init];
	server.delegate = self;
	
	[connected setStringValue: @" status: waiting for client" ];
	
	[server startWithName:testServerName];
}

-(IBAction) onConnectToServer:(id)sender
{
	[serverBrowser stopBrowse];
	[serverBrowser release];
	
	serverBrowser = [[TCPServerBrowser alloc] init];
	serverBrowser.delegate = self;
	[serverBrowser startBrowse];
	
}

- (void)serverListDidChange
{
	if([serverBrowser.serverList count] > 0)
	{
		NSNetService* netService = [serverBrowser.serverList objectAtIndex:0];
		if( [testServerName compare:netService.name] == NSOrderedSame )
		{
			if([serverBrowser.serverList count] > 1)
				netService = [serverBrowser.serverList objectAtIndex:1];
			else
				return;
		}
		
		TCPConnectionPoint* connectionPoint = [[TCPConnectionPoint alloc] initWithNetService:netService];
		BOOL isConnected = [connectionPoint connect];
		if(isConnected)
		{
			[conn release];
			conn = connectionPoint;
			[serverBrowser stopBrowse];
			[serverBrowser release];
			serverBrowser = nil;
			
			[connected setStringValue: @"status: connected to server !!!" ];
		}
	}
}


-(IBAction) onGo:(id)sender
{
	int a = [angle intValue];
	int p = [power intValue];
	
	NSMutableDictionary* packet = [[NSMutableDictionary alloc] init];
	[packet setObject:@"aimer" forKey:@"type"];
	[packet setObject:@"aim" forKey:@"cmd"];
	[packet setObject:[NSNumber numberWithInt:a] forKey:@"angle"];
	[packet setObject:[NSNumber numberWithInt:p] forKey:@"power"];
	
	[conn sendNetworkPacket:packet];
	[packet release];
}

-(IBAction) onFire:(id)sender
{
	int a = [angle intValue];
	int p = [power intValue];
	
	NSMutableDictionary* packet = [[NSMutableDictionary alloc] init];
	[packet setObject:@"aimer" forKey:@"type"];
	[packet setObject:@"fire" forKey:@"cmd"];
	[packet setObject:[NSNumber numberWithInt:a] forKey:@"angle"];
	[packet setObject:[NSNumber numberWithInt:p] forKey:@"power"];
	
	[conn sendNetworkPacket:packet];
	[packet release];
}

- (void) server:(TCPServer*)server didFailWithError:(TCPServerErrorCode)error
{
	[connected setStringValue: @"status: connection filed ... " ];

}

- (void) serverDidAcceptConnection:(TCPConnectionPoint*)connectionPoint
{
	[conn release];
	[connected setStringValue: @"status: client connected!!!" ];
	conn = connectionPoint;
	[conn retain];
}





@end
