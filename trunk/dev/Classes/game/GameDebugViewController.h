//
//  GameDebugViewController.h
//  PirateWars
//
//  Created by Vladimir Demkovich on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameDebugViewController : UIViewController <UITextFieldDelegate>
{
	UITextField* levelTextField;
	UITextField* creditTextField;
	UITextField* rocketTextField;
	UITextField* bowTextField;
	
	NSArray* levelMap;
	NSMutableDictionary* teamProp;
}

@end
