//
//  IPADAppDelegate.h
//  IPAD
//
//  Created by Sun Yu on 11-12-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "FirstNavigationViewController.h"
#import "LoginViewController.h"
@class   HTTPServer;
@class   SecondMainController;
#import <UIKit/UIKit.h>

@interface IPADAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
	LoginViewController *loginContrller;
	
	NSDictionary *addresses;
	NSString *ipAddress;
	
	
	NSString *databaseName; 
	NSString *databasePath; 
	NSString *databaseFile; 
	NSString *masterName; 
	NSString *masterPath; 
	NSString *masterFile;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet LoginViewController *loginContrller;
@property (nonatomic, retain) IBOutlet FirstNavigationViewController *firstContoller;
@property (nonatomic,assign ) SecondMainController *secondNavigation;
@property (nonatomic, retain) NSString *ipAddress;

- (NSString*)getIpAddress;
- (void)checkAndCreateDatabase;
- (void)displayInfoUpdate:(NSNotification *) notification;
@end