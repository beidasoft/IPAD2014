//
//  FirstNavigationViewController.m
//  FirstNavigation
//
//  Created by Lyz on 11-11-21.
//  Copyright 2011 careers. All rights reserved.
//
#import "IconNavigationController.h"
#import "FirstNavigationViewController.h"
#import "SQLiteOptions.h"
#import "TempFileWebViewController.h"
#import "TestTableViewController.h"
#import "NavController.h"
#import "Utilities.h"
#import "SecondMainController.h"
#import "SearchController.h"
#import "NSStringMD5Encrypt.h"

#define OLD_INPUTTEXT_TAG  250        // lijie
#define NEW_INPUTTEXT_TAG  251   // lijie
#define NEW_SET_INPUTTEXT_TAG  252        // lijie
  


@implementation FirstNavigationViewController
//@synthesize tableName;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.view.frame = CGRectMake(0, 0, 768, 1024);
    //更新操控对象
	up = [[Update alloc]init];
	//删除操控对象
    de = [[Delete alloc]init];
	self.title = @"组工综合查询系统";
	//初始化界面
	UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 90)];
    //获取图标路径
	NSString *logoImageDocPath = [Utilities documentsPath:kLogoBackgroundImageName];
    //判断本地是否存在图片文件
	if ([Utilities isFileExist:logoImageDocPath])
	{
		logoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:logoImageDocPath]];
	}
	else {
		logoImage.image = [UIImage imageNamed:kLogoBackgroundImageName];
	}
	logoImage.userInteractionEnabled = YES;
	
    //获取图片名称
	UIImageView *logoTitle = [[UIImageView alloc]initWithFrame:KLOGORECT];
	NSString *logo_documentPath = [Utilities documentsPath:kLogoTitleImageName];
	if ([Utilities isFileExist:logo_documentPath])
	{
		logoTitle.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:logo_documentPath]];
	}
	else 
	{
		logoTitle.image = [UIImage imageNamed:kLogoTitleImageName];
	}
	[logoImage addSubview:logoTitle];
	[logoTitle release];
	
    //初始化版本号显示控件
	versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(820, 700, 200, 30)];
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.textColor = [UIColor blackColor];
	
	NSString *sqlString = @"select * from databaseVersion where id=1;";
	NSArray *versionArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
    //设定控件内容
	versionLabel.text = [NSString stringWithFormat:@"当前数据库版本为:%@",[[versionArray objectAtIndex:0] objectForKey:@"version"]];
	[versionArray release];
	
	//初始化搜索按钮控件
	UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(862,2, 100,60)];
    [searchButton setImage:[UIImage imageNamed:@"setMark.png"]
			   forState:UIControlStateNormal];
	[searchButton addTarget:self 
				  action:@selector(setItems)
		forControlEvents:UIControlEventTouchUpInside];
	
	[logoImage addSubview:searchButton];
	[searchButton release];
	
    //设置背景图片
	UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kFirstPageImageName]];
	backgroundImage.frame = CGRectMake(0, 0, 1024, 768);
	[self.view addSubview:backgroundImage];
	[backgroundImage release];
    
    //初始化各个部分的内容数组
	NSMutableArray *textArray = [NSMutableArray array];
	NSMutableArray *titleArray = [NSMutableArray array];
	NSMutableArray *itemArray = [[NSMutableArray alloc]init];
	NSMutableArray *pictureArray = [[NSMutableArray alloc]init];
    
    //初始化图标NavigationController对象
	iNC = [[IconNavigationController alloc]init];
	NSMutableArray *newArray = [NSMutableArray arrayWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:@"select * from IPAD_Analysis_Group_File where ParentID = 0 order by Porder asc;"]];
	NSMutableArray *reArray = [[NSMutableArray alloc] init];
	for (int i=0; i<[newArray count]; i++)
	{
		NSString *nameValue = [[newArray objectAtIndex:i] objectForKey:@"Title"];
		NSMutableArray *tempArray1 =[[NSMutableArray alloc]initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithTableName:@"MAIN_TABLE" andCondition:[NSString stringWithFormat:@"NAME = '%@'",nameValue]]];
	    for (int i=0; i<[tempArray1 count]; i++)
		{
			[reArray addObject:[tempArray1 objectAtIndex:i]];
		}
		[tempArray1 release];
	}
    //填充内容数组
	NSArray *tempArray = [NSArray arrayWithArray: [[SQLiteOptions sharedSQLiteOptions] queryWithTableName:@"MAIN_TABLE" andCondition:nil]];
	NSMutableArray *endArray = [[NSMutableArray alloc] init];
    
    
	NSString *unitSql = @"select * from IPAD_JB02";
	//通过sql语句获取内容返回数组
    NSArray *unitArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:unitSql];
   if ([tempArray count]!=0)
   {
	   if ([unitArray count]==0)
	   {
		   
	   }
	   else 
	   {
		   [endArray addObject:[tempArray objectAtIndex:0]];
		   [endArray addObject:[tempArray objectAtIndex:1]];
		   [endArray addObject:[tempArray objectAtIndex:2]];	
	   }
	   [endArray addObjectsFromArray:reArray];
	   [endArray addObject:[tempArray objectAtIndex:24]];
	   [endArray addObject:[tempArray objectAtIndex:25]];
	   [endArray addObject:[tempArray objectAtIndex:26]];
	   [reArray release];
   }
    //将NAME、LINK、IMAGE添加到相应的数组中去
	for (NSDictionary *dictionary in endArray) 
	{
		
		if ([[[dictionary allKeys]objectAtIndex:0] hasPrefix:@"NAME"]) {
			[textArray addObject:[[dictionary allValues]objectAtIndex:0]];
		}
		else if([[[dictionary allKeys]objectAtIndex:0] hasPrefix:@"LINK"]) {
			[titleArray addObject:[[dictionary allValues]objectAtIndex:0]];
		}
		else if([[[dictionary allKeys]objectAtIndex:0]hasPrefix:@"IMAGE"])
		{
		    [pictureArray addObject:[[dictionary allValues]objectAtIndex:0]];
		}
	}
	[endArray release];
    //将内容添加到itemArray中
	for (int i = 0; i< [titleArray count]; i++) 
	{
		NSArray *aray = [[NSArray alloc] initWithObjects:
						 [pictureArray objectAtIndex:i],
						 [textArray objectAtIndex:i],
						 [titleArray objectAtIndex:i],
						 nil];
		[itemArray addObject:aray];
		[aray release];
	}
	[pictureArray release];
	iNC.itemArray = itemArray;
	[self.view addSubview:iNC.view];
	[self.view addSubview:logoImage];
	[logoImage release];
	[itemArray release];
    //添加消息中心
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push:) 
												 name:@"push" 
											   object:nil];//其他模块
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push1) 
												 name:@"push1" 
											   object:nil];//其他资料
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reset) 
												 name:@"zero" 
											   object:nil];//重置
	[[NSNotificationCenter defaultCenter]addObserver:self 
											selector:@selector(updateProgressView:)
												name:@"updataBar"
											  object:nil];//更新进度条
	[[NSNotificationCenter defaultCenter]addObserver:self 
											selector:@selector(dismissProgressAlert:)
												name:@"finish"
											  object:nil];//移除提示
	[[NSNotificationCenter defaultCenter]addObserver:self 
											selector:@selector(dismissProgressAlert:)
												name:@"finish1"
											  object:nil];//移除提示
	[[NSNotificationCenter defaultCenter]addObserver:self 
											selector:@selector(dismissProgressAlert:)
												name:@"error"
											  object:nil];//移除提示
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animation) 
//												 name:@"selected" 
//											   object:nil];//显示动画
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIsDianJi) 
												 name:@"setIsDianJi" 
											   object:nil];//设置为点击
    //延时执行更新
	[self performSelector:@selector(update) withObject:nil afterDelay:0.5];
	//加载搜索控件
	UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(230, 70, 572, 100)];//250  572
	searchBar.delegate=self;
	searchBar.showsCancelButton=NO;
	searchBar.barStyle=UIStatusBarStyleDefault;
	searchBar.placeholder= @"请填写您要搜索的内容";
	searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    
	[self.view addSubview:searchBar];
    //ios7搜索条样式适配，modify by zyy 2014-04-21
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([searchBar respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [searchBar setBackgroundColor:[UIColor clearColor]];
        }
        else
        {
            //iOS7.0
            [searchBar setBarTintColor:[UIColor clearColor]];
            [searchBar setBackgroundColor:[UIColor clearColor]];
        }
    }
    else
    {
        //iOS7.0以下
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [searchBar setBackgroundColor:[UIColor clearColor]];
    }
	[searchBar release];
	[self.view addSubview:versionLabel];
}

