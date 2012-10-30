//
//  GameSystem.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 7/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameSystem.h"
#import "Team.h"
#import "GameScene.h"
#import "Hero.h"
#import "Ship.h"
#import "PhysicsSystem.h"
#import "Shape.h"
#import "PlayerMenuScene.h"
#import "WonTable.h"
#import "LostScene.h"
#import "Level.h"
#import "Aimer.h"
#import "Skin.h"
#import "Projectile.h"
#import "Weapon.h"
#import "Skin.h"
#import <AVFoundation/AVFoundation.h>
#import "SpeachLayer.h"

@implementation GameSystem

@synthesize gameMode;
@synthesize gameScene;
@synthesize aimerDelegate;
@synthesize connectionPoint;
@synthesize team1;
@synthesize team2;
@synthesize level;
@synthesize loadingView;

static GameSystem* _sharedGamePtr = nil;

+(GameSystem*)sharedGame
{
	if (!_sharedGamePtr)
		[[self alloc] init];
	
	return _sharedGamePtr;
}

-(id)init
{
	gameMode = kUndefinedGame;
	return self;
}

-(void) loadResources
{
	[ASkin loadSkinDatabase:@""];
	[AHero loadHeroDatabase:@""];
	[AShip loadShipDatabase:@""];
	[AShape loadShapeDatabase:@""];
	[AProjectile loadProjectileDatabase:@""];
	[AWeapon loadWeaponDatabase:@""];
	[ATeam loadTeamDatabase:@""];
	[AGameScene loadSceneDatabase:@""];
	[ALevel loadLevelDatabase:@""];
	
	[self setSound:TRUE];
}

-(BOOL) getSound
{
	return bOnSound;
}

-(void) setSound:(BOOL)sound
{
	bOnSound = sound;
	
	/*if(bOnSound==YES)
	{
		if(![player isPlaying])
		{
			NSString *Path = [[NSBundle mainBundle] pathForResource:@"battle_1" ofType:@"mp3"];
			player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:Path] error:NULL];
			
			bOnSound = YES;
			player.delegate = self;
			player.numberOfLoops = -1;
			[player play];
		}
	}
	else
	{
		if(player) 
		{
			[player stop];
			[player release];
			player = nil;
		}
	}*/

}

-(void) stopPlaying
{
	/*if(player) 
	{
		[player stop];
		[player release];
		player = nil;
	}*/
}

-(void) setActiveHero
{
	[activeTeam setActiveHero];
}

-(AHero*) getActiveHero
{
	AHero* hero = [activeTeam getActiveHero];
	return hero;
}

-(ATeam*) activeTeam
{	
	return activeTeam;
}

-(ATeam*) inactiveTeam;
{
	return team1!=activeTeam ? team1 : team2;
}

-(void) loadLevelMap
{
	[levelMap release];
	NSString *error = nil;
	NSPropertyListFormat format;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"levelmap" ofType:@"plist"];
	NSData *plistData = [NSData dataWithContentsOfFile:path];
	NSDictionary* levelDatabase = [NSPropertyListSerialization propertyListFromData:plistData 
															   mutabilityOption:NSPropertyListImmutable 
															   format:&format errorDescription:&error];
	if(gameMode==kStoryModeGame)
	{
		levelMap = [levelDatabase objectForKey: @"StoryModeLevels"];
	}
	else if (gameMode==kServerModeGame)
	{
		levelMap = [levelDatabase objectForKey: @"ServerModeLevels"];
	}
	else if (gameMode==kClientModeGame)
	{
		levelMap = [levelDatabase objectForKey: @"ClientModeLevels"];
	}
	[levelMap retain];
}

-(void) startDebugLevel:(int)levelNum withTeamProperties:(NSDictionary*)teamProp
{
	team1Prop = teamProp;
	gameMode = kStoryModeGame;
	[self loadLevelMap];
	[self startNewLevel:levelNum];
}

-(void) startNewGame:(GameMode)newGameType 
{
	gameMode = newGameType;
	[self loadLevelMap];
	[self startNewLevel:1];
}

-(void) startNextLevel
{
	if( level < [levelMap count] )
	{
		[self startNewLevel:level+1];
	}
	else
	{
		// congratulations!!!
		// Game complete!!!
	}
}

