//
//  ServerListController.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPServerBrowser.h"
#import "TCPServer.h"

@class TCPServer;
@class TCPServerBrowser;

@interface ServerListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TCPServerDelegate, TCPServerBrowserDelegate>
{
	UITableView* serverListView;
	
	TCPServer* server;
	TCPServerBrowser* serverBrowser;
	
	UIView* loginView;
	UITextField* usernameTextField;
}

@end

