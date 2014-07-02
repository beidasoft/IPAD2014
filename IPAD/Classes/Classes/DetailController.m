//
//  DetailController.m
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailController.h"
#import "GBMCThirdController.h"
#import "CompanyInfo.h"

@implementation DetailController
@synthesize delegate,tit,condition,titCondition,selectCell;
@synthesize isHasChild;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    [super viewDidLoad];
	
	self.title = self.tit;
	self.isHasChild = NO;
	self.delegate = self;
	NSString *sql = [NSString stringWithFormat:@"select distinct *  FROM IPAD_B01 inner join IPAD_B01 bn on IPAD_B01.b00=bn.b00 and IPAD_B01.dmcod like '%@' inner join (select distinct b00 from IPAD_B01 where b00 not in (select IPAD_B01.b00 from IPAD_B01  INNER JOIN IPAD_B01 b2 ON b2.B00 = IPAD_B01.DmParentCod  and b2.dmcod like '%@' )) as zut on zut.b00=IPAD_B01.b00 left join (select distinct IPAD_B01.dmparentcod as fdmcod,count(*) as subdwcount FROM IPAD_B01  inner join IPAD_B01 br on br.b00=IPAD_B01.dmparentcod and br.dmcod like '%@' GROUP BY IPAD_B01.dmparentcod ) as ct on ct.fdmcod=IPAD_B01.b00  where (IPAD_B01.dmparentlev='0') or (IPAD_B01.dmparentlev='1')  order by IPAD_B01.InpFrq",self.condition,self.condition,self.condition];
	resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql]];
}

// Called when the view is about to made visible. Default does nothing
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	if (self.selectCell !=nil)
	{
		self.selectCell.selected = YES;
	}
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#pragma mark -
#pragma mark UIScrollView delegate
// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.tableView.allowsSelection = NO;
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (self.selectCell!=nil)
	{
		selectCell.selected = YES;
	}
	self.tableView.allowsSelection = YES;
}
#pragma mark -
#pragma mark Table view data source
//UITableView代理，返回dection个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//UITableView代理，返回section中cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [resultArray count];
}

//UITableView代理，返回cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int lines = [self autoHeight:[[resultArray objectAtIndex:indexPath.row] objectForKey:@"dmcpt"]
						fontSize:23 labelWidth:461];
	if (lines==1)
	{
		return 60;
	}
	else {
		return 44*lines;
	}
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else 
	{
		for (UIView *subView in [cell subviews]) 
		{
			if ([subView isKindOfClass:[UIButton class]])
			{
				[subView removeFromSuperview];
			}
			
		}
	}
	cell.textLabel.text = [[resultArray objectAtIndex:indexPath.row] objectForKey:@"DmAbr1"];
	int line = [self autoHeight:[[resultArray objectAtIndex:indexPath.row] objectForKey:@"DmAbr1"]
					   fontSize:23 labelWidth:461];
	cell.textLabel.numberOfLines = line;
	cell.textLabel.font = [UIFont systemFontOfSize:23];
	if ([[[resultArray objectAtIndex:indexPath.row] objectForKey:@"HasChildDept"] intValue]>0)
	{
		UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
		bt.backgroundColor = [UIColor clearColor];
		bt.tag = indexPath.row;
		bt.frame = CGRectMake(410, 0, 60, 60);
		[bt addTarget:self
			   action:@selector(showInfos:)
	 forControlEvents:UIControlEventTouchUpInside];
		[bt setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
		[cell addSubview:bt];
	}
	
    return cell;
}
#pragma mark -
#pragma mark Table view delegate

//UITableView代理，cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	   if (selectCell)
	   {
		selectCell.selected = NO;
	   }
	   selectCell = [tableView cellForRowAtIndexPath:indexPath];
	   CompanyInfo *companyInfo = [[CompanyInfo alloc]init];
	   companyInfo.tit = [NSString stringWithFormat:@"%@",[[resultArray objectAtIndex:indexPath.row] objectForKey:@"dmcpt"]];
	   companyInfo.condition = [[[resultArray objectAtIndex:indexPath.row] objectForKey:@"B00"] copy];
	   companyInfo.view.frame = CGRectMake(1024, 0-[self getPaddingY], 1024, 768);
	   companyInfo.view.tag = 111;
	   	
	   UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	   [navagation.view addSubview:companyInfo.view];
	   CGRect endFrame = CGRectMake(0, 0-[self getPaddingY], 1024, 768);
	   [UIView beginAnimations:nil context:companyInfo.view];
	   [UIView setAnimationDuration:0.5];
	   companyInfo.view.frame = endFrame;
	   [UIView commitAnimations];
        //添加手势 向右滑的手势
		companyInfo.view.userInteractionEnabled = YES;
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
		swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
		[companyInfo.view addGestureRecognizer:swipeGesture];
		[swipeGesture release];
}
#pragma mark -
#pragma mark self Method

//ios7搜索条适配 add by zyy 2014-02-18
- (int)getPaddingY{
    int paddingy = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        paddingy = 20;
    }
    return paddingy;
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
//进入下层子单位的按钮的单击事件
-(void)showInfos:(id)sender
{
	UIButton *bt = (UIButton *)sender;
	NSString *unitId = [[resultArray objectAtIndex:bt.tag] objectForKey:@"B00"];
	NSString *sql = [NSString stringWithFormat:@"select distinct *  FROM IPAD_B01 as s inner join (select sz.dmcod,min(sz.dmparentlev) as lev from IPAD_B01 sz inner join  IPAD_B01 sb on sb.b00=sz.dmparentcod and sb.dmcod='%@' and sz.dmcod='%@' inner join IPAD_B01 on sb.b00 = IPAD_B01.b00 and IPAD_B01.BJXB0199='1' group by sz.dmcod) as t on s.dmcod=t.dmcod and s.dmparentlev=t.lev left join (select distinct IPAD_B01.dmparentcod as fdmcod,count(*) as subdwcount FROM IPAD_B01  inner join IPAD_B01 br on br.b00=IPAD_B01.dmparentcod and br.dmcod='%@' group by IPAD_B01.dmparentcod  ) as ct on ct.fdmcod=s.b00 where s.dmparentcod='%@' order by s.InpFrq",self.condition,self.condition,self.condition,unitId];
	NSArray *childUnitResults = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql];
	if (selectCell)
	{
		selectCell.selected = NO;
	}
	selectCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:bt.tag inSection:0]];
	GBMCThirdController *gc = [[GBMCThirdController alloc] initWithStyle:UITableViewStylePlain];
	gc.condition = [self.condition copy];
	gc.tit = [[resultArray objectAtIndex:bt.tag] objectForKey:@"DmAbr1"];
	gc.resultArray = [childUnitResults copy];
	[self.navigationController pushViewController:gc animated:YES];
	[gc release];
}
//手向右滑，视图消失
- (void)detailSwipeFromLeft
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
	[UIView setAnimationDuration:1.2];
	[UIView commitAnimations];
}
#pragma mark -
#pragma mark Memory management

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

//对象释放
- (void)dealloc 
{
	[tit release];
	[resultArray release];
    [super dealloc];
}


@end

