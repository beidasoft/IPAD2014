//
//  CompanyInfo.m
//  IPAD
//
//  Created by  careers on 12-2-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanyInfo.h"
#import "ViewAnimations.h"
#import "PersonsInfo.h"
#import "ContentViewController.h"
#import "FormView.h"

@implementation CompanyInfo
@synthesize currentTabView,condition,tit,delegate,personsArray,year,tableName;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	background.image = [UIImage imageNamed:@"mingcebackground.png"];
	background.userInteractionEnabled = YES;
	
	NSString *countSQL = [NSString stringWithFormat:@"select count(*) from IPAD_A01_Function where A0201B = '%@'",self.condition];
	[[SQLiteOptions sharedSQLiteOptions] openSQLiteDatabase];
	sqlite3_stmt *stmt;
	const char *sql = [countSQL cStringUsingEncoding:4];
	if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL) == SQLITE_OK) 
	{
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			const unsigned char *colName = sqlite3_column_text(stmt,0);
			if (colName != nil)
			{
				NSString *countString = [NSString stringWithUTF8String:(const char *)colName];
				personNumbers = [countString intValue];
			}
		}
		sqlite3_finalize(stmt);
	}
	NSString *sqls;
	if (personNumbers>60)
	{
		sqls = [NSString stringWithFormat:@"select A0101,A0102,a02_a0215_all_MingCe,GetPersonBaseInf,A00 from IPAD_A01_Function where A0201B='%@' order by A02_Order",self.condition];
		resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSearchSQL:sqls andNumber:0 andLastNumber:500]];
	}else
	{
		sqls = [NSString stringWithFormat:@"select * from IPAD_A01_Function where A0201B='%@' order by A02_Order",self.condition];
		resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sqls]];
	}
	NSMutableArray *personInfos = [[NSMutableArray alloc]init];
    for(int i=0;i<[resultArray count];i++)
	{ 
		NSMutableArray *infoArr = [NSMutableArray array];
		NSString *nameContent = [[resultArray objectAtIndex:i]objectForKey:@"A0101"];
		[infoArr addObject:nameContent];
		NSString *pinyinContent = [[resultArray objectAtIndex:i] objectForKey:@"A0102"];
		[infoArr addObject:pinyinContent];
		NSString *detailinfoContent = [[resultArray objectAtIndex:i] objectForKey:@"a02_a0215_all_MingCe"];
		[infoArr addObject:detailinfoContent];
		NSString *detailInfos = [[resultArray objectAtIndex:i] objectForKey:@"GetPersonBaseInf"];
		[infoArr addObject:detailInfos];
		NSString *image;
		if (personNumbers<60)
		{
			image = [NSString stringWithFormat:@"data:image/png;base64,%@",[[resultArray objectAtIndex:i]
																			objectForKey:@"FILE"]];
		}
		else 
		{
			image = @"data:image/png;base64,";
		}
		[infoArr addObject:image];
		NSString *personId = [[resultArray objectAtIndex:i] objectForKey:@"A00"];
			[infoArr addObject:personId];
			[personInfos addObject:infoArr];		
	}
	personsNew = [[NSMutableArray alloc] initWithCapacity:[personInfos count]];
	for (int i=0;i<[personInfos count];i++)
	{
		PersonsInfo *personWrapper =  [[PersonsInfo alloc] initWithData:[[personInfos objectAtIndex:i] objectAtIndex:0] 
																 PinYIn:[[personInfos objectAtIndex:i] objectAtIndex:1] 
															 detailInfo:[[personInfos objectAtIndex:i] objectAtIndex:2] 
															detailInfos:[[personInfos objectAtIndex:i] objectAtIndex:3]
																  image:[[personInfos objectAtIndex:i] objectAtIndex:4]
																	 ID:[[personInfos objectAtIndex:i] objectAtIndex:5]];
		[personsNew addObject:personWrapper];
		[personWrapper release];
	}
	[self setPersonsArray:personsNew];
	UIImageView *btBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 100, 768)];
	btBg.image = [UIImage imageNamed:@"btBg.png"];
	btBg.userInteractionEnabled = YES;
	btBg.tag = 100;
	[self.view addSubview:btBg];
    [btBg release];
	
	UIImageView *contentBg = [[UIImageView alloc]initWithFrame:KCONTENTINFRAME];
	contentBg.image = [UIImage imageNamed:@"contentBg.png"];
	contentBg.tag = 0;
	contentBg.userInteractionEnabled = YES;
	[self.view addSubview:contentBg];
	[contentBg release];
	
	UIImageView *redFrame = [[UIImageView alloc]initWithFrame:KREDFRAME];
	redFrame.image = [UIImage imageNamed:@"mingceredframe.png"];
	[contentBg addSubview:redFrame];
	[redFrame release];
	
	CGRect labelFrame = CGRectMake(10, 15, 895, 50);
	UILabel *titleLabel = [[UILabel alloc]initWithFrame:labelFrame];
	titleLabel.text = tit;
	if ([tit length]*30<895)
	{
		titleLabel.textAlignment = UITextAlignmentCenter;
	}else {
		titleLabel.textAlignment = UITextAlignmentLeft;
	}
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont systemFontOfSize:30];
	[contentBg addSubview:titleLabel];
	[titleLabel release];
	
	tabViewArr = [[NSMutableArray alloc]init];
	btArray = [[NSArray alloc]initWithObjects:@"xiaoziliaobt.png",
			   @"tongxunbt.png",
			   @"kaohebt.png",
			   @"sanbt.png",
			   @"bianzhibt.png",
			   @"fengongbt.png",
			   @"xiaoziliaobtSelected.png",
			   @"tongxunbtSelected.png",
			   @"kaohebtSelected.png",
			   @"sanbtSelected.png",
			   @"bianzhibtSelected.png",
			   @"fengongbtSelected.png",nil];
	NSArray *btFrameArr = [NSArray arrayWithObjects:NSStringFromCGRect(CGRectMake(32, 30, 59, 90)),
						   NSStringFromCGRect(CGRectMake(31, 90, 60, 125)),
						   NSStringFromCGRect(CGRectMake(33, 180, 59, 144)),
						   NSStringFromCGRect(CGRectMake(33, 268, 53, 144)),
						   NSStringFromCGRect(CGRectMake(33, 370, 58, 144)),
						   NSStringFromCGRect(CGRectMake(33, 470, 54, 140)),nil];
	
	for (int i= 5; i>=0; i--) 
	{
		UIButton *bt = [[UIButton alloc]initWithFrame:CGRectFromString([btFrameArr objectAtIndex:i])];
		bt.tag = i;
		[bt addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
		if (0 == i)
		{
			[bt setBackgroundImage:[UIImage imageNamed:[btArray objectAtIndex:i+6]]
				forState:UIControlStateNormal];
		}else 
		{
			[bt setBackgroundImage:[UIImage imageNamed:[btArray objectAtIndex:i]]
				forState:UIControlStateNormal];
		}
		[btBg addSubview:bt];
		[bt release];
	}
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(36, 698, 50,60)];
	backButton.tag = 333;
    [backButton setBackgroundImage:[UIImage imageNamed:@"thirdBack.png"]
						  forState:UIControlStateNormal];
	[backButton addTarget:self 
				   action:@selector(back)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	[backButton release];
	
	
    //小资料界面
	if ( xiaoziliaoTabView==nil ) {
		//-----Table-------
		xiaoziliaoTabView = [[UITableView alloc] initWithFrame:KCONTENTFRAME style:UITableViewStylePlain];
		xiaoziliaoTabView.delegate = self;
		xiaoziliaoTabView.dataSource = self;
		xiaoziliaoTabView.backgroundColor = [UIColor whiteColor]; // kTableBackgroundColor;
		xiaoziliaoTabView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; // [UIColor greenColor];
		xiaoziliaoTabView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
		xiaoziliaoTabView.clipsToBounds = YES;
		xiaoziliaoTabView.tag = 0;
		[contentBg addSubview:xiaoziliaoTabView];
		[tabViewArr addObject:contentBg];
		self.currentTabView = contentBg;
	}
    //通讯录界面
	if ( tongxunBacgroundView==nil ) {
		//-----Table-------
		UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(340, 15, 565, 50)];//120
		titleLabel1.text = tit;
		if ([tit length]*30<565)
		{
			titleLabel1.textAlignment = UITextAlignmentCenter;
		}
		else {
			titleLabel1.textAlignment = UITextAlignmentLeft;
		}

		titleLabel1.backgroundColor = [UIColor clearColor];
		titleLabel1.textColor = [UIColor whiteColor];
		titleLabel1.font = [UIFont systemFontOfSize:30];
		
		tongxunBacgroundView = [[UIImageView alloc]initWithFrame:KCONTENTOUTFRAME];
		tongxunBacgroundView.image = [UIImage imageNamed:@"tongContentBg.png"];
		tongxunBacgroundView.tag = 1;
		[tongxunBacgroundView addSubview:titleLabel1];
		
		[self.view addSubview:tongxunBacgroundView];
		[titleLabel1 release];
		[tabViewArr addObject:tongxunBacgroundView];
	}
	
    //班子考核信息界面
	UIImageView *contentOut = [[UIImageView alloc]initWithFrame:KCONTENTOUTFRAME];
	contentOut.image = [UIImage imageNamed:@"contentBg.png"];
	contentOut.userInteractionEnabled = YES;
	contentOut.tag = 2;
	UIImageView *redFrame1 = [[UIImageView alloc]initWithFrame:KREDFRAME];
	redFrame1.image = [UIImage imageNamed:@"mingceredframe.png"];
	[contentOut addSubview:redFrame1];
    [redFrame1 release];
	UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:labelFrame];
	titleLabel2.text = tit;
	if ([tit length]*30<895)
	{
		titleLabel2.textAlignment = UITextAlignmentCenter;
	}
	else {
		titleLabel2.textAlignment = UITextAlignmentLeft;
	}
	titleLabel2.backgroundColor = [UIColor clearColor];
	titleLabel2.textColor = [UIColor whiteColor];
	titleLabel2.font = [UIFont systemFontOfSize:30];
	[contentOut addSubview:titleLabel2];
	[titleLabel2 release];
	[self.view addSubview:contentOut];
    [contentOut release];
	
	scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 110 ,845, 595)];//595
	scroll.delegate =self;
	scroll.backgroundColor = [UIColor whiteColor];
	scroll.scrollEnabled = YES;
	fv = [[FormView alloc] initWithFrame:CGRectMake(0,0,845, 595) andPageId:0];
	prompt = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(350,200, 100, 100)];
	prompt.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
	[scroll addSubview:prompt];
	
	yButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	yButton.frame=CGRectMake(35, 80, 100, 30);
	[yButton addTarget:self
				action:@selector(changeForm)
	  forControlEvents:UIControlEventTouchUpInside];
	[yButton setTitle:@"请选择图表" forState:UIControlStateNormal];
	yc = [[Yearcontroller alloc] init];
	
	titleText = [[UILabel alloc] initWithFrame:CGRectMake(145, 80, 725, 30)];//
	titleText.textAlignment = UITextAlignmentCenter;
	titleText.font = [UIFont systemFontOfSize:25];
	[contentOut addSubview:scroll];
	[contentOut addSubview:titleText];
	[contentOut addSubview:yButton];
	[tabViewArr addObject:contentOut];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didChanged:) 
												 name:@"picture" 
											   object:nil];
	UIImageView *contentOut1 = [[UIImageView alloc]initWithFrame:KCONTENTOUTFRAME];
	contentOut1.image = [UIImage imageNamed:@"contentBg.png"];
	contentOut1.userInteractionEnabled = YES;
	contentOut1.tag = 3;
	UIImageView *redFrame2 = [[UIImageView alloc]initWithFrame:KREDFRAME];
	redFrame2.image = [UIImage imageNamed:@"mingceredframe.png"];
	[contentOut1 addSubview:redFrame2];
	[redFrame2 release];
	UILabel *titleLabel3 = [[UILabel alloc]initWithFrame:labelFrame];
	titleLabel3.text = tit;
	if ([tit length]*30<895)
	{
		titleLabel3.textAlignment = UITextAlignmentCenter;
	}
	else {
		titleLabel3.textAlignment = UITextAlignmentLeft;
	}
	titleLabel3.backgroundColor = [UIColor clearColor];
	titleLabel3.textColor = [UIColor whiteColor];
	titleLabel3.font = [UIFont systemFontOfSize:30];
	[contentOut1 addSubview:titleLabel3];
	[titleLabel3 release];
	[self.view addSubview:contentOut1];
	[contentOut1 release];
    
    //三定方案界面
	sanfangTextView = [[UITextView alloc]initWithFrame:KCONTENTFRAME];
	sanfangTextView.editable = NO;
	sanfangTextView.tag =3;
	
	[contentOut1 addSubview:sanfangTextView];
	[tabViewArr addObject:contentOut1];
	
	//编制信息界面
	if (bianzhiView == nil)
	{
		bianzhiView = [[BianZhiInfoController alloc] init];
		bianzhiView.view.frame = KCONTENTOUTFRAME;
		bianzhiView.contentOut2.tag = 4;
		bianzhiView.tit = self.tit;
		[self.view addSubview:bianzhiView.contentOut2];
		[tabViewArr addObject:bianzhiView.contentOut2];
	}
	
	UIImageView *contentOut3 = [[UIImageView alloc]initWithFrame:KCONTENTOUTFRAME];
	contentOut3.image = [UIImage imageNamed:@"contentBg.png"];
	contentOut3.userInteractionEnabled = YES;
	UIImageView *redFrame4 = [[UIImageView alloc]initWithFrame:KREDFRAME];
	redFrame4.image = [UIImage imageNamed:@"mingceredframe.png"];
	[contentOut3 addSubview:redFrame4];
	[redFrame4 release];
	contentOut3.tag = 5;
	UILabel *titleLabel5 = [[UILabel alloc]initWithFrame:labelFrame];
	titleLabel5.text = tit;
	if ([tit length]*30<895)
	{
		titleLabel5.textAlignment = UITextAlignmentCenter;
	}
	else {
		titleLabel5.textAlignment = UITextAlignmentLeft;
	}
	titleLabel5.backgroundColor = [UIColor clearColor];
	titleLabel5.textColor = [UIColor whiteColor];
	titleLabel5.font = [UIFont systemFontOfSize:30];
	[contentOut3 addSubview:titleLabel5];
	[titleLabel5 release];
	[self.view addSubview:contentOut3];
	[contentOut3 release];
    
    //班子分工界面
	fengongTextView = [[UITextView alloc]initWithFrame:KCONTENTFRAME];
	fengongTextView.editable = NO;
	fengongTextView.tag =5;
	
	[contentOut3 addSubview:fengongTextView];
	[tabViewArr addObject:contentOut3];
	finishiCount= 0;
}

