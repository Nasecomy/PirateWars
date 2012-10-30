//
//  ASkin.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#pragma unused(varname)

#import "Skin.h"

#import "cocos2d.h"


/////////////////////////////////////////////////////////////////////////////

@protocol ActionBuilder
+(Action*)actionWithProperties:(NSDictionary*)properties;
@end

@interface MoveByActionBuilder: NSObject<ActionBuilder>
{
}
@end

@implementation MoveByActionBuilder
+(Action*)actionWithProperties:(NSDictionary*)properties;
{
	CGFloat x = [[properties objectForKey:@"x"] floatValue];
	CGFloat y = [[properties objectForKey:@"y"] floatValue];
	CGFloat d = [[properties objectForKey:@"duration"] floatValue];
	return [MoveBy actionWithDuration:d position:ccp(x,y)];
}
@end

@interface RotateByActionBuilder: NSObject<ActionBuilder>
{
}
@end

@implementation RotateByActionBuilder
+(Action*)actionWithProperties:(NSDictionary*)properties;
{
	CGFloat a = [[properties objectForKey:@"angle"] floatValue];
	CGFloat d = [[properties objectForKey:@"duration"] floatValue];
	return [RotateBy actionWithDuration:d angle:a];
}
@end

@interface DelayTimeActionBuilder: NSObject<ActionBuilder>
{
}
@end

@implementation DelayTimeActionBuilder
+(Action*)actionWithProperties:(NSDictionary*)properties;
{
	CGFloat d = [[properties objectForKey:@"duration"] floatValue];
	return [DelayTime actionWithDuration:d];
}
@end


@interface SequenceActionBuilder: NSObject<ActionBuilder>
{
}
@end

@implementation SequenceActionBuilder
+(Action*)actionWithProperties:(NSDictionary*)properties;
{
	NSArray* actionPropArray = [properties objectForKey:@"actions"];
	Action* seq = nil;
	if(actionPropArray!=nil && [actionPropArray count]>0)
	{
		for(NSDictionary* actionProp in actionPropArray)
		{
			NSString* actionClassType = [actionProp objectForKey:@"class"];
			if(actionClassType!=nil)
			{
				NSString* builderClassName = [NSString stringWithFormat:@"%@ActionBuilder", actionClassType];
				Class actionBuilderClass = NSClassFromString(builderClassName);
				if(actionBuilderClass!=nil)
				{
					Action* a = [actionBuilderClass actionWithProperties: actionProp];
					if(a!=NULL)
					{
						seq = (seq==nil) ? a : [Sequence actionOne:(id)seq two:(id)a];
					}				
				}
			}
		}
		
		BOOL repeated = [[properties objectForKey:@"repeated"] boolValue];
		if(repeated && seq!=nil)
		{
			seq = [RepeatForever actionWithAction:(id)seq];
		}		
	}
	return seq;
}
@end


@interface SpawnActionBuilder: NSObject<ActionBuilder>
{
}
@end

@implementation SpawnActionBuilder
+(Action*)actionWithProperties:(NSDictionary*)properties;
{
	NSArray* actionPropArray = [properties objectForKey:@"actions"];
	Action* spawn = nil;
	if(actionPropArray!=nil && [actionPropArray count]>0)
	{
		for(NSDictionary* actionProp in actionPropArray)
		{
			NSString* actionClassType = [actionProp objectForKey:@"class"];
			if(actionClassType!=nil)
			{
				NSString* builderClassName = [NSString stringWithFormat:@"%@ActionBuilder", actionClassType];
				Class actionBuilderClass = NSClassFromString(builderClassName);
				if(actionBuilderClass!=nil)
				{
					Action* a = [actionBuilderClass actionWithProperties: actionProp];
					if(a!=NULL)
					{
						spawn = (spawn==nil) ? a : [Spawn actionOne:(id)spawn two:(id)a];
					}				
				}
			}
		}
		
		BOOL repeated = [[properties objectForKey:@"repeated"] boolValue];
		if(repeated && spawn!=nil)
		{
			spawn = [RepeatForever actionWithAction:(id)spawn];
		}		
	}
	return spawn;
}
@end



