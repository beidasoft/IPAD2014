    //
//  BianZhiInfoController.m
//  IPAD
//
//  Created by  careers on 12-5-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BianZhiInfoController.h"


@implementation BianZhiInfoController

@synthesize bianzhiResultArray,tit,contentOut2;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
		contentOut2 = [[UIImageView alloc]initWithFrame:KCONTENTOUTFRAME];
		contentOut2.image = [UIImage imageNamed:@"contentBg.png"];
		contentOut2.userInteractionEnabled = YES;
		UIImageView *redFrame3 = [[UIImageView alloc]initWithFrame:KREDFRAME];
		redFrame3.image = [UIImage imageNamed:@"mingceredframe.png"];
		[contentOut2 addSubview:redFrame3];
		[redFrame3 release];
		
		UILabel *titleLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 895, 50)];
		titleLabel4.text = tit;
		if ([tit length]*30<895)
		{
			titleLabel4.textAlignment = UITextAlignmentCenter;
		}
		else {
			titleLabel4.textAlignment = UITextAlignmentLeft;
		}
		titleLabel4.backgroundColor = [UIColor clearColor];
		titleLabel4.textColor = [UIColor whiteColor];
		titleLabel4.font = [UIFont systemFontOfSize:30];
		[contentOut2 addSubview:titleLabel4];
		[titleLabel4 release];
		[self.view addSubview:contentOut2];
				
}
#pragma mark -
#pragma mark self Method
//设置属性bianzhiResultArray的值
-(void)setBianzhiResultArray:(NSMutableArray *)resultArray
{
    if (mingchengArr) {
        [mingchengArr removeAllObjects];
        [mingchengArr release];
    }
    if (yingpeiArr) {
        [yingpeiArr removeAllObjects];
        [yingpeiArr release];
    }
    if (shipeiArr) {
        [shipeiArr removeAllObjects];
        [shipeiArr release];
    }
    if (chaoqueArr) {
        [chaoqueArr removeAllObjects];
        [chaoqueArr release];
    }
    banziCompany = @"单位名称:";
    mingchengArr = [[NSMutableArray alloc] init];
    yingpeiArr = [[NSMutableArray alloc] init];
    shipeiArr = [[NSMutableArray alloc] init];
    chaoqueArr = [[NSMutableArray alloc] init];
    
    [mingchengArr addObject:@"职务名称:"];
    [yingpeiArr addObject:@"应配职务:"];
    [shipeiArr addObject:@"实配职务:"];
    [chaoqueArr addObject:@"超缺编情况:"];

	if ([resultArray count]==0)
	{
	}else
	{
        for (int i = 0; i < [resultArray count]; i++) {
            [mingchengArr addObject:[[resultArray objectAtIndex:i]objectForKey:@"B0901B"]];
            [yingpeiArr addObject:[[resultArray objectAtIndex:i]objectForKey:@"B0911"]];
            [shipeiArr addObject:[[resultArray objectAtIndex:i]objectForKey:@"B0914"]];
            [chaoqueArr addObject:[[resultArray objectAtIndex:i]objectForKey:@"B0912"]];
        }
	}
	
	bianzhiTabView = [[UITableView alloc] initWithFrame:KCONTENTFRAME style:UITableViewStylePlain];
	bianzhiTabView.delegate = self;
	bianzhiTabView.dataSource = self;
	bianzhiTabView.backgroundColor = [UIColor whiteColor]; // kTableBackgroundColor;
	bianzhiTabView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; // [UIColor greenColor];
	bianzhiTabView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
	bianzhiTabView.clipsToBounds = YES;
	bianzhiTabView.tag = 4;
	bianzhiTabView.separatorStyle=NO;
	[contentOut2 addSubview:bianzhiTabView];
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
#pragma mark -
#pragma mark Table view data source
//UITableView代理方法,返回section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [mingchengArr count]+1;
}

//UITableView代理方法,返回section中cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