//ios7.1搜索条背景适配 add by zyy 2014-04-21
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
//ios7状态栏适配
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    CGRect frame = self.view.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        frame.origin.x = 0;
    }
    self.view.frame = frame;
}
*/

- (void)reloadMainView{
    
    self.view.frame = CGRectMake(0, 0, 768, 1024);
    [self.view reloadInputViews];
    
    //添加logoiamge
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
	
    //添加logotitle控件
	UIImageView *logoTitle = [[UIImageView alloc]initWithFrame:KLOGORECT];
	NSString *logo_documentPath = [Utilities documentsPath:kLogoTitleImageName];
	if ([Utilities isFileExist:logo_documentPath])
	{
		logoTitle.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:logo_documentPath]];
	}
	else 
	{
		logoTitle.image = [UIImage imageNamed:kLogoTitleImageName];
	}
	[logoImage addSubview:logoTitle];
	[logoTitle release];
	
    //添加版本控件
	versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(820, 700, 200, 30)];
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.textColor = [UIColor blackColor];
	
    //通过sql语句获取版本数组
	NSString *sqlString = @"select * from databaseVersion where id=1;";
	NSArray *versionArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
	versionLabel.text = [NSString stringWithFormat:@"当前数据库版本为:%@",[[versionArray objectAtIndex:0] objectForKey:@"version"]];
	[versionArray release];
	
	//添加搜索控件
	UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(862,2, 100,60)];
    [searchButton setImage:[UIImage imageNamed:@"setMark.png"]
                  forState:UIControlStateNormal];
	[searchButton addTarget:self 
                     action:@selector(setItems)
           forControlEvents:UIControlEventTouchUpInside];
	
	[logoImage addSubview:searchButton];
	[searchButton release];
	
    //添加背景图片
	UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kFirstPageImageName]];
	backgroundImage.frame = CGRectMake(0, 0, 1024, 768);
	[self.view addSubview:backgroundImage];
	[backgroundImage release];
	NSMutableArray *textArray = [NSMutableArray array];
	NSMutableArray *titleArray = [NSMutableArray array];
	NSMutableArray *itemArray = [[NSMutableArray alloc]init];
	NSMutableArray *pictureArray = [[NSMutableArray alloc]init];
    
	iNC = [[IconNavigationController alloc]init];
    //从数据库中搜索符合条件的添加到数组中
	NSMutableArray *newArray = [NSMutableArray arrayWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:@"select * from IPAD_Analysis_Group_File where ParentID = 0 order by Porder asc;"]];
	NSMutableArray *reArray = [[NSMutableArray alloc] init];
	for (int i=0; i<[newArray count]; i++)
	{
		NSString *nameValue = [[newArray objectAtIndex:i] objectForKey:@"Title"];
		NSMutableArray *tempArray1 =[[NSMutableArray alloc]initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithTableName:@"MAIN_TABLE" andCondition:[NSString stringWithFormat:@"NAME = '%@'",nameValue]]];
	    for (int i=0; i<[tempArray1 count]; i++)
		{
			[reArray addObject:[tempArray1 objectAtIndex:i]];
		}
		[tempArray1 release];
	}
    
	NSArray *tempArray = [NSArray arrayWithArray: [[SQLiteOptions sharedSQLiteOptions] queryWithTableName:@"MAIN_TABLE" andCondition:nil]];
	NSMutableArray *endArray = [[NSMutableArray alloc] init];
	NSString *unitSql = @"select * from IPAD_JB02";
	NSArray *unitArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:unitSql];
    if ([tempArray count]!=0)
    {
        if ([unitArray count]==0)
        {
            
        }
        else 
        {
            [endArray addObject:[tempArray objectAtIndex:0]];
            [endArray addObject:[tempArray objectAtIndex:1]];
            [endArray addObject:[tempArray objectAtIndex:2]];	
        }
        [endArray addObjectsFromArray:reArray];
        [endArray addObject:[tempArray objectAtIndex:24]];
        [endArray addObject:[tempArray objectAtIndex:25]];
        [endArray addObject:[tempArray objectAtIndex:26]];
        [reArray release];
    }
	for (NSDictionary *dictionary in endArray) 
	{
		
		if ([[[dictionary allKeys]objectAtIndex:0] hasPrefix:@"NAME"]) {
			[textArray addObject:[[dictionary allValues]objectAtIndex:0]];
		}
		else if([[[dictionary allKeys]objectAtIndex:0] hasPrefix:@"LINK"]) {
			[titleArray addObject:[[dictionary allValues]objectAtIndex:0]];
		}
		else if([[[dictionary allKeys]objectAtIndex:0]hasPrefix:@"IMAGE"])
		{
		    [pictureArray addObject:[[dictionary allValues]objectAtIndex:0]];
		}
	}
	[endArray release];
	for (int i = 0; i< [titleArray count]; i++) 
	{
		NSArray *aray = [[NSArray alloc] initWithObjects:
						 [pictureArray objectAtIndex:i],
						 [textArray objectAtIndex:i],
						 [titleArray objectAtIndex:i],
						 nil];
		[itemArray addObject:aray];
		[aray release];
	}
	[pictureArray release];
	iNC.itemArray = itemArray;
	[self.view addSubview:iNC.view];
	[self.view addSubview:logoImage];
	[logoImage release];
	[itemArray release];

	[self.view addSubview:versionLabel];
    
	UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(230, 70, 572, 100)];//250  572
	searchBar.delegate=self;
	searchBar.showsCancelButton=NO;
	searchBar.barStyle=UIStatusBarStyleDefault;
	searchBar.placeholder= @"请填写您要搜索的内容";
	searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
	[self.view addSubview:searchBar];
	for (UIView *subview in searchBar.subviews) { 
		if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {  
			[subview removeFromSuperview];  
			break;  
		}  
	}
	[searchBar release];
	[self.view addSubview:versionLabel];

}

