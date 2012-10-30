//
//  StartLoadingScene.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 8/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "AnimatedFire.h"

@interface StartLoadingScene : Scene 
{
	FireSprite *fireSprite;
}
@property (nonatomic, retain) FireSprite *fireSprite;
@end

@interface StartLoadingLayer : Layer
{
}

-(void)startGame: (id)sender;
-(void)help: (id)sender;
@end
