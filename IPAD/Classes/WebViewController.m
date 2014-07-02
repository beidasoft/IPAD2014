    //
//  WebViewController.m
//  IpadTest
//
//  Created by Sun Yu on 11-12-2.
//  Copyright 2011 careers. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController
@synthesize htmlTemplate,queryCondition,nextHtmlTemplate,nextQueryCondition,nsrequest;



-(id)initWithHtmlTemplate:(NSString *)html 
		andQueryCondition:(NSString *)condition
{
	self = [self init];
	if(self)
	{
	    self.htmlTemplate = html;
		self.queryCondition = condition;
		isFirstLoad = YES;
	}
	return self;
}


-(id)initWithRequest:(NSURLRequest *)req
{
	self = [self init];
	if(self)
	{
	    self.nsrequest = req;
		isFirstLoad = YES;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CGRect frame = [[UIScreen mainScreen]applicationFrame];
	UIWebView *myWebView = [[UIWebView alloc]initWithFrame:frame];
	myWebView.delegate = self;
	//NSArray *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
//	NSString *docPath = [rootPath objectAtIndex:0];
//	NSString *templatePath = [docPath stringByAppendingPathComponent:@"template/"];
	//NSString *filePath = [docPath stringByAppendingString:
//						  [NSString stringWithFormat:@"/template/%@",htmlTemplate]];
//	NSLog(@"%@",templatePath);
//	NSLog(@"%@",htmlTemplate);
	if (nsrequest) {
		
	}
	else {
		
		NSArray *fileName = [htmlTemplate componentsSeparatedByString:@"."];
		if ([fileName count] < 1) {
			[self alert:@"file'name is wrong!"];
			return;
		}
		NSString *path = [[NSBundle mainBundle] pathForResource:[fileName objectAtIndex:0] 
														 ofType:@"html" 
													inDirectory:@"webpages"];
		NSLog(@"%@",path);
		if (!path) {
			[self alert:@"file is not exist!"];
			return;
		}
//		NSFileManager *fileManager= [[NSFileManager alloc] init];
//		NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:templatePath error:nil];
//		[fileManager release];
//		
//		for (int i=0; i<[fileArray count]; i++) {
//			NSString *filePath = [templatePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[fileArray objectAtIndex:i]]];
//			
//		}
//		NSString *filePath = [templatePath stringByAppendingString:
//							 [NSString stringWithFormat:@"/%@",htmlTemplate]];
//		NSLog(@"%@",filePath);
		NSURL *url = [NSURL fileURLWithPath:path];
		nsrequest = [NSURLRequest requestWithURL:url];
	}

	
	
	[myWebView loadRequest:nsrequest];
	
	self.view = myWebView;
	myWebView.multipleTouchEnabled = YES;
	myWebView.scalesPageToFit = YES;
	[myWebView release];
	
	
	activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.width-100)/2, 100, 100)];
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
	//[self registerForKeyboardNotifications];
}
- (void)alert:(NSString *)string
{
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil 
													 message:string 
													delegate:self 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil]autorelease];
	[alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self.navigationController popViewControllerAnimated:YES];
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
    [super dealloc];
}



#pragma mark 
#pragma mark WebViewDelegate

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
					[self.navigationController popViewControllerAnimated:YES];
				}else if ([[array objectAtIndex:1] isEqualToString:@"back"]) 
				{
					
				} 

				else 
				{
					if ([array count] == 3) 
					{
						FileViewController *fileController = [[FileViewController alloc]initWithHtmlName:[array objectAtIndex:1] 
																							 andFileName:[array objectAtIndex:2]];
						[self.navigationController pushViewController:fileController withAnimationName:@"pageUnCurl"];
						[fileController release];
					}
				}

			}
			
		}
		
	}
		
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[activityIndicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[activityIndicator stopAnimating];
	//NSLog(@"%@",error);
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{

	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];//返回应用程序window
    UIView* keyboard;
	NSLog(@"%d",[tempWindow.subviews count]);
    for(int i=0; i<[tempWindow.subviews count]; i++) //遍历window上的所有subview
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard view found; add the custom button to it
		NSLog(@"%@",[keyboard description]);
        if([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES)
		{
			UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(655, 117, 110, 55)];
			b.backgroundColor = [UIColor redColor];
			[keyboard addSubview:b];
			[b release];
		}
		
    }

}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{

	
  
}


@end
