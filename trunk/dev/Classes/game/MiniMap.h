//
//  MiniMap.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@class ASkin;

@interface MiniMap : CocosNode 
{
	ASkin* mapSkin;
	
	NSArray* lifeIndicatorSprites1;
	NSArray* lifeIndicatorSprites2;
	NSArray* crossSprites1;
	NSArray* crossSprites2;
}

+(id)mapWithProperties:(NSDictionary*)properties;

-(id)initWithProperties:(NSDictionary*)properties;
-(void)updateHeroLifes:(NSArray*)helthArray1 lifes:(NSArray*)helthArray2;



@end
