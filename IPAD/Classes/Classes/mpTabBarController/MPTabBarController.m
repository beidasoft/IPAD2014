    //
//  MPTabBarController.m
//  maopao
//
//  Created by Wonderful Live on 11-5-23.
//  Copyright 2011 gooogle.inc. All rights reserved.
//
#import "ViewAnimations.h"
#import "MPTabBarController.h"
#import "SecondMainController.h"
#import <QuartzCore/QuartzCore.h>
/*
#define  KMasterViewRect_landScape CGRectMake(60, 5, 423  + 15,  748 - 10)
#define  KMasterViewRect_portrait  CGRectMake(60, 5, 423 + 15, 1004 - 10)
#define  KDetaitViewControllerRect_landScape CGRectMake(1024 - 547 , 0, 547 , 768 - 20)  //shadow width = 19;
#define  KDetaitViewControllerRect_portrait  CGRectMake(768 - 547, 0, 547 , 1024 - 20)
*/

#define  KMasterViewRect_landScape CGRectMake(100, 65, 481,680)//65
#define  KMasterViewRect_portrait  CGRectMake(100, 65, 481, 680)//65
#define  KDetaitViewControllerRect_landScape CGRectMake(1024 - 481 , 65, 481 , 680)  //65
#define  KDetaitViewControllerRect_portrait  CGRectMake(768 - 481, 65, 481 , 680)//65


#define  KThirdViewControllerRect_landScape CGRectMake(0, 0, 1024,680)
#define  KThirdViewControllerRect_portrait CGRectMake(0, 0, 768, 1004)

#define  KNETINDICATORVIEW_LANSCAPE  CGRectMake(11, 686, 40 , 40)
#define  KNETINDICATORVIEW_PORTRAIT  CGRectMake(11, 686 + 256, 40 , 40)

#define  KMPALERTVIEW_LANSCAPE  CGRectMake((1024 - 350) / 2, (748 - 264) /2.0, 350 , 264)
#define  KMPALERTVIEW_PORTRAIT  CGRectMake((768 - 350) / 2, (1004 - 264) / 2.0, 350 , 264)

#define  kEachItem_Width 85
#define  kEachItem_Height 95

#define kEachItem_ALL_Height 100

#define  kTop_Space 15
#define  kLeft_Space 5

@implementation MPTabBarController
@synthesize selectedIndex, selectedViewController,delegate,tabBar, viewControllers;
@synthesize detailController;
@synthesize thirdController;
@synthesize imageViewLeftShadow, imageViewRightShadow,imageViewSelected;

//视图，数据初始化
-(id)init
{
	if(self = [super init])
	{
		tabBar = [[MPTabBar alloc] initWithFrame:CGRectZero]; // CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
		tabBar.delegate = self;
		tabBar.userInteractionEnabled = YES;
		tabBar.scrollEnabled = YES;
		tabBar.bounces = NO;
		//tabBar.contentSize = CGSizeMake(100,900);//800
		tabBar.contentOffset = CGPointMake(0,0);
		tabBar.backgroundColor = [UIColor clearColor];
		self.selectedIndex = 0;
		tabBar.clipsToBounds = YES;
		//self.view.autoresizesSubviews = NO;
	}
		
	return self;
}

// Called when the view is about to made visible. Default does nothing
-(void)viewWillAppear:(BOOL)animated
{
	//NSLog(@"viewWillAppear_MPTabBarController");
	
	[super viewWillAppear:animated];
	NSLog(@".....3");
	if(selectedIndex >=0 && selectedIndex < [viewControllers count])
	{
		UIViewController *viewController = [viewControllers objectAtIndex:selectedIndex];
		[viewController viewWillAppear:animated];
	}
}

// Called when the view has been fully transitioned onto the screen. Default does nothing
-(void)viewDidAppear:(BOOL)animated
{
	//NSLog(@"viewDidAppear_MPTabBarController");
	NSLog(@".....4");
	[super viewDidAppear:animated];
	if(selectedIndex >=0 && selectedIndex < [viewControllers count])
	{
		UIViewController *viewController = [viewControllers objectAtIndex:selectedIndex];
		[viewController viewDidAppear:animated];
	}
	
	[self.view bringSubviewToFront:tabBar];
    
    //ios7状态栏适配 modify by zyy 2014-02-18
    /*
    CGRect frame = self.view.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        frame.origin.x = 0;
    }
    self.view.frame = frame;
    */
}



// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
-(void)viewWillDisappear:(BOOL)animated
{
	////NSLog(@"viewWillDissappear_MPTabBarController");
	
	[super viewWillDisappear:animated];
	if(selectedIndex >=0 && selectedIndex < [viewControllers count])
	{
		UIViewController *viewController = [viewControllers objectAtIndex:selectedIndex];
		[viewController viewWillDisappear:animated];
	}
}

// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if(selectedIndex >=0 && selectedIndex < [viewControllers count])
	{
		UIViewController *viewController = [viewControllers objectAtIndex:selectedIndex];
		[viewController viewDidDisappear:animated];
	}
}

 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad
{
	self.view.autoresizesSubviews = NO;
    [super viewDidLoad];
	NSLog(@".....2");
	self.view.frame  = CGRectMake(0, 0, 1004, 768);
	imageViewHighLight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_icon_arrow.png"]];
	imageViewHighLight.frame = CGRectMake(83,100 , 16, 32);
	[self.view addSubview:imageViewHighLight];
	
	/*UIImageView *ImageSelectedBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,100, 118)];
	ImageSelectedBg.image = [UIImage imageNamed:@"selectedBg"];
	[self.view addSubview:ImageSelectedBg];*/
	
	imageViewSelected = [[UIImageView alloc] initWithFrame:CGRectMake(13,85,73, 80)];
	//imageViewSelected.backgroundColor = [UIColor redColor];
	[self.view addSubview:imageViewSelected];
	if(tabBar == nil)
	{
		tabBar = [[MPTabBar alloc] initWithFrame:CGRectMake(0, 200, 100, 468)];
		tabBar.delegate = self;
	}
	
	//tabBar.backImage = [UIImage imageNamed:@"nav_bar_bg.png"];
	tabBar.frame = CGRectMake(0, 190, 100, 454);
	tabBar.backgroundColor = [UIColor clearColor];
	
	tabBar.selectedIndex = selectedIndex;

	if(tabBar.superview == nil)
	{
		[self.view addSubview:tabBar];
		//NSLog(@"%@",NSStringFromCGRect(tabBar.frame));
	}
	
	if(self.imageViewLeftShadow == nil)
	{
		imageViewLeftShadow = [[UIImageView alloc] initWithFrame:CGRectMake(100 - 15, 65, 15, self.view.bounds.size.height)];
		imageViewLeftShadow.image = [UIImage imageNamed:@"detail_left_shadow.png"];
		[self.view addSubview:imageViewLeftShadow];
	}
	
	if(self.imageViewRightShadow == nil)
	{
		imageViewRightShadow = [[UIImageView alloc] initWithFrame:CGRectMake(100 + 481, 65, 15, self.view.bounds.size.height)];
		imageViewRightShadow.image = [UIImage imageNamed:@"detail_right_shadow.png"];
		[self.view addSubview:imageViewRightShadow];
	}
	
	UIInterfaceOrientation t_orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if(t_orientation == UIInterfaceOrientationLandscapeLeft || t_orientation == UIInterfaceOrientationLandscapeRight)
	{
		bLandScape = YES;
	}
	else {
		bLandScape = NO;
	}
	
	if(selectedIndex >= 0 && selectedIndex < [viewControllers count])
	{
		UIViewController *vc = (UIViewController *)[viewControllers objectAtIndex:selectedIndex];
		vc.view.frame = bLandScape ? KMasterViewRect_landScape : KMasterViewRect_portrait;
		vc.view.backgroundColor = [UIColor colorWithRed:246 green:244 blue:240 alpha:255];

		[vc viewWillAppear:NO];
		[self.view addSubview:vc.view];
		[vc willAnimateRotationToInterfaceOrientation:t_orientation duration:1.0];
		[vc viewDidAppear:NO];
	}
	
	//刷新按钮
	//btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
//	[btnLogout retain];
//	btnLogout.frame = CGRectMake(0,(bLandScape? 748 : 1004) - 42 - 20,64,42);
//	btnLogout.tag = 101;
//	[btnLogout setBackgroundImage:[UIImage imageNamed:@"menu_refresh@simple.png"] forState:UIControlStateNormal];
//	[btnLogout setBackgroundImage:[UIImage imageNamed:@"menu_refresh_hl@simple.png"] forState:UIControlStateHighlighted];
//	[btnLogout addTarget:self action:@selector(freshCurrentMasterViewController) forControlEvents:UIControlEventTouchUpInside];
//	[self.tabBar addSubview:btnLogout];
	
	
	
}



//刷新当前的视图
-(void)freshCurrentMasterViewController
{
	//[theApp userLogout];
	//return;
	UIViewController *currentController = [viewControllers objectAtIndex:selectedIndex];
	if([currentController conformsToProtocol:NSProtocolFromString(@"ControllerInTabbarDelegate")] && [currentController respondsToSelector:@selector(ViewFreshData)])
	{
		id<ControllerInTabbarDelegate>t_delegate = (id<ControllerInTabbarDelegate>)currentController;
		[t_delegate ViewFreshData];
	}

}

 
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark private methods

-(void)setBadgeValue:(NSString *)value index:(int)index
{
	if(index >= [tabBar.items count])
		return;
	
	UITabBarItem *item = [tabBar.items objectAtIndex:index];
	item.badgeValue = value;
	[tabBar setNeedsDisplay];
}

