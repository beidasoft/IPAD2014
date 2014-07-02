    //
//  DistinguishWordOrExcel.m
//  IPAD
//
//  Created by  careers on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DistinguishWordOrExcel.h"
#import <sqlite3.h>


@implementation DistinguishWordOrExcel
@synthesize tableName,condition,tit,delegate;

// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	NSMutableArray *resultArray = [[NSMutableArray alloc] init];
	NSString *sqlString = [NSString stringWithFormat:@"select FILE_NAME from IPAD_Analysis_Group_File where ID = '%d'",self.condition];
	const char *sql = [sqlString cStringUsingEncoding:4];
	sqlite3_stmt *stmt;
    //打开数据库
	[[SQLiteOptions sharedSQLiteOptions] openSQLiteDatabase];
	if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL)==SQLITE_OK)
	{
		while (sqlite3_step(stmt)==SQLITE_ROW)
		{
			const unsigned char *colName = sqlite3_column_text(stmt,0);
			NSString *colString = [[NSString alloc] initWithUTF8String:colName];
			[resultArray addObject:colString];
			[colString release];
		}
		sqlite3_finalize(stmt);
	}
    //关闭数据库
	[[SQLiteOptions sharedSQLiteOptions] closeSQLiteDatabase];
	NSString *contentName = [resultArray objectAtIndex:0];
	backButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 688, 50,60)];
    //背景图片
	UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    bgImage.image = [UIImage imageNamed:@"jianlibg.png"];
    [self.view addSubview:bgImage];
    [bgImage release];
    //加载图片的框图
    UIImageView *borderBg = [[UIImageView alloc]initWithFrame:CGRectMake(202, 164, 760, 555)];
    borderBg.image = [UIImage imageNamed:@"jianliFrame.png"];
    [self.view addSubview:borderBg];
    [borderBg release];
    //初始化标题
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(204, 100, 757, 30)];
    titleLabel.text = self.tit;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:30];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    //判断webview是否存在
    if ([[self.view subviews] containsObject:webView])
    {
        webView.frame = CGRectMake(204, 167 ,757, 550);
    }
    else 
    {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(204, 167 ,757, 550)];
        [self dateBackupRestore];
        webView.delegate = self;
        webView.backgroundColor = [UIColor clearColor];
    }
    UIImageView *titleBg = [[UIImageView alloc]initWithFrame:CGRectMake(45, 100, 60, 150)];
    [self.view addSubview:titleBg];
    [titleBg release];
    [self addTitle:titleBg];
    webView.scalesPageToFit= YES;
	//判断是否是txt文件，2012－7－12 BY 李国威 
	if ([contentName hasSuffix:@".txt"]) {
		NSString *contentString = [[NSString alloc] 
								   initWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",contentName]]
												 encoding:NSUTF8StringEncoding
													error:nil];
		if (!contentString) {
			contentString = [[NSString alloc] 
							 initWithContentsOfFile:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",contentName]]
							 encoding:0x80000632
							 error:nil];
		}
		//读入模板的文本路径。2012－7－12 BY 李国威
		NSString *templatePath = [[[NSBundle mainBundle] resourcePath]
							   stringByAppendingPathComponent:@"textTemplate.html"];
		//模板内容读入字符串。2012－7－12 BY 李国威
		NSMutableString *htmlString = [[NSMutableString alloc] initWithContentsOfFile:templatePath
																			 encoding:4
																				error:nil];
		//添加内容到模板。2012－7－12 BY 李国威
		[htmlString replaceOccurrencesOfString:@"<htmlContent>"
									withString:contentString
									   options:nil
										 range:NSMakeRange(0, [htmlString length])];

		[webView loadHTMLString:htmlString baseURL:nil];
	}
	//不是txt文件的情况。2012－7－12 BY 李国威
	else {
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[Utilities documentsPath:[NSString stringWithFormat:@"template/%@",contentName]]]]];

	}

	//加载web视图
	[self.view addSubview:webView];
	[backButton setBackgroundImage:[UIImage imageNamed:@"thirdBack.png"]
						  forState:UIControlStateNormal];
	[backButton addTarget:self 
				   action:@selector(back)
		 forControlEvents:UIControlEventTouchUpInside];
    //加载返回按钮
	[self.view addSubview:backButton];
	[resultArray release];
}