#pragma mark -
#pragma mark 小资料
// 加载一屏
- (void)loadImagesForOnscreenRows
{
    if ([personsArray count] > 60)
    {
		if (oldVisiableArray !=nil)
		{
			for (NSIndexPath *indexPath in oldVisiableArray)
			{
				PersonsInfo *person = [personsArray objectAtIndex:indexPath.row];
				
				if (![person.image isEqualToString:@"data:image/png;base64,"]) // avoid the app icon download if the app already has an icon
				{
					person.image = [NSString stringWithFormat:@"%@",@"data:image/png;base64,"];
				}
			}
		}
        NSArray *visiblePaths = [xiaoziliaoTabView indexPathsForVisibleRows];
		oldVisiableArray = [visiblePaths retain];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            PersonsInfo *person = [personsArray objectAtIndex:indexPath.row];
            
            if ([person.image isEqualToString:@"data:image/png;base64,"]) // avoid the app icon download if the app already has an icon
            {
				[NSThread detachNewThreadSelector:@selector(startImageSearch:)
										 toTarget:self
									   withObject:indexPath];
            }
        }
    }
}
//查询图片
-(void)startImageSearch:(NSIndexPath *)indexPath
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    PersonsInfo *person = [personsArray objectAtIndex:indexPath.row];
	NSString *onePersonImageSQL = [NSString stringWithFormat:@"select FILE from IPAD_A01_Function where A00 = '%@'",person.personID];
	[[SQLiteOptions sharedSQLiteOptions] openSQLiteDatabase];
	sqlite3_stmt *stmt;
	const char *sql = [onePersonImageSQL cStringUsingEncoding:4];
	if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL) == SQLITE_OK) 
	{
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			const unsigned char *colName = sqlite3_column_text(stmt,0);
			if (colName != nil)
			{
				NSString *countString = [NSString stringWithUTF8String:(const char *)colName];
				person.image = [NSString stringWithFormat:@"%@%@",person.image,countString];
			}
		}
		sqlite3_finalize(stmt);
	}
	NSURL *url = [NSURL URLWithString:person.image];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *ret = [UIImage imageWithData:imageData];
	[[[xiaoziliaoTabView cellForRowAtIndexPath:indexPath] viewWithTag:55] setImage:ret]; 
	[pool release];
}

