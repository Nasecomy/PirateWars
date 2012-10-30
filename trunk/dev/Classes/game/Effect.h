//
//  Effect.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@class ASkin;

@interface AnEffect : CocosNode 
{
}

-(void)applyToParent:(CocosNode*)parent;

@end

@interface VisualEffect : AnEffect 
{
	ASkin* skin;
	CGFloat duration;
}

-(id)initWithSkin:(ASkin*)s duration:(CGFloat)d;

@end


@interface VisualTargetEffect : VisualEffect 
{
	id endFunction;
}

-(id)initWithSkin:(ASkin*)s duration:(CGFloat)d endingFunction:(id)func;

@end