-(void)setSelectedIndex:(NSUInteger)t_index
{
	
	if(viewControllers == nil ||  t_index >= [viewControllers count])
		return ;
	
	//相同的话， 不会重新加载（相当于双击）
	if(t_index == selectedIndex && t_index != 0)
	{
		return ;
	}
	
	CATransition *transition = [CATransition animation];
	transition.duration = 1.0;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type =   kCATransitionFade;
	transition.subtype = kCATransitionFromLeft;
	//transition.delegate = self;
	
	UIViewController *currentController = [viewControllers objectAtIndex:selectedIndex];
	UIViewController *nextController = [viewControllers objectAtIndex:t_index];
	
	nextController.view.frame = bLandScape ? KMasterViewRect_landScape : KMasterViewRect_portrait;
	nextController.view.backgroundColor = [UIColor colorWithRed:246 green:244 blue:240 alpha:255];
	//[nextController willRotateToInterfaceOrientation:[[UIApplication sharedApplication]  statusBarOrientation]   duration:2.0];
	
	[currentController viewWillDisappear:NO];
	[nextController viewWillAppear:NO];
	
	[currentController.view removeFromSuperview];
	[self.view addSubview:nextController.view];
	
	[currentController viewDidDisappear:NO];
	[nextController viewDidAppear:NO];
	
	[nextController willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:1.0];

	selectedIndex = t_index;
	
	tabBar.selectedIndex = selectedIndex;
	[self.view bringSubviewToFront:tabBar];
	
	
	/*UIImageView *bgView = [[UIImageView alloc] initWithFrame: CGRectInset((bLandScape ? KMasterViewRect_landScape : KMasterViewRect_portrait), -20, 0)];//  bLandScape ? KMasterViewRect_landScape : KMasterViewRect_portrait];
	bgView.image = [UIImage imageNamed:@"timeline_bg_hl.png"];
	//[nextController.view addSubview:bgView];
	//[nextController.view sendSubviewToBack:bgView];
	[bgView release];*/
	if (!isButtonAdd) {
		[tabBar addButton];	
		isButtonAdd = YES;
	}				   
	
	[ViewAnimations addAnimation:imageViewSelected time:0.5 typeName: @"pageCurl" ];
	imageViewSelected.image = [tabBar.highLightImages objectAtIndex:selectedIndex];
	
	[nextController.view.layer addAnimation:transition forKey:@"new"];
	
	[self hideDetailController:YES];
	
}

-(void)setViewControllers:(NSArray *)t_viewController
{
	[t_viewController retain];
	[viewControllers release];
	viewControllers = nil;
	NSLog(@".....0");
	viewControllers = t_viewController ;
	
	if(tabBar == nil)
	{
		tabBar = [[MPTabBar alloc] initWithFrame:CGRectZero];
		tabBar.delegate = self;
	}
	
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[t_viewController count]];
	
	for(int i = 0; i < [t_viewController count]; i++)
	{
		UIViewController *vc = [t_viewController objectAtIndex:i];
		[arr addObject:vc.tabBarItem];
	}
	
	tabBar.items = [NSArray arrayWithArray:arr];
	tabBar.contentSize = CGSizeMake(100,100*[t_viewController count]);
	NSLog(@".....1");
}

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//对象释放
- (void)dealloc {
	
	//NSLog(@"MPTABbarController dealloc");
	
	[selectedViewController release];
	[tabBar release];

    //遍历属于viewControllers的对象，移除
	for(UIViewController *t_controller in viewControllers)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[[NSNotificationCenter defaultCenter] removeObserver:t_controller];
	}
	
	[viewControllers release];

	[detailController release];
	[thirdController release];
	
	[thirdBgView release];
	[btnLogout release];
	[btnSetting release];
	
	[imageViewLeftShadow release];
	[imageViewRightShadow release];
	[imageViewHighLight release];
	
    [super dealloc];
}


//-------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark  detailController 
//详细视图的
-(void)showDetailController:(UIViewController *)viewController animated:(BOOL)animated
{
	if(detailController && detailController.view.superview != nil)
	{
		//[self hideDetailController:NO];
		[self hideDetailControllerBackGround];
	}
	
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.detailController = nc;
	nc.delegate = self;
    //ios7适配 add by zyy 2014-04-21
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        nc.navigationBar.translucent = NO;
    }
	[nc release];
	
	
	nc.view.frame = bLandScape ? KDetaitViewControllerRect_landScape : KDetaitViewControllerRect_portrait;
	viewController.view.frame = CGRectMake(0, 0, nc.view.frame.size.width, nc.view.frame.size.height-44 );
	
	
	//NSLog(@"111111%@",NSStringFromCGRect(nc.view.frame ));
	
	/*viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"关闭" 
																						 type:KNAV_BARBUTTONITEM_TYPE_ROUNDRECT 
																					   target:self 
																					   action:@selector(hideDetailController:)];*/

	
	//添加手势 向右滑的手势
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
	swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
	[nc.view addGestureRecognizer:swipeGesture];
	[swipeGesture release];
	
	UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailView_left_shadow.png"]];
	iv.frame = CGRectMake(-25, 0, 27, nc.view.frame.size.height);
	[nc.view addSubview:iv];
	iv.tag = 888;
	[iv release];
	
	[nc willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:1.0];

	if(animated)
	{
		CATransition *transition = [CATransition animation];
		transition.duration = 0.4;
		transition.delegate = nil;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type =   kCATransitionPush;
		transition.subtype = kCATransitionFromRight;
		[detailController.view.layer addAnimation:transition forKey:nil];
	}
	
	[nc viewWillAppear:YES];
	[self.view addSubview:nc.view];
	[nc viewDidAppear:YES];
}