//根据字符大小和lable宽度，计算字符串有几行
-(int)autoHeight:(NSString *)string fontSize:(int)size labelWidth:(int)width
{
    int length = [string length];
	int lines;
	float counts = width/size;
	int endCount = (int)floor(counts);
	if (length<endCount)
	{
		lines = 1;
	}
	else
	{
		if (length%endCount == 0)
		{
			lines = length/endCount;
		}
		else 
		{
			lines = length/endCount +1;
		}
	}
    return lines;	
}
#pragma mark -
#pragma mark 班子考核信息 
//请选择图表的单击事件
-(void)changeForm
{
	pop = [[UIPopoverController alloc] initWithContentViewController:yc];
	[pop setDelegate:self]; 
	[pop setPopoverContentSize:CGSizeMake(200,([yc.pictureArray count]*45+[yc.yearArray count]*35+100))]; 
	yc.contentSizeForViewInPopover=yc.view.bounds.size; 
	[pop presentPopoverFromRect:CGRectMake(200,80, 50, 60) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

//选择年份，查看图表响应的事件
-(void)didChanged:(NSNotification *)nontification
{
	finishiCount = 0;
	[pop dismissPopoverAnimated:NO];
	int tag = [[nontification object] section];
	int tag1 = [[nontification object] row];
	NSString *pictureName = [NSString stringWithFormat:@"%@.html",[yc.pictureArray objectAtIndex:tag1]];
	NSString *yearName = [yc.yearArray objectAtIndex:tag];
	NSString *newPictureName = [[pictureName componentsSeparatedByString:@".html"] objectAtIndex:0];
	titleText.text = [NSString stringWithFormat:@"%@%@的%@",self.tit,self.year,newPictureName];
	self.year = [yearName copy];
	NSString *sql1 = [NSString stringWithFormat:@"select * from %@ where B00 = '%@' and Year = %@",self.tableName,[self.condition uppercaseString],self.year];
	NSArray *array1 = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql1];
	if ([array1 count]==0)
	{
		sql1 = [NSString stringWithFormat:@"select * from %@ where B00 = '%@' and Year = %@",self.tableName,[self.condition lowercaseString],self.year];
		array1 = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql1];
		if ([array1 count]!=0)
		{
			fv.condition = [self.condition copy];
			fv.yearString = [self.year copy];
			fv.pathString = [pictureName copy];
			fv.delegate = self;
			[scroll addSubview:fv];
		}
	}
	else {
		fv.condition = [self.condition copy];
		fv.yearString = [self.year copy];
		fv.pathString = [pictureName copy];
		fv.delegate = self;
		[scroll addSubview:fv];
	}
	[scroll bringSubviewToFront:prompt];
	[prompt startAnimating];
    for(UIView *v in [self.view subviews])
	{
		if (v.tag==100)
		{
			for(UIButton *bt in [v subviews])
			{
				if ([bt isKindOfClass:[UIButton class]])
				{
					bt.userInteractionEnabled = NO;
				}
			}
		}
		if (v.tag==333)
		{
			v.userInteractionEnabled = NO;
			break;
		}
	}
}
#pragma mark -
#pragma mark 返回
//返回父控制器
- (void)back
{
	UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	CGRect endFrame = CGRectMake(1024, 0, 1024, 768);
	[UIView beginAnimations:nil context:nil];
	for (UIImageView *img in [navagation.view subviews])
	{
		if (111 == img.tag ) 
		{
			img.frame = endFrame;
		}
	}
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(clearView)];
	[UIView setAnimationDuration:1.2];
	[UIView commitAnimations];
}

