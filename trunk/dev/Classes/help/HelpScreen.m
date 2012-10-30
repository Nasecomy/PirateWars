//
//  HelpScreen.m
//  PiratesWar
//
//  Created by Vladimir Demkovich on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
 
#import "HelpScreen.h"

#import "PlayerMenuScene.h"
#import "StartLoadingScene.h"
#import "GameSystem.h"
#import "GameScene.h"

enum
{
	kTag1 = 1,
	kTag2 = 2,
	kTag3 = 3,
	kHelperLayer = 4,
};



@implementation HelpSceneLayer

-(id) init
{
	if( ! [super init] )
		return nil;
	
	isTouchEnabled = YES;
	CGSize s = [[Director sharedDirector] winSize];
	
	
	Sprite * bg = [Sprite spriteWithFile:@"Background_Help_Screen_2.png"];
	
	[bg setPosition:ccp(s.width/2, s.height/2)];
	[self addChild:bg z:0];
	
	sliderPoint = CGPointMake(s.width/2, s.height/2 + 10);
	Sprite * pic_0 = [Sprite spriteWithFile:@"How_To_Pic_1.png"];
	[pic_0 setPosition:sliderPoint];
	[self addChild:pic_0 z:-1 tag:kTag1];
	
	
	Sprite * pic_1 = [Sprite spriteWithFile:@"How_To_Pic_1.png"];
	[pic_1 setPosition:ccp(sliderPoint.x + 303, sliderPoint.y)];
	[self addChild:pic_1 z:-1 tag:kTag2];
	
	
	Sprite * pic_2 = [Sprite spriteWithFile:@"How_To_Pic_1.png"];
	[pic_2 setPosition:ccp(sliderPoint.x + 606, sliderPoint.y)];
	[self addChild:pic_2 z:-1 tag:kTag3];
	
	iAdviceCount = 3; 
	iCurrentAdvice = 0;
	
	item1 = [MenuItemToggle itemWithTarget:self selector:@selector(OnSelectItem:) items:
			 [MenuItemImage itemFromNormalImage:@"Button_How_To_Inactive.png" selectedImage:@"Button_How_To_Pressure.png"],
			 [MenuItemImage itemFromNormalImage:@"Button_How_To_Active.png" selectedImage:@"Button_How_To_Pressure.png"],
			 nil];
	
	item2 = [MenuItemToggle itemWithTarget:self selector:@selector(OnSelectItem:) items:
			 [MenuItemImage itemFromNormalImage:@"Button_Story_Mode_Inactive.png" selectedImage:@"Button_Story_Mode_Pressure.png"],
			 [MenuItemImage itemFromNormalImage:@"Button_Story_Mode_Active.png" selectedImage:@"Button_Story_Mode_Pressure.png"],
			 nil];
	
	item3 = [MenuItemToggle itemWithTarget:self selector:@selector(OnSelectItem:) items:
			 [MenuItemImage itemFromNormalImage:@"Button_War_Mode_Inactive.png" selectedImage:@"Button_War_Mode_Pressure.png"],
			 [MenuItemImage itemFromNormalImage:@"Button_War_Mode_Active.png" selectedImage:@"Button_War_Mode_Pressure.png"],
			 nil];
	
	MenuItemImage *item4 = [MenuItemImage itemFromNormalImage:@"Button_Exit_Inactive.png" selectedImage:@"Button_Exit_Pressure.png" target:self selector:@selector(OnExitHelp:)];
	
	MenuItemToggle *item5 = [MenuItemToggle itemWithTarget:self selector:@selector(menuOnSound:) items:
							 [MenuItemImage itemFromNormalImage:@"Button_Sound_Off_Inactive.png" selectedImage:@"Button_Sound_Off_Pressure.png"],
							 [MenuItemImage itemFromNormalImage:@"Button_Sound_On_Inactive.png" selectedImage:@"Button_Sound_On_Pressure.png"],nil];
	
	if([[GameSystem sharedGame] getSound])
	    [item5 setSelectedIndex:1];
	
	pNextAdv = [MenuItemToggle itemWithTarget:self selector:@selector(OnNextAdv:) items:
				[MenuItemImage itemFromNormalImage:@"Button_N_P_Next_Active.png" selectedImage:@"Button_N_P_Next_Active.png"], 
				[MenuItemImage itemFromNormalImage:@"Button_N_P_Next_Inactive.png" selectedImage:@"Button_N_P_Next_Inactive.png"],
				nil];
	
	pPrevAdv = [MenuItemToggle itemWithTarget:self selector:@selector(OnPrevAdv:) items:
				[MenuItemImage itemFromNormalImage:@"Button_N_P_Previou_Inactive.png" selectedImage:@"Button_N_P_Previou_Inactive.png"], 
				[MenuItemImage itemFromNormalImage:@"Button_N_P_Previou_Active.png" selectedImage:@"Button_N_P_Previou_Active.png"],
				nil];
	
	[MenuItemFont setFontSize:14];
	
	
	itemStr = [MenuItemToggle itemWithTarget:self selector:@selector(OnNextAdvStr:) items:
			   [MenuItemFont itemFromString: @"Shift the screen up/down to adjust the angle"], 
			   [MenuItemFont itemFromString: @"When the user taps it, the game goes to the previous screen"],
			   [MenuItemFont itemFromString: @"Now you can exit help"],
			   nil];
	
	itemCount = [MenuItemToggle itemWithTarget:self selector:@selector(OnNextAdvStr:) items:
				 [MenuItemFont itemFromString: @"1/3"], 
				 [MenuItemFont itemFromString: @"2/3"],
				 [MenuItemFont itemFromString: @"3/3"],
				 nil];		
	
	Menu *menu = [Menu menuWithItems: item1, item2, item3, item4, item5, pNextAdv, pPrevAdv, itemStr, itemCount, nil];	
	menu.position = ccp(0,0);
	
	item1.position = ccp(120,295);
	item2.position = ccp(240,295);
	item3.position = ccp(360,295);
	item4.position = ccp(s.width/2 + 200, 35);	
	item5.position = ccp(s.width/2 - 200, 35);
	
	pNextAdv.position = ccp(s.width/2 + 200, s.height/2);	
	pPrevAdv.position = ccp(s.width/2 - 200, s.height/2);
	
	itemStr.position = ccp(s.width/2, 20);
	itemCount.position = ccp(s.width/2 + 200, s.height/2 + 70);
	
	[item1 setSelectedIndex:1];		
	[self addChild: menu z:3];
	
	


	
	return self;
}

