    //
//  SynopsisPageController.m
//  IPAD
//
//  Created by pc h on 12/20/11.
//  Copyright 2011 careers. All rights reserved.
//

#import "SynopsisPageController.h"
#import "NavController.h"
#import "IPADAppDelegate.h"


@implementation UINavigationBar (CustomImage)  
- (void)drawRect:(CGRect)rect {  
    UIImage *image = [UIImage imageNamed: @"serverTitle.png"];  
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];  
}  
@end  

@implementation SynopsisPageController

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
- (void)viewDidLoad {
    [super viewDidLoad];
	//加载背景图片
	UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"server11.png"]];
	background.frame = CGRectMake(0, 0, 1024, 768);
	[self.view addSubview:background];
	[background release];
	
	self.navigationItem.titleView.tag = 5001;
	
	//设置返回按钮
	UIImage *buttonImage = [UIImage imageNamed:@"excel_back.png"];
	
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
	
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
	
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
	
	// Cleanup
	[customBarItem release];
	
	
	NavController *sPC = [[NavController alloc] init];
    
    //初始化显示服务器地址的标签
	UILabel *ipText = [[UILabel alloc] initWithFrame:CGRectMake(400,500, 600, 100)];
	//ipText.backgroundColor = [UIColor clearColor];
	//ipText.font = [UIFont fontWithName:@"黑体" size:20];
	//设置标签的属性
	ipText.textColor = [UIColor whiteColor];
	ipText.backgroundColor = [UIColor clearColor];
	ipText.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:26];
	
	ipText.shadowColor = [UIColor blackColor];
	ipText.shadowOffset = CGSizeMake(1, 5);
	
	IPADAppDelegate *AppDelegate = (IPADAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[ipText setText:[NSString stringWithFormat:@"http://%@", AppDelegate.ipAddress]];


	[self.view addSubview:ipText];
	[sPC release];
	
	
}
//返回上级控制器
-(void)back {
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}
// Called when the view is about to made visible. Default does nothing
-(void)viewWillAppear:(BOOL)animated{	 
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	 
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