//UITableView代理方法,返回section的title标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{	
    if (section == 0) {
        return banziCompany;
    }
    else {
        return [mingchengArr objectAtIndex:section-1];
    }
}
#pragma mark -
#pragma mark Table view delegate
//UITableView代理方法,返回section高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        int temp;
        int lines = [self autoHeight:self.tit
                            fontSize:25
                          labelWidth:700];
        temp = 50*lines;
        return temp;
    }
    else {
        int temp;
        int lines = [self autoHeight:[mingchengArr objectAtIndex:section-1]
                             fontSize:25
                           labelWidth:230];
        temp = 50*lines;
        return temp;
    }
}

//UITableView代理方法,返回section背景视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *sectionView;
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
	if (sectionTitle == nil) {
		return nil;
	}

    if (section == 0) {
        int lines = [self autoHeight:self.tit
                            fontSize:25
                          labelWidth:700];
        sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50*lines)] autorelease];
        UIImageView *bg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50*lines)]autorelease];
        bg.image = [UIImage imageNamed:@"bianzhititle.png"];
        [sectionView addSubview:bg];
        
        UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.frame = CGRectMake(12, (sectionView.frame.size.height-20)/2, 130, 22);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        titleLabel.text = sectionTitle;
        [sectionView addSubview:titleLabel];

        UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake(142,10*lines/2, 700, 40*lines)];
        contentLable.backgroundColor = [UIColor clearColor];
        contentLable.tag=111;
        contentLable.numberOfLines = lines;
        contentLable.text = self.tit;
        [contentLable setFont:[UIFont boldSystemFontOfSize:25]];
        [sectionView addSubview:contentLable];
        [contentLable release];

    }
    else {
        int lines = [self autoHeight:[mingchengArr objectAtIndex:section - 1]
                            fontSize:25
                          labelWidth:230];
        NSString *fontStyle;
        if (section == 1) {
            fontStyle = @"Arial Rounded MT Bold";
        }
        else {
            fontStyle = @"helvetica";
        }
        sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50*lines)] autorelease];
        UIImageView *bg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50*lines)]autorelease];
        bg.image = [UIImage imageNamed:@"bianzhititle.png"];
        [sectionView addSubview:bg];
                
        UILabel *mingchengLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,10*lines/2, 230, 40*lines)];
        mingchengLabel.backgroundColor = [UIColor clearColor];
        mingchengLabel.numberOfLines = lines;
        mingchengLabel.text = sectionTitle;
        mingchengLabel.font = [UIFont fontWithName:fontStyle size:23];
        [sectionView addSubview:mingchengLabel];
        [mingchengLabel release];

        UILabel *yingpeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(250,10*lines/2, 190, 40*lines)];
        yingpeiLabel.backgroundColor = [UIColor clearColor];
        yingpeiLabel.numberOfLines = lines;
        yingpeiLabel.text = [yingpeiArr objectAtIndex:section - 1];
        yingpeiLabel.font = [UIFont fontWithName:fontStyle size:23];
        [sectionView addSubview:yingpeiLabel];
        [yingpeiLabel release];
        
        UILabel *shipeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(445,10*lines/2, 190, 40*lines)];
        shipeiLabel.backgroundColor = [UIColor clearColor];
        shipeiLabel.numberOfLines = lines;
        shipeiLabel.text = [shipeiArr objectAtIndex:section - 1];
        shipeiLabel.font = [UIFont fontWithName:fontStyle size:23];
        [sectionView addSubview:shipeiLabel];
        [shipeiLabel release];
        
        UILabel *chaoqueLabel = [[UILabel alloc]initWithFrame:CGRectMake(640,10*lines/2, 250, 40*lines)];
        chaoqueLabel.backgroundColor = [UIColor clearColor];
        chaoqueLabel.numberOfLines = lines;
        chaoqueLabel.text = [chaoqueArr objectAtIndex:section - 1];
        chaoqueLabel.font = [UIFont fontWithName:fontStyle size:23];
        [sectionView addSubview:chaoqueLabel];
        [chaoqueLabel release];
        
    }
    
	return sectionView;
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
	[contentOut2 release];
    [mingchengArr release];
    [yingpeiArr release];
    [shipeiArr release];
    [chaoqueArr release];
	[bianzhiResultArray release];
	[bianzhiTabView release];
	[tit release];
    [super dealloc];
}
@end
