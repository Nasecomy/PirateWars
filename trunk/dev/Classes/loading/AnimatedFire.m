//
//  FireSprite.m
//  PiratesWar
//
//  Created by Vladimir Demkovich on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "AnimatedFire.h"
#import "PlayerMenuScene.h"

@implementation FireSprite

@synthesize fireAnimation;

- (void) dealloc
{
	[fireAnimation release];
	[super dealloc];
}

-(id) init
{
	self = [super init];
	
	if (self)
	{
		//init the counter that will be incremented to tell what frame of the animation we are on
		frameCount = 0;
		
		//For some reason if you don't start the sprite with an image you can't display the frames of an animation.
		//So we start it out with the first frame of our animation
		[self initWithFile:@"Loading_Fire_01.png"];
		
		//create an Animation object to hold the frame for the walk cycle
		self.fireAnimation = [[Animation alloc] initWithName:@"fireAnimation" delay:0];
		[fireAnimation release];
						
		for( int i=1;i<26;i++)
			[fireAnimation addFrameWithFilename: [NSString stringWithFormat:@"Loading_Fire_%02d.png", i]];

		
		//Add the animation to the sprite so it can access it's frames
		[self addAnimation:fireAnimation];
		
		//Set the anchor point of this sprite to the lower left. Makes positioning easier
		CGSize s = [[Director sharedDirector] winSize];
	    //[self setPosition:ccp(s.width/2, s.height/2)]; 	
		
		//Set the position of the sprite on screen relative to the lower left corner.
		[self setPosition:ccp(s.width/2, s.height/2)]; 
		
		//Create a tick method to be called at the specified interval
		[self schedule: @selector(tick:) interval:0.1];
		
	}
	
	return self;
}

-(void) tick: (ccTime) dt
{	
	//reset frame counter if its past the total frames
	if(frameCount > 24) 
	{
		PlayerMenuScene * gs = [PlayerMenuScene node];
		[[TextureMgr sharedTextureMgr] removeUnusedTextures];
		[[Director sharedDirector] replaceScene:gs];
		return;
	}
	
	//Set the display frame to the frame in the walk animation at the frameCount index
	[self setDisplayFrame:@"fireAnimation" index:frameCount];
	
	//Increment the frameCount for the next time this method is called
	frameCount = frameCount+1;
}

@end
