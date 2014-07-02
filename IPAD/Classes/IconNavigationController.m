    //
//  IconNavigationController.m
//  FirstNavigation
//
//  Created by Lyz on 11-11-21.
//  Copyright 2011 careers. All rights reserved.
//


#import "IconNavigationController.h"
#import "ItemView.h"
#define VIEWAREAWIDTH 170
#define VIEWAREAHEIGHT 230
#define VIEWAREALEFTBLANKWIDTH 45
#define VIEWAREALEFTBLANKHEIGHT 105

@implementation IconNavigationController


@synthesize itemArray;
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

- (id)initWithItemArray:(NSArray *)array
{
	
		self = [super init];
		if (self) {
			self.itemArray = array;
		}
		return self;
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    //遍历item从中获取信息
	int itemCount = [itemArray count];
	for (int i = 0; i< itemCount; i++) 
	{

		//初始化一个itemview
		ItemView *itemView = [[ItemView alloc]initWithFrame:CGRectMake((i %5)*VIEWAREAWIDTH + VIEWAREALEFTBLANKWIDTH, i/5*VIEWAREAHEIGHT + VIEWAREALEFTBLANKHEIGHT , VIEWAREAWIDTH, VIEWAREAHEIGHT)
													   andItemArray:[itemArray objectAtIndex:i]];
		itemView.tag = i;
		[self.view addSubview:itemView];
		[itemView release];
	}
	
}


// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
}

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
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

//对象释放
- (void)dealloc 
{
	[itemArray release];
    [super dealloc];
}


@end
