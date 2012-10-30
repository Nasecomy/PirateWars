//
//  LifeIndicator.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"


@interface LifeIndicator : CocosNode 
{
	AtlasSprite* lifeSprite;
	Label* lifeValue;
}

-(void) setLifeValue:(int)value;

@end

