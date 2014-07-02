//
//  FormView.m
//  IPAD
//
//  Created by  careers on 12-3-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FormView.h"


@implementation FormView
@synthesize condition;
@synthesize pathString;
@synthesize delegate;
@synthesize yearString;


//- (id)initWithFrame:(CGRect)frame {
//    
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code.
//    }
//    return self;
//}

//初始化对象
-(id)initWithFrame:(CGRect)_frame andPageId:(int)_PageId
{
  self = [super initWithFrame:_frame];
  if (self) 
  {
	  pageId = _PageId;
	  viewFrame = CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height);
	  formView = [[UIWebView alloc]initWithFrame:viewFrame];
      
      [self dateBackupRestore];
      
	  formView.tag = pageId;
	  formView.delegate = self;	
	  formView.scalesPageToFit = YES;
	  formView.detectsPhoneNumbers = NO;
	  for(UIScrollView *v in [formView subviews])
	  {
		 // v.scrollEnabled = NO;
		  v.backgroundColor = [UIColor whiteColor];
	  }
	  [self addSubview:formView];
  }
	return self;
}

//文件信息拷贝
- (void)dateBackupRestore{
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
    (NSLibraryDirectory, NSUserDomainMask, YES); 
    NSString *libraryDir = [libraryPaths objectAtIndex:0];
    NSString *databaseBackupPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseBackupPath]) {        
        NSString *backupFile = [libraryDir stringByAppendingPathComponent:@"Backup"]; 
        NSString *testBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/test.db"]; 
        NSString *databaseBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/Databases.db"];
        NSString *databaseFormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
        NSString *file0FormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases/file__0"];
        
        NSFileManager *NFM = [NSFileManager defaultManager];
        BOOL isDir = YES;
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
        
        NSString *databaseFormerFile = [databaseFormerPath stringByAppendingPathComponent:@"/Databases.db"];
        NSString *testFormerFile = [file0FormerPath stringByAppendingPathComponent:@"/test.db"];
        
        NSData *databaseData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:databaseBackupFile]];
        NSData *testData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:testBackupFile]];
        
        
        [databaseData writeToFile:databaseFormerFile atomically:YES];
        [testData writeToFile:testFormerFile atomically:YES];
        
        [databaseData release];
        [testData release];
        [[NSFileManager defaultManager] removeItemAtPath:backupFile error:nil];
    }
}

//传值:文件路径
-(void)setPathString:(NSString *)_path
{
	pathString = _path;
	[self showForm];
}

//在webView上展示文件信息
-(void)showForm
{
    NSString *filePath;
    NSString *file_bundlePath = [Utilities bundlePath:[NSString stringWithFormat:@"htmlTemplate/%@",self.pathString]];
	NSString *file_documentPath = [Utilities documentsPath:[NSString stringWithFormat:@"htmlTemplate/%@",self.pathString]];
	if ([Utilities isFileExist:file_documentPath])
	{
		filePath = file_documentPath;
	}
	else 
	{
		filePath = file_bundlePath;
	}
	[formView loadHTMLString:[NSString stringWithContentsOfFile:filePath
														   encoding:NSUTF8StringEncoding
															  error:nil] 
						 baseURL:nil];
}
#pragma mark -
#pragma mark UIWebView delegate
//UIwebView代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

//UIWebView代理方法,加载web页面
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSString *sql = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getSql('%@','%@')",self.condition,self.yearString]];
	NSArray *array = [[SQLiteOptions sharedSQLiteOptions]queryWithSqlString:sql];
	NSString *javascript;
	for (NSDictionary *dictionary in array) 
	{
			
		javascript = [NSString stringWithFormat:@"document.getElementById('%@').innerHTML='%@'",[[dictionary allKeys]objectAtIndex:0],[[dictionary allValues]objectAtIndex:0]];
			
		[webView stringByEvaluatingJavaScriptFromString:javascript];
	}
	[webView stringByEvaluatingJavaScriptFromString:@"creat()"];
	[self.delegate stopLoad];
}

//对象释放
- (void)dealloc {
    [super dealloc];
	[formView release];
}
@end