/////////////////////////////////////////////////////////////////////////////


@implementation ASkin

@synthesize direction;
@synthesize position;
@synthesize angle;
@synthesize anchor;
@synthesize iSize;

-(id) init
{
	return [super init];
}


-(void) addToParent: (CocosNode*) parentNode z:(int)z
{
}

-(void) setVisibility: (BOOL)visible
{
}

-(void) setVisibilIndex:(int)index
{
}

-(void) setUnVisibil
{
}

-(void) setVisibil:(int)index
{
}

-(void) removeFromParent: (CocosNode*) parentNode
{
}

-(int) getSize
{
	return 1;
}

-(CocosNode*) node
{
      return nil;	
}

-(void) dealloc
{
	[super dealloc];	
}

-(void)readActionWithProperties:(ASkin*)tSkin properties:(NSDictionary*) prop;
{
	NSDictionary* actionItemPropArray = [prop objectForKey:@"Action"];
	
	CocosNode* nodeCh = [tSkin node];
	//CocosNode* tmpNode = [CocosNode node];	
	//[tmpNode addChild:nodeCh z:0 tag:0];	
	
	if(actionItemPropArray!=nil)
	{
		NSString* actionClassName = [actionItemPropArray objectForKey:@"class"];
		Class actionClass = NSClassFromString(actionClassName);
		if(actionClass!=nil)
		{
			NSString* builderClassName = [NSString stringWithFormat:@"%@ActionBuilder", actionClassName];
			Class actionBuilderClass = NSClassFromString(builderClassName);
			if(actionBuilderClass!=nil)
			{
				Action* action = [actionBuilderClass actionWithProperties:actionItemPropArray];	
				[nodeCh runAction:action];
			}
		}		
		
	}
	
	[nodeCh setPosition:[tSkin position]];					
	//[complexNode addChild:tmpNode z:0 parallaxRatio:ccp(prx,pry) positionOffset:ccp(0,0)];
	
}

static NSDictionary* skinDatabase = nil;

+(void) loadSkinDatabase:(NSString*) filename
{
	if(skinDatabase!=nil)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"skins" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSString *error = nil;
	NSPropertyListFormat format;
	skinDatabase = [NSPropertyListSerialization propertyListFromData:plistData
											 mutabilityOption:NSPropertyListImmutable
													   format:&format
											 errorDescription:&error];
	[skinDatabase retain];
}


+(ASkin*) skinWithProperties: (NSDictionary*) properties
{
	return  nil;
}

+(ASkin*) skinWithName:(NSString*)name
{
	NSDictionary* skinProperties = [skinDatabase objectForKey:name];
	if(skinProperties!=nil)
	{
		NSString* skinClassName = [skinProperties objectForKey:@"class"];
		if(skinClassName!=nil)
		{
			Class skinClass = NSClassFromString(skinClassName);
			if(skinClass!=nil)
			{
				return [skinClass skinWithProperties: skinProperties];
			}
		}			
	}
	return nil;
}

@end


/////////////////////////////////////////////////////////////////////////////


@implementation StaticSkin


-(id)initWithSprite:(AtlasSprite*)sprite spriteManager:(AtlasSpriteManager*)atlasSpriteManager;
{
	if([super init])
	{
		spriteManager = [atlasSpriteManager retain];
		mainSprite = [sprite retain];
		return self;
	}
	return nil;
}

