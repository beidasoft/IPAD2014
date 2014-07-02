    //
//  SecondMainController.m
//  IPAD
//
//  Created by Sun Yu on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondMainController.h"
#import "HistoryController.h"
#import "SearchController.h"
#import "Utilities.h"
#import "OtherController.h"
@implementation SecondMainController
@synthesize tabBarController,initType,titleArray;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad 
{
    [super viewDidLoad];
   
	[self showTabBarController:initType];

	
}


//显示TabBar控制器
- (void) showTabBarController:(int)type
{
	
	if (tabBarController) {
		[tabBarController.view removeFromSuperview];
		self.tabBarController = nil;
	}
	
	//创建tabbar
	self.tabBarController = [[MPTabBarController alloc] init];
	[tabBarController release];
	tabBarController.delegate = self;
	
	
	NSMutableArray *arrControllers = [[NSMutableArray alloc]init];
	
	NSString *unitSql = @"select * from IPAD_JB02 limit 0,1";
	NSArray *unitArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:unitSql];
	NSMutableArray *nameArr = [[NSMutableArray alloc] init];
	tabBarController.tabBar.arrNormalImages = [[NSMutableArray alloc] init];
	tabBarController.tabBar.highLightImages = [[NSMutableArray alloc] init];
	if ([unitArray count]==0)
	{
		//return;
	}
	else 
	{
		HistoryController *hc = [[HistoryController alloc] init];
		hc.title = @"干部名册";
		hc.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"干部名册" image:[UIImage imageNamed:@"gbmingce.png"] tag:0] autorelease];
		hc.delegate = self;
		[arrControllers addObject:hc];
		NSString *ganDocPath = [Utilities documentsPath:@"Small干部名册.png"];
		NSString *ganDocPathS= [Utilities documentsPath:@"Select干部名册.png"];
		if ([Utilities isFileExist:ganDocPath])
		{
			[tabBarController.tabBar.arrNormalImages addObject:[UIImage imageWithData:
																[NSData dataWithContentsOfFile:ganDocPath]]];
		}
		else {
			[tabBarController.tabBar.arrNormalImages addObject:[UIImage imageNamed:@"Small干部名册.png"]];
		}
		if ([Utilities isFileExist:ganDocPathS])
		{
			[tabBarController.tabBar.highLightImages addObject:[UIImage imageWithData:
																[NSData dataWithContentsOfFile:ganDocPathS]]];
		}else {
			[tabBarController.tabBar.highLightImages addObject:[UIImage imageNamed:@"Select干部名册.png"]];
		}
		[hc release];
	}
	
	
	for (int i=0; i<[titleArray count];i++)
	{
			[nameArr addObject:[titleArray objectAtIndex:i]];
			NSString *imageDocPath = [Utilities documentsPath:[NSString stringWithFormat:@"Small%@.png",[titleArray objectAtIndex:i]]];
			NSString *imageDocPathS = [Utilities documentsPath:[NSString stringWithFormat:@"Select%@.png",[titleArray objectAtIndex:i]]];
			if ([Utilities isFileExist:imageDocPath])
			{
				[tabBarController.tabBar.arrNormalImages addObject:[UIImage imageWithData:
																	[NSData dataWithContentsOfFile:imageDocPath]]];
			}
			else {
				[tabBarController.tabBar.arrNormalImages addObject:[UIImage imageNamed:
																	[NSString stringWithFormat:@"Small%@.png",[titleArray objectAtIndex:i]]]];
			}
			if ([Utilities isFileExist:imageDocPathS])
			{
				[tabBarController.tabBar.highLightImages addObject:[UIImage imageWithData:
																	[NSData dataWithContentsOfFile:imageDocPathS]]];
			}else {
				[tabBarController.tabBar.highLightImages addObject:[UIImage imageNamed:
																	[NSString stringWithFormat:@"Select%@.png",[titleArray objectAtIndex:i]]]];
			}
	}
	for (int i=0; i < [nameArr count]; i++)
	{
		NSLog(@"here.8");
		OtherController *oc = [[OtherController alloc]init];
		oc.tit = [nameArr objectAtIndex:i];
		oc.condition = -2;
		oc.delegate = self;
		[arrControllers addObject:oc];
		[oc release];
	}
	
	[nameArr release];
	
 
	NSLog(@"arrControllers:%@",arrControllers);
	tabBarController.viewControllers = arrControllers;
	
	int selectedIndex = type;	
	tabBarController.selectedIndex = selectedIndex;
	
	tabBarController.tabBar.backImage = [UIImage imageNamed:@"tabbar_bg.png"];
	NSLog(@"here1.5");
	UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 90)];//90
	NSString *logoImageDocPath = [Utilities documentsPath:kLogoBackgroundImageName];
	if ([Utilities isFileExist:logoImageDocPath]) 
	{
		logoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:logoImageDocPath]];
	}
	else {
		logoImage.image = [UIImage imageNamed:kLogoBackgroundImageName];
	}
	logoImage.userInteractionEnabled = YES;
	
	NSLog(@"here2");
	UIImage *logoImg;
	NSString *logo_bundlePath = [Utilities bundlePath:kLogoTitleImageName];
	NSString *logo_documentPath = [Utilities documentsPath:kLogoTitleImageName];
	NSData * logo_Data; 
	
	if ([Utilities isFileExist:logo_documentPath])
	{
		
		logo_Data = [NSData dataWithContentsOfFile:logo_documentPath];
		logoImg = [UIImage imageWithData:logo_Data];
	}
	else 
	{
		
		logo_Data = [NSData dataWithContentsOfFile:logo_bundlePath];
		
		logoImg = [UIImage imageWithData:logo_Data];
	}
	
	UIImageView *logoTitle = [[UIImageView alloc]initWithFrame:KLOGORECT];
	logoTitle.image = logoImg;
	[logoImage addSubview:logoTitle];
	[self.view addSubview:logoImage];
	[arrControllers release];
	
	CATransition *transition = [CATransition animation];
	transition.duration = 2;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type =   kCATransitionFade;
	transition.subtype = kCATransitionFromTop;
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	tabBarController.view.frame = CGRectMake(0, 0, 768, 1004);
	[self.view addSubview:tabBarController.view];
	[self.view.layer addAnimation:transition forKey:nil];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 678, 70, 70)];
    [backButton setImage:[UIImage imageNamed:@"backBt.png"] 
				forState:UIControlStateNormal];
	[backButton addTarget:self 
				   action:@selector(back)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	[backButton release];
	
	UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(862,2, 100,60)];
    [searchButton setImage:[UIImage imageNamed:@"searchMark.png"]
				  forState:UIControlStateNormal];
	[searchButton addTarget:self 
					 action:@selector(search)
		   forControlEvents:UIControlEventTouchUpInside];
	
	//[logoImage addSubview:searchButton];
	[self.view addSubview:searchButton];
    //add by zyy 2013-09-27修复二级菜单背景显示问题，原因未知，本来应该在MPTabBarController.m中设置好的
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondMainBg.png"]];
	[searchButton release];
	[logoImage release];
	[logoTitle release];
	NSLog(@"here4");
}