//返回父控制器时，移除并释放本视图的所有东西
-(void)clearView
{
	[personsArray release];
	personsArray = nil;
	[personsNew release];
	personsNew = nil;
	[self.view removeFromSuperview];
	[self release];
}
#pragma mark -
#pragma mark 按钮点击事件，及对应内容的显示
//设置为当前的tableView，并显示它的内容
-(void)setCurrentTabView:(UIView *)_currentTabView
{
	currentTabView = _currentTabView;
    if (currentTabView.tag == 0)
	{
		
	}
	if (currentTabView.tag == 1)
	{
		if ([content.view superview])
		{
			[content.view removeFromSuperview];
		}
		if ([list.view superview])
		{
			[list.view removeFromSuperview];
		}
		if (list)
		{
			[list release];
		}
		if (content)
		{
			[content release];
		}
		content = [[ContentViewController alloc] init];
		content.view.frame = CGRectMake(338, 65, 565, 665);//677
		list = [[ListViewController alloc]initWithStyle:UITableViewStylePlain];
		list.view.frame = CGRectMake(39,63,245,639);//655
		tongxunBacgroundView.userInteractionEnabled = YES;
		[content setDelegate:list];
		list.personsArray = personsNew;
		[tongxunBacgroundView addSubview:list.view];
		[tongxunBacgroundView addSubview:content.view];
	}
	else if (currentTabView.tag == 2)
	{
		if (kaoheArr == nil)
		{
			NSMutableArray *formsArray = [[NSMutableArray alloc] init];
			NSMutableArray *formNameArray = [[NSMutableArray alloc] init];
			NSMutableArray *formItemsArray = [[NSMutableArray alloc] init];
			NSArray *formArray = [[SQLiteOptions sharedSQLiteOptions] queryInTemplate];
			for(int i=0;i<[formArray count];i++)
			{
			    NSString *formName = [[formArray objectAtIndex:i] objectForKey:@"NAME"];
				NSString *htmlName = [[formArray objectAtIndex:i] objectForKey:@"FILE_NAME"];
				NSString *newHtmlName = [[htmlName componentsSeparatedByString:@".html"] objectAtIndex:0];
				NSString *sqls = [NSString stringWithFormat:@"select * from %@ where B00 = '%@'",formName,[self.condition uppercaseString]];
				[formItemsArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sqls]];
                if ([formItemsArray count]==0)
				{
					sqls = [NSString stringWithFormat:@"select * from %@ where B00 = '%@'",formName,[self.condition lowercaseString]];
					[formItemsArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sqls]];
					if ([formItemsArray count]!=0)
					{
						[formNameArray addObject:newHtmlName];
						[formsArray addObject:formItemsArray];
					}
				}
				else {
					[formNameArray addObject:newHtmlName];
					[formsArray addObject:formItemsArray];
				}
				if (0==i&&[formItemsArray count]!=0)
				{
					self.tableName = [formName copy];
				}
			}
		 if (self.tableName !=nil)
		 {
			 NSString *sqls = [NSString stringWithFormat:@"select distinct year from %@",self.tableName];
			 NSMutableArray *a = [[NSMutableArray alloc] init];
			 SQLiteOptions *sqliteO = [SQLiteOptions sharedSQLiteOptions];
			 [sqliteO openSQLiteDatabase];
			 sqlite3_stmt *stmt;
			 const char *sql = [sqls cStringUsingEncoding:4];
			 if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL) == SQLITE_OK) {
				 while (sqlite3_step(stmt) == SQLITE_ROW)
				 {
					 const unsigned char *colName = sqlite3_column_text(stmt,0);
					 if (colName == nil)
					 {
						 
					 }
					 else {
						 NSString *colString = [NSString stringWithUTF8String:(const char *)colName];
						 NSString *yearName = @"Year";
						 NSDictionary *dictionary = [NSDictionary dictionaryWithObject:colString forKey:yearName];
						 [a addObject:dictionary];
					 }
					 
					 
				 }
				 sqlite3_finalize(stmt);
			 }
			 [sqliteO closeSQLiteDatabase];
			 yc.yearArray = [[NSMutableArray alloc] init];
			 for (int i=0; i<[a count]; i++)
			 {
				 [yc.yearArray addObject:[[a objectAtIndex:i]objectForKey:@"Year"]];
			 }
			 [a release];
			 if ([yc.yearArray count]!=1)
			 {
				 for (int i=0; i<[yc.yearArray count]; i++)
				 {
					 for (int j=i+1; j<[yc.yearArray count]; j++) 
					 {
						 NSString *string1 = [yc.yearArray objectAtIndex:i];
						 NSString *string2 = [yc.yearArray objectAtIndex:j];
						 if ([string1 compare:string2] ==  NSOrderedAscending) 
						 {
							 [yc.yearArray replaceObjectAtIndex:i withObject:string2];
							 [yc.yearArray replaceObjectAtIndex:j withObject:string1];
						 }
					 }
				 }
			 }
			 
			 self.year = [yc.yearArray objectAtIndex:0];
			 yc.pictureArray = [[NSMutableArray alloc] initWithArray:formNameArray]; 
			 kaoheArr = [[NSMutableArray alloc] initWithArray:formsArray];
			 NSString *newSql = [NSString stringWithFormat:@"select * from %@ where B00 = '%@' and Year = %@",self.tableName,[self.condition uppercaseString],self.year];
			 NSMutableArray *aa =[[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:newSql]];
			 if ([aa count]!=0)
			 {
				 fv.condition = [self.condition copy];
				  fv.yearString = [self.year copy];
				 fv.pathString = [NSString stringWithFormat:@"%@.html",[yc.pictureArray objectAtIndex:0]];
				 fv.delegate = self;
				 [scroll addSubview:fv];
			 }
			 else {
				 newSql = [NSString stringWithFormat:@"select * from %@ where B00 = '%@' and Year = %@",self.tableName,[self.condition lowercaseString],self.year];
				 [aa addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:newSql]];
				 if ([aa count]!=0)
				 {
					 fv.condition = [self.condition copy];
					 fv.yearString = [self.year copy];
					 fv.pathString = [NSString stringWithFormat:@"%@.html",[yc.pictureArray objectAtIndex:0]];
					 fv.delegate = self;
					 [scroll addSubview:fv];
				 }
				 
			 }
			 NSString *pictureString = [[fv.pathString componentsSeparatedByString:@".html"] objectAtIndex:0];
			 titleText.text = [NSString stringWithFormat:@"%@%@的%@",self.tit,self.year,pictureString];
			 [scroll bringSubviewToFront:prompt];
			 [prompt startAnimating];
			 for(UIView *v in [self.view subviews])
			 {
				 if (v.tag==100)
				 {
					 for(UIButton *bt in [v subviews])
					 {
						 if ([bt isKindOfClass:[UIButton class]])
						 {
							 bt.userInteractionEnabled = NO;
						 }
					 }
				 }
				 if (v.tag==333)
				 {
					 v.userInteractionEnabled = NO;
					 break;
				 }
			 }
			 [aa release];
		 }
			[formItemsArray release];
			[formNameArray release];
			[formsArray release];
		}

	}
	else if(currentTabView.tag ==3)
	{
		if (sanArr ==nil)
		{
			NSString *sql2 = [NSString stringWithFormat:@"select * from IPAD_B02 where B00='%@'",self.condition];
			sanArr = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql2]];
			sanfangTextView.font = [UIFont systemFontOfSize:25];
			if ([sanArr count]!=0) {
                //modify by zyy 2014-06-25三定方案改为多记录显示
                NSMutableString *textString = [NSMutableString stringWithString:@""];
                for (int i=0; i<sanArr.count; i++) {
                    NSMutableString *textStringTemp = [NSMutableString stringWithFormat:@"%@,\n%@,\n%@",[[sanArr objectAtIndex:i] objectForKey:@"BJXB0264"],[[sanArr objectAtIndex:i] objectForKey:@"BJXB0263"],[[sanArr objectAtIndex:i] objectForKey:@"BJXB0258"]];
                    if(i==0){
                        textString = [NSMutableString stringWithFormat:@"%@" ,textStringTemp];
                    }
                    else{
                        textString = [NSMutableString stringWithFormat:@"%@\n\n%@" ,textString,textStringTemp];
                    }
                }
				
                
                NSRange range1 = [textString rangeOfString:@"\\\\"];                
                while (range1.location != NSNotFound) {
                    [textString replaceCharactersInRange:range1 withString:@"\\ "];
                    range1 = [textString rangeOfString:@"\\\\"];
                }

                NSRange range2 = [textString rangeOfString:@"\\n"];                
                while (range2.location != NSNotFound) {
                    [textString replaceCharactersInRange:range2 withString:@"\n"];
                    range2 = [textString rangeOfString:@"\\n"];
                }
                
                NSRange range3 = [textString rangeOfString:@"\\r"];                
                while (range3.location != NSNotFound) {
                    [textString replaceCharactersInRange:range3 withString:@"\r"];
                    range3 = [textString rangeOfString:@"\\r"];
                }
                
                NSRange range4 = [textString rangeOfString:@"\\\""];                
                while (range4.location != NSNotFound) {
                    [textString replaceCharactersInRange:range4 withString:@"\""];
                    range4 = [textString rangeOfString:@"\\\""];
                }
                
                NSRange range5 = [textString rangeOfString:@"\\\'"];                
                while (range5.location != NSNotFound) {
                    [textString replaceCharactersInRange:range5 withString:@"\'"];
                    range5 = [textString rangeOfString:@"\\\'"];
                }
                                
				sanfangTextView.text = textString;
			}
			else {
				sanfangTextView.text = @"对不起，没有相应的内容！";
			}

			
		}
	}
	else if(currentTabView.tag == 4)
	{
		if (bianzhiView.bianzhiResultArray == nil)
		{
			NSString *sql3 = [NSString stringWithFormat:@"select * from IPAD_B09 where B00 = '%@'",self.condition];
			[bianzhiView setBianzhiResultArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql3]];
		}
		
		
	}else if (currentTabView.tag == 5)
	{
		if (fengongArr == nil)
		{
			NSString *sql4 = [NSString stringWithFormat:@"select BJJB3302 from IPAD_BJJB33 where B00='%@'",self.condition];
			fengongArr = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql4]];
			fengongTextView.font = [UIFont systemFontOfSize:25];
			if ([fengongArr count]!=0)
			{
                //wangb一个单位多条记录
                NSMutableString *theText;
                for (int i = 0; i < [fengongArr count]; i++) {
                    if (i == 0) {
                        theText = [NSMutableString stringWithFormat:@"%@",[[fengongArr objectAtIndex:0]objectForKey:@"RecordID"]];
                    }
                    else {
                        theText = [NSMutableString stringWithFormat:@"%@\n%@",theText,[[fengongArr objectAtIndex:i]objectForKey:@"RecordID"]];
                    }
                }
//                NSMutableString *theText = [NSMutableString stringWithFormat:@"%@",[[fengongArr objectAtIndex:0]objectForKey:@"RecordID"]];
                NSRange range1 = [theText rangeOfString:@"\\\\"];                
                while (range1.location != NSNotFound) {
                    [theText replaceCharactersInRange:range1 withString:@"\\ "];
                    range1 = [theText rangeOfString:@"\\\\"];
                }
                
                NSRange range2 = [theText rangeOfString:@"\\n"];                
                while (range2.location != NSNotFound) {
                    [theText replaceCharactersInRange:range2 withString:@"\n"];
                    range2 = [theText rangeOfString:@"\\n"];
                }
                
                NSRange range3 = [theText rangeOfString:@"\\r"];
                while (range3.location != NSNotFound) {
                    [theText replaceCharactersInRange:range3 withString:@"\r"];
                    range3 = [theText rangeOfString:@"\\r"];
                }
                
                NSRange range4 = [theText rangeOfString:@"\\\""];                
                while (range4.location != NSNotFound) {
                    [theText replaceCharactersInRange:range4 withString:@"\""];
                    range4 = [theText rangeOfString:@"\\\""];
                }
                
                NSRange range5 = [theText rangeOfString:@"\\\'"];                
                while (range5.location != NSNotFound) {
                    [theText replaceCharactersInRange:range5 withString:@"\'"];
                    range5 = [theText rangeOfString:@"\\\'"];
                }
//
//                NSRange range = [theText rangeOfString:@"\\n"];                
//                while (range.location != NSNotFound) {
//                    [theText replaceCharactersInRange:range withString:@"\n"];
//                    range = [theText rangeOfString:@"\\n"];
//                }
                fengongTextView.text = theText;
				
			}
			else {
				fengongTextView.text = @"对不起，没有相应的内容！";
			}
		}
		
	}
}