+(ASkin*) skinWithProperties: (NSDictionary*) properties
{
	NSString* skinAtlas = [properties objectForKey:@"atlas"];
	NSNumber* skinFrameWidth = [properties objectForKey:@"width"];
	NSNumber* skinFrameHeight = [properties objectForKey:@"height"];
	
	if(skinAtlas==nil || skinFrameWidth==nil || skinFrameHeight==nil)
		return nil;
	
	int x = [[properties objectForKey:@"x"] intValue];
	int y = [[properties objectForKey:@"y"] intValue];
	int w = [skinFrameWidth intValue];
	int h = [skinFrameHeight intValue];
	int ax = [[properties objectForKey:@"ax"] intValue];
	int ay = [[properties objectForKey:@"ay"] intValue];

	int gravX = [[properties objectForKey:@"gravX"] intValue];
	int gravY = [[properties objectForKey:@"gravY"] intValue];
	
	NSNumber* skinScaleX = [properties objectForKey:@"scaleX"];
	float scaleX = (skinScaleX == nil) ? 1 : [skinScaleX floatValue];
	
	AtlasSpriteManager* atlasManager = [AtlasSpriteManager spriteManagerWithFile:skinAtlas capacity:1];
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:CGRectMake(x, y, w, h) spriteManager: atlasManager];
	sprite.anchorPoint = CGPointMake((CGFloat)ax/w ,(CGFloat)ay/h);
	[atlasManager addChild:sprite z:0 tag:0];
	
	sprite.scaleX = scaleX;
	
	StaticSkin* skin = [[StaticSkin alloc] initWithSprite:sprite spriteManager:atlasManager];
	skin.anchor = CGPointMake(ax, ay);
	skin.position = CGPointMake(skin.position.x + gravX, skin.position.y + gravY);
	
	if(skin!=NULL)
	{
		[skin readActionWithProperties:skin properties:properties];
	}
	
	return [skin autorelease];
}

-(void) setPosition: (CGPoint)pos
{

	mainSprite.position = pos;	
}

-(void) setAngle: (CGFloat)angleValue
{
	mainSprite.rotation = angleValue;
}

-(CGFloat) angle
{
	return mainSprite.rotation;
}

-(void) setVisibility: (BOOL)visible
{
	mainSprite.visible = visible;
}

-(void) addToParent: (CocosNode*) parentNode z:(int)z
{
	[parentNode addChild:spriteManager z:z ];
}

-(CocosNode*) node
{
	return spriteManager;	
}

-(void) dealloc
{
	[mainSprite release];
	[spriteManager release];
	[super dealloc];	
}

@end


/////////////////////////////////////////////////////////////////////////////


@implementation AnimatedSkin


+(ASkin*) skinWithProperties: (NSDictionary*) properties
{
	NSString* skinAtlas = [properties objectForKey:@"atlas"];
	NSNumber* skinFrames = [properties objectForKey:@"frames"];
	NSNumber* skinFrameWidth = [properties objectForKey:@"width"];
	NSNumber* skinFrameHeight = [properties objectForKey:@"height"];
	NSNumber* skinAtlasCols = [properties objectForKey:@"cols"];
	
	if(skinAtlas==nil || skinFrames==nil || skinFrameWidth==nil || skinFrameHeight==nil)
		return nil;
	
	int frames = [skinFrames intValue];
	int cols = (skinAtlasCols==nil) ? frames : [skinAtlasCols intValue];
	
	if(cols==0)
		return nil;
	
	int frame0 = [[properties objectForKey:@"frame0"] intValue];
	CGFloat animationInterval = [[properties objectForKey:@"interval"] floatValue];
	CGFloat sleep = [[properties objectForKey:@"sleep"] floatValue];
	int x = [[properties objectForKey:@"x"] intValue];
	int y = [[properties objectForKey:@"y"] intValue];
	int w = [skinFrameWidth intValue];
	int h = [skinFrameHeight intValue];
	int ax = [[properties objectForKey:@"ax"] intValue];
	int ay = [[properties objectForKey:@"ay"] intValue];
	
	int gravX = [[properties objectForKey:@"gravX"] intValue];
	int gravY = [[properties objectForKey:@"gravY"] intValue];
	
	NSNumber* skinSkaleX = [properties objectForKey:@"scaleX"];
	float skaleX = (skinSkaleX==nil) ? 1 : [skinSkaleX floatValue];
	
	if(gravY>10)
		gravY = gravY;
	AtlasSpriteManager* atlasManager = [AtlasSpriteManager spriteManagerWithFile:skinAtlas capacity:50];
	CGRect frameRect = CGRectMake(x+w*(frame0%cols), y+h*(frame0/cols), w, h);
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:frameRect spriteManager: atlasManager];
	sprite.anchorPoint = CGPointMake((CGFloat)ax/w ,(CGFloat)ay/h);
	[atlasManager addChild:sprite z:0 tag:0];
	sprite.position = CGPointMake(sprite.position.x + gravX, sprite.position.y + gravY);
	
	AtlasAnimation *animation = [AtlasAnimation animationWithName:@"dance" delay:animationInterval];
	for(int i=frame0; i<frame0+frames; i++)
	{
		frameRect = CGRectMake(x+w*(i%cols), y+h*(i/cols), w, h);
		[animation addFrameWithRect: frameRect ];
	}
	
	
	sprite.scaleX = skaleX;
	
	id animationAction = [Animate actionWithAnimation: animation];
	id delayAction = [DelayTime actionWithDuration:sleep];
	id action = [Sequence actionOne:animationAction two:delayAction];
	[sprite runAction: [RepeatForever actionWithAction:action] ];
	
	AnimatedSkin* skin = [[AnimatedSkin alloc] initWithSprite:sprite spriteManager: atlasManager];
	skin.anchor = CGPointMake(ax, ay);
	
	if(skin!=NULL)
	{
		[skin readActionWithProperties:skin properties:properties];
	}
	
	return [skin autorelease];
}