-(void)showDetailController:(UIViewController *)viewController animated:(BOOL)animated andIndex:(NSIndexPath *)indexPath isTableView:(BOOL)is
{
	if(detailController && detailController.view.superview != nil)
	{
		//[self hideDetailController:NO];
		
		if (indexPath==currentIndexPath)
		{
			if ([detailController isKindOfClass:[UINavigationController class]])
			{
				UINavigationController *nc = (UINavigationController *)detailController;
				if (nc.viewControllers.count ==1)
				{
					if (is==YES)
					{
						//[self hideDetailController:YES];
						UITableViewController *t = (UITableViewController *)viewController;
						t.clearsSelectionOnViewWillAppear = NO;
					}
				}
				else 
				{
					if (is==YES)
					{
						UITableViewController *t = (UITableViewController *)viewController;
						t.clearsSelectionOnViewWillAppear = NO;
					}
					[nc popViewControllerAnimated:YES];
				}
				
			}
		}
		else 
		{
			[self hideDetailControllerBackGround];
			UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController];
			self.detailController = nc;
			nc.delegate = self;
			[nc release];
			
			
			nc.view.frame = bLandScape ? KDetaitViewControllerRect_landScape : KDetaitViewControllerRect_portrait;
			viewController.view.frame = CGRectMake(0, 0, nc.view.frame.size.width, nc.view.frame.size.height - 44);
			
			
			
			
			//添加手势 向右滑的手势
			UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
			swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
			[nc.view addGestureRecognizer:swipeGesture];
			[swipeGesture release];
			
			UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailView_left_shadow.png"]];
			iv.frame = CGRectMake(-25, 0, 27, nc.view.frame.size.height);
			[nc.view addSubview:iv];
			iv.tag = 888;
			[iv release];
			
			[nc willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:1.0];
			
			if(animated)
			{
				CATransition *transition = [CATransition animation];
				transition.duration = 0.4;
				transition.delegate = nil;
				transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
				transition.type =   kCATransitionPush;
				transition.subtype = kCATransitionFromRight;
				[detailController.view.layer addAnimation:transition forKey:nil];
			}
			
			[nc viewWillAppear:YES];
			[self.view addSubview:nc.view];
			[nc viewDidAppear:YES];
		}
		
	}
	else
	{
		
		UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController];
		self.detailController = nc;
		nc.delegate = self;
		[nc release];
		
		
		nc.view.frame = bLandScape ? KDetaitViewControllerRect_landScape : KDetaitViewControllerRect_portrait;
		viewController.view.frame = CGRectMake(0, 0, nc.view.frame.size.width, nc.view.frame.size.height - 44);
		
		
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
		swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
		[nc.view addGestureRecognizer:swipeGesture];
		[swipeGesture release];
		
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailView_left_shadow.png"]];
		iv.frame = CGRectMake(-25, 0, 27, nc.view.frame.size.height);
		[nc.view addSubview:iv];
		iv.tag = 888;
		[iv release];
		
		[nc willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:1.0];
		
		if(animated)
		{
			CATransition *transition = [CATransition animation];
			transition.duration = 0.4;
			transition.delegate = nil;
			transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			transition.type =   kCATransitionPush;
			transition.subtype = kCATransitionFromRight;
			[detailController.view.layer addAnimation:transition forKey:nil];
		}
		
		[nc viewWillAppear:YES];
		[self.view addSubview:nc.view];
		[nc viewDidAppear:YES];
		
		
	}
	
	currentIndexPath = [indexPath copy];
	
	
}


//手势操作
-(void)showSimpleDetailController:(UIViewController *)viewController animated:(BOOL)animated
{
	[self hideDetailController:YES];
	
	viewController.view.frame = bLandScape ? KDetaitViewControllerRect_landScape : KDetaitViewControllerRect_portrait;
	
	//添加手势 向右滑的手势
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
	swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
	[viewController.view addGestureRecognizer:swipeGesture];
	[swipeGesture release];
	
	UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_left_shadow.png"]];
	iv.frame = CGRectMake(-25, 0, 27, viewController.view.frame.size.height);
	[viewController.view addSubview:iv];
	iv.tag = 888;
	[iv release];
	
	[viewController willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:1.0];
	
	if(animated)
	{
		CATransition *transition = [CATransition animation];
		transition.duration = 0.4;
		transition.delegate = nil;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type =   kCATransitionPush;
		transition.subtype = kCATransitionFromRight;
		[viewController.view.layer addAnimation:transition forKey:nil];
	}
	
	[viewController viewWillAppear:YES];
	[self.view addSubview:viewController.view];
	[viewController viewDidAppear:YES];
	
	self.detailController = viewController;
}