//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //搜索文件
	NSDateFormatter *datef = [[NSDateFormatter alloc] init];
	[datef setDateFormat:@"ss"];
	[searchBar resignFirstResponder];
	NSString *findString =searchBar.text;
	[self search:findString];
	searchBar.text = nil;
}
//重置进度条
-(void)reset
{
	progressView_.progress = 0.0;
}

-(void)search:(NSString *)_string
{
	if (searchController) {
		[searchController release];
	}
    //搜索控制器初始化和添加
    searchController = [[SearchController alloc]init];
	searchController.view.frame = CGRectMake(0, 748, 1024, 748);
	[self.view addSubview:searchController.view];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:searchController];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDidStopSelector:@selector(showAlert)];
    //
	searchController.searchArea.text = _string;
	searchController.isFirstPage = YES;
	[searchController searchWithKeyword];
	searchController.view.frame = CGRectMake(0, 0,1024, 748);
	[UIView commitAnimations];
	
}
-(void)setItems
{
    //设置控制器初始化
	setController = [[SetController alloc] initWithStyle:UITableViewStylePlain];
    setController.delegate = self;
	pop = [[UIPopoverController alloc] initWithContentViewController:setController];
	[pop setDelegate:self]; 
	[pop setPopoverContentSize:CGSizeMake(200,90)]; 
	setController.contentSizeForViewInPopover=setController.view.bounds.size; 
	[pop presentPopoverFromRect:CGRectMake(892, 0, 50, 60) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[setController release];
}

//修改密码视图
-(void)animation
{	//初始化界面
	iNC.view.userInteractionEnabled = NO;
	self.view.userInteractionEnabled = YES;
		if (background)
		{
			for(UIView * v in [background subviews])
			{
				[v removeFromSuperview];
			}
			[background removeFromSuperview];
		}
		[pop dismissPopoverAnimated:YES];
		background = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-500)/2, 100,500,400)];
		background.image = [UIImage imageNamed:@"reset.png"];
		background.userInteractionEnabled = YES;
        //显示标题框的控件
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 30, 200, 50)];
		titleLabel.text = @"修改密码";
		titleLabel.font = [UIFont fontWithName:@"helvetica" size:30];
		titleLabel.backgroundColor = [UIColor clearColor];
		UILabel *old = [[UILabel alloc] initWithFrame:CGRectMake(80, 130, 120, 30)];
		old.text = @"请输入旧密码：";
		old.backgroundColor = [UIColor clearColor];
		UILabel *new = [[UILabel alloc] initWithFrame:CGRectMake(80, 180, 120, 30)];
		new.text = @"请输入新密码：";
		new.backgroundColor = [UIColor clearColor];
		UILabel *newSet = [[UILabel alloc] initWithFrame:CGRectMake(80, 230, 120, 30)];
		newSet.text = @"请确认新密码：";
		newSet.backgroundColor = [UIColor clearColor];
	//判断密码输入控件的初始化和添加	
    if (nil == oldPassword) 
		{
			oldPassword = [[UITextField alloc] initWithFrame:CGRectMake(210, 130, 200, 50)];
			oldPassword.returnKeyType = UIReturnKeyDone;
			oldPassword.font = [UIFont systemFontOfSize:20];
			oldPassword.backgroundColor = [UIColor clearColor];
			oldPassword.secureTextEntry = YES;
			oldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
			oldPassword.delegate = self;
			oldPassword.tag = OLD_INPUTTEXT_TAG; 			
		}
	
		if (nil == newPassword) 
		{
			newPassword = [[UITextField alloc] initWithFrame:CGRectMake(210, 180, 200, 50)];
			newPassword.returnKeyType = UIReturnKeyDone;
			newPassword.font = [UIFont systemFontOfSize:20];
			newPassword.backgroundColor = [UIColor clearColor];
			newPassword.secureTextEntry = YES;
			newPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
			newPassword.delegate = self;	
			newPassword.tag = NEW_INPUTTEXT_TAG;
		}
		if (nil == newSetPassword)
		{
			newSetPassword = [[UITextField alloc] initWithFrame:CGRectMake(210, 230, 200, 50)];
			newSetPassword.returnKeyType = UIReturnKeyDone;
			newSetPassword.font = [UIFont systemFontOfSize:20];
			newSetPassword.backgroundColor = [UIColor clearColor];
			newSetPassword.secureTextEntry = YES;
			newSetPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
			newSetPassword.delegate = self;
			newSetPassword.tag = NEW_SET_INPUTTEXT_TAG;
			
		}
		if (nil == sureButton)
		{
			sureButton = [[UIButton alloc]initWithFrame:CGRectMake(395,25, 60,60)];
			[sureButton setImage:[UIImage imageNamed:@"finish.png"]
						forState:UIControlStateNormal];
			
			
		}
		if (nil == cancelButton) 
		{
			cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(50,25, 60,60)];
			[cancelButton setImage:[UIImage imageNamed:@"cancel.png"]
						  forState:UIControlStateNormal];
			[cancelButton addTarget:self 
							 action:@selector(cancelClicked)
				   forControlEvents:UIControlEventTouchUpInside];
			
			
		}
		oldPassword.text = nil;  
		newPassword.text = nil;  
		newSetPassword.text = nil;  
		sureButton.selected = NO;   
		cancelButton.selected = NO;  
        //添加控件
		[background addSubview:sureButton];
	    [background addSubview:cancelButton];
		[background addSubview:titleLabel];
		[background addSubview:old];
		[background addSubview:new];
		[background addSubview:newSet];
		[background addSubview:oldPassword];
		[background addSubview:newPassword];
		[background addSubview:newSetPassword];
		
		iNC.view.alpha = 0.5;
		//动画
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.8];
		[animation setSubtype: kCATransitionFromBottom];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
		[self.view addSubview:background];
		[self.view.layer addAnimation:animation forKey:nil];
	[titleLabel release];
	[old release];
	[new release];
	[newSet release];
	
}

