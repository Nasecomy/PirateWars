//
//  MainWindowController.h
//  tcptest
//
//  Created by Vladimir Demkovich on 9/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "TCPServer.h"
#import "TCPConnectionPoint.h"
#import "TCPServerBrowser.h"

@interface MainWindowController : NSObject<TCPServerDelegate, TCPServerBrowserDelegate>
{
	IBOutlet NSTextField* power;
	IBOutlet NSTextField* angle;
	IBOutlet NSTextField* connected;
	IBOutlet NSButton* goBtn;

	TCPServer* server;
	TCPConnectionPoint* conn;
	TCPServerBrowser* serverBrowser;
}

-(IBAction) onGo:(id)sender;
-(IBAction) onFire:(id)sender;

-(IBAction) onConnectToServer:(id)sender;
-(IBAction) onStartServer:(id)sender;

@end

