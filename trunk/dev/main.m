//
//  main.m
//  PirateWars
//
//  Created by Vladimir Demkovich on 11/12/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"PirateWarsAppDelegate");
    [pool release];
    return retVal;
}