//数据安全设置视图
-(void)databaseSafe
{	//初始化界面
	iNC.view.userInteractionEnabled = NO;
	self.view.userInteractionEnabled = YES;
    if (background)
    {
        for(UIView * v in [background subviews])
        {
            [v removeFromSuperview];
        }
        [background removeFromSuperview];
    }
    [pop dismissPopoverAnimated:YES];
    background = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-500)/2, 100,500,400)];
    background.image = [UIImage imageNamed:@"reset1.png"];
    background.userInteractionEnabled = YES;
    //显示标题框的控件
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 30, 200, 50)];
    titleLabel.text = @"数据安全";
    titleLabel.font = [UIFont fontWithName:@"helvetica" size:30];
    titleLabel.backgroundColor = [UIColor clearColor];
    UILabel *yesOrNo = [[UILabel alloc] initWithFrame:CGRectMake(80, 160, 120, 30)];
    yesOrNo.text = @"联网删除数据：";
    yesOrNo.backgroundColor = [UIColor clearColor];
    UILabel *setTime = [[UILabel alloc] initWithFrame:CGRectMake(80, 220, 120, 30)];
    setTime.text = @"设置删除时间：";
    setTime.backgroundColor = [UIColor clearColor];
//    UILabel *newSet = [[UILabel alloc] initWithFrame:CGRectMake(80, 230, 120, 30)];
//    newSet.text = @"空";
//    newSet.backgroundColor = [UIColor clearColor];
    
    if (nil == delOrSave) {
        delOrSave = [[UISwitch alloc] initWithFrame:CGRectMake(310, 160, 100, 50)];
        NSLog(@"isCanDeleteData ==== %@",isCanDeleteData);
        if ([isCanDeleteData boolValue]) {
            delOrSave.on = YES;
        }
        else {
            delOrSave.on = NO;
        }

    }
    
    if (nil == oldPassword) 
    {
        deleteTimeText = [[UITextField alloc] initWithFrame:CGRectMake(340, 225, 70, 30)];
//        deleteTimeText.returnKeyType = UIReturnKeyDone;
        deleteTimeText.font = [UIFont systemFontOfSize:20];
        deleteTimeText.backgroundColor = [UIColor clearColor];
//        deleteTimeText.secureTextEntry = YES;
        deleteTimeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        deleteTimeText.delegate = self;
        deleteTimeText.text = [NSString stringWithFormat:@"%@",deleteDataTime];
    }
	
    if (nil == deleteTimeBt) 
    {
        deleteTimeBt = [[UIButton alloc]initWithFrame:CGRectMake(250,212, 160,50)];
//        [deleteTimeBt setImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        [deleteTimeBt setBackgroundColor:[UIColor clearColor]];
        [deleteTimeBt addTarget:self action:@selector(changeTime) forControlEvents:UIControlEventTouchUpInside];

    }

    
	//判断密码输入控件的初始化和添加	
    if (nil == finishDbSafe)
    {
        finishDbSafe = [[UIButton alloc]initWithFrame:CGRectMake(395,25, 60,60)];
        [finishDbSafe setImage:[UIImage imageNamed:@"finish.png"]
                    forState:UIControlStateNormal];
        [finishDbSafe addTarget:self action:@selector(finishDatabase) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (nil == cancelButton) 
    {
        cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(50,25, 60,60)];
        [cancelButton setImage:[UIImage imageNamed:@"cancel.png"]
                      forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
//    deleteTimeBt.text = nil;  
    sureButton.selected = NO;   
    cancelButton.selected = NO;  
    //添加控件
    [background addSubview:finishDbSafe];
    [background addSubview:cancelButton];
    [background addSubview:titleLabel];
    [background addSubview:yesOrNo];
    [background addSubview:setTime];
//    [background addSubview:newSet];
    [background addSubview:delOrSave];
    [background addSubview:deleteTimeText];
    [background addSubview:deleteTimeBt];
    
    iNC.view.alpha = 0.5;
    //动画
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.view addSubview:background];
    [self.view.layer addAnimation:animation forKey:nil];
	[titleLabel release];
	[yesOrNo release];
	[setTime release];
	
}

-(void)cancelClicked
{
    //取消按钮点击出发时间
	cancelButton.selected = YES;
   for(UIView * v in [background subviews])
   {
	   [v removeFromSuperview];
   }
    //动画
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.8];
	[animation setSubtype: kCATransitionFromBottom];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	[background removeFromSuperview];
	[self.view.layer addAnimation:animation forKey:nil];
	iNC.view.alpha = 1;
	iNC.view.userInteractionEnabled = YES;
}