//视图移出的动画效果
-(void)hideDetailController:(BOOL)animated
{
	
	if(detailController && [detailController.view superview])
	{
		if(animated)
		{
			[UIView beginAnimations:@"hidedetailcontroller" context:nil];
			[UIView	 setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.4];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
			
			/*
			
			CATransition *transition = [CATransition animation];
			transition.duration = 1.0;
			transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			transition.type =   kCATransitionPush;
			transition.subtype = kCATransitionFromLeft;
			transition.delegate = self;
			 */
			
			
			CGRect rect = CGRectZero;
			if(bLandScape)
			{
				rect	= CGRectMake(1024, 65, 1024 - 535, 768 - 20);//0-65
			}
			
			else
			{
				rect = CGRectMake(768, 65, 768 - 277, 1024 - 20);//0-65
			}
			
			detailController.view.alpha = 0;
			detailController.view.frame = rect;
			[UIView commitAnimations];
			//[detailController.view.layer addAnimation:transition forKey:@"removeDetailView"];
		}
		
		else
		{
			[detailController.view removeFromSuperview];
			self.detailController  = nil;
		}
	}
	
	
	//取消选择
	UIViewController *currentController = [viewControllers objectAtIndex:selectedIndex];
	if([currentController conformsToProtocol:NSProtocolFromString(@"ControllerInTabbarDelegate")] && [currentController respondsToSelector:@selector(ViewDeselectCurrentSelect)])
	{
		id<ControllerInTabbarDelegate>t_delegate = (id<ControllerInTabbarDelegate>)currentController;
		[t_delegate ViewDeselectCurrentSelect];
	}
	
	//ViewDeselectCurrentSelect
}

//移出detailController控制器
-(void)hideDetailControllerBackGround
{
	if(detailController && [detailController.view superview])
	{
		[detailController.view removeFromSuperview];
	}
	
	self.detailController  = nil;
}

-(void)presentThirdController:(UIViewController	 *)viewController animated:(BOOL)animated
{
	//thirdBgView = [[UIView alloc] initWithFrame:self.view.bounds];
	//thirdBgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
	//[thirdBgView addSubview:viewController.view];
	//NSLog(@"third third third");
	self.thirdController = viewController;
	
	//viewController.view.center = thirdBgView.center;
	bLandScape = YES;
	viewController.view.frame = bLandScape ? KThirdViewControllerRect_landScape : KThirdViewControllerRect_portrait;
	[viewController willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];

	if(animated)
	{
		thirdController.view.alpha = 0.0;
		//thirdBgView.alpha  = 0.0;
		[UIView beginAnimations:@"showThirdViewController" context:nil];
		[UIView	 setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		thirdController.view.alpha = 1.0;
		thirdBgView.alpha  = 1.0;
		[UIView setAnimationDelegate:self];
		[UIView commitAnimations];
	}
	
	[viewController viewWillAppear:YES];
	//[self.view addSubview:thirdBgView];
	[self.view addSubview:thirdController.view];
	[viewController viewDidAppear:YES];
}

//移除视图控制器
-(void)disMissThirdController:(BOOL)animated
{
	if(thirdController && thirdController.view.superview)
	{
		if(animated)
		{
			[UIView beginAnimations:@"hidedThirdcontroller" context:nil];
			[UIView	 setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:1.0];
			thirdController.view.alpha = 0.0;
			//thirdBgView.alpha  = 0.0;
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
			[UIView commitAnimations];
		}
			
		else 
		{
			//[thirdBgView removeFromSuperview];
			thirdBgView = nil;
			[thirdController.view removeFromSuperview];
			self.thirdController = nil;
		}
	}
}

//详细视图从左向右的滑动手势
-(void)detailSwipeFromLeft
{
	if(detailController == nil || detailController.view.superview == nil)
	{
		return;
	}
	
	
	//detailcontroller 不是导航控制器
	if(![detailController isKindOfClass:[UINavigationController class]])
	{
		[self hideDetailController:YES];
	}
	
	//detailconroller是导航控制器
	
    UINavigationController *nc = (UINavigationController *)detailController;
	
	if(nc.viewControllers.count == 1)
	{
		[self hideDetailController:YES];
	}
	
	else {
		[nc popViewControllerAnimated:YES];
	}

}


//动画结束
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if([animationID isEqualToString:@"hidedetailcontroller"])
	{
		[detailController.view removeFromSuperview];
		self.detailController = nil;
	}
	
	else if([animationID isEqualToString:@"hidedThirdcontroller"])
	{
		[thirdBgView removeFromSuperview];
		thirdBgView = nil;
		[thirdController.view removeFromSuperview];
		self.thirdController = nil;
	}
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	/*
	//NSLog(@"animation stop");
	[detailController.view removeFromSuperview];
	self.detailController = nil;
	 */
}

