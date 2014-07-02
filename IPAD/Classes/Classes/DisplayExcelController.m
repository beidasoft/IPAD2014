    //
//  DisplayExcelController.m
//  IPAD
//
//  Created by careers on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayExcelController.h"


@implementation DisplayExcelController
@synthesize tableName;
@synthesize condition;
@synthesize delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载背景图片
	UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20-[self getPaddingY], 1024, 748)];
	bgImage.image = [UIImage imageNamed:@"excel_Bg.png"];
	[self.view addSubview:bgImage];
	[bgImage release];
	
	//标题栏的背景图片
	UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 90)];
	NSString *logoImageDocPath = [Utilities documentsPath:kLogoBackgroundImageName];
	if ([Utilities isFileExist:logoImageDocPath])
	{
		logoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:logoImageDocPath]];
	}
	else {
		logoImage.image = [UIImage imageNamed:kLogoBackgroundImageName];
	}
	logoImage.userInteractionEnabled = YES;
	//logo图片路径
	UIImage *logoImg;
	NSString *logo_bundlePath = [Utilities bundlePath:kLogoTitleImageName];
	NSString *logo_documentPath = [Utilities documentsPath:kLogoTitleImageName];
	NSData * logo_Data; 
	//判断是默认logo，还是自定义logo
	if ([Utilities isFileExist:logo_documentPath])
	{
		
		logo_Data = [NSData dataWithContentsOfFile:logo_documentPath];
		logoImg = [UIImage imageWithData:logo_Data];
	}
	else 
	{
		
		logo_Data = [NSData dataWithContentsOfFile:logo_bundlePath];
		
		logoImg = [UIImage imageWithData:logo_Data];
	}
	//加载logo图片
	UIImageView *logoTitle = [[UIImageView alloc]initWithFrame:KLOGORECT];
	logoTitle.image = logoImg;
	[logoImage addSubview:logoTitle];
	[bgImage addSubview:logoImage];
	[logoTitle release];
	[logoImage release];
	
	//查询文件的文件名	
	NSString *sql;	
	sql = [NSString stringWithFormat:@"select * from IPAD_Analysis_Group_File where ID = %d limit 0,100",self.condition];
	NSMutableArray * resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql]];
	NSString *contentName;
	contentName = [[resultArray objectAtIndex:0]objectForKey:@"FILE_NAME"];
	//加载excel文件
	myExcel = [[MyExcel alloc]initWithExcelName:contentName andFrame:CGRectMake(0.0, 20-[self getPaddingY], 1024, 748)];
	myExcel.realFileName = self.tableName;
	[self.view addSubview:myExcel];
	[resultArray release];

    //加载返回按钮
	CGRect temp_frame =CGRectMake(20, 698-[self getPaddingY], 50,60);
	UIButton *button = [[UIButton alloc]initWithFrame:temp_frame];
	[button setBackgroundImage:[UIImage imageNamed:@"thirdBack.png"] forState: UIControlStateNormal];
	[button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	button.tag = 998;
	button.enabled = NO;
	[self.view addSubview:button];
	[button release];
 
}

//ios7搜索条适配 add by zyy 2014-02-18
- (int)getPaddingY{
    int paddingy = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        paddingy = 20;
    }
    return paddingy;
}

//对象释放
- (void)dealloc {
	
	 [super dealloc];
	
	[myExcel release];
	[tableName release];
   
}
//返回按钮方法
-(void)back
{
	if (!myExcel.finishLoad)
	{
		return;
		
	}
	CGRect endFrame = CGRectMake(1024, 0, 1024, 768);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDidStopSelector:@selector(didBack)];
	[UIView setAnimationDelegate:self];
	self.view.frame = endFrame;
	[UIView commitAnimations];
	[delegate deselected];
	
}
//移除控制器视图
-(void)didBack
{
	[self.view removeFromSuperview];
	[self release];
	
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
@end
