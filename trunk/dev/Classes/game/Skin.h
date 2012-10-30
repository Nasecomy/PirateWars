//
//  ASkin.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

typedef enum eSkinDirection
{
	SD_RIGHT,
	SD_LEFT,
} SkinDirection;

@interface ASkin:NSObject 
{
	SkinDirection direction;
	CGPoint position;
	CGPoint anchor;
	CGFloat angle;
    int iSize;
}

@property (nonatomic) SkinDirection direction;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGPoint anchor;
@property (nonatomic) CGFloat angle;
@property (nonatomic) int iSize;

-(void) addToParent: (CocosNode*) parentNode z:(int)z; 

-(void) setVisibility: (BOOL)visible;
-(void) setVisibilIndex:(int)index;
-(void) setVisibil:(int)index;
-(int) getSize;
-(void) setUnVisibil;

+(void) loadSkinDatabase:(NSString*) filename;

+(ASkin*) skinWithProperties: (NSDictionary*) properties; 
+(ASkin*) skinWithName:(NSString*)name;
-(CocosNode*)node;
-(void) removeFromParent: (CocosNode*) parentNode;
-(void)readActionWithProperties:(ASkin*)tSkin properties:(NSDictionary*) prop;

@end

@interface StaticSkin : ASkin
{
	AtlasSpriteManager* spriteManager;
	AtlasSprite* mainSprite;
}

-(id)initWithSprite:(AtlasSprite*)sprite spriteManager:(AtlasSpriteManager*)atlasSpriteManager;  
-(CocosNode*)node;

@end


@interface AnimatedSkin : ASkin
{
	AtlasSpriteManager* spriteManager;
	AtlasSprite* mainSprite;
}

-(id)initWithSprite:(AtlasSprite*)sprite spriteManager:(AtlasSpriteManager*)atlasSpriteManager;  
-(CocosNode*)node;

@end

@interface AtlasSkin : ASkin
{
	//TileMapAtlas* tileMapAtlas;
	ParallaxNode* atlasNode;
}

-(id)initWithTileMapAtlas:(TileMapAtlas*)tileMapAtlas; 
-(CocosNode*)node;
-(void) addToParallax:(CocosNode*)_tmpNode x:(CGFloat)_prx y:(CGFloat)_pry;

@end

@interface ComplexSkin : ASkin
{	
	ParallaxNode* complexNode;
}

-(void)readActionWithProperties:(ASkin*)tSkin properties:(NSDictionary*) prop;
-(id)initComplexSkin;
-(CocosNode*)node;
-(void) setVisibilIndex:(int)index;
-(void) setVisibil:(int)index;
-(int) getSize;
-(void) setPosition: (CGPoint)pos index:(int)ind;
-(void) setUnVisibil;
@end

@interface AnimatedArraySkin : ASkin
{
	AtlasSpriteManager* spriteManager;
	AtlasSprite* mainSprite;
}

-(id)initWithSprite:(AtlasSprite*)sprite spriteManager:(AtlasSpriteManager*)atlasSpriteManager;  
-(CocosNode*)node;
@end
