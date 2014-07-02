//
//  GBMCThirdController.m
//  IPAD
//
//  Created by  careers on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "GBMCThirdController.h"
#import "SecondMainController.h"
#import "SQLiteOptions.h"
#import "ConnectController.h"
#import "DetailInfosController.h"
#import "MPTabBarController.h"
#import "IPADAppDelegate.h"

@implementation GBMCThirdController
@synthesize delegate,tit,condition,resultArray;

#pragma mark -
#pragma mark View lifecycle

// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = self.tit;
}
// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}
#pragma mark -
#pragma mark Table view data source
//UITableView代理方法，返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//UITableView代理方法，返回section中cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [resultArray count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
    }
	cell.textLabel.text = [[resultArray objectAtIndex:indexPath.row] objectForKey:@"DmAbr1"];
	int line = [self autoHeight:[[resultArray objectAtIndex:indexPath.row] objectForKey:@"DmAbr1"]
					   fontSize:23 labelWidth:461];
	cell.textLabel.numberOfLines = line;
	cell.textLabel.font = [UIFont systemFontOfSize:23];
    //NSLog(@"indexPath.row:%d",indexPath.row);
    //NSLog(@"childcount:%d",[[[resultArray objectAtIndex:indexPath.row] objectForKey:@"HasChildDept"] intValue]);
    // add by zyy 2013-09-27解决小箭头重复问题(每当该方法执行时需要先清除以前cell上的subview)
    for (int i=0; i<[cell.subviews count]; i++) {
        if([[cell.subviews objectAtIndex:i]isKindOfClass:[UIButton class]]){
            [[cell.subviews objectAtIndex:i] removeFromSuperview];
            break;
        }
    }
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
    /*
    else{
        // add by zyy 2013-09-27解决小箭头重复问题
        if([cell.subviews count]>1){
            NSLog(@"subviews count %d",[cell.subviews count]);
            NSLog(@"subviews is %@",cell.subviews);
            for (int i=0; i<[cell.subviews count]; i++) {
                if([[cell.subviews objectAtIndex:i]isKindOfClass:[UIButton class]]){
                    [[cell.subviews objectAtIndex:i] removeFromSuperview];
                    break;
                }
            }
        }
    }
    */
    return cell;
}
#pragma mark -
#pragma mark Table view delegate
//UITableView代理方法，返回cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int lines = [self autoHeight:[[resultArray objectAtIndex:indexPath.row] objectForKey:@"dmcpt"]
						fontSize:23 labelWidth:461];
	if (lines==1)
	{
		return 60;
	}else {
		return 60*lines;
	}
}

//UITableView代理方法，UITableView的cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
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
//向右滑的手势执行的方法
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
	}else
	{
		if (length%endCount == 0)
		{
			lines = length/endCount;
		}else 
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
		NSString *sql = [NSString stringWithFormat:@"select distinct *  FROM IPAD_B01 as s inner join (select sz.dmcod,min(sz.dmparentlev) as lev from IPAD_B01 sz inner join IPAD_B01 b on b.b00=sz.b00 inner join  IPAD_B01 sb on sb.b00=sz.dmparentcod and sb.dmcod='%@' and b.dmcod='%@' and sz.BJXB0199='1' group by sz.dmcod) as t on s.dmcod=t.dmcod and s.dmparentlev=t.lev left join (select distinct IPAD_B01.dmparentcod as fdmcod,count(*) as subdwcount FROM IPAD_B01  inner join IPAD_B01 br on br.b00=IPAD_B01.dmparentcod and br.dmcod='%@' group by IPAD_B01.dmparentcod  ) as ct on ct.fdmcod=s.b00 where s.dmparentcod='%@' order by s.InpFrq",self.condition,self.condition,self.condition,unitId];
		NSArray *childUnitResults = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql];
		GBMCThirdController *gc = [[GBMCThirdController alloc] initWithStyle:UITableViewStylePlain];
		gc.condition = [self.condition copy];
		gc.tit = [[resultArray objectAtIndex:bt.tag] objectForKey:@"DmAbr1"];
		gc.resultArray = [childUnitResults copy];
		[self.navigationController pushViewController:gc animated:YES];
		[gc release];
}

//查询数据库,添加、显示新视图
-(void)show
{
	CompanyInfo *ci = [[CompanyInfo alloc]init];
	ci.tit = [self.tit copy];
	NSString *sqlString = [NSString stringWithFormat:@"select * from IPAD_B01_JB02 where DmAbr1 = '%@'",ci.tit];
	NSArray *conditionArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString];
	ci.condition = [[[conditionArray objectAtIndex:0] objectForKey:@"B00"] copy];
	ci.view.frame = CGRectMake(1024, 0-[self getPaddingY], 1024, 768);
	ci.view.tag = 111;
	
	UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	navagation.view.backgroundColor = [UIColor lightGrayColor];
	[navagation.view addSubview:ci.view];
	CGRect endFrame = CGRectMake(0, 0-[self getPaddingY], 1024, 768);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	ci.view.frame = endFrame;
	[UIView commitAnimations];
	//添加手势 向右滑的手势
	ci.view.userInteractionEnabled = YES;
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
	swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
	[ci.view addGestureRecognizer:swipeGesture];
	[swipeGesture release];
}

//ios7搜索条适配 add by zyy 2014-02-18
- (int)getPaddingY{
    int paddingy = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        paddingy = 20;
    }
    return paddingy;
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