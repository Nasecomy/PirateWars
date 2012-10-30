//
//  TCPServer.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TCPServer.h"
#import "TCPConnectionPoint.h"

#include <CFNetwork/CFSocketStream.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>


@interface TCPServer()

@property(nonatomic,assign) uint16_t port;
@property(nonatomic,retain) NSNetService* netService;

- (BOOL)createServer;
- (void)terminateServer;

- (BOOL)publishServiceWithName:(NSString*) serviceName;
- (void)unpublishService;

@end


@implementation TCPServer

@synthesize delegate;
@synthesize port;
@synthesize netService;


- (BOOL)startWithName:(NSString*)serviceName 
{
	if ( [self createServer] ) 
	{
		if ( [self publishServiceWithName:serviceName] )
		{
			return YES;
		}

		[self terminateServer];
	}

	return NO;
}


- (void)stop 
{
	[self terminateServer];
	[self unpublishService];
}


- (void)handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle 
{
	TCPConnectionPoint* connection = [[[TCPConnectionPoint alloc] initWithNativeSocketHandle:nativeSocketHandle] autorelease];
	
	if ( connection == nil ) 
	{
		close(nativeSocketHandle);
		return;
	}
	
	if ( ! [connection connect] ) 
	{
		[connection close];
		return;
	}
	
	[delegate serverDidAcceptConnection:connection];
}


static void serverAcceptCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) 
{
	TCPServer *server = (TCPServer*)info;
	
	if ( type == kCFSocketAcceptCallBack ) 
	{
		CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle*)data;
		[server handleNewNativeSocket:nativeSocketHandle];
	}
}

- (BOOL)createServer 
{
	CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
	
	listeningSocket = CFSocketCreate( kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&serverAcceptCallback, &socketCtxt );
	if ( listeningSocket == NULL ) 
	{
		return NO;
	}
	
	int existingValue = 1;
	setsockopt( CFSocketGetNative(listeningSocket), SOL_SOCKET, SO_REUSEADDR, (void *)&existingValue, sizeof(existingValue));
	
	struct sockaddr_in socketAddress;
	memset(&socketAddress, 0, sizeof(socketAddress));
	socketAddress.sin_len = sizeof(socketAddress);
	socketAddress.sin_family = AF_INET; 
	socketAddress.sin_port = 0;
	socketAddress.sin_addr.s_addr = htonl(INADDR_ANY);
	
	NSData *socketAddressData = [NSData dataWithBytes:&socketAddress length:sizeof(socketAddress)];
	
	if ( CFSocketSetAddress(listeningSocket, (CFDataRef)socketAddressData) != kCFSocketSuccess ) 
	{
		if ( listeningSocket != NULL ) 
		{
			CFRelease(listeningSocket);
			listeningSocket = NULL;
		}
		return NO;
	}
	
	NSData *socketAddressActualData = [(NSData *)CFSocketCopyAddress(listeningSocket) autorelease];
	
	struct sockaddr_in socketAddressActual;
	memcpy(&socketAddressActual, [socketAddressActualData bytes], [socketAddressActualData length]);
	
	self.port = ntohs(socketAddressActual.sin_port);
	
	CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
	CFRunLoopSourceRef runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, listeningSocket, 0);
	CFRunLoopAddSource(currentRunLoop, runLoopSource, kCFRunLoopCommonModes);
	CFRelease(runLoopSource);
	
	return YES;
}


- (void) terminateServer 
{
	if ( listeningSocket != nil ) 
	{
		CFSocketInvalidate(listeningSocket);
		CFRelease(listeningSocket);
		listeningSocket = nil;
	}
}

- (BOOL) publishServiceWithName:(NSString*)serviceName
{
 	self.netService = [[NSNetService alloc] initWithDomain:@"" type:@"_pw._tcp." name:serviceName port:self.port];
	if (self.netService != nil)
	{
		[self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		[self.netService setDelegate:self];
		[self.netService publish];
		return YES;
	}
	return NO;
}

- (void) unpublishService 
{
	if ( self.netService != nil ) 
	{
		[self.netService stop];
		[self.netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		self.netService = nil;
	}
}

- (void)netService:(NSNetService*)sender didNotPublish:(NSDictionary*)errorDict 
{
	if ( sender == self.netService ) 
	{
		[self terminateServer];
		[self unpublishService];
		[delegate server:self didFailWithError:kBonjourPublishingFiled];
	}
}

@end