//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark UINavigationController delegate methods
// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[viewController didRotateFromInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

}

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	//NSLog(@"navigationController = %@",viewController);
	
	viewController.view.frame = CGRectMake(0, 0, detailController.view.frame.size.width, detailController.view.frame.size.height - 44);
	[viewController willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:1.0];
}

#pragma mark -
#pragma mark  rotate
// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//NSLog(@"_MPTabBarController ShouldAutorotateToInterfaceOrientation");
	
	////NSLog(@"toInterfaceOrientation = %d", toInterfaceOrientation);
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
	{
		self.view.frame = CGRectMake(0, 0, 768, 1004);
	}
	
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
	   toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		bLandScape = YES;
		self.view.frame = CGRectMake(0, 0, 1024, 768);
	}
	
	else 
	{
		bLandScape = NO;
	}
	
	
	
	if(detailController &&  [detailController isKindOfClass:[UINavigationController class]])
	{
		
		for( UIViewController *t_controller in [(UINavigationController *)detailController viewControllers])
		{
			[t_controller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
			
		}
	}
	 
	
	if(thirdController)
	{
		[thirdController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
	}
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:bLandScape ? @"secondMainBg.png" : @"secondMainBg.png"]];
	return YES;
}

// Notifies when rotation begins, reaches halfway point and ends
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//NSLog(@" MPTabBarController didRotateFromInterfaceOrientation");
	
	if(detailController && detailController.view.superview)
	{
		[detailController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
		
		//return;
		
		/*
		//郁闷 不知为什么 还需要讲navcontroller里面的每个子控制器每个都指定frame 
		if([detailController isKindOfClass:[UINavigationController class]])
		{
			for( UIViewController *t_controller in [(UINavigationController *)detailController viewControllers])
			{
				if(t_controller == [(UINavigationController *)detailController topViewController])
					continue;
				
				CGRect rc_current = t_controller.view.frame;
				CGRect rc_next = CGRectMake(0, 0, detailController.view.frame.size.width, detailController.view.frame.size.height - 44);
				
				if(!CGRectEqualToRect(rc_current, rc_next))
				{
					[t_controller didRotateFromInterfaceOrientation:fromInterfaceOrientation];
				}
			}
		}
		 */
	}
}

// Faster one-part variant, called from within a rotating animation block, for additional animations during rotation.
// A subclass may override this method, or the two-part variants below, but not both.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	
	////NSLog(@"interfaceOrientation = %d", interfaceOrientation);
	
	if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
	   interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		bLandScape = YES;
	}
	
	else 
	{
		bLandScape = NO;
	}
	
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:bLandScape ? @"secondMainBg.png" : @"secondMainBg.png"]];
	
	UIViewController *currentController = [viewControllers objectAtIndex:selectedIndex];
	currentController.view.frame =bLandScape ? KMasterViewRect_landScape : KMasterViewRect_portrait;
	currentController.view.backgroundColor = [UIColor colorWithRed:246 green:244 blue:240 alpha:255];
	[currentController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	
	if(detailController && detailController.view.superview)
	{
		detailController.view.frame = bLandScape ? KDetaitViewControllerRect_landScape : KDetaitViewControllerRect_portrait;
		[detailController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
		
		//detailcontroller的阴影
		UIImageView *iv = (UIImageView *)[detailController.view viewWithTag:888];
		if(iv && [iv isKindOfClass:[UIImageView class]])
		{
			iv.frame = CGRectMake(-25, 0, 27, detailController.view.frame.size.height);
		}
		
		}
	
	tabBar.frame = CGRectMake(0,0, 60, bLandScape? 748 : 1004);
	//btnLogout.frame = CGRectMake(0,(bLandScape? 748 : 1004) - 42 - 20,64,42);
	
	[tabBar setNeedsDisplay];
	
	//thirdBgView.frame = self.view.bounds;
	if(thirdController)
	{
		thirdController.view.frame = bLandScape ? KThirdViewControllerRect_landScape : KThirdViewControllerRect_portrait;
		[thirdController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	}
	
}






#pragma mark -
#pragma mark  MPTabBarDelegate methods
- (void)mpTabBar:(MPTabBar *)_tabBar didSelectItem:(UITabBarItem *)item
{
	
	if(delegate && [delegate respondsToSelector:@selector(mpTabBarController:shouldSelectViewController:)])
	{
		[delegate mpTabBarController:self shouldSelectViewController:[viewControllers objectAtIndex:_tabBar.selectedIndex]];
	}

	self.selectedIndex = _tabBar.selectedIndex;

	if(delegate && [delegate respondsToSelector:@selector(mpTabBarController:didSelectViewController:)])
	{
		[delegate mpTabBarController:self didSelectViewController:[viewControllers objectAtIndex:_tabBar.selectedIndex]];
	}
}

//anniu
-(void)showPopular
{
	/*
	pvc = [[PopularViewController alloc] init];
	pvc.view.frame = self.view.bounds;
	[self.view addSubview:pvc.view];
	//[pvc release];
	 */
}

-(void)hidePopular
{}

@end




//-----------------------------------------------------------------------------------------------------
//
//    MPTabbar
//
//-----------------------------------------------------------------------------------------------------

@implementation MPTabBar
@synthesize items, selectedItem,backImage,delegate, arrNormalImages, arrSelectedImages, selectedIndex,highLightImages;
-(void)setItems:(NSArray *)t_items
{
	[t_items retain];
	[items release];
	items = nil;
	items = t_items ;}

//选中了某个tabbaritem
-(void)didSelectedIndex:(int)index
{
	selectedIndex = index;
	[self setNeedsDisplay];
	//if(imageViewHighLight == nil)
//	{
//		imageViewHighLight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_icon_arrow.png"]];
//		imageViewHighLight.backgroundColor = [UIColor blackColor];
//		[self addSubview:imageViewHighLight];
//		
//	}
//	[UIView beginAnimations:@"selecte" context:nil];
//	imageViewHighLight.frame = CGRectMake(85 - 5, kTop_Space + index  * kEachItem_ALL_Height + (kEachItem_Height - 32 ) / 2.0 , 16, 32);
//	[UIView commitAnimations];
	
	if(delegate && [delegate respondsToSelector:@selector(mpTabBar:didSelectItem:)])
	{
		[delegate mpTabBar:self didSelectItem:[items objectAtIndex:index]];
	}
}

-(void)setSelectedIndex:(NSUInteger)t_index
{
	selectedIndex = t_index;
	//if(imageViewHighLight == nil)
//	{
//		imageViewHighLight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_icon_arrow.png"]];
//		[self addSubview:imageViewHighLight];
//	}
//	
//	imageViewHighLight.frame = CGRectMake(85-5, kTop_Space + selectedIndex  * kEachItem_ALL_Height + (kEachItem_Height - 32 ) / 2.0 , 16, 32);

	[self setNeedsDisplay];
}

//对象释放
-(void)dealloc
{
	[items release];
	[backImage release];
	
	[arrNormalImages release];
	[arrSelectedImages release];
	
	[super dealloc];
}

//添加button
-(void)addButton
{
    if(items == nil || [items count] == 0)
		return;
	for(int i = 0;i<[items count];i++)
	{
	   if(i<[arrNormalImages count])
	   {
		  
		   UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kLeft_Space, kTop_Space + i * kEachItem_ALL_Height , kEachItem_Width, kEachItem_Height)];
		   [button addTarget:self action:@selector(changed:) forControlEvents:UIControlEventTouchUpInside];
		   [button setTag:i];
		   [button setImage:[arrNormalImages objectAtIndex:i] forState:UIControlStateNormal];
		   [self addSubview:button];
		  
	   }
	}
		
}

