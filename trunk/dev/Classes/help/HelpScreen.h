//
//  HelpScreen.h
//  PiratesWar
//
//  Created by Vladimir Demkovich on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface HelpScene : Scene {
	BOOL IsReturnToGame;
}
@property (nonatomic) BOOL IsReturnToGame;
@end


@interface HelpSceneLayer: Layer
{
	CGPoint startPoint;
	CGPoint sliderPoint;
	MenuItemToggle *item1, *item2, *item3, *itemStr, *itemCount;
	MenuItemToggle *pNextAdv, *pPrevAdv; 
	//BOOL bOnSound;
	int iAdviceCount; 
	int iCurrentAdvice;	
}
-(void) DecrementAdv;
-(void) IncrementAdv;
-(void) SetActivePic:(int) direction;
@end

