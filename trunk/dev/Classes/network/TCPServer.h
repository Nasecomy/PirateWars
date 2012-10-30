//
//  TCPServer.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TCPServer;
@class TCPConnectionPoint;

typedef enum eTCPServerErrorCode
{
	kServerOK,
	kBonjourPublishingFiled,
} TCPServerErrorCode;

@protocol TCPServerDelegate

- (void) server:(TCPServer*)server didFailWithError:(TCPServerErrorCode)error;
- (void) serverDidAcceptConnection:(TCPConnectionPoint*)connectionPoint;

@end


@interface TCPServer : NSObject 
{
    uint16_t port;
    CFSocketRef listeningSocket;
    id<TCPServerDelegate> delegate;
    NSNetService* netService;
	
}

@property(nonatomic,retain) id<TCPServerDelegate> delegate;

- (BOOL)startWithName:(NSString*)serviceName;
- (void)stop;


@end
