    //
//  OtherController.m
//  IPAD
//
//  Created by  careers on 12-2-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OtherController.h"
#import "MPTabBarController.h"
#import "SQLiteOptions.h"
#import "RenMianController.h"


@implementation OtherController
@synthesize delegate,tit,condition;
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
	if (-2 == self.condition)
	{
		if ( tblView==nil ) {
			//-----Table-------
			CGRect rcTable = CGRectMake(0.0, 45 ,480.0, 645);//645
			tblView = [[UITableView alloc] initWithFrame:rcTable style:UITableViewStylePlain];
			tblView.delegate = self;
			tblView.dataSource = self;
			tblView.backgroundColor = [UIColor whiteColor]; 
			tblView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; 
			tblView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
			tblView.clipsToBounds = NO;
			[self.view addSubview:tblView];
			
		}
		
		tblView.backgroundColor = [UIColor clearColor];
			
		UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kEachViewController_Width, 43)];
		titleView.image = [UIImage imageNamed:@"master_title_view_bg.png"];
		[self.view addSubview:titleView];
		[titleView release];
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 400, 20)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = [UIColor blackColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:20];
		titleLabel.text = self.tit;
		[titleView addSubview:titleLabel];
		[titleLabel release];
		
		
		resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:@"SELECT * FROM IPAD_Analysis_Group_File where ParentID = 0"]];
		for (int i =0 ; i < [resultArray count]; i++)
		{
			
			if ([self.tit isEqualToString:[[resultArray objectAtIndex:i]objectForKey:@"Title"]])
			{
				self.condition = [[[resultArray objectAtIndex:i]objectForKey:@"ID"] intValue];
			}
		}
		//NSString *sql = [NSString stringWithFormat:@"select * from Analysis_Group_File where ParentID = %d order by Porder asc",self.condition];
		[resultArray removeAllObjects];
		//[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql]];
		[resultArray addObjectsFromArray:[[SQLiteOptions sharedSQLiteOptions]queryWithCondition:self.condition]];
		for(NSMutableDictionary *dic in resultArray)
		{
		    [dic removeObjectForKey:@"FILE"];
		}
		//resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql]];
		isSecondpage = YES;
		linesNumber = [resultArray count];
	}
	else
	{
		self.title = self.tit;
        resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithCondition:self.condition]];
		if ( subTblView==nil ) {
			//-----Table-------
			CGRect rcTable = CGRectMake(0, 0 ,480.0, 645);
			subTblView = [[UITableView alloc] initWithFrame:rcTable style:UITableViewStylePlain];
			subTblView.delegate = self;
			subTblView.dataSource = self;
			subTblView.backgroundColor = [UIColor whiteColor]; 
			subTblView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; 
			subTblView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
			subTblView.clipsToBounds = NO;
			[self.view addSubview:subTblView];
			
		}
	}
}

-(int)autoLabelHeight:(NSString *)_string
{
	int _stringCount = [_string length];
	int lines;
	if (0 == _stringCount%20)
	{
		lines = _stringCount/20;
	}
	else {
		lines = _stringCount/20+1;
	}
	
	return lines;
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [resultArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int lines = [self autoHeight:[[resultArray objectAtIndex:indexPath.row]objectForKey:@"Title"] fontSize:23 labelWidth:390];
    if(lines==1)
	{
		return 60;
	}
	else
	{
		return 40*lines;
	}

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else {
        //modify by zyy 2014-01-24 修改列表加载以适配ios7
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            // 7.0 系统的适配处理。
            for (UIView *psubView in [cell subviews])
            {
                for(UIView *v in [psubView subviews]){
                    if ([v superview])
                    {
                        if ([v isKindOfClass:[UILabel class]])
                        {
                            [v removeFromSuperview];
                        }
                    }
                }
            }
        }
        else{
            //6.0及以前版本的处理
            for(UIView *v in [cell subviews]){
                if ([v superview])
                {
                    if ([v isKindOfClass:[UILabel class]])
                    {
                        [v removeFromSuperview];
                    }
                }
            }
        }
	}
	titleString = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"Title"];
	cell.tag =[[[resultArray objectAtIndex:indexPath.row]objectForKey:@"ID"]intValue];

	UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 390, 60)];//450
	contentLabel.backgroundColor = [UIColor clearColor];
	contentLabel.text = titleString;
	contentLabel.font = [UIFont systemFontOfSize:23];
	contentLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	int lines = [self autoHeight:titleString fontSize:23 labelWidth:390];
	contentLabel.numberOfLines = lines;
	if (lines!=1)
	{
		contentLabel.frame = CGRectMake(80, 0, 390, 40*lines);
	}
	contentLabel.tag = 111;
	[cell addSubview:contentLabel];
	[contentLabel release];
	
	UIImageView *fileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (contentLabel.frame.size.height-40)/2, 40, 40)];
	[cell addSubview:fileImageView];
	[fileImageView release];
	
	NSString *fileName = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"FILE_NAME"];
	if ([fileName isEqualToString:@" "])
	{
		fileImageView.image = [UIImage imageNamed:@"文件夹.png"];
	}
	else
	{
		fileImageView.image = [UIImage imageNamed:@"文件.png"];
	}

    return cell;
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