//选择某个button
-(void)changed:(UIButton *)sender
{
	
	for (UIButton *bt in [self subviews]) 
	{
		
		if ([bt isKindOfClass:[UIButton class]])
		{
			//NSLog(@"bt bt bt ===== %d",bt.selected);
			//NSLog(@"sender === %d",sender.selected);
			
			if (sender.tag == bt.tag)
			{
				
				[self didSelectedIndex:sender.tag];
				
				
			}
			
					
					
					
					
				
				
			}
	}
	/*if(sender.tag!=0)
	{
		NSLog(@"ddd");
		sender.selected = NO;
		[sender setImage:[UIImage imageNamed:@"nav_backButton_icon.png"] forState:UIControlStateNormal];
		[self didSelectedIndex:nIndexTouched];
	}*/
//	if(clickCount !=1)
//	{
//	if(nIndexTouched != nowIndexTouched)
//	{
//		[array removeObjectAtIndex:0];
//		[array addObject:[NSNumber numberWithInt:nIndexTouched]];
//	}
//	NSLog(@"%@",[array objectAtIndex:0]);
//	NSLog(@"%@",[array objectAtIndex:1]);
	//}
	
}
//-(void)drawRect:(CGRect)rect
//{
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetLineWidth(context,2.0);	
//	if(items == nil || [items count] == 0)
//		return;
//		for(int i = 0; i < [items count] ; i++)
//	    {
//		
//		if(i < [arrNormalImages count])
//		{
//			
//			
//			if(selectedIndex == i)
//			{
//				//[[UIImage imageNamed:@"Click_light.png"]  drawInRect:CGRectMake(left_space , top_space + i * each_width  , each_width - left_space * 2, rect.size.height  - top_space * 2 - 10)];
//			}
//			
//			UIImage *img = (selectedIndex == i) ? [arrSelectedImages objectAtIndex:i] :  [arrNormalImages objectAtIndex:i];
//			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kLeft_Space, kTop_Space + i * kEachItem_ALL_Height , kEachItem_Width, kEachItem_Height)];
//			//[button setType:UIButtonTypeRoundedRect];
//			button.backgroundColor = [UIColor yellowColor];
//			//[img drawInRect:CGRectMake(kLeft_Space, kTop_Space + i * kEachItem_ALL_Height , kEachItem_Width, kEachItem_Height)];
//			[img drawInRect:button.frame];
//			[self addSubview:button];
//			for (UIView *v in [self subviews])
//			{
//				NSLog(@"ss====%d",[self.subviews count]);
//				NSLog(@"dd=====%@",[self subviews]);
//				if ([v isKindOfClass:[UIButton class]]) {
//					//[v removeFromSuperview];
//					//v.backgroundColor = [UIColor yellowColor];
//				}
//			}
//			
//			
//			//选中高亮图片
//			//if(nIndexTouched == i && bSelectedShow == YES)
//			{
//				//UIImage *imgHighLight = [UIImage imageNamed:@"light_white.png"];
//				
//				CGRect rcButton = CGRectMake(kLeft_Space, kTop_Space + i * kEachItem_ALL_Height , kEachItem_Width, kEachItem_Height);
//				[[UIImage imageNamed:@"btn_hight_ligthed.png"] drawInRect:CGRectInset(rcButton, (rcButton.size.width - 70) / 2.0, (rcButton.size.height - 70) /2.0)];
//
//				//[imgHighLight drawInRect:CGRectMake(kLeft_Space, kTop_Space + i * kEachItem_ALL_Height , kEachItem_Width, kEachItem_Height)];
//			}
//			
//			UITabBarItem *t_item = [items objectAtIndex:i];
//			
//			//badge
//			NSString *badgeValue = t_item.badgeValue;
//			
//			//badgeValue = @"new";
//			if(badgeValue && [badgeValue length] > 0)
//			{
//				float left_space = 7.0; //文字 与 badge背景图片左右边的留白
//				float height = 23;// 23.0; //整个badge背景的高度
//				
//				CGSize cs = [badgeValue sizeWithFont:[UIFont boldSystemFontOfSize:12]];
//				if(cs.width + left_space * 2 < height)
//				{
//					cs.width = (height - left_space * 2);
//				}
//				
//				//origionx一定要是整数， 否则图片拉伸的话 中间可能会出现黑条
//				float origionx = (float)((int)(i*kEachItem_ALL_Height )) + kTop_Space - 10;
//				float origiony = rect.size.width - (cs.width + kLeft_Space * 2);
//				CGRect rc = CGRectMake(origiony , origionx , (cs.width + kLeft_Space * 2), height);
//				[[[UIImage imageNamed:@"tabbar_badge_bg.png"] stretchableImageWithLeftCapWidth:11.5 topCapHeight:11.5] drawInRect:rc];
//				[[UIColor whiteColor] set];
//				[badgeValue drawInRect:CGRectMake(kLeft_Space + origiony, origionx  + (height - cs.height) / 2.0, cs.width, cs.height) 
//							  withFont:[UIFont boldSystemFontOfSize:12] 
//						 lineBreakMode:UILineBreakModeTailTruncation 
//							 alignment:UITextAlignmentCenter];
//			}
//		}
//	}
//}