-(void) startNewLevel:(int)levelNumber
{	
	[self resetTime];
	[self setStartTime];

	
	usedShots = 0;
	
	level = levelNumber;
	NSString* levelName = [levelMap objectAtIndex:level-1];
	
	ALevel* gameLevel = [ALevel levelWithName:levelName];
	
	if(team1Prop!=nil)
	{
		[team1 release];
		team1 = [[ATeam teamWithProperties:team1Prop] retain];
	}
	else
	{
		ATeam* t1 = [gameLevel loadTeam1];
		if(t1!=nil)
		{
			[team1 release];
			team1 = [t1 retain];
		}
		
	}
	
	/*if(team2Prop!=nil)
	{
		[team2 release];
		team2 = [[ATeam teamWithProperties:team2Prop] retain];
	}
	else*/
	{
		ATeam* t2 = [gameLevel loadTeam2];
		if(t2!=nil)
		{
			[team2 release];
			team2 = [t2 retain];
		}
	}
	
	gameScene = [[gameLevel loadGameScene] retain];
	[gameScene setShips:[team1 getShip] ship2:[team2 getShip]];
	
	[[Director sharedDirector] replaceScene:gameScene];	
	
	[PhysicsSystem initSystem];
	[gameScene physicsRegister];
	[team1 physicsRegister];
	[team2 physicsRegister];
	
	activeTeam = team1;
	//[team1 activate];	

	//[team1 activateSpeach];	
}

-(void) startBattleLevel
{	
	if(activeTeam == nil)
	    activeTeam = team1;
	
	[activeTeam activate];
}

-(void) setStartTime
{
    if( gettimeofday( &startTime, NULL) != 0 ) {
	     CCLOG(@"error in gettimeofday");
    }
}

-(void) setTimeUsed
{
	struct timeval now;
	
	if( gettimeofday( &now, NULL) != 0 ) {
		CCLOG(@"error in gettimeofday");
	}
	
	ccTime period = (now.tv_sec - startTime.tv_sec) + (now.tv_usec - startTime.tv_usec) / 1000000.0f;
	usedTime = usedTime + period;		
}

-(void) resetTime
{
	usedTime = 0.0f;	
}

-(void) setShotsUsed
{
	usedShots++;	
}

-(int) getShotsUsed
{
	return usedShots;
}

-(int) getTimeUsed
{
	return usedTime;	
}

-(int) getCurrentLevel
{
	return level;
}

-(int) getCredits
{
	return activeTeam.credits;
}

-(void) setCredits:(int)value
{
	activeTeam.credits += value;
}


-(ALevel*) getLevel
{
	NSString* levelName = [levelMap objectAtIndex:level-1];
	ALevel* Level = [ALevel levelWithName:levelName];

	return Level;
}

-(AGameScene*) getScene
{
	return gameScene;
}

-(void) finishLevel
{	
	[team1 physicsUnregister];
	[team2 physicsUnregister];
	[gameScene physicsUnregister];
	
	[gameScene release];
	gameScene = nil;
}

-(void) exitToMenu
{
    PlayerMenuScene * menuScene = [PlayerMenuScene node];
 	[[Director sharedDirector] replaceScene:menuScene];
}

-(void) startUpgrade
{
	NSString* levelName = [levelMap objectAtIndex:level-1];
	ALevel* gameLevel = [ALevel levelWithName:levelName];
	
	activeTeam = team1;
	
	AGameScene* upgradeScene = [gameLevel loadUpgradeScene];
	
	AShip* upgradeShip = [gameLevel loadUpgradeShip];
	[activeTeam putHeroesToShip:upgradeShip heroes:nil];
	AShip* downgradeShip = [AShip shipWithName:[team1 getShip].name];
	[activeTeam putHeroesToShip:downgradeShip heroes:nil];
	[upgradeScene setShips:downgradeShip ship2:upgradeShip];
	
	[[Director sharedDirector] replaceScene:upgradeScene];
	
	gameScene = [upgradeScene retain];
}

-(void) onUpgradeShip
{
	[(UpgradeScene*)gameScene showUpgradeShip];
}

-(void) onDowngradeShip
{
	[(UpgradeScene*)gameScene showDowngradeShip];
}

