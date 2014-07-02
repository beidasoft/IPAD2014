//
//  SearchController.m
//  IPAD
//
//  Created by  careers on 12-5-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchController.h"
#import "SQLiteOptions.h"
#import "PersonsInfo.h"
#import "Utilities.h"
#import "ResumeViewController.h"
#import "DisplayExcelController.h"
#import "DistinguishWordOrExcel.h"
#import "CompanyInfo.h"

@implementation SearchController
@synthesize searchArea;
@synthesize isFirstPage;

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
// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,1024,768)];
	backgroundImageView.image = [UIImage imageNamed:@"searchBackground.png"];
	backgroundImageView.userInteractionEnabled = YES;
	[self.view addSubview:backgroundImageView];
	[backgroundImageView release];
	
	sortButton = [[UIButton alloc]initWithFrame:CGRectMake(28, 13, 106, 45)];
	[sortButton setBackgroundImage:[UIImage imageNamed:@"人员信息.png"] 
						  forState:UIControlStateNormal];
	[sortButton addTarget:self 
				   action:@selector(showSort)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:sortButton];
	
	searchArea = [[UISearchBar alloc] initWithFrame:CGRectMake(145, 10, 597, 45)];
	searchArea.backgroundColor = [UIColor clearColor];
	searchArea.delegate=self;
	searchArea.showsCancelButton=NO;
	searchArea.barStyle=UIStatusBarStyleDefault;
	searchArea.placeholder= @"请填写您要搜索的内容";
	searchArea.keyboardType=UIKeyboardTypeNamePhonePad;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [searchArea setBarTintColor:[UIColor clearColor]];
    }
	[self.view addSubview:searchArea];
	for (UIView *subview in searchArea.subviews) {  
		if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {  
			[subview removeFromSuperview];  
			break;  
		}  
	} 
	
	historyButton = [[UIButton alloc]initWithFrame:CGRectMake(920, 13, 90, 45)];
	[historyButton setBackgroundImage:[UIImage imageNamed:@"historyButton.png"] 
							 forState:UIControlStateNormal];
	[historyButton addTarget:self 
					  action:@selector(showHisotryList)
			forControlEvents:UIControlEventTouchUpInside];
	historyButton.backgroundColor = [UIColor clearColor];
	[self.view addSubview:historyButton];
	
	[[NSNotificationCenter defaultCenter]addObserver:self 
											selector:@selector(changeSort:)
												name:@"changed"
											  object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self 
											selector:@selector(changeSearchContent:)
												name:@"changeSearchContent"
											  object:nil];
	
	showTableView = [[UITableView alloc] initWithFrame:CGRectMake(12,90,1000, 640)];
	showTableView.delegate = self;
	showTableView.dataSource = self;
	showTableView.backgroundColor = [UIColor clearColor];
	showTableView.layer.cornerRadius = 10;
	showTableView.layer.borderColor = [[UIColor blackColor] CGColor];
	showTableView.layer.masksToBounds = YES;
	
	currentSort = @"人员信息";
	
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documensDirectory=[paths objectAtIndex:0];
	NSString *filePath=[documensDirectory stringByAppendingPathComponent:@"historyFile.plist"];
	if ([fileManager fileExistsAtPath:filePath]==NO)
	{
		historyArray = [[NSMutableArray alloc] init];
		[historyArray writeToFile:filePath atomically:YES];
	}
	else {
		historyArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
	}
	
	searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
	searchButton.frame = CGRectMake(757, 10, 80, 50);
	[searchButton setBackgroundImage:[UIImage imageNamed:@"searchMark.png"]
							forState:UIControlStateNormal];
	searchButton.backgroundColor = [UIColor clearColor];
	[searchButton addTarget:self
					 action:@selector(searchWithKeyword)
		   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:searchButton];
	
	backButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 680, 50, 50)];
	[backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	
	searchCount = 0;
	
	NSArray *nils = [[NSBundle mainBundle]loadNibNamed:@"RefreshViewIpad" owner:self options:nil];
    refreshView = [[nils objectAtIndex:0] retain];
	refreshView.backgroundColor=[UIColor clearColor];
	
	totalDataArray = [[NSMutableArray alloc] init];
	
	caracterArray = [[NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil] retain];
	
}

//返回到主目录控制器
-(void)backToMenu
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(clearView)];
	[UIView setAnimationDuration:1.0];
	self.view.frame = CGRectMake(0, 748, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
	
}

//清除视图
-(void)clearView
{
	if (searchArea.text!=nil)
	{
		searchArea.text = nil;
	}
	[self.view removeFromSuperview];
	[resultArray release];
	resultArray = nil;
	[totalDataArray release];
	totalDataArray = nil;
	[historyArray release];
	historyArray = nil;
	//searchCount = 0;
}