//点击左边六个按钮时，响应的事件
- (void)clicked:(UIButton *)sender
{
	int index = [tabViewArr indexOfObject:currentTabView];
	if (index == sender.tag)
	{
		return;
	}
	for (UIButton *bt in [[self.view viewWithTag:100] subviews])
	{
		if ([bt isKindOfClass:[UIButton class]])
		{
			
			if (bt.tag == index)
			{
				[bt setBackgroundImage:[UIImage imageNamed:[btArray objectAtIndex:index]] forState:UIControlStateNormal];
			}
			if (bt.tag == sender.tag)
			{
				[bt setBackgroundImage:[UIImage imageNamed:[btArray objectAtIndex:(sender.tag + 6)]] forState:UIControlStateNormal];
				
			}
		}
	}
	lastTabView = [tabViewArr objectAtIndex:index];
    self.currentTabView = [tabViewArr objectAtIndex:sender.tag];
	[currentTabView.superview bringSubviewToFront:currentTabView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(resetCurrentView)];
	self.currentTabView.frame = KCONTENTINFRAME;
	[UIView commitAnimations];
}

//重置当前视图
-(void)resetCurrentView
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	lastTabView.frame = KCONTENTOUTFRAME;
	[UIView commitAnimations];
	if (lastTabView.tag == 2)
	{
		scroll.contentOffset = CGPointMake(0, 0);
	}
}
#pragma mark -
#pragma mark Table view data source
//UITableView代理，返回tableView的sectin个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