-(void) completeUpgrade:(int)credits  bows:(int)bows rockets:(int)rockets ship:(BOOL)newShip
{
	NSString* levelName = [levelMap objectAtIndex:level-1];
	ALevel* gameLevel = [ALevel levelWithName:levelName];
	AShip* ship = newShip ? [gameLevel loadUpgradeShip] : [AShip shipWithName:[team1 getShip].name];	
	
	[activeTeam setShip:ship];
	
	[activeTeam setProjectileCountForWeapon:@"BowWeapon" count:bows];
	[activeTeam setProjectileCountForWeapon:@"RocketWeapon" count:rockets];
	activeTeam.credits = credits;
	activeTeam = nil;
	
	// Demkovich
	[[GameSystem sharedGame] saveGame];
	
	[gameScene release];
	gameScene = nil;
	
	[self startNextLevel];
}

-(void) updateMiniMap
{
	[gameScene updateMiniMapHeroLifes:[team1 getHeroHelthArray] lifes:[team2 getHeroHelthArray]];	
}

-(void) activateNextTeam
{
	[activeTeam deactivate];
    [[GameSystem sharedGame] hideAimControls];
	activeTeam = (activeTeam != team1) ? team1 : team2;
	[activeTeam activate];
}

-(ATeam*) getNextTeam
{
    if(activeTeam == team1)
		return team2;
	else 
		return team1;
}

-(void) strikeDidFinish
{
	BOOL team1IsLost = [team1 isLost];
	BOOL team2IsLost = [team2 isLost];
	
	if( (team1IsLost && gameMode == kStoryModeGame) || 
	    (team1IsLost && gameMode == kServerModeGame) ||
	    (team2IsLost && gameMode == kClientModeGame) )
	{
		// game lost 			
		[team1 deactivate];
		[team2 activateLastScene];
		[gameScene hideAimLayer];
		
		Scene* lostScene = [LostScene node];
		[team2 makeHeroesLost];
		[gameScene addChild:lostScene z:10];
	}
	else if( (team2IsLost && gameMode == kStoryModeGame) || 
			 (team2IsLost && gameMode == kServerModeGame) ||
			 (team1IsLost && gameMode == kClientModeGame) )
	{
		// game won !!!
		[activeTeam deactivate];
		
		[self setTimeUsed];
		[self setShotsUsed];
		
		CocosNode* wonTable = [WonTable node];
		
		[gameScene hideAimLayer];
		[gameScene addChild:wonTable z:10];
		[gameScene showExitButton:NO];
	}
	else
	{
		// continue game
		[self activateNextTeam];
	}
}

-(AGameScene*) gameScene
{
	return gameScene;
}

-(ATeam*) team1
{
	return team1;
}

-(ATeam*) team2
{
	return team2;
}

-(NSArray*) gameTeams
{
	NSArray* teams = [[[NSArray alloc] initWithObjects: team1, team2, nil] autorelease];
	return teams;
}

-(void) showAimControls
{
	[gameScene showAimLayer];
}

-(void) hideAimControls
{
	[gameScene hideAimLayer];
}