//显示分类视图
-(void)showSort
{
	sortListController = [[SortController alloc] init];
	sortImageArray = [[NSMutableArray alloc] init];
	NSString *unitSql = @"select * from IPAD_JB02 limit 0,1";
	NSArray *unitArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:unitSql]];
	if ([unitArray count]!=0)
	{
		sortListController.sortArray = [[NSMutableArray alloc] initWithObjects:@"人员信息",@"单位信息",nil];
		[sortImageArray addObject:[UIImage imageNamed:@"人员信息.png"]];
		[sortImageArray addObject:[UIImage imageNamed:@"单位信息.png"]];
	}
	else
	{
		sortListController.sortArray = [[NSMutableArray alloc] init];
	}
	
	NSArray *otherModelArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:@"select * from IPAD_Analysis_Group_File where ParentID = 0 order by Porder asc"]];
	if ([otherModelArray count]!=0)
	{
		int otherModelCount = [otherModelArray count];
		for (int i=0; i<otherModelCount; i++)
		{
			
			if ([[[otherModelArray objectAtIndex:i]objectForKey:@"Title"] isEqualToString:@"组工资料"]||[[[otherModelArray objectAtIndex:i]objectForKey:@"Title"] isEqualToString:@"任免上会"])
			{
				
			}
			else 
			{
				[sortImageArray addObject:[UIImage imageNamed:
										   [NSString stringWithFormat:@"%@.png",[[otherModelArray objectAtIndex:i]objectForKey:@"Title"]]]];
				[sortListController.sortArray addObject:[[otherModelArray objectAtIndex:i]objectForKey:@"Title"]];
			}
			
		}
		
	}
	
    categoryPop = [[UIPopoverController alloc] initWithContentViewController:sortListController];
	[categoryPop setDelegate:self]; 
	[categoryPop setPopoverContentSize:CGSizeMake(85*[sortImageArray count],40)]; 
	sortListController.contentSizeForViewInPopover=sortListController.view.bounds.size; 
	[categoryPop presentPopoverFromRect:CGRectMake(28, 0, 50, 60) 
								 inView:self.view 
			   permittedArrowDirections:UIPopoverArrowDirectionUp 
							   animated:YES];
	
	[unitArray release];
	[otherModelArray release];
}

//选择分类
-(void)changeSort:(NSNotification *)non
{
    int tag = [[non object] intValue];
	[sortButton setBackgroundImage:[sortImageArray objectAtIndex:tag]
						  forState:UIControlStateNormal];
	[categoryPop dismissPopoverAnimated:YES];
	currentSort = [NSString stringWithString:[sortListController.sortArray objectAtIndex:tag]];
}

//选择搜索内容
-(void)changeSearchContent:(NSNotification *)non
{
	[historyPop dismissPopoverAnimated:YES];
	NSArray *searchContentArray = [non object];
	NSString *sort = [searchContentArray objectAtIndex:1];
    [sortButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",sort]] 
						  forState:UIControlStateNormal];
	currentSort = [NSString stringWithFormat:@"%@",sort];
	searchArea.text = [searchContentArray objectAtIndex:0];
	[self searchWithKeyword];
	
}

//显示搜索历史列表
-(void)showHisotryList
{
	historyList = [[HistoryListController alloc] initWithStyle:UITableViewStylePlain];
	if (historyArray!=nil)
	{
		[historyArray removeAllObjects];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDate *date = [NSDate date];
		NSDateComponents *comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
											  fromDate:date];
		NSInteger week = [comps week]; // 今年的第几周
		NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
		NSString *newWeekString = [NSString stringWithFormat:@"%d",week];// 今年的第几周
		NSString *newWeekDayString = [NSString stringWithFormat:@"%d",weekday];// 星期几（注意，周日是“1”，周一是“2”。。。。）
		NSString *newTimeString = [NSString stringWithFormat:@"%@-%@",newWeekDayString,newWeekString];
		
		NSMutableArray *todayArray = [NSMutableArray array];
		NSMutableArray *lastWeekArray = [NSMutableArray array];
		NSMutableArray *otherTimeArray = [NSMutableArray array];
		NSMutableArray *tempArray = [NSMutableArray array];
		
		[historyArray addObjectsFromArray:[NSMutableArray arrayWithContentsOfFile:[Utilities documentsPath:@"historyFile.plist"]]];
		
		for(NSMutableArray *ma in historyArray)
		{
			if ([[ma objectAtIndex:2] isEqualToString:newTimeString])
			{
			    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithObject:[ma objectAtIndex:0] forKey:[ma objectAtIndex:1]];
				[todayArray addObject:mdic];
				[lastWeekArray addObject:mdic];
			}
			else 
			{
				NSString *tempTimeString = [NSString stringWithFormat:@"%@",[ma objectAtIndex:2]];
				int tempWeek = [[[tempTimeString componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
				//int tempWeekDay = [[[tempTimeString componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
				
				if (tempWeek==week)
				{
					NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithObject:[ma objectAtIndex:0] forKey:[ma objectAtIndex:1]];
					[lastWeekArray addObject:mdic];
				}
				else
				{
					NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithObject:[ma objectAtIndex:0] forKey:[ma objectAtIndex:1]];
					[otherTimeArray addObject:mdic];
				}
				
			}
			
		}
		[tempArray addObject:todayArray];
		[tempArray addObject:lastWeekArray];
		[tempArray addObject:otherTimeArray];
		
		historyList.historyArray = tempArray;
	}
	else
	{
		historyList.historyArray = nil;
	}
	
	historyPop = [[UIPopoverController alloc] initWithContentViewController:historyList];
	[historyPop setDelegate:self]; 
	[historyPop setPopoverContentSize:CGSizeMake(350,700)]; 
	historyList.contentSizeForViewInPopover=historyList.view.bounds.size; 
	[historyPop presentPopoverFromRect:CGRectMake(970,0, 50, 60) 
								inView:self.view 
			  permittedArrowDirections:UIPopoverArrowDirectionUp 
							  animated:YES];
}

//UISearchBar代理，UISearchBar的button和搜索等button的点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	if (searchBar.text!=nil)
	{
		[self searchWithKeyword:searchBar.text];
	}
}

