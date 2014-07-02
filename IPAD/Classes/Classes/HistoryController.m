//
//  HistoryController.m
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryController.h"
#import "MPTabBarController.h"
#import "SQLiteOptions.h"
#import "SecondMainController.h"
@implementation HistoryController
@synthesize tblView,delegate;

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
// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    if ( tblView==nil ) {
		//-----Table-------
		CGRect rcTable = CGRectMake(0.0, 0 ,320.0, 367);
		tblView = [[UITableView alloc] initWithFrame:rcTable style:UITableViewStylePlain];
		tblView.delegate = self;
		tblView.dataSource = self;
		tblView.backgroundColor = [UIColor whiteColor];
		tblView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; ;
		tblView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
		tblView.clipsToBounds = NO;
		[self.view addSubview:tblView];
	}
	tblView.backgroundColor = [UIColor clearColor];
	tblView.frame = CGRectMake(0, 43 , self.view.bounds.size.width, self.view.bounds.size.height-43);
	UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kEachViewController_Width, 43)];
	titleView.image = [UIImage imageNamed:@"master_title_view_bg.png"];
	[self.view addSubview:titleView];
	[titleView release];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 400, 20)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20];
	titleLabel.text = @"干部名册";
	[titleView addSubview:titleLabel];
	[titleLabel release];
	
	bLandScape = YES;
	resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:@"select * from IPAD_JB02 order by InpFrq asc;"]];
}
#pragma mark -
#pragma mark self Method
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
#pragma mark Table view data source
//UITableView代理方法，返回sectiom个数
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
	
    cell.textLabel.text = [[resultArray objectAtIndex:indexPath.row] objectForKey:@"dmcpt"];
	int line = [self autoHeight:[[resultArray objectAtIndex:indexPath.row] objectForKey:@"dmcpt"]
					   fontSize:23 labelWidth:461];
	cell.textLabel.numberOfLines = line;
	cell.textLabel.font = [UIFont systemFontOfSize:23];
    // Configure the cell...
    return cell;
}
#pragma mark -
#pragma mark Table view delegate
//UITableView代理方法，UITableView的cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	MPTabBarController *tabbarController = [delegate tabBarController];
	if (dc)
	{
		if (indexPath == currentIndex) 
		{
			dc.selectCell.selected = YES;
		}
		else 
		{
			dc = [[DetailController alloc] initWithStyle:UITableViewStylePlain];
			dc.tit = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
			dc.condition = [[[resultArray objectAtIndex:indexPath.row] objectForKey:@"Dmcod"] copy];
		}
	}
	else 
	{
		dc = [[DetailController alloc] initWithStyle:UITableViewStylePlain];
		dc.tit = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
		dc.condition = [[[resultArray objectAtIndex:indexPath.row] objectForKey:@"Dmcod"] copy];
	}
	[tabbarController showDetailController:dc animated:YES andIndex:indexPath isTableView:YES];
	currentIndex = [indexPath copy];
}

//UITableView代理方法，返回cell行高
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
#pragma mark -
#pragma mark UIScrollView delegate
//UIvcrollView代理方法，scrollView点击事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	if(!bLandScape)
	{
		NSIndexPath *index = [tblView indexPathForSelectedRow];
		if(index)
		{
			[tblView deselectRowAtIndexPath:index animated:YES];
		}
		if(!scrollView.decelerating && scrollView.dragging)
		{
			[[delegate tabBarController] hideDetailController:YES];
		}
	}
}
#pragma mark -
#pragma mark  rotate
// Faster one-part variant, called from within a rotating animation block, for additional animations during rotation.
// A subclass may override this method, or the two-part variants below, but not both.
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
	   interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		bLandScape = YES;
	}else 
	{
		bLandScape = NO;
	}
    if(bLandScape)
	{
		tblView.frame = CGRectMake(0, 43, self.view.bounds.size.width , self.view.bounds.size.height - 43 );
	}else 
	{
		tblView.frame = CGRectMake(0, 43, self.view.bounds.size.width, self.view.bounds.size.height - 43 );
	}
	imageViewBg.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
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
	if (dc)
	{
		[dc release];
		dc = nil;
	}
	[currentIndex release];
	[tblView release];
	[imageViewBg release];
	[resultArray release];
	[super dealloc];
}
@end