//
//  TCPConnectionPoint.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TCPConnectionPoint.h"
#import <CFNetwork/CFSocketStream.h>


void readStreamEventHandler(CFReadStreamRef stream, CFStreamEventType eventType, void *info);
void writeStreamEventHandler(CFWriteStreamRef stream, CFStreamEventType eventType, void *info);

@interface TCPConnectionPoint ()

@property(nonatomic,retain) NSString* host;
@property(nonatomic,assign) int port;
@property(nonatomic,assign) CFSocketNativeHandle connectedSocketHandle;
@property(nonatomic,retain) NSNetService* netService;

- (void)clean;
- (BOOL)setupSocketStreams;
- (void)readStreamHandleEvent:(CFStreamEventType)event;
- (void)writeStreamHandleEvent:(CFStreamEventType)event;
- (void)readFromStreamIntoIncomingBuffer;
- (void)writeOutgoingBufferToStream;

@end

@implementation TCPConnectionPoint

@synthesize delegate;
@synthesize host, port;
@synthesize connectedSocketHandle;
@synthesize netService;


- (void)clean 
{  
	readStream = nil;
	readStreamOpen = NO;
	
	writeStream = nil;
	writeStreamOpen = NO;
	
	incomingDataBuffer = nil;
	outgoingDataBuffer = nil;
	
	self.netService = nil;
	self.host = nil;
	connectedSocketHandle = -1;
	packetBodySize = -1;
}

- (void)dealloc 
{
	self.netService = nil;
	self.host = nil;
	self.delegate = nil;
	
	[super dealloc];
}

- (id)initWithHostAddress:(NSString*)_host andPort:(int)_port 
{
	[self clean];
	self.host = _host;
	self.port = _port;
	return self;
}

- (id)initWithNativeSocketHandle:(CFSocketNativeHandle)nativeSocketHandle 
{
	[self clean];
	self.connectedSocketHandle = nativeSocketHandle;
	return self;
}

- (id)initWithNetService:(NSNetService*)_netService 
{
	[self clean];
	if ( _netService.hostName != nil ) 
	{
		return [self initWithHostAddress:_netService.hostName andPort:_netService.port];
	}
	
	self.netService = _netService;
	return self;
}

- (BOOL)connect 
{
	if ( self.host != nil ) 
	{
		CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)self.host, self.port, &readStream, &writeStream);
		return [self setupSocketStreams];
	}
	else if ( self.connectedSocketHandle != -1 ) 
	{
		CFStreamCreatePairWithSocket(kCFAllocatorDefault, self.connectedSocketHandle, &readStream, &writeStream);
		return [self setupSocketStreams];
	}
	else if ( netService != nil ) 
	{
		if ( netService.hostName != nil ) 
		{
			CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)netService.hostName, netService.port, &readStream, &writeStream);
			return [self setupSocketStreams];
		}
		
		netService.delegate = self;
		[netService resolveWithTimeout:5.0];
		return YES;
	}
	
	return NO;
}

- (BOOL)setupSocketStreams 
{
	if ( readStream == nil || writeStream == nil ) 
	{
		[self close];
		return NO;
	}
	
	incomingDataBuffer = [[NSMutableData alloc] init];
	outgoingDataBuffer = [[NSMutableData alloc] init];
	
	CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	
	CFOptionFlags registeredEvents = kCFStreamEventOpenCompleted |
	kCFStreamEventHasBytesAvailable | kCFStreamEventCanAcceptBytes |
	kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred;
	
	CFStreamClientContext ctx = {0, self, NULL, NULL, NULL};
	
	CFReadStreamSetClient(readStream, registeredEvents, readStreamEventHandler, &ctx);
	CFWriteStreamSetClient(writeStream, registeredEvents, writeStreamEventHandler, &ctx);
	
	CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	
	if ( ! CFReadStreamOpen(readStream) || ! CFWriteStreamOpen(writeStream)) 
	{
		[self close];
		return NO;
	}
	
	return YES;
}

- (void)close 
{
	if ( readStream != nil ) 
	{
		CFReadStreamUnscheduleFromRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFReadStreamClose(readStream);
		CFRelease(readStream);
		readStream = NULL;
	}
	
	if ( writeStream != nil ) 
	{
		CFWriteStreamUnscheduleFromRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFWriteStreamClose(writeStream);
		CFRelease(writeStream);
		writeStream = NULL;
	}
	
	[incomingDataBuffer release];
	incomingDataBuffer = NULL;
	
	[outgoingDataBuffer release];
	outgoingDataBuffer = NULL;
	
	if ( netService != nil ) 
	{
		[netService stop];
		self.netService = nil;
	}
	
	[self clean];
}