-(id)initWithSprite:(AtlasSprite*)sprite spriteManager:(AtlasSpriteManager*)atlasSpriteManager
{
	if([super init])
	{
		spriteManager = [atlasSpriteManager retain];
		mainSprite = [sprite retain];
		//animations = [animationList retain];
		
		
		//mainSprite.scaleY = -mainSprite.scaleY;
		
		return self;
	}
	return nil;
}



-(void) setPosition: (CGPoint)pos
{
	mainSprite.position = pos;
}

-(void) setAngle: (CGFloat)angleValue
{
	mainSprite.rotation = angleValue;
}


-(void) setVisibility: (BOOL)visible
{
	mainSprite.visible = visible;
}


-(void) addToParent: (CocosNode*) parentNode z:(int)z
{
	[parentNode addChild:spriteManager z:z ];
}

-(void) removeFromParent: (CocosNode*) parentNode
{
	[parentNode removeChild:spriteManager cleanup:YES];
}

-(void) dealloc
{
	//[animations release];
	[mainSprite release];
	[spriteManager release];
	[super dealloc];	
}

-(CocosNode*) node
{
	return spriteManager;	
}

@end



/////////////////////////////////////////////////////////////////////////////


@implementation AtlasSkin

+(ASkin*) skinWithProperties: (NSDictionary*) properties
{	
	NSString* skinAtlas = [properties objectForKey:@"atlas"];
	NSString* mapFileTga = [properties objectForKey:@"mapFileTga"];
	NSNumber* skinTileWidth = [properties objectForKey:@"tileWidth"];
	NSNumber* skinTileHeight = [properties objectForKey:@"tileHeight"];
	NSNumber* skinSkaleX = [properties objectForKey:@"skaleX"];
	NSNumber* skinSkaleY = [properties objectForKey:@"skaleY"];
	NSNumber* offsetX = [properties objectForKey:@"offsetX"];
	NSNumber* offsetY = [properties objectForKey:@"offsetY"];
	NSNumber* skinAnchorPointX = [properties objectForKey:@"skinAnchorPointX"];
	NSNumber* skinAnchorPointY = [properties objectForKey:@"skinAnchorPointY"];
	
	if(skinAtlas==nil || mapFileTga==nil || skinTileWidth==nil || skinTileHeight==nil)
		return nil;
	
	int tWidth = [[properties objectForKey:@"tileWidth"] intValue];
	int tHeight = [[properties objectForKey:@"tileHeight"] intValue];
	float skaleX = (skinSkaleX==nil) ? 0 : [skinSkaleX floatValue];
	float skaleY = (skinSkaleY==nil) ? 0 : [skinSkaleY floatValue];

    int anchorPointX = (skinAnchorPointX==nil) ? 0 : [skinAnchorPointX intValue];
    int anchorPointY = (skinAnchorPointY==nil) ? 0 : [skinAnchorPointY intValue];

	int offtX = (offsetX==nil) ? 0 : [offsetX intValue];
    int offtY = (offsetY==nil) ? 0 : [offsetY intValue];

	NSNumber* prxNumX = [properties objectForKey:@"prx"];
	CGFloat prx = (prxNumX!=nil) ? [prxNumX floatValue] : 1.0;
	
	NSNumber* prxNumY = [properties objectForKey:@"pry"];
	CGFloat pry = (prxNumY!=nil) ? [prxNumY floatValue] : 1.0;
	
	
	TileMapAtlas *tileMapAtlas = [TileMapAtlas tileMapAtlasWithTileFile:skinAtlas mapFile:mapFileTga tileWidth:tWidth tileHeight:tHeight ];
	[tileMapAtlas releaseMap];
    [tileMapAtlas.texture setAliasTexParameters];
	
	tileMapAtlas.scaleX = skaleX;
	tileMapAtlas.scaleY = skaleY;
	
	tileMapAtlas.anchorPoint = CGPointMake(anchorPointX,anchorPointY);		
	
	AtlasSkin* skin = [[AtlasSkin alloc] initWithTileMapAtlas:tileMapAtlas];

	skin.anchor = CGPointMake(0, 0);
	skin.position = CGPointMake(offtX,offtY);

	CocosNode* tmpNode = [CocosNode node];	
	[tmpNode addChild:tileMapAtlas z:0 tag:0];	
	[skin addToParallax:tmpNode x:prx y:pry];
	
	return [skin autorelease];	
}