//按照关键字进行搜索
-(void)searchWithKeyword:(NSString *)string
{
	NSString *searchString = [NSString stringWithString:string];
	searchCount ++;
	if (searchCount==1)
	{
		resultArray = [[NSMutableArray alloc] init];
	}
	else 
	{
		[resultArray removeAllObjects];
	}
	[totalDataArray removeAllObjects];
    if ([searchString isEqualToString:@""])
	{
		[self showAlertLabel];
	}
	else
	{
		if ([self containSpecialCharacter:searchString]!=YES)
		{	
			if ([self isMixedCaracterWithHanzi:searchString]==YES)
			{
				UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" 
																  message:@"对不起，您输入的内容包含汉字与字母的组合，请重新输入！"
																 delegate:self
														cancelButtonTitle:@"确定" 
														otherButtonTitles:nil];
				[alertView show];
				[alertView release];
				return ;
			}
			else
			{
			    NSString *sqlString;
				if ([currentSort isEqualToString:@"人员信息"])
				{
					if ([searchString length]==1)
					{
						if ([caracterArray containsObject:[searchString lowercaseString]])
						{
							for (int i = 0;i<26; i++)
							{
								if ([[searchString lowercaseString]isEqualToString:[caracterArray objectAtIndex:i]])
								{
									if (i==25) 
									{
										sqlString = [NSString stringWithFormat:@"select count(DISTINCT A00)from IPAD_A01_Function where A0102>='%@'",[searchString uppercaseString]];
										personSearchSQL = [[NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0102>='%@' ORDER BY A0102",[searchString uppercaseString]] retain];
										
									}
									else 
									{
										sqlString = [NSString stringWithFormat:@"select count(DISTINCT A00)from IPAD_A01_Function where A0102>='%@' and A0102<'%@'",[searchString uppercaseString],[[caracterArray objectAtIndex:(i+1)] uppercaseString]];
										personSearchSQL = [[NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0102>='%@' and A0102<'%@' ORDER BY A0102",[searchString uppercaseString],[[caracterArray objectAtIndex:(i+1)] uppercaseString]] retain];
									}
									break;
								}
							}
						}
						else//王渤 2012－8－29 修改搜索一个字时只能搜索姓改为姓、名都可以
						{
							sqlString = [NSString stringWithFormat:@"select count(DISTINCT A00)from IPAD_A01_Function where A0101 like '%@%@%@'",@"%",searchString,@"%"];
							personSearchSQL = [[NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0101 like'%@%@%@' ORDER BY A0102",@"%",searchString,@"%"] retain];
						}
						
						
					}
					else//大于一个字符
					{
						NSRange range = {0,1};
						NSLog(@"search:%@",searchString);
						if (![caracterArray containsObject:[[searchString substringWithRange:range] lowercaseString]])//中文
						{
							if ([searchString length]>2)//三个字往上
							{
								sqlString = [NSString stringWithFormat:@"select count(DISTINCT A00) from IPAD_A01_Function where A0101 = '%@'",searchString];
								personSearchSQL = [NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0101 = '%@'",searchString];
							}
							else//两个字
                                //王渤 2012－8－29 sql语句的修改
							{
								for (int i=0;i<[searchString length]; i++)
								{
									NSLog(@"i:%d",i);
									range.location = i;
									if (i==0)
									{
										sqlString = [NSString stringWithFormat:@"select count(DISTINCT A00) from IPAD_A01_Function where A0101 like '%@%@%@",@"%",[searchString substringWithRange:range],@"%"];
										personSearchSQL = [NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0101 like '%@%@%@",@"%",[searchString substringWithRange:range],@"%"];
									}
									else
									{
										sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"%@%@'",[searchString substringWithRange:range],@"%"]];
                                        //原语句写法	personSearchSQL = [personSearchSQL stringByAppendingString:[NSString stringWithFormat:@"and A0101 like '%@%@%@'",@"%",[searchString substringWithRange:range],@"%"]];

										personSearchSQL = [personSearchSQL stringByAppendingString:[NSString stringWithFormat:@"%@%@'",[searchString substringWithRange:range],@"%"]];
										if (i==([searchString length]-1))
										{
											personSearchSQL = [[personSearchSQL stringByAppendingString:@" order by A0102"] retain];
										}
									}
								}
								
								NSLog(@"sqlString:%@",sqlString);
								NSLog(@"personSearchSQL:%@",personSearchSQL);
							}
						}
						else//英文搜索
						{
							if ([searchString length]>2)
							{
								sqlString = [NSString stringWithFormat:@"select count(DISTINCT A00) from IPAD_A01_Function where A0102 ='%@'",[searchString uppercaseString]];
								personSearchSQL = [[NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0102='%@'ORDER BY A0102",[searchString uppercaseString]] retain];
							}
							else
							{
								for (int i=0;i<[searchString length]; i++)
								{
									range.location = i;
									if(range.location == ([searchString length]-1)) 
									{
                                        searchString = [searchString lowercaseString];
										sqlString = [NSString stringWithFormat:@"select count(DISTINCT A00) from IPAD_A01_Function where A0102"];
										int lastIndex = [caracterArray indexOfObject:[searchString substringWithRange:range]];
										if (lastIndex!=25)
										{
											NSString *lastCaracter = [[searchString substringWithRange:range] uppercaseString];
											NSString *firstSearchString = [[searchString substringToIndex:range.location] uppercaseString];
											NSString *newLastCaracter = [[caracterArray objectAtIndex:(lastIndex+1)] uppercaseString];
											sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@">= '%@%@' and A0102<'%@%@'",firstSearchString,lastCaracter,firstSearchString,newLastCaracter]];
											personSearchSQL = [[NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0102>='%@%@' and A0102<'%@%@' ORDER BY A0102",firstSearchString,lastCaracter,firstSearchString,newLastCaracter] retain];
										}
										else
										{
											NSRange firstCaracterRange = {0,1};
											if ([[[searchString substringWithRange:firstCaracterRange] lowercaseString] isEqualToString:@"z"])
											{
												sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@">= '%@'",[searchString uppercaseString]]];//zz
												personSearchSQL = [[NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0102>='%@' ORDER BY A0102",[searchString uppercaseString]] retain];
											}
											else
											{
												NSInteger firstIndex = [caracterArray indexOfObject:[searchString substringWithRange:firstCaracterRange]];
												NSString *firstIndexString = [NSString stringWithFormat:@"%d",firstIndex];
												NSString *newFirstCaracter = [[caracterArray objectAtIndex:([firstIndexString intValue]+1)] uppercaseString];
												sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@">= '%@' and A0102<'%@%@'",[searchString uppercaseString],newFirstCaracter,[[caracterArray objectAtIndex:0]uppercaseString]]];//(az,ba)(qz,ra)
												personSearchSQL = [[NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,A00 FROM IPAD_A01_Function WHERE A0102>='%@' and A0102<'%@%@' ORDER BY A0102",[searchString uppercaseString],newFirstCaracter,[[caracterArray objectAtIndex:0]uppercaseString]] retain];
											}
										}
										
										
									}
								}
							}	
						}
					}
					[[SQLiteOptions sharedSQLiteOptions] openSQLiteDatabase];
					sqlite3_stmt *stmt;
					const char *sql = [sqlString cStringUsingEncoding:4];
					if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL) == SQLITE_OK) 
					{
						while (sqlite3_step(stmt) == SQLITE_ROW)
						{
							const unsigned char *colName = sqlite3_column_text(stmt,0);
							if (colName != nil)
							{
								NSString *countString = [NSString stringWithUTF8String:(const char *)colName];
								numbers = [countString intValue];
							}
						}
						sqlite3_finalize(stmt);
					}
					if (numbers!=0)
					{
						if (numbers>10)
						{
							if (numbers>=100)
							{
								isLoadDataAlertView = [[UIAlertView alloc] initWithTitle:@"此查询结果超出100条，是否耐心等待加载？"
																				 message:nil
																				delegate:self
																	   cancelButtonTitle:@"否"
																	   otherButtonTitles:@"是",nil];
								if (isFirstPage!=YES)
								{
									[isLoadDataAlertView show];
								}
							}
							else 
							{
								isFirstPage = NO;
								[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSearchSQL:personSearchSQL
																											   andNumber:0
																										   andLastNumber:10]];
								
								[refreshView setupWithOwner:showTableView delegate:self];
								//加偏移，用来触发scroll的代理方法 BY 李国威 2012-7-13
								[showTableView setContentOffset:CGPointMake(0, 0.5) animated:YES];
								refreshView.cellCount = numbers;
								currentNumer =10;
							}
							
							
						}
						else
						{
							isFirstPage = NO;
							[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSearchSQL:personSearchSQL
																										   andNumber:0
																									   andLastNumber:numbers]];
						}
						[totalDataArray addObjectsFromArray:resultArray];
						[self updateFile:searchString andString:currentSort];
						if (numbers>3)
						{
							if (numbers>=100)
							{
								showTableView.frame = CGRectMake(12,90,1000, 20);
							}
							else 
							{
								showTableView.frame = CGRectMake(12,90,1000, 640);
							}
						}
						else
						{
							showTableView.frame = CGRectMake(12, 90, 1000, 210*numbers+20);
						}
					}
					else 
					{
						showTableView.frame = CGRectMake(12, 90, 1000, 210*numbers+20);
						isFirstPage = NO;
					}
			    }
				else if([currentSort isEqualToString:@"单位信息"])
				{
					sqlString = [NSString stringWithFormat:@"select * from IPAD_B01 where dmcpt like '%@%@%@' order by InpFrq asc",@"%",searchString,@"%"];
					[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
					numbers = [resultArray count];
					if (50*numbers+20>640) 
					{
						showTableView.frame = CGRectMake(12,90,1000, 640);
					}
					else
					{
						showTableView.frame = CGRectMake(12,90,1000,50*numbers+20);
					}
					if (numbers!=0)
					{
						[self updateFile:searchString andString:currentSort];
					}
				}
				else 
				{
					sqlString= [NSString stringWithFormat:@"select * from IPAD_Analysis_Group_File where Title like '%@%@%@' and BaseParentID in (SELECT ID FROM IPAD_Analysis_Group_File WHERE Title = '%@')",@"%",searchString,@"%",currentSort];
					[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
					numbers = [resultArray count];
					if (50*numbers+20>640) 
					{
						showTableView.frame = CGRectMake(12,90,1000, 640);
					}
					else
					{
						showTableView.frame = CGRectMake(12,90,1000,50*numbers+20);
					}
					if (numbers!=0)
					{
						[self updateFile:searchString andString:currentSort];
					}
				}
				
				if (![[self.view subviews] containsObject:showTableView])
				{
					[self.view addSubview:showTableView];
					[self.view bringSubviewToFront:backButton];
				}
				[showTableView reloadData];	
			}
			
		}
		else 
		{
			UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" 
															  message:@"对不起，您输入的内容包含特殊字符，请重新输入！"
															 delegate:self
													cancelButtonTitle:@"确定" 
													otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			return ;
		}
    }
}

//显示alwet视图
-(void)showAlert
{
	if (isLoadDataAlertView)
	{
		[isLoadDataAlertView show];
		isFirstPage = NO;
	}
}

//UIAlertView代理，点击button事件的处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==1)
	{
		[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSearchSQL:personSearchSQL
																					   andNumber:0
																				   andLastNumber:10]];
		[refreshView setupWithOwner:showTableView delegate:self];
		//用来触发scroll代理方法 BY 李国威 2012-7-13
		[showTableView setContentOffset:CGPointMake(0, 0.5) animated:YES];
		refreshView.cellCount = numbers;
		currentNumer =10;
		[totalDataArray addObjectsFromArray:resultArray];
		showTableView.frame = CGRectMake(12, 90, 1000, 640);
		[showTableView reloadData];
	}
	else
	{
		numbers = 0;
		showTableView.frame = CGRectMake(12, 90, 1000, 210*numbers+20);
	}
	
}

//根据关键字搜索内容
-(void)searchWithKeyword
{
	[searchArea resignFirstResponder];
	if (searchArea.text!=nil)
	{
		[self searchWithKeyword:searchArea.text];
	}
	else
	{
		[self showAlertLabel];
	}
	
}

//弹出提示框，且几秒后消失
-(void)showAlertLabel
{
    if ([[self.view subviews] containsObject:showTableView])
	{
		[showTableView removeFromSuperview];
	}
	alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(412,354, 190, 50)];
	alertLabel.backgroundColor = [UIColor blackColor];
	alertLabel.layer.cornerRadius = 10;
	alertLabel.layer.borderColor = [[UIColor blackColor] CGColor];
	alertLabel.layer.masksToBounds = YES;
	alertLabel.text = @"请输入需要查询的内容！";
	alertLabel.textColor = [UIColor whiteColor];
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.8];
	[animation setSubtype: kCATransitionFromBottom];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	[self.view addSubview:alertLabel];
	[self.view.layer addAnimation:animation forKey:nil];
	//更改跳出bug BY 李国威 2012－07－14
	searchButton.userInteractionEnabled = NO;
	[NSTimer scheduledTimerWithTimeInterval:1.5 
									 target:self 
								   selector:@selector(disappearAlertLable) 
								   userInfo:nil 
									repeats:NO];
}

//移除alertlable的动画效果
-(void)disappearAlertLable
{
    CATransition *animation = [CATransition animation];
	[animation setDuration:0.8];
	[animation setSubtype: kCATransitionFromBottom];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	[alertLabel removeFromSuperview];
	[self.view.layer addAnimation:animation forKey:nil];
	[alertLabel release];
	//更改跳出bug BY 李国威 2012－07－14
	searchButton.userInteractionEnabled = YES;
}

//更新时间数据
-(void)updateFile:(NSString *)findString andString:(NSString *)sortString
{
	if (historyList.isCleared == YES)
	{
		[historyArray removeAllObjects];
	}
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *date = [NSDate date];
	NSDateComponents *comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
										  fromDate:date];
	NSInteger week = [comps week]; // 今年的第几周
	NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
	NSString *timeString = [NSString stringWithFormat:@"%d-%d",weekday,week];
	NSString *filePathString = [self getFilePath];
	
	if ([historyArray count]!=0)
	{
		for (int i=0; i<[historyArray count]; i++)
		{
			if ([findString isEqualToString:[[historyArray objectAtIndex:i]objectAtIndex:0]])
			{
				if ([sortString isEqualToString:[[historyArray objectAtIndex:i]objectAtIndex:1]])
				{
					[historyArray removeObjectAtIndex:i];
				}
			}
		}
	}
	
	NSMutableArray *searchArray = [NSMutableArray arrayWithObjects:findString,sortString,timeString,nil];
	[historyArray addObject:searchArray];
	
	[historyArray writeToFile:filePathString atomically:YES];
}