- (void)sendNetworkPacket:(NSDictionary*)packet 
{
	NSData* rawPacket = [NSKeyedArchiver archivedDataWithRootObject:packet];
	int packetLength = [rawPacket length];
	[outgoingDataBuffer appendBytes:&packetLength length:sizeof(int)];
	[outgoingDataBuffer appendData:rawPacket];
	[self writeOutgoingBufferToStream];
}

void readStreamEventHandler(CFReadStreamRef stream, CFStreamEventType eventType, void *info) 
{
	TCPConnectionPoint* connection = (TCPConnectionPoint*)info;
	[connection readStreamHandleEvent:eventType];
}

- (void)readStreamHandleEvent:(CFStreamEventType)event 
{
	if ( event == kCFStreamEventOpenCompleted ) 
	{
		readStreamOpen = YES;
	}
	else if ( event == kCFStreamEventHasBytesAvailable ) 
	{
		[self readFromStreamIntoIncomingBuffer];
	}
	else if ( event == kCFStreamEventEndEncountered || event == kCFStreamEventErrorOccurred ) 
	{
		[self close];
		if ( !readStreamOpen || !writeStreamOpen ) 
		{
			[delegate connectionAttemptFailed:self];
		}
		else 
		{
			[delegate connectionTerminated:self];
		}
	}
}

- (void)readFromStreamIntoIncomingBuffer 
{
	UInt8 buf[1024];
	
	while( CFReadStreamHasBytesAvailable(readStream) ) 
	{  
		CFIndex len = CFReadStreamRead(readStream, buf, sizeof(buf));
		if ( len <= 0 ) 
		{
			[self close];
			[delegate connectionTerminated:self];
			return;
		}
		[incomingDataBuffer appendBytes:buf length:len];
	}
	
	while( YES ) 
	{
		if ( packetBodySize == -1 ) 
		{
			if ( [incomingDataBuffer length] >= sizeof(int) ) 
			{
				memcpy(&packetBodySize, [incomingDataBuffer bytes], sizeof(int));
				NSRange rangeToDelete = {0, sizeof(int)};
				[incomingDataBuffer replaceBytesInRange:rangeToDelete withBytes:NULL length:0];
			}
			else 
			{
				break;
			}
		}
		
		if ( [incomingDataBuffer length] >= packetBodySize ) 
		{
			NSData* raw = [NSData dataWithBytes:[incomingDataBuffer bytes] length:packetBodySize];
			NSDictionary* packet = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
			
			[delegate connection:self didReceivePacket:packet];
			
			NSRange rangeToDelete = {0, packetBodySize};
			[incomingDataBuffer replaceBytesInRange:rangeToDelete withBytes:NULL length:0];
			
			packetBodySize = -1;
		}
		else 
		{
			break;
		}
	}
}

void writeStreamEventHandler(CFWriteStreamRef stream, CFStreamEventType eventType, void *info) 
{
	TCPConnectionPoint* connection = (TCPConnectionPoint*)info;
	[connection writeStreamHandleEvent:eventType];
}


- (void)writeStreamHandleEvent:(CFStreamEventType)event 
{
	if ( event == kCFStreamEventOpenCompleted ) 
	{
		writeStreamOpen = YES;
	}
	else if ( event == kCFStreamEventCanAcceptBytes ) 
	{
		[self writeOutgoingBufferToStream];
	}
	else if ( event == kCFStreamEventEndEncountered || event == kCFStreamEventErrorOccurred ) 
	{
		[self close];
		
		if ( !readStreamOpen || !writeStreamOpen ) 
		{
			[delegate connectionAttemptFailed:self];
		}
		else 
		{
			[delegate connectionTerminated:self];
		}
	}
}

- (void)writeOutgoingBufferToStream 
{
	if ( !readStreamOpen || !writeStreamOpen ) 
	{
		return;
	}
	
	if ( [outgoingDataBuffer length] == 0 ) 
	{
		return;
	}
	
	if ( !CFWriteStreamCanAcceptBytes(writeStream) ) 
	{ 
		return;
	}
	
	CFIndex writtenBytes = CFWriteStreamWrite(writeStream, [outgoingDataBuffer bytes], [outgoingDataBuffer length]);
	
	if ( writtenBytes == -1 ) 
	{
		[self close];
		[delegate connectionTerminated:self];
		return;
	}
	
	NSRange range = {0, writtenBytes};
	[outgoingDataBuffer replaceBytesInRange:range withBytes:NULL length:0];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict 
{
	if ( sender == netService ) 
	{
		[delegate connectionAttemptFailed:self];
		[self close];
	}
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender 
{
	if ( sender != netService ) 
	{
		return;
	}
	
	self.host = netService.hostName;
	self.port = netService.port;
	self.netService = nil;
	
	if ( ![self connect] ) 
	{
		[delegate connectionAttemptFailed:self];
		[self close];
	}
}

@end
