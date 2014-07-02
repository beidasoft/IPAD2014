    //
//  FileViewController.m
//  IPAD
//
//  Created by Sun Yu on 12-1-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FileViewController.h"

#import "IPADAppDelegate.h"
@implementation FileViewController
@synthesize htmlName;
@synthesize fileName;
@synthesize webView;
@synthesize fileView;


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
- (id)initWithHtmlName:(NSString *)html andFileName:(NSString *)file
{
	self =[super initWithNibName:@"FileViewController" bundle:nil];
	if (self) {
        self.htmlName = html;
		self.fileName = file;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"%@,%@",htmlName,fileName);
	NSString *path = [[NSBundle mainBundle] pathForResource:[[htmlName componentsSeparatedByString:@"."] objectAtIndex:0] 
													 ofType:[[htmlName componentsSeparatedByString:@"."] objectAtIndex:1] 
												inDirectory:@"webpages"];
	
	[self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
	self.webView.delegate = self;
	for (id subview in [self.webView subviews])
	{
		NSLog(@"%@",[subview class]);
	
		if ([[subview class] isSubclassOfClass: [UIScrollView class]])
		{
			
			
			((UIScrollView *)subview).bounces = NO;
			((UIScrollView *)subview).scrollEnabled = NO;
		}
	}
	
	path = [[NSBundle mainBundle] pathForResource:[[fileName componentsSeparatedByString:@"."] objectAtIndex:0] 
											ofType:[[fileName componentsSeparatedByString:@"."] objectAtIndex:1] 
									inDirectory:@"webpages"];
	
	[self.fileView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
	for (id subview in [self.fileView subviews])
	{
		NSLog(@"%@",[subview class]);
		
		if ([[subview class] isSubclassOfClass: [UIScrollView class]])
		{
			((UIScrollView *)subview).bounces = NO;
		}
	}
	self.fileView.backgroundColor = [UIColor clearColor];
	self.fileView.opaque = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *string = [[request URL] absoluteString];
	if (![[[string componentsSeparatedByString:@"/"] objectAtIndex:0] isEqualToString:@"file:"])
	{
		NSArray *array = [string componentsSeparatedByString:@":"];
		if ([array count] >1) 
		{
			if ([[array objectAtIndex:0] isEqualToString:@"protocol"]) 
			{
				if ([[array objectAtIndex:1] isEqualToString:@"home"]) 
				{
					[self.navigationController popToViewController:[(IPADAppDelegate *)[[UIApplication sharedApplication]delegate]firstContoller] animated:YES];
				}else if ([[array objectAtIndex:1] isEqualToString:@"back"]) 
				{
					[self.navigationController popViewControllerAnimated:YES];
				} 
				
			}
			
		}
		
	}
	
	
	return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
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
	
	[webView release];
	[fileView release];
    [super dealloc];
}


@end
