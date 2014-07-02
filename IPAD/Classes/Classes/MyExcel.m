//
//  MyExcel.m
//  OrganizationInqury
//
//  Created by careers on 12-2-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#define BARHEIGHT 60
#define X_DECREASE 64
#define Y_DECREASE 180
#define Y_ORIGIN 100

#import "MyExcel.h"
#import "Utilities.h"


@implementation MyExcel
@synthesize myName,realFileName;
@synthesize finishLoad;


-(id)initWithExcelName:(NSString *)_excelName andFrame:(CGRect)_frame
{
	if (self == [super initWithFrame:_frame])
	{
		//self.backgroundColor = [UIColor redColor];
		
		self.myName = _excelName;		
		myFrame = CGRectMake(0.0, BARHEIGHT, self.bounds.size.width, self.bounds.size.height -BARHEIGHT);
		
		finishLoad = NO;
		self.userInteractionEnabled = NO;
		//加载控制excel中sheet大小的button
		CGRect  temp_frame =CGRectMake(929, 0.0, 95, 54);
		changeStyleButton = [[UIButton alloc]initWithFrame:temp_frame];
		[changeStyleButton setImage:[UIImage imageNamed:@"excel_big.png"] forState: UIControlStateNormal];
		[changeStyleButton addTarget:self action:@selector(changeStyle) forControlEvents:UIControlEventTouchUpInside];		
		[self addSubview:changeStyleButton];
		[changeStyleButton release];
		
		//加载系统控件UIPageControl，多个页面提示视图
		pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(412, 700, 200,30)];		
		[self addSubview:pageControl];
		[pageControl release];
		//加载系统控件UIActivityIndicatorView，"加载中"提示
		spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
				 UIActivityIndicatorViewStyleGray];		
		[spinner setCenter:CGPointMake(myFrame.size.width * 0.5 - 125, myFrame.size.height * 0.5)];
		//spinner.frame = CGRectMake(spinner.frame.origin.x, spinner.frame.origin.y, 40, 40);		
		[self addSubview:spinner];
		[spinner release];
        
		//加载"双击查看"按钮
		doubleClickView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"doubleClicked.png"]];
		doubleClickView.center = CGPointMake(myFrame.size.width *0.5, myFrame.size.height * 0.5);
		doubleClickView.alpha = 0.0;		
		[self addSubview:doubleClickView];
		[doubleClickView release];
		//excel中sheet标题
		sheetTitle = [[UILabel alloc]initWithFrame:CGRectMake(X_DECREASE * 2, BARHEIGHT +20, myFrame.size.width - X_DECREASE * 4, 70)];
		sheetTitle.backgroundColor = [UIColor clearColor];		
		[sheetTitle setFont:[UIFont fontWithName:@"HelVetica" size:30]];
		sheetTitle.textAlignment = UITextAlignmentCenter;
		[self addSubview:sheetTitle];
		[sheetTitle release];
        //excel文件路径
		NSString *path = [Utilities documentsPath:[NSString stringWithFormat:@"template/%@",myName]];
		NSURL *url = [NSURL fileURLWithPath:path];
		//webview加载excel
        NSURLRequest * request = [NSURLRequest requestWithURL:url];		
		UIWebView *webView = [[UIWebView alloc]init];
        [self dateBackupRestore];

		webView.delegate = self;			
		[webView loadRequest:request];	
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
//对象释放
-(void)dealloc
{
	[super dealloc];
	[myName release];
	[sheetArray release];
	[sheetNames release];
	[myScrollView release];
}
#pragma mark -
#pragma mark UIWebView delegate
//webview代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //解析sheet的个数
	NSString *excelHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];	
	NSArray *tempArray = [excelHtml componentsSeparatedByString:@"SelectSheet"];		
	excelNum = [tempArray count] - 1;	
	//如果sheet数量为1的情况
    if (excelNum <= 0)
	{
		excelNum = 1;
	}
	sheetNames = [[NSMutableArray alloc]initWithCapacity:excelNum];
	NSString *string;
    //将每个sheet的名字存储到一个数组中
	if (1 == excelNum)
	{
		[sheetNames addObject:self.realFileName];
		sheetTitle.text = [sheetNames objectAtIndex:0];
	}
	else
	{
		for (int i = 1; i <= excelNum; i++) 
		{
            //名称格式为"文件名－i"
			string = [NSString stringWithFormat:@"%@-%d",self.realFileName,i];
			[sheetNames addObject:string];
		}
		sheetTitle.text = [sheetNames objectAtIndex:0];
	}
	[webView stopLoading];
	webView.delegate = nil;
	[webView release];
	[self loadAllSheet];
}
/*
-(void)stopAllSheetLoading
{
	for (SheetView *aSheet in [contentView subviews])
	{
		if (!aSheet.clicked) 
		{
			
			[aSheet stopMyLoading];
			break;
		}
	}
}
 */