//数据安全设置完成__wangbo
- (void)finishDatabase{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:delOrSave.on] forKey:@"isDeleteData"];

    
    [[NSUserDefaults standardUserDefaults] setObject:deleteTimeText.text forKey:@"deleteTime"];
    
    [NSThread sleepForTimeInterval:0.01];
    
    for(UIView * v in [background subviews])
    {
        [v removeFromSuperview];
    }
    //动画
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.8];
	[animation setSubtype: kCATransitionFromBottom];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	[background removeFromSuperview];
	[self.view.layer addAnimation:animation forKey:nil];
	iNC.view.alpha = 1;
	iNC.view.userInteractionEnabled = YES;

    if (delOrSave.on) {
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(postDeleteNot) userInfo:nil repeats:NO];
    }
}

- (void)postDeleteNot{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginThreadDelete" object:nil]; 
}

//选择删除时间__wangbo
- (void)changeTime{
    popoChange = [[PopoChangeViewController alloc] init];
    popoChange.delegate = self;
    popoChange.changeArray = [[NSMutableArray alloc] init];
    [popoChange.changeArray setArray:[NSArray arrayWithObjects:@"15秒",@"30秒",@"60秒", nil]];
    pop = [[UIPopoverController alloc] initWithContentViewController:popoChange];
    [pop setDelegate:self];
    [pop setPopoverContentSize:CGSizeMake(180, 110)];
    popoChange.contentSizeForViewInPopover = popoChange.view.bounds.size;
    [pop presentPopoverFromRect:CGRectMake(560, 240, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

//PopoChangeViewController代理，row：选择哪一行
- (void)changeTableArray:(int)row{
    [pop dismissPopoverAnimated:YES];
    if (0 == row) {
        deleteTimeText.text = @"15秒";
    }
    if (1 == row) {
        deleteTimeText.text = @"30秒";
    }
    if (2 == row) {
        deleteTimeText.text = @"60秒";
    }
}

-(void)show:(NSString *)formatstring{
    //警告框
	UIAlertView *Point = [[[UIAlertView alloc] initWithTitle:nil 
													 message:formatstring 
													delegate:nil 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil]autorelease];
	[Point show];
}

//UITextField输入长度限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 20) 
    {
		[self show:@"密码长度有误,密码长度不应大于20位"];
		
        return NO;
    }
    return YES;
	
}
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	
}
//文本框结束编辑执行的代理
- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	NSString *strPath = [Utilities documentsPath:@"password.plist"];
	array = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
	//密码的是否符合要求
	if ([[oldPassword.text md5HashDigest] isEqualToString: [array objectAtIndex:0]]) 
	{
		[sureButton  removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
		[sureButton addTarget:self 
					   action:@selector(finishClicked)
			 forControlEvents:UIControlEventTouchUpInside];
	}
	else 
	{
		[sureButton  removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
		[sureButton addTarget:self 
					   action:@selector(finishClicked2)
			 forControlEvents:UIControlEventTouchUpInside];		
		if (OLD_INPUTTEXT_TAG == textField.tag && !cancelButton.selected
			&& !sureButton.selected) 
		{
			
			[self show:@"请正确的输入旧密码！"];
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField   
{	
	//切换输入框
	if (NEW_SET_INPUTTEXT_TAG == textField.tag)
	{
		[sureButton sendActionsForControlEvents:UIControlEventTouchUpInside];
		
		
	}
	else if(OLD_INPUTTEXT_TAG == textField.tag)
	{
        //弹出键盘
		[newPassword becomeFirstResponder];
	
	}
	else if(NEW_INPUTTEXT_TAG == textField.tag)
	{	
        //弹出键盘
		[newSetPassword becomeFirstResponder];	
	
	
	}


	return YES;
	
	
}

- (void)finishClicked
{
    //判断密码是否正确
	if(newPassword.text==nil)
	{
		[self show:@"请输入新密码！"];
	}
	else if(![newSetPassword.text isEqualToString:newPassword.text])
	{
	    [self show:@"请输入正确的确认密码"];
	}
	else if(newSetPassword.text == nil)
	{
		[self show: @"请输入确认密码！"];	
	}
    else
	{
		[array removeAllObjects];
		[array addObject:[newPassword.text md5HashDigest]];
		[array writeToFile:[Utilities documentsPath:@"password.plist"] atomically:YES];
		[self show:@"密码修改成功！"];
		for(UIView * v in [background subviews])
		{
			[v removeFromSuperview];
		}
		[background removeFromSuperview];
		iNC.view.alpha = 1;
	    iNC.view.userInteractionEnabled = YES;
	}
	sureButton.selected = YES;
	
}
- (void)finishClicked2
{
    //密码输入失败，显示提示，并将按钮重置为可用
	[self show:@"请正确的输入旧密码！"];
	sureButton.selected = YES;
	
}
-(void)update
{
    //读取文件
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	
	NSError *error;
	
	NSArray *as = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:documentDir
																				  error:&error]];
    //根据sql语句获取内容数组
	NSString *sqlStringPath=@"";
	NSString *version = @"";
	NSArray *versions = [NSArray arrayWithArray:[[SQLiteOptions sharedSQLiteOptions] 
												 queryWithSQL:@"select * from databaseVersion where id = 1"]];
	for(NSDictionary *d in versions)
	{
		version = [d objectForKey:@"version"];//当前数据库版本
	}
    //解析
	for(int i=0;i<[as count];i++)
	{

		NSString *sa = [[NSString alloc] initWithString:UPDATEFILENAME];
		NSRange range = [[as objectAtIndex:i] rangeOfString:sa];
        if(range.length != 0)
		{
			sqlStringPath=[as objectAtIndex:i];
		}
		[sa release];
	}
    //根据结果显示不同内容
	NSString *path = [documentDir stringByAppendingPathComponent:sqlStringPath];
	if(![path isEqualToString:documentDir])
	{
		NSArray *a = [sqlStringPath componentsSeparatedByString:UPDATEFILENAME];
		NSString *s = [[[a objectAtIndex:1] componentsSeparatedByString:@".sql"] objectAtIndex:0];//document下面的更新文件
		NSString *title = @"您有新的数据库版本需要更新";
		NSString *message1 = [NSString stringWithFormat:@"您原数据库的版本为%@新版本的数据库为:%@",version,s];
		NSString *message2 = [NSString stringWithFormat:
							 @"您当前数据库版本为%@最新版本的数据库为:%@,您需要下载%@版与%@版之间的所有更新包，才可更新！"
							 ,version,s,version,s];
		NSString *message3 = [NSString stringWithFormat:
							  @"您当前数据库版本为%@高于最新版本的数据库%@，请查看是否有更高版本的数据库需要更新",version,s];
		NSString *message4 = [NSString stringWithFormat:@"您数据库版本与当前数据库版本相同，请查看比%@更高版本更新当前数据库",version];
	    NSString *resultValue = [NSString stringWithFormat:@"%.1f",([s floatValue]-[version floatValue])];
        //判断不同的状态并显示不同的提示
		if([resultValue isEqualToString:@"0.1"])
		{
			[self showAlert:title andMessage:message1 cancel:@"否" other:@"是"];
		}
		else if([resultValue floatValue]<0)
		{
			[self showAlert:nil andMessage:message3 cancel:@"OK" other:nil];
		}
		else if([resultValue isEqualToString:@"0.0"])
		{
			[self showAlert:nil andMessage:message4 cancel:@"OK" other:nil];
		}
		else if([resultValue floatValue]>=0.2)
		{
			[self showAlert:title andMessage:message2 cancel:@"否" other:@"是"];
		}
   }
	else
	{
        //判断是否存在数据库
	   if ([Utilities isFileExist:[Utilities documentsPath:@"delete.sql"]]==YES)
	   {
		   [self showAlert:@"清除数据" 
				andMessage:nil
					cancel:@"否"
					 other:@"是"];
	   }	
	}

	[as release];
}
-(void)showAlert:(NSString *)title andMessage:(NSString *)message cancel:(NSString *)cancelString other:(NSString *)otherString
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
												   message:message
												  delegate:self
										 cancelButtonTitle:cancelString
										 otherButtonTitles:otherString,nil];
	[alert show];
	[alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
	{
        //关闭自动锁屏 2012－8－16 王渤
        [UIApplication sharedApplication].idleTimerDisabled=YES;

	    UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:nil
												message:@"正在更新数据库⋯⋯"
											   delegate:nil
									  cancelButtonTitle:nil
									  otherButtonTitles:nil]
					 autorelease];
		[self.view addSubview:alertView];
		progressView_ = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		progressView_.frame = CGRectMake(30, 60, 225, 30);
		[alertView addSubview:progressView_];
		[alertView show];
		[self performSelector:@selector(start) withObject:nil afterDelay:0.5];	
	}
}
-(void)start
{
    //获取test。db的路径
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *libraryDir = [libraryPaths objectAtIndex:0];
	databasePath = [libraryDir stringByAppendingPathComponent:@"WebKit/Databases/file__0/test.db"]; 
    //成功标示
	BOOL success;
    //从目标路径中读取内容到数组中
	NSMutableArray *updateArray = [[NSMutableArray alloc]init];
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	NSArray *as = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:documentDir
																			  error:nil]];
	NSString *deletePath;
    success = [fileManager fileExistsAtPath:databasePath]; 
	if(success)
	{
        //填充sqlPath
		for(int i=0;i<[as count];i++)
		{
			NSString *sa = [UPDATEFILENAME copy];
			NSRange range = [[as objectAtIndex:i] rangeOfString:sa];
			NSRange range1 = [[as objectAtIndex:i]rangeOfString:@"delete"];
			if(range.length != 0)
			{
				sqlPath=[as objectAtIndex:i];
				[updateArray addObject:sqlPath];
			}
			if (range1.length!=0)
			{
				deletePath = [as objectAtIndex:i];
			}
			[sa release];
		}
        //处理内容
		for (int i=0; i<[updateArray count]; i++)
		{
			for (int j=i+1; j<[updateArray count]; j++) 
			{
				NSString *string1 = [updateArray objectAtIndex:i];
				NSString *string2 = [updateArray objectAtIndex:j];
				if ([string1 compare:string2] ==  NSOrderedDescending) 
				{
					[updateArray replaceObjectAtIndex:i withObject:string2];
					[updateArray replaceObjectAtIndex:j withObject:string1];
				}
			}
		}
		//[as release];
	}
	else 
	{
		NSLog(@"no");
	}
	[as release];
	if ([updateArray count]==0)
	{
		//删除旧数据
		[de deleteOldDate:databasePath sqlFilePath:deletePath];
	}
	else
	{
		[up updateNewData:databasePath updateStringPath:updateArray];
        NSString *sqlString = @"select * from databaseVersion where id=1;";
        NSArray *versionArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
        NSString *database = [NSString stringWithFormat:[[versionArray objectAtIndex:0] objectForKey:@"version"]];
        [[NSUserDefaults standardUserDefaults] setObject:database forKey:@"sqldatabase"];
	}
    [updateArray release];
	
}
//进度条改变
- (void)updateProgressView:(NSNotification *)progress
{
	progressValue = [[progress object] floatValue];
	[NSThread detachNewThreadSelector:@selector(updateProgress) 
							 toTarget:self 
						   withObject:nil];
}
//改变进度
- (void)updateProgress{
    progressView_.progress = progressView_.progress +progressValue;
}
//点击alert按钮
- (void)dismissProgressAlert:(NSNotification *)notification
{
    if (progressView_ == nil) {
        return;
    }
    if ([progressView_.superview isKindOfClass:[UIAlertView class]]) {
        UIAlertView* alertView = (UIAlertView*)progressView_.superview;
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    [progressView_ release];
    progressView_ = nil;
	if ([[notification name] isEqualToString:@"finish"])
	{
		NSString *sqlString = @"select * from databaseVersion where id=1";
		NSArray *versionArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
		versionLabel.text = [NSString stringWithFormat:@"当前数据库版本为:%@",[[versionArray objectAtIndex:0] objectForKey:@"version"]];
		[versionArray release];
		
	}
}
-(void)setIsDianJi
{
	isDianJi = NO;
}
//推进
- (void) push:(NSNotification*)notification 
{
	if (!isDianJi) 
	{
        //申请控制器
		SecondMainController *secondNavigation = [[SecondMainController alloc] init];
		secondNavigation.initType = [[notification object] intValue];
        //获取标示名称
		NSString *sql = @"select Title from IPAD_Analysis_Group_File where ParentID = 0 order by Porder asc;";
		NSMutableArray *ret = [NSMutableArray array];
		[[SQLiteOptions sharedSQLiteOptions] openSQLiteDatabase];
		sqlite3_stmt *stmt;
		if (sqlite3_prepare_v2([SQLiteOptions getDatabase],  [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) 
		{
			while (sqlite3_step(stmt) == SQLITE_ROW)
			{
				const unsigned char *colName = sqlite3_column_text(stmt, 0);
				NSString *colString = [[NSString alloc] initWithUTF8String:(const char *)colName];
				[ret addObject:colString];
				[colString release];
			}
				
			sqlite3_finalize(stmt);
		}
			
		[[SQLiteOptions sharedSQLiteOptions] closeSQLiteDatabase];
			
			
		secondNavigation.titleArray = ret;
		[self.navigationController pushViewController:secondNavigation
												 animated:YES];
		[secondNavigation release];
		isDianJi = YES;
	}
	
}
//推入其他资料的控制器
- (void) push1 
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [documentPaths objectAtIndex:0];
	NSString *fileDir = [docDir stringByAppendingPathComponent:@"file/"];
	
	NavController *navCtrl = [[NavController alloc] initWithWorkingDir:fileDir isRoot:NO];
	[navCtrl setWorkingDirectory:fileDir];
	[self.navigationController pushViewController:navCtrl animated:YES];
	[navCtrl release];
}

//setController代理,弹出视图
-(void)popoForTouch:(int)row{
    if (0 == row) {
        [self animation];
    }
    if (1 == row) {
        [self databaseSafe];
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

//add by zyy 2013-06-05为了兼容ios6的sdk，启动横屏模式增加
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
//add by zyy 2013-06-05为了兼容ios6的sdk，支持屏幕旋转
-(BOOL)shouldAutorotate{
    return TRUE;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//对象释放
- (void)dealloc {
	//[searchController release];
	[iNC release];
	[sureButton release];
	[pop release];
	[oldPassword release];
	[newPassword release];
	[newSetPassword release];
	[background release];
	[array release];
	[cancelButton release];
	[versionLabel release];
    [delOrSave release];
	//[de release];
	[up release];
    [super dealloc];
}

@end
