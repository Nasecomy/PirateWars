//
//  ServerListController.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ServerListViewController.h"

#import "TCPServer.h"
#import "TCPServerBrowser.h"
#import "TCPConnectionPoint.h"
#import "GameSystem.h"

@implementation ServerListViewController

-(void) initNetworkWithServerName:(NSString*)serverName
{
	
	server = [[TCPServer alloc] init];
	if(server!=nil)
	{
		server.delegate = self;
		if(![server startWithName:serverName])
		{
			[server release];
			server = nil;
		}
	}
	
	serverBrowser = [[TCPServerBrowser alloc] init];
	serverBrowser.delegate = self;
	[serverBrowser startBrowse];
}

-(void)loadView
{
	UIView* view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	view.backgroundColor = [UIColor whiteColor];
	self.view = view;
	[view release];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20,20,150,50)];
	[label setText:@"Choose server:"];
	[view addSubview:label];
	[label release];
	
	
	serverListView = [[UITableView alloc] initWithFrame:CGRectMake(200,20, 250, 280) style:UITableViewStylePlain];
	serverListView.delegate = self;
	serverListView.dataSource = self;
	[view addSubview:serverListView];
	

	NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
	
	if( [username length] >0 )
	{
		[self initNetworkWithServerName:username];
	}
	else
	{
		loginView = [[UIView alloc] initWithFrame:CGRectMake(0,0,480,320)];
		loginView.backgroundColor = [UIColor lightGrayColor];
		[self.view addSubview:loginView];
		[loginView release];
		
		UILabel* userlabel = [[UILabel alloc] initWithFrame:CGRectMake(40,40,80,30)];
		[userlabel setText:@"Name:"];
		[loginView addSubview:userlabel];
		[userlabel release];
		
		
		usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(140,40,180,30)];
		usernameTextField.borderStyle = UITextBorderStyleBezel;
		usernameTextField.placeholder = @"<enter text>";
		usernameTextField.backgroundColor = [UIColor whiteColor];
		usernameTextField.returnKeyType = UIReturnKeyDone;
		[loginView addSubview:usernameTextField];
		[usernameTextField release];	
		
		
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(400, 40, 60, 30)];
		button.backgroundColor = [UIColor grayColor];
		[button setTitle:@"OK" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(onLoginOk:) forControlEvents:UIControlEventTouchUpInside];
		[loginView addSubview:button];
		[button release];
	}	
}


- (void)onLoginOk:(id)sender
{
	if([usernameTextField.text length] > 0)
	{
		[[NSUserDefaults standardUserDefaults] setObject:usernameTextField.text forKey:@"username"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self initNetworkWithServerName:usernameTextField.text];
		[loginView removeFromSuperview];
	}
}


-(void)viewDidAppear:(BOOL)animated
{
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [serverBrowser.serverList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	
	NSNetService* netService = [serverBrowser.serverList objectAtIndex:indexPath.row];
	cell.textLabel.text = [netService name];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNetService* netService = [serverBrowser.serverList objectAtIndex:indexPath.row];
	TCPConnectionPoint* connectionPoint = [[TCPConnectionPoint alloc] initWithNetService:netService];
	BOOL connected = [connectionPoint connect];
	if(connected)
	{
		[GameSystem sharedGame].connectionPoint = connectionPoint;
		[connectionPoint release];

		[self.view removeFromSuperview];
		[[GameSystem sharedGame] startNewGame:kClientModeGame];
	}
}

- (void) server:(TCPServer*)server didFailWithError:(TCPServerErrorCode)error
{
	
}

- (void) serverDidAcceptConnection:(TCPConnectionPoint*)connectionPoint
{
	[GameSystem sharedGame].connectionPoint = connectionPoint;
	[self.view removeFromSuperview];
	[[GameSystem sharedGame] startNewGame:kServerModeGame];
}

- (void)serverListDidChange
{
	[serverListView reloadData];
}

-(void) dealloc
{
	[serverBrowser stopBrowse];
	[serverBrowser release];
	
	[server stop];
	[server release];

	[super dealloc];
}

@end

