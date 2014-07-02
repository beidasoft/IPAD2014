//
//  IPADAppDelegate.m
//  IPAD
//
//  Created by Sun Yu on 11-12-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <mach/mach.h>
#import "LoginViewController.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAdresses.h"
#import "NavController.h"
#import "NSData+Base64.h"
#import "IPADAppDelegate.h"
#import "SQLiteOptions.h"
#import "Utilities.h"

//#define TEMPLATENAME template
@implementation IPADAppDelegate

@synthesize window,ipAddress,firstContoller,secondNavigation,navigationController,loginContrller;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
// 	NSData *data = [NSData dataWithContentsOfFile:[Utilities bundlePath:@"8.jpg"]];
//	NSString *s = [NSString stringWithFormat:@"data:image/png;base64,%@",[data base64EncodedString]];    
//	NSURL *url = [NSURL URLWithString:s];
//	
//	NSLog(@"base64=====%@",s);
//	NSData *imageData = [NSData dataWithContentsOfURL:url];
//	UIImage *ret = [UIImage imageWithData:imageData];
//    UIImageView *v = [[UIImageView alloc]initWithImage:ret];
//	v.frame = CGRectMake(50,50, 100, 100);
//	[background addSubview:v];
//	v.backgroundColor = [UIColor grayColor];
//	NSLog(@"frame====%@",NSStringFromCGRect(v.frame));
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAdresses performSelectorInBackground:@selector(list) withObject:nil];

	[self displayInfoUpdate:nil];
	
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault registerDefaults:[self settingsBundleDefaultValues]];

	databaseName = @"test.db" ;
	masterName = @"Databases.db"; 
	
	// Get the path to the Library directory and append the databaseName 
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
	(NSLibraryDirectory, NSUserDomainMask, YES); 
	NSString *libraryDir = [libraryPaths objectAtIndex:0]; 
    
	
	
	// the directory path for the Databases.db file 
	masterPath = [libraryDir stringByAppendingPathComponent:@"WebKit/Databases/"]; 
	
	// the directory path for the 0000000000000001.db file 
	databasePath = [libraryDir stringByAppendingPathComponent:@"WebKit/Databases/file__0/"]; 
	
	// the full path for the Databases.db file 
	masterFile = [masterPath stringByAppendingPathComponent:masterName]; 
	// the full path for the 0000000000000001.db file 
	databaseFile = [databasePath 
					stringByAppendingPathComponent:databaseName]; 
	// Execute the "checkAndCreateDatabase" function 
	[self checkAndCreateDatabase];
	
	
	loginContrller = [[LoginViewController alloc]init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:loginContrller];
	navigationController.navigationBar.topItem.title = @"系统登陆";
	[navigationController setNavigationBarHidden:YES];
	//[Utilities createTemplate];
	//[Utilities createHtmlTemplate];
//	UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serverTitle.png"]];
//	imageview.frame = CGRectMake(0, 0, 1024, 44); 
//	navigationController.navigationItem.titleView = imageview;
	
	
	NSString *bundlePath = [Utilities bundlePath:@"password.plist"];
	NSString *documentPath = [Utilities documentsPath:@"password.plist"];
	if (![Utilities isFileExist:documentPath])
	{
		[Utilities copyFile:bundlePath to:documentPath];
	}
	
	
	//[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(report) userInfo:nil repeats:YES];
	//add by zyy 2013-06-05为了兼容ios6及以上版本的sdk，支持屏幕旋转
	if([[UIDevice currentDevice].systemVersion floatValue] < 6.0){
        //ios5及以下做法
        [self.window addSubview:navigationController.view];
    }
    else{
        //ios6需要设置为rootviewcontorller
        [self.window setRootViewController:navigationController];
    }
    //[self.window addSubview:navigationController.view];
    //ios7状态栏显示 modify by zyy 2014-02-17
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //去掉ios7状态栏的占位，现在的调整只适合横屏app
        self.window.frame = CGRectMake(0,0, self.window.frame.size.width-20, self.window.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.window makeKeyAndVisible];
	
	return YES;
}
- (void)report
{
	report_memory();
}
void report_memory(void) {
	
	struct task_basic_info info;
	
	mach_msg_type_number_t size = sizeof(info);
	
	kern_return_t kerr = task_info(mach_task_self(),
								   TASK_BASIC_INFO,
								   (task_info_t)&info,
								   &size);
	
	if( kerr == KERN_SUCCESS ) {
		
		NSLog(@"Memory used: %u", info.resident_size); //in bytes
		
	} else {
		
		NSLog(@"Error: %s", mach_error_string(kerr));
		
	}
	
}


