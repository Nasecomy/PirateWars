//
//  AnAimer.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AimerProtocol
-(void) didChangeAngle:(CGFloat)angle;
-(void) didChangePower:(CGFloat)power;
-(CGFloat) aimerAngle;
-(CGFloat) aimerPower;
@optional
-(void) didCompleteAiming;
@end


@interface AnAimer : NSObject 
{
	CGFloat angle;
	CGFloat power;
}

+(AnAimer*) aimerWithName:(NSString*)className;

-(void) takeAim;
-(CGFloat) getAngle;
-(CGFloat) getPower;

@end

@interface AIAimer :AnAimer <AimerProtocol>
{
	id scheduler;
}
	
@end

@interface ManualAimer :AnAimer <AimerProtocol>
{
}
@end


@interface NetworkMasterAimer : ManualAimer
{
	
}

+(NSDictionary*) packetAimWithAngle:(int)a power:(int)p;
+(NSDictionary*) packetFire;

@end


@interface NetworkSlaveAimer :AnAimer <AimerProtocol>
{
	
}

+(void)translateNetworkPacket:(NSDictionary*)packet;

@end


