    //
//  SortController.m
//  IPAD
//
//  Created by  careers on 12-5-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SortController.h"


@implementation SortController
@synthesize sortArray;

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
// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.view.frame = CGRectMake(0, 0,85*[sortArray count], 40);
	int interval = 85;
	int sortCount = [sortArray count];
	for (int i=0;i<sortCount; i++) 
	{
		
		UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(i*interval,0,85,40)];
		bt.tag = i;
		[bt setTitle:[sortArray objectAtIndex:i]
			forState:UIControlStateNormal];
		[bt addTarget:self 
			   action:@selector(clicked:) 
	 forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:bt];
		[bt release];
	}
	
}

//点击事件
-(void)clicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
	button.backgroundColor = [UIColor blueColor];
	for(UIButton *bt in [self.view subviews])
	{
		if ([bt isKindOfClass:[UIButton class]])
		{
			if (bt.tag != button.tag)
			{
				bt.backgroundColor = [UIColor clearColor];
				button.backgroundColor = [UIColor blueColor];
			}
		}
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"changed"
														object:[NSNumber numberWithInt:[button tag]]];
	
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait. Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait. Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview. Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview. Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
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
	[sortArray release];
    [super dealloc];
}


@end
