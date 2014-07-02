//
//  ProfileController.m
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "DetailController.h"
#import "MPTabBarController.h"
#import "SecondMainController.h"
@implementation ProfileController

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
		tblView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; 
		tblView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
		tblView.clipsToBounds = NO;
		[self.view addSubview:tblView];
		
	}
	
	tblView.backgroundColor = [UIColor clearColor];
	tblView.frame = CGRectMake(0, 43 , self.view.bounds.size.width, self.view.bounds.size.height - 43 );
	
	
	
	self.title = @"干部测评";
	UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kEachViewController_Width, 43)];
	titleView.image = [UIImage imageNamed:@"master_title_view_bg.png"];
	[self.view addSubview:titleView];
	[titleView release];
	
	CGSize szTitle = [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20]];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (43-szTitle.height)/2.0, szTitle.width, szTitle.height)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20];
	titleLabel.text = self.title;
	[self.view addSubview:titleLabel];
	[titleLabel release];
	resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:@"SELECT * FROM ganbufenxi where level = 1"]];
	//NSLog(@"resultArray=====%@",resultArray);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[[delegate tabBarController] setBadgeValue:nil index:KTabIndex_Feed_AND_Checkins];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	[[delegate tabBarController] setBadgeValue:@"53" index:1];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[delegate tabBarController] setBadgeValue:nil index:1];

}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


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
	cell.textLabel.text = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"title"];
	cell.tag =[[[resultArray objectAtIndex:indexPath.row]objectForKey:@"id"]intValue];//[[[[resultArray objectAtIndex:indexPath.row]allObjects] objectAtIndex:0]intValue];
	//NSLog(@"[resultArray count]===%d",[[[resultArray objectAtIndex:indexPath.row]objectForKey:@"id"]intValue]);
	//NSLog(@"cell.tag=====%d",cell.tag);

    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	////NSLog(@"NSIndexPathLast = %@", [tableView indexPathForSelectedRow]);
	////NSLog(@"NSIndexPathWillSelect = %@", indexPath);
	
	if ([tableView indexPathForSelectedRow] == indexPath)
	{
		if ([[[[delegate tabBarController]detailController]view]superview])
		{
			[[delegate tabBarController] hideDetailController:YES];
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return nil;
	}
	
	return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSString *contentName;
	contentName = [[resultArray objectAtIndex:indexPath.row]objectForKey:@"name"];
		
	if ([contentName hasSuffix:@".doc"])
	{
		
		if (dwe) 
		{
			[dwe.view removeFromSuperview];
			[dwe release];
		}
		dwe = [[DistinguishWordOrExcel alloc] init];
		dwe.tit = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
		dwe.condition = [[tableView cellForRowAtIndexPath:indexPath]tag];
		dwe.tableName = @"ganbufenxi";
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
		
		//添加手势 向右滑的手势
		dwe.view.userInteractionEnabled = YES;
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
		swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
		[dwe.view addGestureRecognizer:swipeGesture];
		[swipeGesture release];
	}
	else if([contentName hasSuffix:@".xls"])
	{
		//NSLog(@"conddition:%d",[[[resultArray objectAtIndex:indexPath.row]objectForKey:@"id"] intValue]);
		if (myExcelController) {
			NSLog(@"exist myExcelController");
			[myExcelController release];
		}
		 myExcelController = [[DisplayExcelController alloc] init];

		myExcelController.tableName = @"ganbufenxi";		
		myExcelController.condition = [[[resultArray objectAtIndex:indexPath.row]objectForKey:@"id"] intValue];
		
	    myExcelController.view.frame = CGRectMake(1024, 0, 1024, 768);	
		UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];		
		[navagation.view addSubview:myExcelController.view];
		CGRect endFrame = CGRectMake(0, 0, 1024, 768);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		myExcelController.view.frame = endFrame;
		[UIView commitAnimations];
		
		
		//添加手势 向右滑的手势
	/*	myExcelController.view.userInteractionEnabled = YES;
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
		swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
		[myExcelController.view addGestureRecognizer:swipeGesture];
		[swipeGesture release];
		*/
		
		
		
		
		
		
		
	}

		
  
	
	

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


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	tblView.frame = CGRectMake(0, 43.0, self.view.frame.size.width, self.view.frame.size.height-43.0);
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	if (myExcelController) {
		[myExcelController release];
	}
    [super dealloc];
}


@end

