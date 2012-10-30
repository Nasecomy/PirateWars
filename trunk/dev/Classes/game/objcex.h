//
//  objcex.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSXPoint : NSObject
{
	CGPoint point;
}

@property (nonatomic,assign) CGPoint point;

+(id)pointWithPoint:(CGPoint)p;
-(id)initWithPoint:(CGPoint)p;

@end