- (BOOL)ccTouchesBegan:(NSMutableSet *)touches withEvent:(UIEvent *)event
{	
	UITouch *touch = [touches anyObject];
	startPoint = [touch locationInView: [touch view]];
    startPoint =  [[Director sharedDirector] convertCoordinate: startPoint];
	
	return YES;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    point =  [[Director sharedDirector] convertCoordinate: point];
	
	if( fabs(startPoint.x - point.x) < 10)
		return NO;
	
	int direction = 1;
	if(startPoint.x < point.x)
		direction = -1;
	
	if(direction>0)
		[self IncrementAdv];
	else 
		[self DecrementAdv];
		
	
	return kEventHandled;
}


-(void) OnSelectItem: (id) sender
{
	[item1 setSelectedIndex:0];
	[item2 setSelectedIndex:0];	
	[item3 setSelectedIndex:0];
	
	[sender setSelectedIndex:1];
}

-(void) menuOnSound: (id) sender
{
	[[GameSystem sharedGame] setSound: ![[GameSystem sharedGame] getSound] ];
}


-(void) SetActivePic:(int) direction
{	

	sliderPoint.x += direction*303;
	
	
	CocosNode *s1 = [self getChildByTag:kTag1];
	[s1 stopAllActions];
	[s1 runAction: [MoveTo actionWithDuration:0.3 position:ccp(sliderPoint.x, sliderPoint.y)]];
	
	CocosNode *s2 = [self getChildByTag:kTag2];
	[s2 stopAllActions];
	[s2 runAction: [MoveTo actionWithDuration:0.3 position:ccp(sliderPoint.x + 303, sliderPoint.y)]];
	
	CocosNode *s3 = [self getChildByTag:kTag3];
	[s3 stopAllActions];
	[s3 runAction: [MoveTo actionWithDuration:0.3 position:ccp(sliderPoint.x + 606, sliderPoint.y)]];


}

-(void) OnPrevAdv: (id) sender
{
	[self DecrementAdv];
}

-(void) DecrementAdv
{
	iCurrentAdvice--;
	
	if(iCurrentAdvice >= 0)
	    [self SetActivePic:1];

	if(iCurrentAdvice < 0)
		iCurrentAdvice = 0;
	
	if(iCurrentAdvice > 0)
	    [pPrevAdv setSelectedIndex:1];
	else
		[pPrevAdv setSelectedIndex:0];
	
	if(iCurrentAdvice < iAdviceCount-1)
	    [pNextAdv setSelectedIndex:0];	
	
	[itemStr setSelectedIndex:iCurrentAdvice];
	[itemCount setSelectedIndex:iCurrentAdvice];
	
}

-(void) OnNextAdv: (id) sender
{
	[self IncrementAdv];	
}

-(void) IncrementAdv
{
	iCurrentAdvice++;

	if(iCurrentAdvice < iAdviceCount)
	    [self SetActivePic:-1];
	
	if(iCurrentAdvice > iAdviceCount-1)
		iCurrentAdvice = iAdviceCount-1;
	
	if(iCurrentAdvice == iAdviceCount-1)
	    [pNextAdv setSelectedIndex:1];
	else
		[pNextAdv setSelectedIndex:0];
	
	if(iCurrentAdvice > 0)
	    [pPrevAdv setSelectedIndex:1];	
	
	[itemStr setSelectedIndex:iCurrentAdvice];
	[itemCount setSelectedIndex:iCurrentAdvice];
	
}

-(void) OnNextAdvStr: (id) sender
{
	[sender setSelectedIndex:1];
}

-(void) OnExitHelp: (id) sender
{
	//PlayerMenuScene * gs = [PlayerMenuScene node];
	//[[Director sharedDirector] replaceScene:gs];
	HelpScene* hlpsc = (HelpScene*)[self parent];
	
	if(![hlpsc IsReturnToGame])
	{
	    PlayerMenuScene * gs = [PlayerMenuScene node];
		[[Director sharedDirector] replaceScene:gs];
	}
	else {
		AGameScene * gs = [[GameSystem sharedGame] getScene];
		[[Director sharedDirector] replaceScene:gs];
	}
	
	return;		
}

- (void) dealloc
{
	[super dealloc];
}
@end





@implementation HelpScene

@synthesize IsReturnToGame;

- (id) init {
    self = [super init];
    if (self != nil) {
		
        [self addChild:[HelpSceneLayer node] z:0 tag:kHelperLayer];			
    }
    return self;
}

-(void) dealloc
{
	[super dealloc];	
}

@end