//返回历史纪录地址
-(NSString *)getFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath=[documentsDirectory stringByAppendingPathComponent:@"historyFile.plist"];
	return filePath;
}

//是否包含特殊字符，如;:%
-(BOOL)containSpecialCharacter:(NSString *)string
{
	NSMutableString *sqlString = [NSMutableString stringWithString:string];
	NSRange range1 = [sqlString rangeOfString:@";"];
	NSRange range2 = [sqlString rangeOfString:@"_"];
	NSRange range3 = [sqlString rangeOfString:@"%"];
	if (range1.length==0&&range2.length==0&&range3.length==0) {
		return NO;
	}
	else {
		return YES;
	}
}

//判断是否是汉字和拼音混合的字符串
-(BOOL)isMixedCaracterWithHanzi:(NSString *)string
{
	NSString *string1 = [NSString stringWithString:string];
	int matchCount = 0;
	int errorMatchCount = 0;
	if ([string1 length]==1)
	{
		return NO;
	}
	else
	{
		NSRange range = {0,1};
		for(int i = 0; i<[string1 length]; i++)
		{
			range.location = i;
			NSString *oneCaracter = [[string1 substringWithRange:range] lowercaseString];
			if ([caracterArray containsObject:oneCaracter])
			{
				matchCount++;
			}
			else
			{
				errorMatchCount++;
			}
		}
		if (matchCount==[string1 length]) 
		{
			return NO;
		}
		else if(errorMatchCount == [string1 length])
		{
			return NO;
		}
		else if(matchCount+errorMatchCount==[string1 length])
		{
			return YES;
		}
	}  
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

//UITableView代理，返回UITableView的section的title值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSString stringWithFormat:@"相关搜索记录：%d条",numbers]; 
}

