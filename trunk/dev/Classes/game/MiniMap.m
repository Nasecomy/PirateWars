//
//  MiniMap.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MiniMap.h"
#import "Skin.h"

@implementation MiniMap


static const int lifeSpriteSizeWidth = 65;
static const int lifeSpriteSizeHeight = 10;

static NSString* lifeSpriteImg = @"Life_Indicate_u.png"; 
static NSString* lifeSpriteBackImg = @"Life_Indicate_d.png"; 


+(id)mapWithProperties:(NSDictionary*)properties
{
	return [[[MiniMap alloc] initWithProperties:properties] autorelease];	
}

-(id)initWithProperties:(NSDictionary*)properties
{
	if([super init])
	{
		NSString* skinName = [properties objectForKey:@"skin"];
		NSArray* points1 = [properties objectForKey:@"points1"];
		NSArray* points2 = [properties objectForKey:@"points2"];
		
		mapSkin = [[ASkin skinWithName:skinName] retain];
		[mapSkin addToParent:self z:0];
		
		
		
		AtlasSpriteManager* atlasManager = [AtlasSpriteManager spriteManagerWithFile:lifeSpriteImg capacity:8];
		[self addChild:atlasManager z:2];
		atlasManager.anchorPoint = CGPointMake(0,0);
		atlasManager.position = CGPointMake(0, 0);
		
		NSMutableArray* crossSprites = [[NSMutableArray alloc] init];
		NSMutableArray* lifeIndicatorSprites = [[NSMutableArray alloc] init];
		int i;
		for(i=0; i<[points1 count]; i+=2)
		{
			int x = [[points1 objectAtIndex:i] intValue];
			int y = [[points1 objectAtIndex:i+1] intValue];
			
			
			Sprite* cross = [Sprite spriteWithFile:@"cross1.png"];
			[self addChild:cross z:1 tag:0];
			cross.position = ccp(x,y);
			cross.scale = 0.7;
			[crossSprites addObject:cross];
			
			
			/*AtlasSprite* lifeSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, lifeSpriteSizeWidth/2, lifeSpriteSizeHeight) spriteManager: atlasManager];
			lifeSprite.anchorPoint = CGPointMake(0,0);
			lifeSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2, y+30);
			lifeSprite.scale = 0.6;
			[atlasManager addChild:lifeSprite z:1 tag:0];
			[lifeIndicatorSprites addObject:lifeSprite];
			
			Sprite* lifeBackSprite = [Sprite spriteWithFile:lifeSpriteBackImg];
			lifeBackSprite.anchorPoint = CGPointMake(0,0);
			lifeBackSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2, y+30);
			lifeBackSprite.scale = 0.6;
			[self addChild:lifeBackSprite z:0 tag:0];		*/
		
			
			AtlasSprite* lifeSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, lifeSpriteSizeWidth/2, lifeSpriteSizeHeight) spriteManager: atlasManager];
			lifeSprite.anchorPoint = CGPointMake(0,0);
			lifeSprite.scale = 0.5;	
			lifeSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2*lifeSprite.scale, y+30);
			[atlasManager addChild:lifeSprite z:1 tag:0];
			[lifeIndicatorSprites addObject:lifeSprite];
			
			Sprite* lifeBackSprite = [Sprite spriteWithFile:lifeSpriteBackImg];
			lifeBackSprite.anchorPoint = CGPointMake(0,0);
			lifeBackSprite.scale = 0.5;		
			lifeBackSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2*lifeBackSprite.scale, y+30);
			[self addChild:lifeBackSprite z:0 tag:0];
			
		}
		crossSprites1 = crossSprites;
		lifeIndicatorSprites1 = lifeIndicatorSprites;
		
		lifeIndicatorSprites = [[NSMutableArray alloc] init];
		crossSprites = [[NSMutableArray alloc] init];
		for(i=0; i<[points2 count]; i+=2)
		{
			int x = [[points2 objectAtIndex:i] intValue];
			int y = [[points2 objectAtIndex:i+1] intValue];
			
			
			Sprite* cross = [Sprite spriteWithFile:@"cross1.png"];
			[self addChild:cross z:1 tag:0];
			cross.position = ccp(x,y);
			cross.scale = 0.7;
			[crossSprites addObject:cross];
			
			
			/*AtlasSprite* lifeSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, lifeSpriteSizeWidth/2, lifeSpriteSizeHeight) spriteManager: atlasManager];
			lifeSprite.anchorPoint = CGPointMake(0,0);
			lifeSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2, y+30);
			lifeSprite.scale = 0.6;
			[atlasManager addChild:lifeSprite z:1 tag:0];
			[lifeIndicatorSprites addObject:lifeSprite];
			
			Sprite* lifeBackSprite = [Sprite spriteWithFile:lifeSpriteBackImg];
			lifeBackSprite.anchorPoint = CGPointMake(0,0);
			lifeBackSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2, y+30);
			lifeBackSprite.scale = 0.6;
			[self addChild:lifeBackSprite z:0 tag:0];*/			

			AtlasSprite* lifeSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, lifeSpriteSizeWidth/2, lifeSpriteSizeHeight) spriteManager: atlasManager];
			lifeSprite.anchorPoint = CGPointMake(0,0);
			lifeSprite.scale = 0.5;	
			lifeSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2*lifeSprite.scale, y+30);
			[atlasManager addChild:lifeSprite z:1 tag:0];
			[lifeIndicatorSprites addObject:lifeSprite];
			
			Sprite* lifeBackSprite = [Sprite spriteWithFile:lifeSpriteBackImg];
			lifeBackSprite.anchorPoint = CGPointMake(0,0);
			lifeBackSprite.scale = 0.5;
			lifeBackSprite.position = CGPointMake(x -lifeSpriteSizeWidth/2*lifeBackSprite.scale, y+30);
			[self addChild:lifeBackSprite z:0 tag:0];					
		}
		crossSprites2 = crossSprites;
		lifeIndicatorSprites2 = lifeIndicatorSprites;
		
		return self;
	}
		
	return nil;
}

-(void)updateHeroLifes:(NSArray*)helthArray lifeIndicatorSprites:(NSArray*)indicators crossSprites:(NSArray*)crosses
{
	for(int i=0; i<[indicators count]; i++)
	{
		int helth = ( i<[helthArray count] ) ? [[helthArray objectAtIndex:i] intValue] : 0;
		
		if(i<[crosses count])
		{
			Sprite* crossSprite = [crosses objectAtIndex:i];
			[crossSprite setVisible:(helth==0)];
		}
		
		AtlasSprite* lifeIndicatorSprite = [indicators objectAtIndex:i];
		int indicatorWidth = lifeSpriteSizeWidth*helth/100;
		[lifeIndicatorSprite setTextureRect:CGRectMake(0,0, indicatorWidth, lifeSpriteSizeHeight)];
	}
}

-(void)updateHeroLifes:(NSArray*)helthArray1 lifes:(NSArray*)helthArray2;
{
	[self updateHeroLifes:helthArray1 lifeIndicatorSprites:lifeIndicatorSprites1 crossSprites:crossSprites1];
	[self updateHeroLifes:helthArray2 lifeIndicatorSprites:lifeIndicatorSprites2 crossSprites:crossSprites2];
}

-(void)dealloc
{
	[crossSprites1 release];
	[lifeIndicatorSprites2 release];
	[lifeIndicatorSprites1 release];
	[crossSprites2 release];
	[mapSkin release];
	[super dealloc];
}



@end








