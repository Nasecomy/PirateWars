//
//  TCPServerBrowser.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TCPServerBrowserDelegate

- (void)serverListDidChange;

@end


@interface TCPServerBrowser : NSObject 
{
	NSNetServiceBrowser* serviceBrowser;
	NSMutableArray* serverList;
	id<TCPServerBrowserDelegate> delegate;
}

@property(nonatomic,readonly) NSMutableArray* serverList;
@property(nonatomic,retain) id<TCPServerBrowserDelegate> delegate;

- (BOOL)startBrowse;
- (void)stopBrowse;

@end