//UITableView代理，返回UITableView的section中cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if ([currentSort isEqualToString:@"人员信息"])
	{
		return [totalDataArray count];
	}
	else
	{
		return [resultArray count];
	}
}

//UITableView代理，返回UITableView的cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([currentSort isEqualToString:@"人员信息"])
	{
		return 210;
	}
	else
	{
		return 50;
	}
}

//UITableView代理，UITableView加载cell视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *kCellIdentifier=@"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
		
	}
	
	// Set up the cell…
	cell.selectionStyle=UITableViewCellSelectionStyleGray;
	for (UIView *vie in [cell subviews])
	{
        //modify by zyy 2014-01-24 修改班子列表加载以适配ios7
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            // 7.0 系统的适配处理。
            for (UIView *subSubView in [vie subviews])
            {
                if ([subSubView isKindOfClass:[UIImageView class]])
                {
                    [subSubView removeFromSuperview];
                }
                else if([subSubView isKindOfClass:[UILabel class]])
                {
                    [subSubView removeFromSuperview];
                }
            }
        }
        else{
            //6.0及以前版本的处理
            if (vie!=nil)
            {
                if ([vie isKindOfClass:[UIImageView class]])
                {
                    [vie removeFromSuperview];
                }
                else if([vie isKindOfClass:[UILabel class]])
                {
                    [vie removeFromSuperview];
                }
            }
        }
        /*
		if (vie!=nil)
		{
			if ([vie isKindOfClass:[UIImageView class]])
			{
				[vie removeFromSuperview];
			}
			else if([vie isKindOfClass:[UILabel class]])
			{
				[vie removeFromSuperview];
			}
		}
         */
	}
	if ([currentSort isEqualToString:@"人员信息"])
	{
		UIView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 205)];
		img.backgroundColor = [UIColor whiteColor];
		cell.backgroundView=(UIView *)img;
		[img release];
		UIImageView *personImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, KPICTURERECT_WIDTH, KPICTURERECT_HEIGHT)];
		personImg.tag= 225;
		[cell addSubview:personImg];
		PersonsInfo *person = [[PersonsInfo alloc] init];
		
		NSDictionary *dirctory = [totalDataArray objectAtIndex:indexPath.row];
		person.name = [dirctory objectForKey:@"A0101"];
		person.detailInfo =[dirctory objectForKey:@"a02_a0215_all_MingCe"];
		person.detailInfos =[dirctory objectForKey:@"GetPersonBaseInf"];
		//person.image =[NSString stringWithFormat:@"data:image/png;base64,%@",[dirctory
		//																			 objectForKey:@"FILE"]];
		
		UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(160, 2, 100, 50)];
		nameLable.backgroundColor = [UIColor clearColor];
		nameLable.tag=111;
		nameLable.text = person.name;
		[nameLable setFont:[UIFont boldSystemFontOfSize:20]];
		[cell addSubview:nameLable];
		[nameLable release];
		
		UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(160, 60, 500, 20)];
		infoLable.backgroundColor = [UIColor clearColor];
		infoLable.text = person.detailInfo;
		infoLable.tag = 1222;
		[infoLable setFont:[UIFont boldSystemFontOfSize:23]];
		[cell addSubview:infoLable];
		[infoLable release];
		
		
		UILabel *InfosLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 65,830 ,140)];
		InfosLabel.backgroundColor = [UIColor clearColor];
		InfosLabel.text = person.detailInfos;
		InfosLabel.numberOfLines= 3;
		[InfosLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[cell addSubview:InfosLabel];
		[InfosLabel release];
		
		
		
		NSURL *url = [NSURL URLWithString:person.image];
		NSData *imageData = [NSData dataWithContentsOfURL:url];
		UIImage *ret = [UIImage imageWithData:imageData];
		[personImg setImage:ret];
		[personImg release];
		[person release];
		
		//if ([person.image isEqualToString:@"data:image/png;base64,"])
		//	   {
		//		   if (showTableView.dragging == NO && showTableView.decelerating == NO)
		//		   {
		//			   [NSThread detachNewThreadSelector:@selector(startImageSearch:)
		//									toTarget:self
		//								  withObject:indexPath];
		//		   }
		//	   }
	}
	else if([currentSort isEqualToString:@"单位信息"])
	{
		UIView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 50)];
		img.backgroundColor = [UIColor whiteColor];
		cell.backgroundView=(UIView *)img;
		[img release];  
		
		UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, showTableView.frame.size.width, 50)];
		nameLabel.backgroundColor=[UIColor clearColor];
		nameLabel.font = [UIFont boldSystemFontOfSize:25];
		nameLabel.tag = 2012;
		nameLabel.text = [[resultArray objectAtIndex:indexPath.row] objectForKey:@"dmcpt"];  

		[cell addSubview:nameLabel];
		[nameLabel release];
	}
	else
	{
		UIView *img =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 50)];
		img.backgroundColor = [UIColor whiteColor];
		cell.backgroundView=(UIView *)img;
		[img release];  
		
		UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, showTableView.frame.size.width, 50)];
		nameLabel.backgroundColor=[UIColor clearColor];
		nameLabel.font = [UIFont boldSystemFontOfSize:25];
		nameLabel.tag = 2012;
		nameLabel.text = [[resultArray objectAtIndex:indexPath.row] objectForKey:@"Title"];

		[cell addSubview:nameLabel];
		[nameLabel release];
		cell.tag = [[[resultArray objectAtIndex:indexPath.row] objectForKey:@"ID"] intValue];
	}
	//NSDateFormatter *datef = [[NSDateFormatter alloc] init];
	//	 [datef setDateFormat:@"ss"];
	//	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[datef stringFromDate:[NSDate date]]]
	//	 message:nil
	//	 delegate:self
	//	 cancelButtonTitle:@"a"
	//	 otherButtonTitles:nil];
	//	 [alert show];
	//	 [alert release];
	return cell;
}