-(void) saveGame
{
	if( !gameMode || !level || !gameScene || !team1 || !team2 )
		return;
	
	NSMutableDictionary* gameDict = [[NSMutableDictionary alloc] init];
	[gameDict setObject:[NSNumber numberWithInt:gameMode] forKey:@"gamemode"];
	[gameDict setObject:[NSNumber numberWithInt:level] forKey:@"level"];
	
	//team1Prop = [team1 getTeamProperties];	
	//[gameDict setObject: team1Prop forKey: @"team1"];
	[gameDict setObject: [team1 getTeamProperties] forKey: @"team1"];
	
	//team2Prop = [team2 getTeamProperties];	
	//[gameDict setObject: team2Prop forKey: @"team2"];
	[gameDict setObject: [team2 getTeamProperties] forKey: @"team2"];
	
	[gameDict setObject: [NSNumber numberWithInt: ( activeTeam==team2 ? 2 : 1)] forKey: @"active"];
	[gameDict setObject: [NSNumber numberWithBool: [[GameSystem sharedGame]getSound]] forKey:@"sound"];

	
    NSArray *appPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [appPaths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"game.plist"];
	NSString* errorMsg = nil;
	NSData* data  = [NSPropertyListSerialization dataFromPropertyList:gameDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorMsg];

	BOOL success = [data writeToFile:filePath atomically:YES];
	if(success)
	{
		[[NSUserDefaults standardUserDefaults] setBool: YES forKey:@"saved"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"Level %d", level] forKey:@"savename"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

-(void) loadGame
{
	BOOL bIsLost = NO;
	if([team1 isLost])
		bIsLost = YES;	
	
	if(bIsLost)
	{
		[[GameSystem sharedGame] startUpgrade];
		return;		
	}
	
	if([team2 isLost])
	{
		[[GameSystem sharedGame] startUpgrade];
		return;
	}
	
    NSArray *appPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [appPaths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"game.plist"];

	NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
	if(plistDict==nil)
		return;
	
	gameMode = [[plistDict objectForKey:@"gamemode"] intValue];
	level =  [[plistDict objectForKey:@"level"] intValue];
	team1Prop = [plistDict objectForKey:@"team1"];
	team2Prop = [plistDict objectForKey:@"team2"];
	int activeTeamIndex = [[plistDict objectForKey:@"active"] intValue];
	[[GameSystem sharedGame]setSound:[[plistDict objectForKey:@"sound"] boolValue]];
	
	[self loadLevelMap];
	NSString* levelName = [levelMap objectAtIndex:level-1];
	ALevel* gameLevel = [ALevel levelWithName:levelName];
	
	team1 = [[ATeam teamWithProperties:team1Prop] retain];
	team1Prop = nil;
	
	team2 = [[ATeam teamWithProperties:team2Prop] retain];	
	team2Prop = nil;

	gameScene = [[gameLevel loadGameScene] retain];
	[gameScene setShips:[team1 getShip] ship2:[team2 getShip]];
	
	[[Director sharedDirector] replaceScene:gameScene];	
	
	[PhysicsSystem initSystem];
	[gameScene physicsRegister];
	[team1 physicsRegister];
	[team2 physicsRegister];
	
	activeTeam = (activeTeamIndex==2) ? team2 : team1;
	
	/*if([team1 isLost])
		[self strikeDidFinishF];*/
	
	/*if(bIsLost)
		[[GameSystem sharedGame] startUpgrade];
	
	if([team2 isLost])
	{
		[[GameSystem sharedGame] startUpgrade];
		return;
	}*/
}


- (void) setConnectionPoint:(TCPConnectionPoint*) cp
{
	[connectionPoint release];
	connectionPoint  = cp;
	[connectionPoint retain];
	connectionPoint.delegate = self;
}

- (void) connectionAttemptFailed:(TCPConnectionPoint*)connection
{
	
}

- (void) connectionTerminated:(TCPConnectionPoint*)connection
{
	
}

-(void) connection:(TCPConnectionPoint*)connection didReceivePacket:(NSDictionary*)packet
{
	NSString* packetType = [packet valueForKey:@"type"];
	if( [packetType compare:@"aimer"] == NSOrderedSame )
	{
		[NetworkSlaveAimer translateNetworkPacket:packet];
	}	
}




+(id) alloc
{
	NSAssert(_sharedGamePtr == nil, @"Attempted to allocate a second instance of a singleton.");
	return _sharedGamePtr = [super alloc];
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}
- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
	return UINT_MAX; //denotes an object that cannot be released
}

-(void) showActivityIndicator
{
	UIImage* loadingImage = [UIImage imageNamed:@"Glass_Loading.png"];
	loadingView = [[[UIImageView alloc] initWithImage:loadingImage] autorelease];
	[[[Director sharedDirector] openGLView] addSubview:loadingView];
	[loadingView setTransform: CGAffineTransformMakeRotation(3.1415/2) ];
	loadingView.frame = CGRectMake(0,0, 320, 480);
	UIActivityIndicatorView* loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingIndicator.frame = CGRectMake(215,180, 50, 50);
	[loadingIndicator startAnimating];
	[loadingView addSubview:loadingIndicator];

}

- (void)release 
{
	// never release
}

- (id)autorelease 
{
	return self;
}

@end
