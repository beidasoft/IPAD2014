    //
//  TempFileWebViewController.m
//  IpadTest
//
//  Created by pc h on 12/8/11.
//  Copyright 2011 careers. All rights reserved.
//

#import "TempFileWebViewController.h"


@implementation TempFileWebViewController
@synthesize fileName;

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
    //初始化显示用的webview
	CGRect frame = [[UIScreen mainScreen]applicationFrame];
	webView1 = [[UIWebView alloc] initWithFrame:frame];
    [self dateBackupRestore];
	webView1.delegate = self;
    //支持多点触控
	webView1.multipleTouchEnabled = YES;
	//至此缩放
    webView1.scalesPageToFit = YES;

	
	//获取pdf的文件夹路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	

	NSString *docPath = [documentsDirectory stringByAppendingString:
						 [NSString stringWithFormat:@"/pdf/%@",self.fileName]];

	
	NSURL *url = [NSURL fileURLWithPath:docPath];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //加载返回的url
	[webView1 loadRequest:request];
	self.view = webView1;

	
}

- (void)dateBackupRestore{	
    //获取数据库备份的地址
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
    (NSLibraryDirectory, NSUserDomainMask, YES); 
    NSString *libraryDir = [libraryPaths objectAtIndex:0];
    NSString *databaseBackupPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
    //如果不存在指定文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseBackupPath]) {        
        NSString *backupFile = [libraryDir stringByAppendingPathComponent:@"Backup"]; 
        NSString *testBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/test.db"]; 
        NSString *databaseBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/Databases.db"];
        NSString *databaseFormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
        NSString *file0FormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases/file__0"];
        
        NSFileManager *NFM = [NSFileManager defaultManager];
        BOOL isDir = YES;
        //判断是否存在文件，如果不存在就创建文件夹
        if (![NFM fileExistsAtPath:databaseFormerPath isDirectory:&isDir]) {
            if (![NFM createDirectoryAtPath:databaseFormerPath attributes:nil]) {
                //build forder
            }
        }
        if (![NFM fileExistsAtPath:file0FormerPath isDirectory:&isDir]) {
            if (![NFM createDirectoryAtPath:file0FormerPath attributes:nil]) {
                //build forder
            }
        }
        //获取数据库路径
        NSString *databaseFormerFile = [databaseFormerPath stringByAppendingPathComponent:@"/Databases.db"];
        //获取test.db的路径
        NSString *testFormerFile = [file0FormerPath stringByAppendingPathComponent:@"/test.db"];
        
        //将文件读取到NADATA中
        NSData *databaseData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:databaseBackupFile]];
        NSData *testData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:testBackupFile]];
        
        //写入数据库
        [databaseData writeToFile:databaseFormerFile atomically:YES];
        [testData writeToFile:testFormerFile atomically:YES];
        
        [databaseData release];
        [testData release];
        //移除文件
        [[NSFileManager defaultManager] removeItemAtPath:backupFile error:nil];
    }
}
//加载页面
- (void)go:(id)sender{

    //获取文件路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *docPath = [documentsDirectory stringByAppendingString:
						 [NSString stringWithFormat:@"/pdf/%@",self.fileName]];
	
	NSURL *url = [NSURL fileURLWithPath:docPath];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	//加载内容
    [webView1 loadRequest:request];
	
}

//webview开始加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

	
	
	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

	
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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

//对象释放
- (void)dealloc {
    [super dealloc];
}


@end