-(void) addToParallax:(CocosNode*)_tmpNode x:(CGFloat)_prx y:(CGFloat)_pry
{
	[atlasNode addChild:_tmpNode z:0 parallaxRatio:ccp(_prx,_pry) positionOffset:ccp(0,0)];

}

-(CocosNode*) node
{
	//return tileMapAtlas;
	return atlasNode;
}

-(id)initWithTileMapAtlas:(TileMapAtlas*)tMapAtlas
{
	if([super init])
	{
		atlasNode = [ParallaxNode node];
		
		//tileMapAtlas = [tMapAtlas retain];
		return self;
	}
	return nil;
}


-(void) setPosition: (CGPoint)pos
{
	position = pos;
}

-(void) setAngle: (CGFloat)angleValue
{
	angle = angleValue;
}


-(void) setVisibility: (BOOL)visible
{
	//tileMapAtlas.visible = visible;
}


-(void) dealloc
{

	//[tileMapAtlas release];
	[super dealloc];	
}



@end


/////////////////////////////////////////////////////////////////////////////


@implementation ComplexSkin

+(ASkin*) skinWithProperties: (NSDictionary*) properties
{	 
	NSArray* skinPropArray = [properties objectForKey:@"skins"];
	
	if(skinPropArray!=nil && [skinPropArray count]>0)
	{	
		ComplexSkin* skinCompl = [[ComplexSkin alloc] initComplexSkin];
		skinCompl.iSize = [skinPropArray count];
		
		for(NSDictionary* skinProp in skinPropArray)
		{
			NSDictionary* skinItemPropArray = [skinProp objectForKey:@"Skin"];
			if(skinItemPropArray!=nil)
			{
				NSString* skinClassName = [skinItemPropArray objectForKey:@"class"];
				if(skinClassName!=nil)
				{
					Class skinClass = NSClassFromString(skinClassName);
					if(skinClass!=nil)
					{
						ASkin* skin = [skinClass skinWithProperties: skinItemPropArray];
						//skin.iSize = [skinPropArray count];
						if(skin!=NULL)
						{
							[skinCompl readActionWithProperties: skin properties:skinProp];
							continue;
						}

					}

				}
			}
			
			NSString* skinItemName = [skinProp objectForKey:@"SkinName"];
			if(skinItemName!=nil)
			{
				NSDictionary* skinProperties = [skinDatabase objectForKey:skinItemName];
				if(skinProperties!=nil)
				{
					NSString* skinClassName = [skinProperties objectForKey:@"class"];
					if(skinClassName!=nil)
					{
						Class skinClass = NSClassFromString(skinClassName);
						if(skinClass!=nil)
						{
							ASkin* skin = [skinClass skinWithProperties: skinProperties];
							if(skin!=NULL)
							{
								[skinCompl readActionWithProperties: skin properties:skinProp];
								continue;
							}							
						}
					}			
				}
				
			}
		
		}
			
		return [skinCompl autorelease];
	}	
	
	return nil;		
}

