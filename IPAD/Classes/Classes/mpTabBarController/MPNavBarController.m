    //
//  MPNavBarController.m
//  maopao_hd
//
//  Created by 曾鸣 on 11-7-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MPNavBarController.h"


@implementation MPNavBarController

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
- (void)viewDidLoad {
    [super viewDidLoad];
	

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
- (void)dealloc {
    [super dealloc];
}

//详细视图的
-(void)showDetailController:(UIViewController *)viewController animated:(BOOL)animated{
	UINavigationController *nav= [[UINavigationController alloc]initWithRootViewController:viewController];
	[super showDetailController:nav animated:animated];
	[nav release];
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

// Faster one-part variant, called from within a rotating animation block, for additional animations during rotation.
// A subclass may override this method, or the two-part variants below, but not both.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	/*
	switch (interfaceOrientation) {
		case UIInterfaceOrientationPortrait:
			theApp.window.transform = CGAffineTransformMakeRotation(0);
			//theApp.window.frame = CGRectMake(0.0, 0.0, 768, 1024);
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			theApp.window.transform = CGAffineTransformMakeRotation(M_PI);
			//theApp.window.frame = CGRectMake(0.0, 0.0, 768, 1024);
			break;
		case UIInterfaceOrientationLandscapeRight:
			theApp.window.transform = CGAffineTransformMakeRotation(M_PI / 2);
			//theApp.window.frame = CGRectMake(0.0, 0.0, 1024, 768);
			break;
		case UIInterfaceOrientationLandscapeLeft:
			theApp.window.transform = CGAffineTransformMakeRotation(M_PI * 1.5);
			//theApp.window.frame = CGRectMake(0.0, 0.0, 1024, 768);
			break;
	}
	*/
	//[theApp messageBox:@"OK" type:kMpAlertViewType_Success closeDelay:1];
}

@end
