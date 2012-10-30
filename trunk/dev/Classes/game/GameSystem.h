//
//  GameSystem.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define DEBUG_SHAPES 0


#import <Foundation/Foundation.h>
#import "TCPConnectionPoint.h"
#include "ccTypes.h" 
#import <AVFoundation/AVFoundation.h>

@class ATeam;
@class AHero;
@class AGameScene;
@class GameLevel;

@protocol AimerProtocol;

typedef enum eGameMode 
{
		kUndefinedGame,
		kStoryModeGame,
		kServerModeGame,	
		kClientModeGame,	
}GameMode;

@interface GameSystem : NSObject <TCPConnectionDelegate, AVAudioPlayerDelegate>
{
	AGameScene* gameScene;

	NSDictionary* team1Prop;
	NSDictionary* team2Prop;
	
	ATeam* team1;
	ATeam* team2;
	
	ATeam* activeTeam;
	id<AimerProtocol> aimerDelegate;
	
	GameMode gameMode;
	NSArray* levelMap;
	int level;
	struct timeval startTime;	
	ccTime usedTime;
	int usedShots;
	TCPConnectionPoint* connectionPoint;
	BOOL bOnSound;
	//AVAudioPlayer *player;
	UIImageView* loadingView;
}

+(GameSystem*)sharedGame;

-(void) loadResources;

-(void) startDebugLevel:(int)level withTeamProperties:(NSDictionary*)teamProp;

-(void) startNewGame:(GameMode)newGameType;
-(void) startNewLevel:(int)levelNumber;
-(void) startNextLevel;
-(void) finishLevel;
-(void) startUpgrade;
-(void) exitToMenu;
-(void) strikeDidFinish;

-(void) showAimControls;
-(void) hideAimControls;

//-(AHero*) activeHero;
-(ATeam*) activeTeam;
-(ATeam*) inactiveTeam;

-(void) updateMiniMap;

-(void) saveGame;
-(void) loadGame;

-(void) activateNextTeam;
-(ATeam*) getNextTeam;
-(void) startBattleLevel;

-(void) onDowngradeShip;
-(void) onUpgradeShip;
-(void) completeUpgrade:(int)credits  bows:(int)bows rockets:(int)rockets ship:(BOOL)newShip;
-(void) setShotsUsed;
-(int) getShotsUsed;
-(int) getTimeUsed;
-(int) getCurrentLevel;
-(int) getCredits;
-(GameLevel*) getLevel;
-(void) setCredits:(int)value;
-(AGameScene*) getScene;
-(void) setStartTime;
-(void) resetTime;
-(void) setTimeUsed;
-(AGameScene*) getScene;
-(BOOL) getSound;
-(void) setSound:(BOOL)sound;
-(AHero*) getActiveHero;
-(void) setActiveHero;
-(void) stopPlaying;
-(void) showActivityIndicator;

@property (nonatomic, readonly) ATeam* team1;
@property (nonatomic, readonly) ATeam* team2;
@property (nonatomic, assign) GameMode gameMode;
@property (nonatomic, readonly) AGameScene* gameScene;
@property (nonatomic, assign) id<AimerProtocol> aimerDelegate;
@property (nonatomic, retain) TCPConnectionPoint* connectionPoint;
@property (nonatomic, readonly) int level;
@property (nonatomic, assign) UIImageView* loadingView;
@end