//将Backup文件夹里的数据库文件copy到webkit目录下
- (void)dateBackupRestore{	
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
    (NSLibraryDirectory, NSUserDomainMask, YES); 
    NSString *libraryDir = [libraryPaths objectAtIndex:0];
    //数据库文件存放路径
    NSString *databaseBackupPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
    //如果数据库文件不存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseBackupPath]) {
        NSString *backupFile = [libraryDir stringByAppendingPathComponent:@"Backup"];
        NSString *testBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/test.db"]; 
        NSString *databaseBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/Databases.db"];
        NSString *databaseFormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
        NSString *file0FormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases/file__0"];
        
        NSFileManager *NFM = [NSFileManager defaultManager];
        BOOL isDir = YES;
        //如果文件夹不存在，则创建
        if (![NFM fileExistsAtPath:databaseFormerPath isDirectory:&isDir]) {
            if (![NFM createDirectoryAtPath:databaseFormerPath attributes:nil]) {
                //build forder
            }
        }
        //如果文件夹不存在，则创建
        if (![NFM fileExistsAtPath:file0FormerPath isDirectory:&isDir]) {
            if (![NFM createDirectoryAtPath:file0FormerPath attributes:nil]) {
                //build forder
            }
        }
        //原数据库文件路径
        NSString *databaseFormerFile = [databaseFormerPath stringByAppendingPathComponent:@"/Databases.db"];
        NSString *testFormerFile = [file0FormerPath stringByAppendingPathComponent:@"/test.db"];
        //拷贝数据库文件
        NSData *databaseData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:databaseBackupFile]];
        NSData *testData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:testBackupFile]];
        
         //创建数据库文件
        [databaseData writeToFile:databaseFormerFile atomically:YES];
        [testData writeToFile:testFormerFile atomically:YES];
        
        [databaseData release];
        [testData release];
        [[NSFileManager defaultManager] removeItemAtPath:backupFile error:nil];
    }
}



//返回上一级控制器
- (void)back
{
	UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	CGRect endFrame = CGRectMake(1024, 0, 1024, 768);
	
	[UIView beginAnimations:nil context:nil];
	for (UIImageView *img in [navagation.view subviews])
	{
		if (100 == img.tag ) 
		{
			img.frame = endFrame;
		}
		
	}
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didBack)];
	[UIView setAnimationDuration:1.2];
	[UIView commitAnimations];
	[delegate deselected];
	
}
//移除控制器视图
-(void)didBack
{
	[self.view removeFromSuperview];
	[self release];
}
-(void)addTitle:(UIImageView *)_titleBg
{
	if ([tableName isEqualToString:@"干部测评"])
	{
		_titleBg.image = [UIImage imageNamed:@"gbcptitle.png"];
	}
	else if([tableName isEqualToString:@"干部分析"])
	{
		_titleBg.image = [UIImage imageNamed:@"gbfxtitle.png"];
	}
	else if([tableName isEqualToString:@"干部年统"])
	{
		_titleBg.image = [UIImage imageNamed:@"gbnttitle.png"];
	}
	else if([tableName isEqualToString:@"党内统计"])
	{
		_titleBg.image = [UIImage imageNamed:@"dntjtitle.png"];
	}
	else if([tableName isEqualToString:@"党内分析"])
	{
		_titleBg.image = [UIImage imageNamed:@"dnfxtitle.png"];
	}
	else if([tableName isEqualToString:@"人才分析"])
	{
		_titleBg.image = [UIImage imageNamed:@"rcfxtitle.png"];
	}
	else if([tableName isEqualToString:@"组工资料"])
	{
		_titleBg.image = [UIImage imageNamed:@"zgzltitle.png"];
	}

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
- (void)dealloc 
{
	[webView release];
	[titleLabel release];
	[backButton release];
	[super dealloc];
}
@end