-(id)initComplexSkin
{
	if([super init])
	{
		//complexNode = [[ParallaxNode alloc] init];
		complexNode = [ParallaxNode node];
		return self;
	}
	return nil;
	
}

-(void)readActionWithProperties:(ASkin*)tSkin properties:(NSDictionary*) prop;
{
	NSDictionary* actionItemPropArray = [prop objectForKey:@"Action"];
	
	NSNumber* prxNumX = [prop objectForKey:@"prx"];
	CGFloat prx = (prxNumX!=nil) ? [prxNumX floatValue] : 1.0;
	
	NSNumber* prxNumY = [prop objectForKey:@"pry"];
	CGFloat pry = (prxNumY!=nil) ? [prxNumY floatValue] : 1.0;
	
	CocosNode* nodeCh = [tSkin node];
	CocosNode* tmpNode = [CocosNode node];	
	[tmpNode addChild:nodeCh z:0 tag:0];	
	
	
	if(actionItemPropArray!=nil)
	{
		NSString* actionClassName = [actionItemPropArray objectForKey:@"class"];
		Class actionClass = NSClassFromString(actionClassName);
		if(actionClass!=nil)
		{
			NSString* builderClassName = [NSString stringWithFormat:@"%@ActionBuilder", actionClassName];
			Class actionBuilderClass = NSClassFromString(builderClassName);
			if(actionBuilderClass!=nil)
			{
				Action* action = [actionBuilderClass actionWithProperties:actionItemPropArray];	
				[nodeCh runAction:action];
			}
		}		
		
	}
				
	[nodeCh setPosition:[tSkin position]];					
	[complexNode addChild:tmpNode z:0 parallaxRatio:ccp(prx,pry) positionOffset:ccp(0,0)];
	
}

-(void) setPosition: (CGPoint)pos index:(int)ind
{
}

-(void) setAngle: (CGFloat)angleValue
{
}

-(void) setVisibility: (BOOL)visible
{
	for (CocosNode *child in [complexNode children]) 
	{
		child.visible = visible;
	}

}

-(void) setVisibilIndex:(int)index
{
	int iCurrentChild = 0;
	for (CocosNode *child in [complexNode children]) 
	{
		if(iCurrentChild == index)
		    child.visible = YES;
		else
		    child.visible = NO;
		
		iCurrentChild++;
	}
   
}

-(void) setVisibil:(int)index
{
	int iCurrentChild = 0;
	for (CocosNode *child in [complexNode children]) 
	{
		if(iCurrentChild == index)
		     child.visible = YES;
	}
	
}

-(void) setUnVisibil
{
	for (CocosNode *child in [complexNode children]) 
	{
			child.visible = NO;
	}
	
}

-(int) getSize
{
	return iSize;
}

-(void) addToParent: (CocosNode*) parentNode z:(int)z
{	
	[parentNode addChild:complexNode z:z ];
}

-(CocosNode*) node
{
	return complexNode;	
}

