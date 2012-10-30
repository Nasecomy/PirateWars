//
//  Effect.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Effect.h"
#import "Skin.h"

@implementation AnEffect

-(void)applyToParent:(CocosNode*)parent
{
}

@end


@implementation VisualEffect

-(id)initWithSkin:(ASkin*)s duration:(CGFloat)d
{
	[super init];
	skin = [s retain];
	duration = d;
	return self;
}

-(void)endingCallback
{
	[parent removeChild:self cleanup:YES];
}

-(void)applyToParent:(CocosNode*)parentNode
{
	[parentNode addChild:self];
	[skin addToParent:self z:0];
	if(duration>0)
	{
		id delayAction = [DelayTime actionWithDuration:duration];
		id endAction = [CallFunc actionWithTarget:self selector: @selector(endingCallback)];
		[self runAction: [Sequence actionOne:delayAction two:endAction]];	
	}
}

-(void) dealloc
{
	[skin release];
	[super dealloc];
}

@end




@implementation VisualTargetEffect

-(id)initWithSkin:(ASkin*)s duration:(CGFloat)d endingFunction:(id)func
{
	[super init];
	skin = [s retain];
	duration = d;
	endFunction = func;
	return self;
}

-(void)endingCallback
{
	[self runAction:endFunction];
	[parent removeChild:self cleanup:YES];
}

-(void)applyToParent:(CocosNode*)parentNode
{
	[parentNode addChild:self];
	[skin addToParent:self z:0];
	if(duration>0)
	{
		id delayAction = [DelayTime actionWithDuration:duration];
		id endAction = [CallFunc actionWithTarget:self selector: @selector(endingCallback)];
		[self runAction: [Sequence actionOne:delayAction two:endAction]];	
	}
}

-(void) dealloc
{
	[skin release];
	[super dealloc];
}

@end

