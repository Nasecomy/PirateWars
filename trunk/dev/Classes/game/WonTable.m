//
//  WonTable.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WonTable.h"

#import "Skin.h"
#import "GameSystem.h"

@implementation WonTable

-(id)init
{
	if ([super init]) 
	{
		ASkin* bg = [ASkin skinWithName:@"WonTableSkin"];
		[self addChild:[bg node] z:1];	
		
		Label* levelLabel = [Label labelWithString:[NSString stringWithFormat:@"Level %d", [[GameSystem sharedGame] getCurrentLevel]] fontName:@"Arial-BoldMT" fontSize:14];
		[self addChild:levelLabel z:10];
		[levelLabel setPosition: ccp(240, 200)];
		[levelLabel setRGB:109 :23 :23];

		Label* levelcomplLabel = [Label labelWithString:@"level completed =>" fontName:@"Arial" fontSize:12];
		[self addChild:levelcomplLabel z:10];
		[levelcomplLabel setPosition: ccp(200, 180)];
		[levelcomplLabel setRGB:33 :33 :33];
		
		Label* creditLevel = [Label labelWithString:[NSString stringWithFormat:@"%d coins", 500] fontName:@"Arial-BoldMT" fontSize:12];
		[self addChild:creditLevel z:10];
		[creditLevel setPosition: ccp(320, 180)];
		[creditLevel setRGB:0 :0 :0];
	
		int creditsForShots = 0;
		if ([[GameSystem sharedGame] getShotsUsed] <= 6)
			creditsForShots = 500;
		
		Label* creditShots = [Label labelWithString:[NSString stringWithFormat:@"%d coins", creditsForShots] fontName:@"Arial-BoldMT" fontSize:12];
		[self addChild:creditShots z:10];
		[creditShots setPosition: ccp(320, 160)];
		[creditShots setRGB:0 :0 :0];
		
		int creditsForTime = 0;
		if ([[GameSystem sharedGame] getTimeUsed] <= 25)
			creditsForTime = 500;
			
		Label* creditTime = [Label labelWithString:[NSString stringWithFormat:@"%d coins", creditsForTime] fontName:@"Arial-BoldMT" fontSize:12];
		[self addChild:creditTime z:10];
		[creditTime setPosition: ccp(320, 140)];
		[creditTime setRGB:0 :0 :0];
		
		int levelsGold = creditsForTime + creditsForShots + 500;
		Label* goldLabel = [Label labelWithString:[NSString stringWithFormat:@"COINS EARNED: %d", levelsGold] fontName:@"Verdana-Bold" fontSize:11];
		[self addChild:goldLabel z:10];
		[goldLabel setPosition: ccp(240, 120)];
		[goldLabel setRGB:3 :91 :123];
	
		int totalCredits = levelsGold + [[GameSystem sharedGame] getCredits];
		[[GameSystem sharedGame] setCredits:totalCredits];
		Label* totalLabel = [Label labelWithString:[NSString stringWithFormat:@"Total coins: %d", totalCredits] fontName:@"Arial" fontSize:12];
		[self addChild:totalLabel z:10];
		[totalLabel setPosition: ccp(240, 100)];
		[totalLabel setRGB:109 :23 :23];
		
		Label* undeline = [Label labelWithString:@"-----------------------" fontName:@"Arial" fontSize:12];
		[self addChild:undeline z:10]; 
		[undeline setPosition: ccp(240, 95)];
		[undeline setRGB:109 :23 :23];
			
		int usedTime = [[GameSystem sharedGame] getTimeUsed];
		NSString* strTime = @"time used: ";
		if(usedTime < 60)
		{
			if(usedTime > 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d secs =>", usedTime]];
			else
				strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d secs =>", usedTime]];
		}
		
		if(usedTime >= 60 && usedTime < 3600)
		{
			int min = usedTime/60;
			int sec = usedTime%60;
			
			if(min > 1  && sec > 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d mins %d secs =>", min, sec]];
			
			if(min == 1  && sec > 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d min %d secs =>", min, sec]];		
			
			if(min > 1  && sec == 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d mins %d sec =>", min, sec]];
			
			if(min == 1  && sec == 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d min %d sec =>", min, sec]];	
			
		}
	
		if(usedTime >= 3600 && usedTime < 216000)
		{
			int h = usedTime/3600;
			int min = usedTime%3600;
			
			if(min > 1  && h > 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d hs %d mins =>", h, min]];
			
			if(min > 1  && h == 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d h %d mins =>", h, min]];
			
			if(min == 1  && h == 1)
			    strTime = [strTime stringByAppendingString: [NSString stringWithFormat:@"%d h %d min =>", h, min]];

			
		}

		if(usedTime >= 216000 )
			strTime = [strTime stringByAppendingString: @"too long.."];
		
		Label* timeLabel = [Label labelWithString:strTime fontName:@"Arial" fontSize:12];
		[self addChild:timeLabel z:10];
		[timeLabel setPosition: ccp(200, 140)];
		[timeLabel setRGB:33 :33 :33];		
	
		Label* shotsLabel = [Label labelWithString:[NSString stringWithFormat:@"shots fired: %d (par 6) =>", [[GameSystem sharedGame] getShotsUsed]] fontName:@"Arial" fontSize:12];
		[self addChild:shotsLabel z:10];
		[shotsLabel setPosition: ccp(200, 160)];
		[shotsLabel setRGB:33 :33 :33];	
		
		MenuItemImage* exitMenuItem = [MenuItemImage itemFromNormalImage:@"Level_Batton_At.png" 
														   selectedImage:@"Level_Batton_At.png" 
																  target:self selector:@selector(onNext:)];
		Menu* exitButton = [Menu menuWithItems:exitMenuItem, nil];
		exitButton.position = ccp(460, 20);
		[self addChild: exitButton];
		[exitButton retain];
		
		
		return self;
	}
	return nil;
}

-(void)onNext: (id) sender
{
	[[GameSystem sharedGame] finishLevel];
	[[GameSystem sharedGame] startUpgrade];
}

-(void) dealloc
{
	[super dealloc];
}

@end

