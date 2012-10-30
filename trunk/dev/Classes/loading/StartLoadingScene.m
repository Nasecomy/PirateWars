//  StartLoadingScene.m
//  PiratesWars
//
//  Created by Vladimir Demkovich on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "StartLoadingScene.h"
#import "PlayerMenuScene.h"

@implementation StartLoadingScene

@synthesize fireSprite;

- (void) dealloc
{
	[fireSprite release];
	[super dealloc];
}

- (id) init {
    self = [super init];
    if (self != nil) {
        Sprite * bg = [Sprite spriteWithFile:@"Loading_Screen.png"];
		CGSize s = [[Director sharedDirector] winSize];
		[bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg z:0];
        [self addChild:[StartLoadingLayer node] z:1];	
		
		//Create our test sprite
		FireSprite *sprite = [[FireSprite alloc] init];
		self.fireSprite = sprite;
		[sprite release];
		
		//Add the test sprite to the Scene
		[self addChild:fireSprite];
		
    }
    return self;
}
@end

@implementation StartLoadingLayer
- (id) init {
    self = [super init];
    if (self != nil) {
	    [MenuItemFont setFontSize:20];
	    [MenuItemFont setFontName:@"Helvetica"];
        MenuItemFont *start = [MenuItemFont itemFromString:@"Start Game"
												target:self
											  selector:@selector(startGame:)];
        Menu *menu = [Menu menuWithItems:start, nil];
        [menu alignItemsVertically];
	
        [self addChild:menu];
		
    }
    return self;
}
-(void)startGame: (id)sender {
    PlayerMenuScene * gs = [PlayerMenuScene node];
	[[TextureMgr sharedTextureMgr] removeUnusedTextures];
    [[Director sharedDirector] replaceScene:gs];
	
}
-(void)help: (id)sender {
    NSLog(@"help");
}
@end