//UIScrollView代理，scrollView执行完毕
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//更改跳出bug BY 李国威 2012－07－14
	searchButton.userInteractionEnabled = YES;
	
	//更改跳出bug BY 李国威 2012－08－07
	if ([currentSort isEqualToString:@"人员信息"])
	{
		[self loadImagesForOnscreenRows];
	}
}
//检测scroll停止滚动的代理方法 BY 李国威 2012-7-13
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
	//更改跳出bug BY 李国威 2012－07－14

	searchButton.userInteractionEnabled = YES;
	
	//更改跳出bug BY 李国威 2012－08－07
	if ([currentSort isEqualToString:@"人员信息"])
	{
		[self loadImagesForOnscreenRows];
	}
}

//在cell中加载图片
- (void)loadImagesForOnscreenRows
{
	//if (oldVisiableIndexPathArray !=nil)
	//		{
	//			for (NSIndexPath *indexPath in oldVisiableIndexPathArray)
	//			{
	//				 NSString *oldImageString = [[totalDataArray objectAtIndex:indexPath.row] objectForKey:@"FILE"];
	//				
	//				if (![oldImageString isEqualToString:@"data:image/png;base64,"]) // avoid the app icon download if the app already has an icon
	//				{
	//					oldImageString = [NSString stringWithFormat:@"%@",@"data:image/png;base64,"];
	//				}
	//			}
	//		}
	NSArray *visiblePaths = [showTableView indexPathsForVisibleRows];
	//oldVisiableIndexPathArray = [visiblePaths retain];
	for (NSIndexPath *indexPath in visiblePaths)
	{
        //王渤 2012-8-14 判断图片是否有加载，然后再加载没有图片的cell
        if ([[[showTableView cellForRowAtIndexPath:indexPath] viewWithTag:225] image] == nil) {
            NSString *imageString = [[totalDataArray objectAtIndex:indexPath.row] objectForKey:@"FILE"];
            if (imageString == nil) // avoid the app icon download if the app already has an icon
            {
                [NSThread detachNewThreadSelector:@selector(startImageSearch:)
                                         toTarget:self
                                       withObject:indexPath];
            }
            //当字符串不为空时直接向cell填充图片-BY 李国威 2012-7-13
            else {
                
                imageString = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",imageString];
                NSURL *url = [NSURL URLWithString:imageString];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *ret = [UIImage imageWithData:imageData];
                [[[showTableView cellForRowAtIndexPath:indexPath] viewWithTag:225] setImage:ret];
            }

        }
//		NSString *imageString = [[totalDataArray objectAtIndex:indexPath.row] objectForKey:@"FILE"];
//		if (imageString == nil) // avoid the app icon download if the app already has an icon
//		{
//			[NSThread detachNewThreadSelector:@selector(startImageSearch:)
//									 toTarget:self
//								   withObject:indexPath];
//		}
//		//当字符串不为空时直接向cell填充图片-BY 李国威 2012-7-13
//		else {
//			
//			imageString = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",imageString];
//			NSURL *url = [NSURL URLWithString:imageString];
//			NSData *imageData = [NSData dataWithContentsOfURL:url];
//			UIImage *ret = [UIImage imageWithData:imageData];
//			[[[showTableView cellForRowAtIndexPath:indexPath] viewWithTag:225] setImage:ret];
//            NSLog(@"[[showTableView cellForRowAtIndexPath:indexPath] viewWithTag:225] ==== %@",[[showTableView cellForRowAtIndexPath:indexPath] viewWithTag:225]);
//		}
		
		
 
	}
}