//UITableView代理，返回tableView中sectin的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int temp;
	if (tableView.tag == 0)
	{
		temp = [resultArray count];
	}
	else
	{
		temp = 1;
	}
    return temp;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	int personCount = [personsArray count];
    Boolean flag = false;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (tableView.tag == 0)
	{
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            NSLog(@"%d",[indexPath row]);
		}else
		{
            int num = 0;
			for (UIView *subView in [cell subviews]) 
			{
                //modify by zyy 2014-01-24 修改班子列表加载以适配ios7
                if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
                {
                    // 7.0 系统的适配处理。
                    for (UIView *subSubView in [subView subviews])
                    {
                        if ([subSubView isKindOfClass:[UILabel class]])
                        {
                            [subSubView removeFromSuperview];
                        }else {
                            [subSubView removeFromSuperview];
                        }
                    }
                }
                else{
                    //6.0及以前版本的处理
                    if ([subView isKindOfClass:[UILabel class]])
                    {
                        [subView removeFromSuperview];
                    }else {
                        [subView removeFromSuperview];
                    }
                }
                /*
                PersonsInfo *person ;
                person = [personsArray objectAtIndex:indexPath.row];
                NSString *test = [[subView class] description];
                NSLog(@"%@",test);
                
                if(num == 0){
                    UIImageView *personImg = (UIImageView *)subView;
                    NSURL *url = [NSURL URLWithString:person.image];
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *ret = [UIImage imageWithData:imageData];
                    [personImg setImage:ret];
                }
                else if(num == 1){
                    UILabel *nameLable = (UILabel *)subView;
                    nameLable.text = person.name;
                }
                else if(num == 2){
                    UILabel *infoLable = (UILabel *)subView;
                    infoLable.text = person.detailInfo;
                }
                else if(num == 3){
                    UILabel *InfosLabel = (UILabel *)subView;
                    InfosLabel.text = person.detailInfos;
                }
                */
                num++;
			}
            flag = true;
		}
		if (personCount > 0)
		{
			// Set up the cell...
			UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 205)];
			img.image = [UIImage imageNamed:@"mingceBg.png"];
			cell.backgroundView=img;
			[img release];
			cell.selectionStyle=UITableViewCellSelectionStyleGray;
			
			UIImageView *personImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, KPICTURERECT_WIDTH, KPICTURERECT_HEIGHT)];
			personImg.tag = 55;
			[cell addSubview:personImg];
			PersonsInfo *person ;
			person = [personsArray objectAtIndex:indexPath.row];
			
			UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(160, 2, 1000, 50)];
			nameLable.backgroundColor = [UIColor clearColor];
			nameLable.tag=1111;
			nameLable.text = person.name;
			[nameLable setFont:[UIFont boldSystemFontOfSize:26]];
			[cell addSubview:nameLable];
			[nameLable release];
			
			UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(160,50, 660, 20)];
			infoLable.backgroundColor = [UIColor clearColor];
			infoLable.text = person.detailInfo;
			infoLable.tag = 12222;
			int lines = [self autoHeight:person.detailInfo
								fontSize:23 labelWidth:660];
			infoLable.frame = CGRectMake(160, 50, 660, 35*lines);
			infoLable.numberOfLines = lines;
			[infoLable setFont:[UIFont boldSystemFontOfSize:23]];
			[cell addSubview:infoLable];
			[infoLable release];
			
			UILabel *InfosLabel = [[UILabel alloc] initWithFrame:CGRectMake(160,(50+35*lines),660,40)];
			InfosLabel.backgroundColor = [UIColor clearColor];
			InfosLabel.text = person.detailInfos;
			InfosLabel.tag = 233;
			int line = [self autoHeight:person.detailInfos fontSize:23 labelWidth:660];
			InfosLabel.frame = CGRectMake(160, (40+35*lines), 660, 40*line);
			InfosLabel.numberOfLines= detailInfosLines;
			[InfosLabel setFont:[UIFont boldSystemFontOfSize:23]];
			[cell addSubview:InfosLabel];
			[InfosLabel release];
			NSURL *url = [NSURL URLWithString:person.image];
			NSData *imageData = [NSData dataWithContentsOfURL:url];
			UIImage *ret = [UIImage imageWithData:imageData];
			[personImg setImage:ret];
			[personImg release];
			// Only load cached images; defer new downloads until scrolling ends
			if (personNumbers<0)
			{
				if ([person.image isEqualToString:@"data:image/png;base64,"])
				{
					if (xiaoziliaoTabView.dragging == NO && xiaoziliaoTabView.decelerating == NO)
					{
						[self startImageSearch:indexPath];
					} 
				}
			}
		}
   	}
    return cell;
}
#pragma mark -
#pragma mark Table view delegate
//UITableView代理，tableView的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (tableView.tag == 0)
	{
		for(UIView *v in [self.view subviews])
		{
            if (v.tag==100)
            {
                for(UIButton *bt in [v subviews])
                {
                    if ([bt isKindOfClass:[UIButton class]])
                    {
                        bt.userInteractionEnabled = NO;
                    }
                }
            }
			if (v.tag==333)
			{
				v.userInteractionEnabled = NO;
			}
		}
		PersonsInfo *person = [personsArray objectAtIndex:indexPath.row];
		
		if (resumeController)
		{
			[resumeController.view removeFromSuperview];
		}
		resumeController=[[ResumeViewController alloc]init];
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:resumeController action:@selector(moveRight)];
		swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
		[resumeController.view addGestureRecognizer:swipeGesture];
		[swipeGesture release];
		resumeController.view.frame=CGRectMake(1024, 0, 1024, 768);
		[resumeController setDel:self];
		resumeController.personID = person.personID;
		resumeController.personName = person.name;
		resumeController.unitName = person.detailInfo;
		resumeController.personImageString = person.image;
		UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
		[navagation.view addSubview:resumeController.view];
		resumeController.view.tag = 150;
		[UIView beginAnimations:nil context:resumeController.view];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationRepeatCount:1];
		[UIView setAnimationDelegate:self];
		resumeController.view.frame=CGRectMake(0, 0, 1024, 768);
		[UIView commitAnimations];
	}
	for(UIButton *bt in [self.view subviews])
	{
	    if ([bt isKindOfClass:[UIButton class]])
		{
			if (bt.tag==333)
			{
				bt.userInteractionEnabled = NO;
			}
		}
	}
}

