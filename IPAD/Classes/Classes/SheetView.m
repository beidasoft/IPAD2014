//
//  SheetView.m
//  OrganizationInqury
//
//  Created by careers on 12-2-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SheetView.h"


@implementation SheetView
@synthesize excelName;
@synthesize clicked;
@synthesize sheetScaleToFit;

@synthesize sheetId;
@synthesize sheetNum;
@synthesize myStyle;

@synthesize sheetFrame;
@synthesize originFrame;
@synthesize hasClicked;
@synthesize delegate;



-(id)initWithName:(NSString *)_excelName andFrame:(CGRect)_frame andSheetId:(int)_sheetId
{
    
    self = [super initWithFrame:_frame];
    if (self)
	{
		
		sheetId = _sheetId;
		sheetFrame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
		self.excelName = _excelName;	
		loadTime = 0;
		//加载sheet的背景图片
		UIImageView *bg = [[UIImageView alloc]initWithFrame:self.bounds];
		bg.image = [UIImage imageNamed:@"excel_sheetFrame.png"];
		[self addSubview:bg];
		[bg release];
	    //加载显示sheet的webview
		sheetWebView = [[UIWebView alloc]initWithFrame:sheetFrame];
        [self dateBackupRestore];
        //配置webview各属性
		sheetWebView.tag = sheetId;
		sheetWebView.delegate = self;	
		sheetWebView.scalesPageToFit = YES;
		self.sheetScaleToFit = NO;
	
		[self addSubview:sheetWebView];
		
		clicked = NO;
		//是否点击过初始化 BY 李国威 2012-8-7
		self.hasClicked = NO;
	    //添加视图双击手势的识别
		UITapGestureRecognizer *doubleClickGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClicked)];			
		doubleClickGesture.numberOfTapsRequired = 2;
		[self addGestureRecognizer:doubleClickGesture];
		[doubleClickGesture release];
		
    }
    return self;
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
//释放对象
- (void)dealloc {
    [super dealloc];
	[excelName release];
	
	[sheetWebView stopLoading];
	sheetWebView.delegate = nil;
	[sheetWebView release];
}
#pragma mark -
#pragma mark 设置属性值
//设置属性sheetFrame的值,不同的样式，大小不一样
-(void)setSheetFrame:(CGRect)_frame
{
    //如果sheet的样式为放大状态
	if (2 == myStyle)
	{
        //改变sheet的大小
		self.frame = _frame;
		sheetFrame = self.bounds;		
		sheetWebView.frame = sheetFrame;
	}
	else
	{
		self.frame = _frame;		
		sheetFrame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
		sheetWebView.frame = sheetFrame;
		//重新加载表 BY 李国威 2012-7-20
		[self showSheet];
	}
}
//设置属性sheetScaleToFit的值
-(void)setSheetScaleToFit:(BOOL)_scaleToFit
{
	sheetScaleToFit = _scaleToFit;
	if (sheetScaleToFit)
	{
		sheetWebView.userInteractionEnabled = YES;
	}
	else
	{
		sheetWebView.userInteractionEnabled = NO;
	}
}
#pragma mark -
#pragma mark UIWebView delegate
//webview 的代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{	
	//判断是否是当前webview
	if (webView.tag != sheetId)
	{
		
		return;
	}
    //如果只有一个sheet
	if (1 == sheetNum)
	{		
		
		clicked = YES;
		[self.delegate displayAllSheet];
		return;
	}
	else
	{
        //sheet未解析完
		if (!clicked)
		{
            //解析excel中当前的sheet
			NSString *aString = [NSString stringWithFormat:@"document.getElementById('Tab%D').onclick()",sheetId];
			
			[webView stringByEvaluatingJavaScriptFromString:aString];
			for (int i = 0; i < sheetNum; i++)
			{
				NSString *tempString = [NSString stringWithFormat:@"document.getElementById('Tab%d').parentNode.removeChild(document.getElementById('Tab%d'));",i,i];
				[webView stringByEvaluatingJavaScriptFromString:tempString];
			}
			clicked = YES;		
		}
		if (loadTime >=2) 
		{
            //sheet解析完，代理显示所有的sheet
			[self.delegate displayAllSheet];
		}
		else
		{
			loadTime ++;
		}
	}
}
#pragma mark -
#pragma mark self Method
//加载当前sheet所属的excel
-(void)showSheet
{ 
    //excel文件路径
	NSString *path = [Utilities documentsPath:[NSString stringWithFormat:@"template/%@",self.excelName]];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	//加载路径下的文件
	[sheetWebView loadRequest:request];

}
-(void)stopMyLoading
{	
	[sheetWebView stopLoading];
}
//双击sheet视图
-(void)doubleClicked
{ 
    //如果是放大状态不处理
	if (2 == self.myStyle) 
	{
		return;
	}
    //放大sheet视图
	myStyle = 2;
	[self.delegate displayOneSheet:sheetId];
}
@end
