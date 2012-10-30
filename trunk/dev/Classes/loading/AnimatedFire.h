//
//  FireSprite.h
//  PiratesWar
//
//  Created by Vladimir Demkovich on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface FireSprite : Sprite
{
	Animation *fireAnimation;
	
	int frameCount;
}

@property (nonatomic, retain) Animation *fireAnimation;

@end