//==============================================================================================================================
//
//
//touch
//
//==============================================================================================================================
//清除selection
- (void) clearSelection {
	nIndexTouched = selectedIndex;
	bSelectedShow = NO;
}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	UITouch *touch = [touches anyObject];
//	CGPoint pt = [touch locationInView:self];
//	
//	
//	if(items == nil || [items count] == 0)
//		return;
//	
//	for(int i = 0; i < [items count] ; i++)
//	{
//		if(CGRectContainsPoint(CGRectMake(0, kTop_Space + i * kEachItem_ALL_Height, kEachItem_ALL_Height, kEachItem_ALL_Height), pt))
//		{
//			//[self didSelectedIndex:i];
//			nIndexTouched = i;
//			bSelectedShow = YES;
//			[self setNeedsDisplay];
//			return;
//		}
//	}
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	UITouch *touch = [touches anyObject];
//	CGPoint pt = [touch locationInView:self];
//	
//	if(nIndexTouched >= 0 && nIndexTouched < [items count])
//	{
//		for(int i = 0; i < [items count]; i++)
//	    {
//			CGRect rc = CGRectInset(CGRectMake(0, kTop_Space + i * kEachItem_ALL_Height, kEachItem_ALL_Height, kEachItem_ALL_Height), -kEachItem_ALL_Height, -kEachItem_ALL_Height);
//			
//			BOOL bOldSelectedShow = bSelectedShow;
//			if ( CGRectContainsPoint( rc, pt) ) {
//				bSelectedShow = YES;
//			}
//			else {
//				bSelectedShow = NO;
//			}
//			if ( bOldSelectedShow!=bSelectedShow ) {
//				[self setNeedsDisplay];
//			}
//		}
//	}
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[self clearSelection];
//	[self setNeedsLayout];
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	if(nIndexTouched >=0 && nIndexTouched < [items count] && bSelectedShow == YES)
//	{
//		[self didSelectedIndex:nIndexTouched];
//		//[self setNeedsDisplay];
//	}
//	
//	//else 
//	{
//		[self clearSelection];
//		[self setNeedsDisplay];
//	}
//
//}

@end


