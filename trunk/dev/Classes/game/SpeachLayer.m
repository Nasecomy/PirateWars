//
//  SpeachLayer.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SpeachLayer.h"
#import "Skin.h"
#import "GameSystem.h"
#import "Level.h"
#import "GameScene.h"
#import "Effect.h"
#import "Team.h"
#import "Hero.h"
#import "GameHelperLayer.h"


/*@implementation SpeachLayer

-(id) init
{
	if([super init])
	{
		isTouchEnabled = YES;		

		ALevel* level = [[GameSystem sharedGame] getLevel];
		NSDictionary* speachProperties = [(GameLevel*)level getSpeachesProp];
		
		if(speachProperties!=nil)
		{
			NSString* skinName = [speachProperties objectForKey:@"skin"];
			if(skinName!=nil)
				speaches = [[ASkin skinWithName:skinName] retain];	
			
			skinArray = [speachProperties objectForKey:@"positions"];
		}
		
		[self addChild:[speaches node] z:100];
		
	    [speaches setUnVisibil];
		
		iCurrentSpeach = 0;
		
		return self;
	}
	
	return nil;
}

-(void) setTimerToSpech
{
	[self schedule:@selector(updateTimerToSpech:) interval:2.0];
}

- (BOOL)ccTouchesBegan:(NSMutableSet *)touches withEvent:(UIEvent *)event
{	
	if(isTouchEnabled)
	{
		//[self makeAllUnVisible];
		WarScene* wscene =  (WarScene*)([GameSystem sharedGame].gameScene);			
		GameHelperLayer* helperLayer = [wscene helperLayer];
		[helperLayer makeLevelTextUnVisible];
		
	    isTouchEnabled = NO;
	   
		//[self schedule:@selector(moveToLeft:)];
		//[self setTimerToSpech];
		[self schedule:@selector(activateTeam:) interval:0.0];
		
		return YES;
	}
	
    return NO;	
}

-(void) moveToRight:(ccTime)delta
{
	
	CGFloat sceneSize = [[GameSystem sharedGame].gameScene size].width;
	
	CGFloat velosity =  sceneSize/2.0;
	CGFloat distance = delta*velosity;
	
	CGFloat pos = [[GameSystem sharedGame].gameScene getPosition];
	
	if(pos >= -sceneSize+500)
	     [[GameSystem sharedGame].gameScene moveTo: distance];
    else 
	{
		[self unschedule: @selector(moveToRight:)];
		[self schedule:@selector(moveToLeft:)];

	}

}

-(void) moveToLeft:(ccTime)delta
{	
	CGFloat sceneSize = [[GameSystem sharedGame].gameScene size].width;
	GLint winSize = [[Director sharedDirector] winSize].width;
	
	CGFloat velosity = 0;
	
	if (iDistance < winSize/2)
		velosity = sceneSize/10.0;
	else 
		velosity = sceneSize;
	
	if (iDistance > (sceneSize - winSize - winSize/2))
		velosity = sceneSize/10.0;
	
	CGFloat distance = delta*velosity;
	
	CGFloat pos = [[GameSystem sharedGame].gameScene getPosition];
	
	if(pos < -40)
		[[GameSystem sharedGame].gameScene moveTo: -distance];
    else 
	{
		[self unschedule: @selector(moveToLeft:)];
	    [self setTimerToSpech];
		//[self schedule:@selector(activateTeam:) interval:0.0];
	}
	
	iDistance += distance;
}


-(void) activateTeam:(int)delta
{
	ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
	[activeTeam activate];
	[self unschedule: @selector(activateTeam:)];
}

-(void) updateTimerToSpech:(int)delta
{
	if(iCurrentSpeach == [speaches getSize])
	{ 
		[speaches setVisibility:NO];
		[self unschedule: @selector(updateTimerToSpech:)];

		[self schedule:@selector(activateTeam:) interval:1.0];
		return;
	}
	
	int index = [[skinArray objectAtIndex:iCurrentSpeach] intValue];
	
	ATeam* t = nil;
	if(index < 0)	
		t = [GameSystem sharedGame].team1;
	else
		t = [GameSystem sharedGame].team2;
	
	int i = fabs(index)-1;
	AHero* h = [t getHero:i];
		
	if(h != nil)
	{
		[speaches setVisibilIndex:iCurrentSpeach];
		[h setSpeachMode];	
	}
			
	
	if(index > 0)
	{
	    CGSize screenSize = [[Director sharedDirector] winSize];
	    CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
	    //[[GameSystem sharedGame].gameScene scrollTo:sceneSize.width-screenSize.width];
		
		if(h!=nil)
		{
            int pos = cpfmin( sceneSize.width-screenSize.width, [h getHeroPosition].x - screenSize.width/2);
			[[GameSystem sharedGame].gameScene scrollTo:pos];
		}
	}
	else
	{
		[[GameSystem sharedGame].gameScene scrollTo:0];
	}
	
	
	iCurrentSpeach++;	
	
}

@end
 */



@implementation SpeachLayer

