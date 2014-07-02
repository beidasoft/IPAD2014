#import "fileViewController.h"
#import "Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation fileViewController

@synthesize root;

- (id)initWithFileName:(NSString *)titel withRoot:(NSString*)rt
{
	self = [super init];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.title = titel;
		root = rt;
		
	}
	return self;
}
-(void)viewWillAppear:(BOOL)animated{
	//self.navigationController.hidesBottomBarWhenPushed = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	NSLog(@"viewWillDisappear");
}
//对象释放
- (void)dealloc
{
	[super dealloc];
}
-(void)back {
    // Tell the controller to go back
    [self.navigationController popViewControllerAnimated:YES];
}
// Automatically invoked after -loadView
// This is the preferred override point for doing additional setup after -initWithNibName:bundle:
//

NSString* fileMIMEType(NSString * file) {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[file pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return [(NSString *)MIMEType autorelease];
}

// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad
{
	
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
	
	self.navigationItem.title = @"";
	
	NSString *filePath = [root stringByAppendingPathComponent:self.title];
	
	NSLog(@"filepath : %@",filePath);
	
	if ([fileMIMEType(filePath) hasPrefix:@"image"])
	{
        [webView setHidden:NO];
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
		
		
		[webView release];

//		[imageView setHidden:NO];
//		[imageView setImage:[UIImage imageWithContentsOfFile:filePath]];
	}
	else {

		[webView setHidden:NO];
//		NSData *htmlData = [NSData dataWithContentsOfFile:filePath];  
//		if (htmlData) {  
//			[webView loadData:htmlData MIMEType:fileMIMEType(filePath) textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:root]];  
//		}
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
		
		
		[webView release];
		
	}
	//[self.navigationController popToRootViewControllerAnimated:YES];
	
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)addAction:(id)sender
{
	// the add button was clicked, handle it here
	//
}

- (void)viewDidAppear:(BOOL)animated
{
	// do something here as our view re-appears
}

@end
