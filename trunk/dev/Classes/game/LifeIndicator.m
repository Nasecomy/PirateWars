//
//  LifeIndicator.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LifeIndicator.h"


@implementation LifeIndicator

static const int lifeSpriteSizeWidth = 65;
static const int lifeSpriteSizeHeight = 10;

static NSString* lifeSpriteImg = @"Life_Indicate_u.png"; 
static NSString* lifeSpriteBackImg = @"Life_Indicate_d.png"; 

-(id) init
{
	[super init];
	
	AtlasSpriteManager* atlasManager = [AtlasSpriteManager spriteManagerWithFile:lifeSpriteImg capacity:1];
	lifeSprite = [AtlasSprite spriteWithRect:CGRectMake(0, 0, lifeSpriteSizeWidth/2, lifeSpriteSizeHeight) spriteManager: atlasManager];
	lifeSprite.anchorPoint = CGPointMake(0,0);
	lifeSprite.position = CGPointMake(-lifeSpriteSizeWidth/2, 0);
	[atlasManager addChild:lifeSprite z:0 tag:0];
	[self addChild:atlasManager z:1];
	atlasManager.anchorPoint = CGPointMake(0,0);
	atlasManager.position = CGPointMake(0, 0);
	
	Sprite* lifeBackSprite = [Sprite spriteWithFile:lifeSpriteBackImg];
	lifeBackSprite.anchorPoint = CGPointMake(0,0);
	lifeBackSprite.position = CGPointMake(-lifeSpriteSizeWidth/2, 0);
	[self addChild:lifeBackSprite z:0 tag:0];	
	
	lifeValue = [Label labelWithString:@"0%" fontName:@"Arial" fontSize:20];
	[self addChild: lifeValue z:0];
	[lifeValue setPosition: ccp(0, 25)];
	[lifeValue setRGB:255 :255 :255];

	return self;
}


-(void) setLifeValue:(int)value
{
	//NSString* ns = [NSString stringWithFormat:@"%d%%", value];
	[lifeValue setString:[NSString stringWithFormat:@"%d%%", value]];
	int width = lifeSpriteSizeWidth*value/100;
	[lifeSprite setTextureRect:CGRectMake(0, 0, width, lifeSpriteSizeHeight)];
}

@end