-(id) init
{
	if([super init])
	{
		isTouchEnabled = YES;		
		ALevel* level = [[GameSystem sharedGame] getLevel];
		NSDictionary* speachProperties = [(GameLevel*)level getSpeachesProp];
		
		if(speachProperties!=nil)
		{
			NSString* skinName = [speachProperties objectForKey:@"skin"];
			if(skinName!=nil)
				speaches = [[ASkin skinWithName:skinName] retain];	
			
			skinArray = [speachProperties objectForKey:@"positions"];
		}
		
		[self addChild:[speaches node] z:100];
		
	    [speaches setUnVisibil];
		
		iCurrentSpeach = 0;
		
		return self;
	}
	
	return nil;
}


-(void) setTimerToSpech
{
	[self schedule:@selector(updateTimerToSpech:) interval:2];
}

- (BOOL)ccTouchesBegan:(NSMutableSet *)touches withEvent:(UIEvent *)event
{	
	if(isTouchEnabled)
	{
		WarScene* wscene =  (WarScene*)([GameSystem sharedGame].gameScene);			
		GameHelperLayer* helperLayer = [wscene helperLayer];
		[helperLayer makeLevelTextUnVisible];
		
	    isTouchEnabled = NO;
		
		[self schedule:@selector(moveToLeft:)];
		//[self schedule:@selector(activateTeam:) interval:0.0];
		
		return YES;
	}
	
    return NO;	
}

-(void) moveToRight:(ccTime)delta
{
	
	CGFloat sceneSize = [[GameSystem sharedGame].gameScene size].width;
	
	CGFloat velosity =  sceneSize/2.0;
	CGFloat distance = delta*velosity;
	
	CGFloat pos = [[GameSystem sharedGame].gameScene getPosition];
	
	if(pos >= -sceneSize+500)
		[[GameSystem sharedGame].gameScene moveTo: distance];
    else 
	{
		[self unschedule: @selector(moveToRight:)];
		[self schedule:@selector(moveToLeft:)];
		
	}
	
}

-(void) moveToLeft:(ccTime)delta
{	
	CGFloat sceneSize = [[GameSystem sharedGame].gameScene size].width;
	GLint winSize = [[Director sharedDirector] winSize].width;
	
	CGFloat velosity = 0;
	
	if (iDistance < winSize/2)
		velosity = sceneSize/10.0;
	else 
		velosity = sceneSize;
	
	if (iDistance > (sceneSize - winSize - winSize/2))
		velosity = sceneSize/10.0;
	
	CGFloat distance = delta*velosity;
	
	CGFloat pos = [[GameSystem sharedGame].gameScene getPosition];
	
	if(pos < -40)
		[[GameSystem sharedGame].gameScene moveTo: -distance];
    else 
	{
		[self unschedule: @selector(moveToLeft:)];
	    [self setTimerToSpech];
		//[self schedule:@selector(activateTeam:) interval:0.0];
	}
	
	iDistance += distance;
}


-(void) activateTeam:(int)delta
{
	ATeam* activeTeam = [[GameSystem sharedGame] activeTeam];
	[activeTeam activate];
	[self unschedule: @selector(activateTeam:)];
}

-(void) updateTimerToSpech:(int)delta
{
	//currentPosition=0;
	
	
	if(iCurrentSpeach == [speaches getSize])
	{ 
		[speaches setVisibility:NO];
		[self unschedule: @selector(updateTimerToSpech:)];
		
		[self schedule:@selector(activateTeam:) interval:1.0];
		return;
	}
	
	
	int index = [[skinArray objectAtIndex:iCurrentSpeach] intValue];
	
	ATeam* t = nil;
	if(index < 0)	
		t = [GameSystem sharedGame].team1;
	else
		t = [GameSystem sharedGame].team2;
	
	int i = fabs(index)-1;
	AHero* h = [t getHero:i];
	
	if(h != nil)
	{
		[speaches setVisibilIndex:iCurrentSpeach];
		[h setSpeachMode];	
	}
	
	
	if(index > 0)
	{
	    CGSize screenSize = [[Director sharedDirector] winSize];
	    CGSize sceneSize = [[GameSystem sharedGame].gameScene size];
		
		if(h!=nil)
		{
            nextPosition = cpfmin( sceneSize.width-screenSize.width, [h getHeroPosition].x - screenSize.width/2);
		}
	}
	else
	{
		nextPosition = 0;
	}
	
	iDistance =0;
	[self schedule:@selector(movingAction:)];
	
	
	iCurrentSpeach++;	
	
}

-(void) movingAction:(ccTime)delta
{	
	CGFloat velosity = 0;
	
	CGFloat pos = [[GameSystem sharedGame].gameScene getPosition];
	pos = -pos;
	
	int total = nextPosition - pos;
	int moduleTotal = fabs(total);
	
	if((iDistance < 50) )
		velosity = 150;
	else velosity = 1500;
	
	if(moduleTotal <= 150)
	{
		velosity =150;
	}
	
	CGFloat distance = delta*velosity;
	
	if( (pos < (nextPosition +20)) && (pos >( nextPosition -20)) )
	{
		[self unschedule: @selector(movingAction:)];
	    [self setTimerToSpech];
	}
	else 
	{
		if(total>=0)
			[[GameSystem sharedGame].gameScene moveTo: distance];
		else [[GameSystem sharedGame].gameScene moveTo: -distance];
		
	}
	
	iDistance += distance;
}


@end


