//
//  TCPConnectionPoint.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCPConnectionPoint;

@protocol TCPConnectionDelegate

- (void) connectionAttemptFailed:(TCPConnectionPoint*)connection;
- (void) connectionTerminated:(TCPConnectionPoint*)connection;
- (void) connection:(TCPConnectionPoint*)connection didReceivePacket:(NSDictionary*)packet;

@end


@interface TCPConnectionPoint : NSObject 
{
	id<TCPConnectionDelegate> delegate;
	
	NSString* host;
	int port;
	
	CFSocketNativeHandle connectedSocketHandle;
	
	NSNetService* netService;
	
	CFReadStreamRef readStream;
	bool readStreamOpen;
	NSMutableData* incomingDataBuffer;
	int packetBodySize;
	
	CFWriteStreamRef writeStream;
	bool writeStreamOpen;
	NSMutableData* outgoingDataBuffer;
}


@property(nonatomic,retain) id<TCPConnectionDelegate> delegate;

- (id)initWithHostAddress:(NSString*)host andPort:(int)port;
- (id)initWithNativeSocketHandle:(CFSocketNativeHandle)nativeSocketHandle;
- (id)initWithNetService:(NSNetService*)netService;
- (BOOL)connect;
- (void)close;
- (void)sendNetworkPacket:(NSDictionary*)packet;

@end