#pragma mark -
#pragma mark UIScrollView delegate
//UIScrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
	float wid ;
    //scrollView滑动的距离
	wid = _scrollView.contentOffset.x;
    //切换UIPageControl的显示
	pageControl.currentPage = round(wid/1024);
	currentSheetId = pageControl.currentPage;
    //切换不同sheet的标题
	sheetTitle.text = [sheetNames objectAtIndex:currentSheetId];
	//contentView 做相应的移动
	CGFloat offset = _scrollView.contentOffset.x *0.1875;
	/*  0.1875 = 1- (1024/16 * 12 + 1024/16 )/1024 */
	CGAffineTransform transform = CGAffineTransformMakeTranslation(offset, 0);
	[contentView setTransform:transform];
}
#pragma mark -
#pragma mark ExcelSheetDelegate delegate
//显示excel的所有的sheet
-(void)displayAllSheet
{
    //遍历所有的SheetView
	for (SheetView *aSheet in [contentView subviews])
	{
        //判断sheet是否解析完
		if (!aSheet.clicked) 
		{
			[aSheet showSheet];
			return;
		}
	}
    //所有的sheet加载完
	self.userInteractionEnabled = YES;
	finishLoad = YES;
    //风火轮停止转动
	[spinner stopAnimating];
    //显示“双击”按钮
	UIButton *aButton = (UIButton *)[self.superview viewWithTag:998]; /*998 -backBt.tag*/
	aButton.enabled = YES;
	[self bringSubviewToFront:doubleClickView];
	
	UIImageView *aImage = (UIImageView *)[self.superview viewWithTag:999]; /*999 -loading.tag*/
	[aImage removeFromSuperview];

	for (SheetView *aSheet in [contentView subviews])
	{
	    //判断是否是第一次返回而出现是否播放动画 BY 李国威 2012-8-7
        if (!aSheet.hasClicked) 
        {
            //播放2秒显示的动画
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2.0];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(hiddenDoubleClicked)];
            doubleClickView.alpha = 1.0;
            [UIView commitAnimations];
            aSheet.hasClicked = YES;
        }
    }
}
/*
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	
	[context release];
	
}
*/
#pragma mark -
#pragma mark self Method
//加载所有的sheet
-(void)loadAllSheet
{
	SheetView *sheetView ;
	CGRect temp_frame;
	int i ;
    //UIPageControl的显示个数
	pageControl.numberOfPages = excelNum;
	currentSheetId = 0;	
	sheetStatus = YES;
    //初始化存放所有SheetView的数组
	sheetArray = [[NSMutableArray alloc]initWithCapacity:excelNum];
	
    myScrollView = [[UIScrollView alloc]initWithFrame:myFrame];	
	
	/*  temp_frame :  0,0,768 ,608  */
	temp_frame = CGRectMake(0.0,0, myFrame.size.width - X_DECREASE * 4, myFrame.size.height - Y_DECREASE);
	NSLog(@"temp_frame:%@",NSStringFromCGRect(temp_frame));
	//将所有SheetView放在contentView这个容器中
    contentView = [[UIView alloc] initWithFrame:
				   CGRectMake(X_DECREASE * 2, Y_ORIGIN, excelNum*temp_frame.size.width+(excelNum-1)*X_DECREASE, temp_frame.size.height)];
	contentView.userInteractionEnabled = YES;
	//根据excel中sheet的数量初始化所有的SheetView
	for (i = 0; i < excelNum; i++)	
	{	
		
		sheetView = [[SheetView alloc]initWithName:myName andFrame:temp_frame andSheetId:i];
		sheetView.delegate = self;
		sheetView.sheetNum = excelNum;
		sheetView.originFrame = temp_frame;
		sheetView.myStyle = 1;
		[sheetArray addObject:sheetView];		
        
		[contentView addSubview:sheetView];	
		[sheetView release];
		temp_frame.origin.x += X_DECREASE + temp_frame.size.width;
        
	}	
	//配置scrollView各项属性
	myScrollView.contentSize = CGSizeMake(excelNum *myFrame.size.width, myFrame.size.height);
	myScrollView.pagingEnabled = YES;
	myScrollView.bounces = NO;
	myScrollView.showsHorizontalScrollIndicator = NO;
	myScrollView.delegate = self;
	
	[myScrollView addSubview:contentView];
	[contentView release];
	[self addSubview:myScrollView];
	//加载、显示各个SheetView
	for (SheetView *aSheet in [contentView subviews])
	{
		if (!aSheet.clicked) 
		{
			
			[self bringSubviewToFront:spinner];			
			[spinner startAnimating];
			
			UIImageView *loadingView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"excel_loading.png"]];
			loadingView.tag = 999;
			loadingView.center = CGPointMake(myFrame.size.width * 0.5, myFrame.size.height * 0.5);
			[self addSubview:loadingView];
			[loadingView release];			
			
			[aSheet showSheet];
			break;
		}
	}
	
}
//放大显示某一个sheet
-(void)displayOneSheet:(int)_sheetId
{
	//改变按钮显示样式
	sheetStatus = NO;
	[changeStyleButton setImage:[UIImage imageNamed:@"excel_small.png"] forState: UIControlStateNormal];
	UIButton *aButton = (UIButton *)[self.superview viewWithTag:998]; /*998 -backBt.tag*/
	aButton.hidden = YES;
	//改变sheet的大小、放大后的标识
	SheetView *tempSheet = [sheetArray objectAtIndex:_sheetId];
	tempSheet.myStyle = 2;	
	tempSheet.sheetScaleToFit = YES;
	tempSheet.sheetFrame = myFrame;
    //放大动画
	[UIView beginAnimations:nil context:tempSheet];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone 
						   forView:[[(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController]view] cache:YES];
	[tempSheet retain];
	[tempSheet removeFromSuperview];
	[self addSubview:tempSheet];
	[UIView commitAnimations];
}
//改变sheet的显示样式
-(void)changeStyle
{
	CGRect tempFrame;
	//sheet为缩小状态
	if (sheetStatus)
	{
        //放大显示某个sheet
		[self displayOneSheet:currentSheetId];
	}
	else
	{
        //将某个放大的sheet缩小
		for (SheetView *aSheetView in [self subviews])
		{
			if ([aSheetView isMemberOfClass:[SheetView class]])
			{
                //调节sheet缩小后的各项属性
				UIButton *aButton = (UIButton *)[self.superview viewWithTag:998]; /*998 -backBt.tag*/
				aButton.hidden = NO;
				tempFrame = aSheetView.originFrame;
				aSheetView.myStyle = 1;
				//aSheetView.sheetFrame = tempFrame;
				aSheetView.sheetScaleToFit = NO;
				aSheetView.sheetFrame = tempFrame;
				
				[aSheetView retain];
				[aSheetView removeFromSuperview];
				//缩小动画
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationDuration:0.5];
				[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:aSheetView cache:YES];
                
				[contentView addSubview:aSheetView];				
				[UIView commitAnimations];
				
				//重新加载webview BY 李国威 2012-8-7
				[aSheetView showSheet];
				aSheetView.clicked = NO;
				[aSheetView release ];
			}
		}
        //改变样式的标示（放大／缩小）
		sheetStatus = YES;
		[changeStyleButton setImage:[UIImage imageNamed:@"excel_big.png"] forState: UIControlStateNormal];
	}
}
//隐藏提示双击视图
-(void)hiddenDoubleClicked
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.0];
	doubleClickView.alpha = 0.0;
	[UIView commitAnimations];
}
//单个sheet放大缩小动画
- (void)addAnimation:(UIView *)targetView time:(float)time typeName:(NSString *)name
{
	CATransition *transition = [CATransition animation];
	transition.duration = time;          /*  间隔时间*/
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	transition.type = name;  
	transition.subtype =  kCATransitionFromBottom;
	transition.removedOnCompletion = YES;
	transition.fillMode = kCAFillModeBackwards;
	transition.delegate = targetView;
	[targetView.layer addAnimation:transition forKey:nil];  
}


@end