//开始图片搜索
-(void)startImageSearch:(NSIndexPath *)indexPath
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //PersonsInfo *person = [totalDataArray objectAtIndex:indexPath.row];
	NSString *imageString = [[totalDataArray objectAtIndex:indexPath.row] objectForKey:@"FILE"];
	

	
	NSString *personIDString = [[totalDataArray objectAtIndex:indexPath.row] objectForKey:@"A00"];
	NSString *onePersonImageSQL = [NSString stringWithFormat:@"select FILE from IPAD_A01_Function where A00 = '%@'",personIDString];
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
				//person.image = [NSString stringWithFormat:@"%@%@",person.image,countString];
				imageString = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",countString];
				//向totalDataArray填充图片数据-BY 李国威 2012-7-13
				[[totalDataArray objectAtIndex:indexPath.row] setValue:countString forKey:@"FILE"];
			}
		}
		sqlite3_finalize(stmt);
	}
	



	NSURL *url = [NSURL URLWithString:imageString];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *ret = [UIImage imageWithData:imageData];
	[[[showTableView cellForRowAtIndexPath:indexPath] viewWithTag:225] setImage:ret]; 
	[pool release];
}

//UITableView代理方法，UITableView的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchArea resignFirstResponder];

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([currentSort isEqualToString:@"人员信息"])
	{
		NSDictionary *dic = [totalDataArray objectAtIndex:indexPath.row];
		ResumeViewController  *resumeController = [[ResumeViewController alloc]init];
		resumeController.view.frame=CGRectMake(1024, 0, 1024, 768);
		resumeController.view.tag = 110;
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] 
												  initWithTarget:resumeController 
												  action:@selector(moveRight)];
		swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
		[resumeController.view addGestureRecognizer:swipeGesture];
		[swipeGesture release];
		
		resumeController.personName = [dic objectForKey:@"A0101"];
		resumeController.unitName =[dic objectForKey:@"a02_a0215_all_MingCe"];
		resumeController.personImageString = [NSString stringWithFormat:@"data:image/png;base64,%@",[dic
																									 objectForKey:@"FILE"]];
		
		
		//NSLog(@"presonImageString:%@",resumeController.personImageString);
		//NSLog(@"presonImageString:%@",dic);	

		resumeController.personID = [dic objectForKey:@"A00"];

		
		UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
		[navagation.view addSubview:resumeController.view];
		[UIView beginAnimations:nil context:resumeController.view];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationRepeatCount:1];
		resumeController.view.frame=CGRectMake(0, 0, 1024, 768);
		[UIView commitAnimations];
	}
	else if([currentSort isEqualToString:@"单位信息"])
	{
		CompanyInfo *gc = [[CompanyInfo alloc] init];
		UILabel *findLabel = (UILabel *)[cell viewWithTag:2012];
		NSString *findString = findLabel.text;
		NSString *sql = [NSString stringWithFormat:@"select * from IPAD_B01 where dmcpt = '%@'",findString];
		gc.condition = [[[[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql] objectAtIndex:0] objectForKey:@"B00"] copy];
		gc.tit = findString;
		gc.view.frame = CGRectMake(1024, 0, 1024, 768);
		gc.view.tag = 111;
		UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];		
		[navagation.view addSubview:gc.view];
		CGRect endFrame = CGRectMake(0, 0, 1024, 768);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		gc.view.frame = endFrame;
		[UIView commitAnimations];
	}
	else 
	{
		NSString *contentName = [NSString stringWithFormat:@"%@",[[resultArray objectAtIndex:indexPath.row]objectForKey:@"FILE_NAME"]];
		if ([contentName hasSuffix:@".xls"]||[contentName hasSuffix:@".xlsx"])
		{
			DisplayExcelController*myExcelController = [[DisplayExcelController alloc] init];
			myExcelController.tableName = [NSString stringWithFormat:@"%@",currentSort];		
			myExcelController.condition = [[[resultArray objectAtIndex:indexPath.row]objectForKey:@"ID"] intValue];
			myExcelController.view.frame = CGRectMake(1024, 0, 1024, 768);	
			UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];		
			[navagation.view addSubview:myExcelController.view];
			CGRect endFrame = CGRectMake(0, 0, 1024, 768);
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.5];
			myExcelController.view.frame = endFrame;
			[UIView commitAnimations];
		}
		else
		{
			DistinguishWordOrExcel*dwe = [[DistinguishWordOrExcel alloc] init];
			dwe.tit = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
			dwe.condition = [[tableView cellForRowAtIndexPath:indexPath]tag];
			dwe.tableName = currentSort;
			dwe.view.frame = CGRectMake(1024, 0, 1024, 768);
			dwe.view.tag = 100;
			
			UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
			navagation.view.backgroundColor = [UIColor lightGrayColor];
			[navagation.view addSubview:dwe.view];
			CGRect endFrame = CGRectMake(0, 0, 1024, 768);
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.5];
			dwe.view.frame = endFrame;
			[UIView commitAnimations];
		}
	}
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

