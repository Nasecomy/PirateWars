//
//  SpeachLayer.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class ASkin;
@class StaticSkin;

/*@interface SpeachLayer  : Layer
{
	ASkin* speaches;
	NSArray* skinArray;
    int iCurrentSpeach;
	//ASkin* parSkin;
	GLint iDistance;
}

@end
*/

@interface SpeachLayer  : Layer
{
	ASkin* speaches;
	NSArray* skinArray;
    int iCurrentSpeach;
	GLint iDistance;
	int nextPosition;
}

@end