-(void) dealloc
{
	[super dealloc];	
}

@end


/////////////////////////////////////////////////////////////////////////////


@implementation AnimatedArraySkin


+(ASkin*) skinWithProperties: (NSDictionary*) properties
{
	NSString* skinAtlas = [properties objectForKey:@"atlas"];
	NSNumber* skinFrameWidth = [properties objectForKey:@"width"];
	NSNumber* skinFrameHeight = [properties objectForKey:@"height"];
	
	if(skinAtlas==nil || skinFrameWidth==nil || skinFrameHeight==nil)
		return nil;
	
    NSArray* skinFrames = [properties objectForKey:@"framesArray"];
	int framesSize = [skinFrames count];
	
	CGFloat animationInterval = [[properties objectForKey:@"interval"] floatValue];
	CGFloat sleep = [[properties objectForKey:@"sleep"] floatValue];
	int x = [[properties objectForKey:@"x"] intValue];
	int y = [[properties objectForKey:@"y"] intValue];
	int w = [skinFrameWidth intValue];
	int h = [skinFrameHeight intValue];
	int ax = [[properties objectForKey:@"ax"] intValue];
	int ay = [[properties objectForKey:@"ay"] intValue];
	
	int gravX = [[properties objectForKey:@"gravX"] intValue];
	int gravY = [[properties objectForKey:@"gravY"] intValue];
	
	if(gravY>10)
		gravY = gravY;
	
	int frame0;
	if(framesSize > 0)
		frame0 = [[skinFrames objectAtIndex:0] intValue];
		
	AtlasSpriteManager* atlasManager = [AtlasSpriteManager spriteManagerWithFile:skinAtlas capacity:50];
	CGRect frameRect = CGRectMake(x+w*(frame0%framesSize), y+h*(frame0/framesSize), w, h);
	AtlasSprite *sprite = [AtlasSprite spriteWithRect:frameRect spriteManager: atlasManager];
	sprite.anchorPoint = CGPointMake((CGFloat)ax/w ,(CGFloat)ay/h);
	[atlasManager addChild:sprite z:0 tag:0];
	sprite.position = CGPointMake(sprite.position.x + gravX, sprite.position.y + gravY);
	
	AtlasAnimation *animation = [AtlasAnimation animationWithName:@"dance" delay:animationInterval];
	
	for(NSNumber* frame in skinFrames)
	{
        int i = [frame intValue];
		frameRect = CGRectMake(x+w*(i%framesSize), y+h*(i/framesSize), w, h);
		[animation addFrameWithRect: frameRect ];
	}
	
	id animationAction = [Animate actionWithAnimation: animation];
	id delayAction = [DelayTime actionWithDuration:sleep];
	id action = [Sequence actionOne:animationAction two:delayAction];
	[sprite runAction: [RepeatForever actionWithAction:action] ];
	
	AnimatedSkin* skin = [[AnimatedSkin alloc] initWithSprite:sprite spriteManager: atlasManager];
	skin.anchor = CGPointMake(ax, ay);
	
	return [skin autorelease];
}


-(id)initWithSprite:(AtlasSprite*)sprite spriteManager:(AtlasSpriteManager*)atlasSpriteManager
{
	if([super init])
	{
		spriteManager = [atlasSpriteManager retain];
		mainSprite = [sprite retain];
		
		return self;
	}
	return nil;
}



-(void) setPosition: (CGPoint)pos
{
	mainSprite.position = pos;
}

-(void) setAngle: (CGFloat)angleValue
{
	mainSprite.rotation = angleValue;
}


-(void) setVisibility: (BOOL)visible
{
	mainSprite.visible = visible;
}


-(void) addToParent: (CocosNode*) parentNode z:(int)z
{
	[parentNode addChild:spriteManager z:z ];
}

-(void) dealloc
{
	[mainSprite release];
	[spriteManager release];
	[super dealloc];	
}

-(CocosNode*) node
{
	return spriteManager;	
}

@end