//停止加载视图数据
- (void)stopLoading {
    [refreshView stopLoading];
}

// 开始，可以触发自己定义的开始方法
- (void)startLoading {
    [refreshView startLoading];
	[self reloadArrayData];
    [self stopLoading];
}

//查询数据库，更新reloadArray数据，重置显示内容的数组
- (void)reloadArrayData
{
	[resultArray removeAllObjects];
	if (currentNumer+10>numbers)
	{
		[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSearchSQL:personSearchSQL
																					  andNumber:currentNumer
																				  andLastNumber:(numbers-currentNumer)]];
	}
	else 
	{
		[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSearchSQL:personSearchSQL
																					  andNumber:currentNumer
																				  andLastNumber:10]];
	}
	if ([totalDataArray count]<numbers)
	{
		[totalDataArray addObjectsFromArray:resultArray];
		[showTableView reloadData];
	}
	if (currentNumer+10>numbers)
	{
	}
	else {
		currentNumer+=10;
	}
}

//refresh 代理 开始加载
- (void)refresh {
    [self startLoading];
}
#pragma mark - RefreshViewDelegate
//RefreshView 代理 加载完成，重新加载列表视图
- (void)refreshViewDidCallBack {
    [self refresh];
	[showTableView reloadData];
}
#pragma mark - UIScrollView 
// 刚拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
	if ([currentSort isEqualToString:@"人员信息"])
	{
		if (numbers>10)
		{
			[refreshView scrollViewWillBeginDragging:scrollView];
		}
		contentNum = 0;
        loaded = NO;
	}
    
}
// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	searchButton.userInteractionEnabled = NO;
	if ([currentSort isEqualToString:@"人员信息"])
	{
		if (numbers>10)
		{
			[refreshView scrollViewDidScroll:scrollView];
		}
        [self velocity:(UIScrollView *)scrollView];

	}
}

//王渤 2012－8－14 判断滑动过程中的速度
- (void)velocity:(UIScrollView *)scrollView{
//    NSLog(@"decelerationRate ==== %f",scrollView.decelerationRate);
//    NSLog(@"contentOffset ==== %f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if (contentNum == 0) {
        lastContentSetY = scrollView.contentOffset.y;
        contentNum = 100;//下次执行不再执行这个"==0"的条件
    }
    else {
        contentNum = lastContentSetY - scrollView.contentOffset.y;
        lastContentSetY = scrollView.contentOffset.y;
        NSLog(@"contentNum = %d",contentNum);
        
        if (3 > contentNum && contentNum > -3 && !loaded) {
            [self loadImagesForOnscreenRows];
            loaded = YES;
        }
    }

}

//UIScrollView代理， 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	//if (lines>10||[dataArray count]<lines)
	//{

	if ([currentSort isEqualToString:@"人员信息"])
	{
//		if (!decelerate)
//		{
//			[self loadImagesForOnscreenRows];
//		}
		if (numbers>10)
		{
			[refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
		}
		
	}
	//}
    //[refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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
	[backButton release];
	[sortButton release];
	[sortListController release];
	[resultArray release];
    
    //如果存在historyList对象,释放historyList
	if (historyList)
	{
		[historyList release];
		historyList = nil;
	}
    
    //如果存在categoryPop对象,释放categoryPop
	if (categoryPop)
	{
		[categoryPop release];
		categoryPop = nil;
	}
    
    //如果存在historyPop对象,释放historyPop
	if (historyPop)
	{
		[historyPop release];
		historyPop = nil;
	}
	[caracterArray release];
	[totalDataArray release];
	[refreshView release];
	[personSearchSQL release];
	[searchArea release];
    [super dealloc];
}


@end