/*
//ios7状态栏适配
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    CGRect frame = self.view.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        frame.origin.x = 0;
    }
    self.view.frame = frame;
}
*/

//返回上层控制器
-(void)back
{
	if (searchController)
	{
		[searchController release];
		searchController = nil;
	}
	if (titleArray)
	{
		[titleArray release];
		titleArray = nil;
	}
	[[NSNotificationCenter defaultCenter]postNotificationName:@"setIsDianJi" object:nil];
	[self.navigationController popViewControllerAnimated:YES];
}

//搜索
-(void)search
{
	if (searchController) {
		[searchController release];
	}
	searchController = [[SearchController alloc]init];
	searchController.view.frame = CGRectMake(0, 748, 1024, 748);
	[self.view addSubview:searchController.view];
	searchController.isFirstPage = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	searchController.view.frame = CGRectMake(0, 0,1024, 748);
	[UIView commitAnimations];
	
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//NSLog(@"SecondMainController____interfaceOrientation=====%D",interfaceOrientation);
	if (UIDeviceOrientationLandscapeLeft == interfaceOrientation || UIDeviceOrientationLandscapeRight == interfaceOrientation) 
	{
		[self.tabBarController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
    
	
    return (UIDeviceOrientationLandscapeLeft == interfaceOrientation || UIDeviceOrientationLandscapeRight == interfaceOrientation);
}

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview. Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc. Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//对象释放
- (void)dealloc 
{
	[searchController release];
	[titleArray release];
    [super dealloc];
}


@end
