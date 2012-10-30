//
//  GameDebugViewController.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameDebugViewController.h"

#import "GameSystem.h"
#import "Level.h"
#import "Team.h"

@implementation GameDebugViewController

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
	levelMap = [levelDatabase objectForKey: @"StoryModeLevels"];
	[levelMap retain];
}


-(void) getDebugTeamProp
{
	NSString* levelName = [levelMap objectAtIndex:0];
	ALevel* level = [ALevel levelWithName:levelName];
	teamProp = [NSMutableDictionary dictionaryWithDictionary:[level team1Properties]];
	[teamProp retain];
}



-(id)init
{
	if( [super init]!=nil )
	{
		
		[self loadLevelMap];
		[self getDebugTeamProp];
		
		
		return self;
	}	
	return nil;
}

-(void)loadView
{
	UIView* view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	view.backgroundColor = [UIColor whiteColor];
	self.view = view;
	[view release];


	UILabel* levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,120,120,30)];
	[levelLabel setText:@"Go to level:"];
	[view addSubview:levelLabel];
	[levelLabel release];
	
	levelTextField = [[UITextField alloc] initWithFrame:CGRectMake(140,120,50,30)];
	levelTextField.text = @"1";
	levelTextField.borderStyle = UITextBorderStyleBezel;
	levelTextField.backgroundColor = [UIColor whiteColor];
	levelTextField.returnKeyType = UIReturnKeyDone;
	levelTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	levelTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
	levelTextField.delegate = self;
	[view addSubview:levelTextField];
	[levelTextField release];
	
	UIButton *levelButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 120, 60, 30)];
	levelButton.backgroundColor = [UIColor grayColor];
	[levelButton setTitle:@"GO" forState:UIControlStateNormal];
	[levelButton addTarget:self action:@selector(onGoToLevel:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:levelButton];
	[levelButton release];
	
	

	UILabel* creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,20,120,30)];
	[creditLabel setText:@"Credit:"];
	[view addSubview:creditLabel];
	[creditLabel release];
	
	creditTextField = [[UITextField alloc] initWithFrame:CGRectMake(120,20,80,30)];
	creditTextField.borderStyle = UITextBorderStyleBezel;
	creditTextField.backgroundColor = [UIColor whiteColor];
	creditTextField.returnKeyType = UIReturnKeyDone;
	creditTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	creditTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
	creditTextField.delegate = self;
	[view addSubview:creditTextField];
	[creditTextField release];
	
	UIButton *creditButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 20, 100, 30)];
	creditButton.backgroundColor = [UIColor grayColor];
	[creditButton setTitle:@"Set credits" forState:UIControlStateNormal];
	[creditButton addTarget:self action:@selector(onSetCredits:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:creditButton];
	[creditButton release];

	
	
	
	UILabel* roketLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,70,130,30)];
	[roketLabel setText:@"Set Rockets:"];
	[view addSubview:roketLabel];
	[roketLabel release];
	
	rocketTextField = [[UITextField alloc] initWithFrame:CGRectMake(130,70,30,30)];
	rocketTextField.borderStyle = UITextBorderStyleBezel;
	rocketTextField.backgroundColor = [UIColor whiteColor];
	rocketTextField.returnKeyType = UIReturnKeyDone;
	rocketTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	rocketTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
	rocketTextField.delegate = self;
	[view addSubview:rocketTextField];
	[rocketTextField release];
	
	UILabel* bowLabel = [[UILabel alloc] initWithFrame:CGRectMake(170,70,130,30)];
	[bowLabel setText:@"and bows:"];
	[view addSubview:bowLabel];
	[bowLabel release];

	bowTextField = [[UITextField alloc] initWithFrame:CGRectMake(250,70,30,30)];
	bowTextField.borderStyle = UITextBorderStyleBezel;
	bowTextField.backgroundColor = [UIColor whiteColor];
	bowTextField.returnKeyType = UIReturnKeyDone;
	bowTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	bowTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
	bowTextField.delegate = self;
	[view addSubview:bowTextField];
	[bowTextField release];

	UIButton *weaponsButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 70, 120, 30)];
	weaponsButton.backgroundColor = [UIColor grayColor];
	[weaponsButton setTitle:@"Set weapons" forState:UIControlStateNormal];
	[weaponsButton addTarget:self action:@selector(onSetWeapons:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:weaponsButton];
	[weaponsButton release];
	
	
	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 270, 100, 30)];
	backButton.backgroundColor = [UIColor grayColor];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:backButton];
	[backButton release];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)onGoToLevel:(id)sender
{
	if([levelTextField.text length] > 0)
	{
		int levelNum = [levelTextField.text intValue];
		NSString* levelName = [levelMap objectAtIndex:levelNum-1];
		if(levelName!=nil)
		{
			ALevel* level = [ALevel levelWithName:levelName];
			if(level!=nil)
			{
				[[GameSystem sharedGame] startDebugLevel:levelNum withTeamProperties:teamProp];
				[self.view removeFromSuperview];
			}
		}
	}
}

- (void)onSetCredits:(id)sender
{
	if([creditTextField.text length] > 0)
	{
		int credits = [creditTextField.text intValue];
		[teamProp setObject:[NSNumber numberWithInt:credits] forKey:@"credits"];
	}
}

-(void) setProjectiles:(int)projectiles forWeapon:(NSString*)weapon
{
	NSArray* oldWeaponArray = [teamProp objectForKey:@"weapons"];
	NSMutableArray* weaponArray;
	if(oldWeaponArray!=nil)
	{
		weaponArray = [NSMutableArray arrayWithArray:oldWeaponArray];
		for(NSDictionary* oldWeaponItem in weaponArray)
		{
			NSString* name = [oldWeaponItem objectForKey:@"name"];
			if( [name compare:weapon]==NSOrderedSame )
			{
				[weaponArray removeObject:oldWeaponItem];
				break;
			}			
		}
	}
	else
	{
		weaponArray = [[[NSMutableArray alloc] init] autorelease];
	}
	
	NSMutableDictionary* weaponItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									weapon, @"name",
									[NSNumber numberWithInt:projectiles], @"projectiles",
									   nil];
	[weaponArray addObject:weaponItem];
	[weaponItem release];
	[teamProp setObject:weaponArray forKey:@"weapons"];
}

- (void)onSetWeapons:(id)sender
{
	int rockets = [rocketTextField.text intValue];
	[self setProjectiles:rockets forWeapon:@"RocketWeapon"];
	int bows = [bowTextField.text intValue];
	[self setProjectiles:bows forWeapon:@"BowWeapon"];
}


- (void)onBack:(id)sender
{
	[self.view removeFromSuperview];
}


-(void) dealloc
{
	[teamProp release];
	
	[super dealloc];
}

@end