//UITableView代理方法，点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	selectIndexPath = [indexPath copy];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (oldIndexPath!=selectIndexPath)
	{
		UITableViewCell *cellOld = [tblView cellForRowAtIndexPath:oldIndexPath];
		cellOld.selected = NO;
	}
	
	UILabel *titLabel=(UILabel *)[cell viewWithTag:111];
	NSString *titString=titLabel.text;
	int lineNumber = [self tableView:tableView numberOfRowsInSection:0];
	if (lineNumber == linesNumber)
	{
		isSecondpage = YES;
	}
	NSString *fileName = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"FILE_NAME"];
	if (fileName == @" ")
	{
		if (isSecondpage) 
		{
		    if ([self.tit isEqualToString:@"任免上会"])
			{
				RenMianController *rc = [[RenMianController alloc] init];
				[[SQLiteOptions sharedSQLiteOptions] openSQLiteDatabase];
				NSString *sqls = [NSString stringWithFormat:@"select FILE_NAME,Title from IPAD_Analysis_Group_File where ParentID = '%@'",[[resultArray objectAtIndex:indexPath.row]objectForKey:@"ID"]];
				NSMutableArray *ret = [[NSMutableArray alloc] init];
				sqlite3_stmt *stmts;
				if (sqlite3_prepare_v2([SQLiteOptions getDatabase],  [sqls UTF8String], -1, &stmts, nil) == SQLITE_OK) 
				{
					NSMutableArray *nameArray = [NSMutableArray array];
					NSMutableArray *contentArray = [NSMutableArray array];
					while (sqlite3_step(stmts) == SQLITE_ROW)
					{
						const unsigned char *colName = sqlite3_column_text(stmts, 0);
						NSString *colString = [[NSString alloc] initWithUTF8String:(const char *)colName];
						
						if ([colString hasSuffix:@".txt"])
						{
							NSString *name = [NSString stringWithContentsOfFile:[Utilities documentsPath:
																					[NSString stringWithFormat:@"template/%@",colString]]
																		  encoding:NSUTF8StringEncoding
																			 error:nil];
							[nameArray addObjectsFromArray:[name componentsSeparatedByString:@"\n"]];
							
                            //王渤 2012-8-10，读取文件数据时，把空行数据也读取在内，遍历清除空行数据
							for (int i = 0; i < [nameArray count]; i++) {
                                NSString *namel = [nameArray objectAtIndex:i];
                                if (1 > namel.length) {
                                    [nameArray removeObjectAtIndex:i];
                                    i = i--;
                                }
                            }
						}
						else
						{
							//const unsigned char *colNameOther = sqlite3_column_text(stmts, 1);
//							NSString *colStringOther = [[NSString alloc] initWithUTF8String:(const char *)colNameOther];
//							NSDictionary *dic = [NSDictionary dictionaryWithObject:colString forKey:colStringOther];
//							[ret addObject:dic];
//							[colStringOther release];
                            //王渤 2012-8-10,隐藏文件Thumbs.db出现在数据库中,为去除Thumbs.db文件的影响
                            if (![colString hasSuffix:@".db"]) {
                                [contentArray addObject:colString];
                            }
						}
						
						[colString release];
					}
					[ret addObject:nameArray];
					[ret addObject:contentArray];
					sqlite3_finalize(stmts);
				}
				[[SQLiteOptions sharedSQLiteOptions] closeSQLiteDatabase];
				rc.resultArray = [ret retain];
				rc.view.frame = CGRectMake(1024,0,1024,768);
				UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];		
				[navagation.view addSubview:rc.view];
				CGRect endFrame = CGRectMake(0, 0, 1024, 768);
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationDuration:0.5];
				rc.view.frame = endFrame;
				[UIView commitAnimations];
				[ret release];
			}
			else
			{
			    OtherController *dc = [[OtherController alloc] init];
				dc.tit = titString;
				dc.condition = [[tableView cellForRowAtIndexPath:indexPath]tag];
				MPTabBarController *tabbarController = [delegate tabBarController];
				[tabbarController showDetailController:dc animated:YES];
				[dc release];	
			}
		}
		else {
			OtherController *sc = [[OtherController alloc] init];//WithStyle:UITableViewStylePlain];
			sc.tit = titString;//[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
			sc.condition = [[tableView cellForRowAtIndexPath:indexPath]tag];
			[self.navigationController pushViewController:sc animated:YES];	
			[sc release];
			
		}

	}
	else 
	{
		NSString *contentName;
		contentName = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"FILE_NAME"];
		if ([contentName hasSuffix:@".xls"]||[contentName hasSuffix:@"xlsx"])
		{
			DisplayExcelController *myExcelController = [[DisplayExcelController alloc] init];
			
			myExcelController.delegate = self;
			myExcelController.tableName = titString;
			myExcelController.condition = [[[resultArray objectAtIndex:indexPath.row]objectForKey:@"ID"] intValue];
			
			myExcelController.view.frame = CGRectMake(1024, 20-[self getPaddingY], 1024, 768);
			UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
			[navagation.view addSubview:myExcelController.view];
			CGRect endFrame = CGRectMake(0, 20-[self getPaddingY], 1024, 768);
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.5];
			myExcelController.view.frame = endFrame;
			[UIView commitAnimations];
			//[myExcelController release];
		}
		else {
			//if (dwe) 
//			{
//				[dwe.view removeFromSuperview];
//				[dwe release];
//			}
			DistinguishWordOrExcel *dwe = [[DistinguishWordOrExcel alloc] init];
			dwe.tit = titString;//[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
			dwe.condition = [[[resultArray objectAtIndex:indexPath.row]objectForKey:@"ID"]intValue];
			NSString *sql1 = [NSString stringWithFormat:@"select * from IPAD_Analysis_Group_File where ID = '%d'",[[[resultArray objectAtIndex:indexPath.row]objectForKey:@"BaseParentID"]intValue]];
			NSArray *array = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql1];
			dwe.tableName = [[array objectAtIndex:0] objectForKey:@"Title"];
			dwe.delegate = self;
			dwe.view.frame = CGRectMake(1024, 0, 1024, 768);
			dwe.view.tag = 100;
			UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
			//navagation.view.backgroundColor = [UIColor lightGrayColor];
			[navagation.view addSubview:dwe.view];
			CGRect endFrame = CGRectMake(0, 0, 1024, 768);
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.5];
			dwe.view.frame = endFrame;
			[UIView commitAnimations];
			
			//添加手势 向右滑的手势
			dwe.view.userInteractionEnabled = YES;
			UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
			swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
			[dwe.view addGestureRecognizer:swipeGesture];
			[swipeGesture release];
			
		}
		oldIndexPath = [selectIndexPath copy];
	}

}

//ios7搜索条适配 add by zyy 2014-02-18
- (int)getPaddingY{
    int paddingy = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        paddingy = 20;
    }
    return paddingy;
}


-(void)deselected
{
	[tblView deselectRowAtIndexPath:selectIndexPath animated:NO];
	selectedCell.selected = YES;
}


- (void)detailSwipeFromLeft
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
	[UIView setAnimationDuration:1.2];
	[UIView commitAnimations];
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
- (void)dealloc {
	if (selectIndexPath)
	{
		[selectIndexPath release];
	}
	if (oldIndexPath)
	{
		[oldIndexPath release];
	}
	
	[resultArray release];
    [super dealloc];
}


@end
