//
//  GameScene.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Scene;
@class Layer;
@class CocosNode;
@class AShip;
@class AShape;
@class AProjectile;
@class AnEffect;
@class GameHelperLayer;
@class ManualAimLayer;
@class UpgradeHelperLayer;
@class SpeachLayer;


@interface AGameScene : Scene 
{
	NSString* name;
	CGPoint ship1Pos;
	CGPoint ship2Pos;
	
	CocosNode* bgLayer1;
	CocosNode* bgLayer2;
	CocosNode* gameLayer;
	SpeachLayer* speachLayer;
};

@property (nonatomic, assign) CGPoint ship1Pos;
@property (nonatomic, assign) CGPoint ship2Pos;
@property (nonatomic, assign) SpeachLayer* speachLayer;

+(void) loadSceneDatabase:(NSString*)filename;
+(AGameScene*) sceneWithName:(NSString*)name;

-(void) physicsRegister;
-(void) physicsUnregister;

-(void) showAimLayer;
-(void) hideAimLayer;
-(ManualAimLayer*) getAimLayer;

-(void) showExitButton:(BOOL)show;
-(void) hideExitButton;
-(void) showPauseButton;
-(void) hidePauseButton;

-(void)updateMiniMapHeroLifes:(NSArray*)helthArray1 lifes:(NSArray*)helthArray2;

-(void) scrollTo: (CGFloat)pos; 
-(void) moveTo: (CGFloat)pos; 

-(void) setShips:(AShip*)ship1 ship2:(AShip*)ship2;

-(void) addEffect:(AnEffect*)effect;
-(void) addProjectile:(AProjectile*) projectile;
-(void) removeProjectile:(AProjectile*) projectile;
-(void) addNode:(CocosNode*) tNode;

-(CGSize) size;

-(CGPoint) sceneCoordinate:(CocosNode*)parent point:(CGPoint)pos;
-(CGPoint) localCoordinate:(CocosNode*)parent point:(CGPoint)point;

-(void) updateAimerAngle:(int)angle power:(int)power;
-(void) updateAimerControls;
-(void) moveTo: (CGFloat)pos;
-(CGFloat) getPosition;
-(void) resetPowerGrow;
@end


@interface WarScene: AGameScene
{
	//int tick;
	//int direction;
	GameHelperLayer* helperLayer;
	ManualAimLayer* aimLayer;
	AShape* sceneShape;
}

+(WarScene*) sceneWithProperties:(NSDictionary*)properties;
-(WarScene*) initWithProperties:(NSDictionary*)properties;

@property (nonatomic, assign) GameHelperLayer* helperLayer;

@end


@interface UpgradeScene : AGameScene
{
	UpgradeHelperLayer* helperLayer;
	AShip* upgradeShip;
	AShip* downgradeShip;
}

+(UpgradeScene*) sceneWithProperties:(NSDictionary*)properties;
-(UpgradeScene*) initWithProperties:(NSDictionary*)properties;

-(void)showUpgradeShip;
-(void)showDowngradeShip;

@end