- (void)checkAndCreateDatabase{ 
	// Check if the SQL database has already been saved to the users 
	//phone, if not then copy it over 
	BOOL success; 
	//NSDate *date = [NSDate date];
	// Create a FileManager object, we will use this to check the status 
	// of the database and to copy it over if required 
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	success = [fileManager fileExistsAtPath:databasePath]; 
	
	// If the database already exists then return without doing anything 
	if(success) return; 
	
	// If not then proceed to copy the database from the application to 
	//the users filesystem 
	
	// Get the path to the database in the application package 
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] 
									 stringByAppendingPathComponent:databaseName]; 
	NSString *masterPathFromApp = [[[NSBundle mainBundle] resourcePath] 
								   stringByAppendingPathComponent:masterName]; 
	
	// Create the database folder structure 
	[fileManager createDirectoryAtPath:databasePath 
		   withIntermediateDirectories:YES attributes:nil error:NULL]; 
	
	// Copy the database from the package to the users filesystem 
	[fileManager copyItemAtPath:databasePathFromApp toPath:databaseFile 
						  error:nil]; 
	// Copy the Databases.db from the package to the appropriate place 
	[fileManager copyItemAtPath:masterPathFromApp toPath:masterFile 
						  error:nil]; 
	
	[fileManager release]; 
	//SLog(@"时间间隔：%f",[date timeIntervalSinceNow]);
}

- (void)displayInfoUpdate:(NSNotification *) notification
{
	//NSLog(@"displayInfoUpdate:");
	
	if(notification)
	{
		[addresses release];
		addresses = [[notification object] copy];
		//NSLog(@"addresses: %@", addresses);
	}
	if(addresses == nil)
	{
		return;
	}
	
	NSString *info;
	//	UInt16 port = [httpServer port];
	
	NSString *localIP = [addresses objectForKey:@"en0"];
	if (!localIP)
	{
		info = @"No Wifi connection!\n";
	}else{
		info = [NSString stringWithFormat:@"%@", localIP];
	}
	
	ipAddress = [[NSString alloc] initWithFormat:@"%@:8080",info];
	
}

- (NSString*)getIpAddress
{
	return ipAddress;
}


//配置是否联网删除
- (NSDictionary*)settingsBundleDefaultValues
{
    NSMutableDictionary *defaultDic_ = [[NSMutableDictionary alloc]init];
    NSURL *settingsUrl =
    [NSURL fileURLWithPath:[[NSBundle mainBundle]
                            pathForResource:@"Root"
                            ofType:@"plist"
                            inDirectory:@"Settings.bundle"] isDirectory:YES];
    NSDictionary *settingBundle = [NSDictionary dictionaryWithContentsOfURL:settingsUrl];
    NSArray *preference_ = [settingBundle objectForKey:@"PreferenceSpecifiers"];
    for (NSDictionary *component_ in preference_) {
        NSString *key = [component_ objectForKey:@"Key"];
        NSString *defaultValue = [component_ objectForKey:@"DefaultValue"];
        if (!key||!defaultValue) continue;
        if (![component_ objectForKey:key]) {
            [defaultDic_ setObject:[component_ objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    return defaultDic_;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	//[httpServer release];
	
	[loginContrller release];
	[navigationController release];
    [window release];
	[firstContoller release];
    [super dealloc];
}

@end