//UITableView代理，返回tableView的cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int temp;
	if (tableView.tag == 0)
	{
		detailInfoLines = [self autoHeight:[[resultArray objectAtIndex:indexPath.row]objectForKey:@"a02_a0215_all_MingCe"] 
								  fontSize:23 labelWidth:660];
		detailInfosLines = [self autoHeight:[[resultArray objectAtIndex:indexPath.row]objectForKey:@"GetPersonBaseInf"] 
								   fontSize:23 labelWidth:660];
		temp = 2+50+detailInfoLines*35+detailInfosLines*40;
		if (temp<210)
		{
			temp = 210;
		}
	}
	else {
		temp =50;
	}
	return temp;
}
#pragma mark -
#pragma mark UIScrollView delegate
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark  stopDelegate
//停止加载
-(void)stopLoad
{
	++finishiCount;
	if (finishiCount == 1)
	{
		[prompt stopAnimating];
		for(FormView *v in [scroll subviews])
		{
			v.userInteractionEnabled = YES;
		}
		scroll.userInteractionEnabled = YES;
		yButton.userInteractionEnabled = YES;
		[self performSelector:@selector(resetButton) withObject:nil afterDelay:0.5];
	}
}

//重置button的状态
-(void)resetButton
{
    //遍历视图是不是在当前视图下
    for(UIView *v in [self.view subviews])
	{
        //tag值判断视图
		if (v.tag==100)
		{
			for(UIButton *bt in [v subviews])
			{
				if ([bt isKindOfClass:[UIButton class]])
				{
					bt.userInteractionEnabled = YES;
				}
			}
		}
        //tag值判断视图
		if (v.tag==333)
		{
			v.userInteractionEnabled = YES;
		}
	}
}
#pragma mark -
#pragma mark reuseDelegate
-(void)resue
{
   if (resumeController.view.frame.origin.x==1024)
   {
	   for(UIView *v in [self.view subviews])
	   {
		   if (v.tag==100)
		   {
			   for(UIButton *bt in [v subviews])
			   {
				   if ([bt isKindOfClass:[UIButton class]])
				   {
					   bt.userInteractionEnabled = YES;
				   }
			   }
		   }
		   if (v.tag==333)
		   {
			   v.userInteractionEnabled = YES;
		   }
	   }
   }
    
}

//重置personsArray的数据
- (void)setPersonsArray:(NSMutableArray *)newDataArray 
{
    if (newDataArray != personsArray) {
		[personsArray release];
		personsArray = [newDataArray retain];
	}
	if (personsArray == nil) {
		//self.sectionsArray = nil;
	}
	else {
		//[self configureSections];
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
	[tabViewArr release];
	[xiaoziliaoTabView release];
	[tongxunBacgroundView release];
    //如果存在personsNew对象,释放personsNew
	if (personsNew)
	{
		[personsNew release];
		personsNew = nil;
	}
	[sanArr release];
	[fengongArr release];
	[scroll release];
	[titleText release];
	[prompt release];
	[kaoheArr release];
	[list release];
	[content release];
	[pop release];
	[fv release];
    
    //如果存在oldVisiableArray对象,释放oldVisiableArray
	if (oldVisiableArray)
	{
		[oldVisiableArray release];
		oldVisiableArray = nil;
	}
	[super dealloc];
}
@end
