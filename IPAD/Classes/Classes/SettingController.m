    //
//  SettingController.m
//  IPAD
//
//  Created by yang on 12-2-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingController.h"
#import "DNTJController.h"
#import "MPTabBarController.h"

@implementation SettingController

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
		tblView.backgroundColor = [UIColor whiteColor]; // kTableBackgroundColor;
		//		tblView.separatorColor =[UIColor lightGrayColor];
		//tblView.separatorColor =[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		tblView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; // [UIColor greenColor];
		tblView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
		tblView.clipsToBounds = NO;
		[self.view addSubview:tblView];
		
	}
	
	tblView.backgroundColor = [UIColor clearColor];
	tblView.frame = CGRectMake(0, 43 , self.view.bounds.size.width, self.view.bounds.size.height - 43 );
	
	
	
	UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 5 , 320, 35.0)];
	labelTitle.backgroundColor = [UIColor clearColor];
	labelTitle.textColor = [UIColor blackColor];
	labelTitle.font = [UIFont boldSystemFontOfSize:20];
    labelTitle.text = @"历史" ; //self.title;
	labelTitle.textAlignment = UITextAlignmentLeft;
	[imageViewBg addSubview:labelTitle];
	[labelTitle release];
	
	
	UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kEachViewController_Width, 43)];
	titleView.image = [UIImage imageNamed:@"master_title_view_bg.png"];
	[self.view addSubview:titleView];
	[titleView release];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 400, 20)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20];
	titleLabel.text = @"党内统计";
	[titleView addSubview:titleLabel];
	[titleLabel release];
	
	
	resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:@"SELECT * FROM dangneitongji where parent_id = -1"]];
		
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
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
	
	
	cell.textLabel.text = [[resultArray objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	cell.tag =[[[[resultArray objectAtIndex:indexPath.row]allObjects] objectAtIndex:0]intValue];
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	////NSLog(@"NSIndexPathLast = %@", [tableView indexPathForSelectedRow]);
	////NSLog(@"NSIndexPathWillSelect = %@", indexPath);
	
	if ([tableView indexPathForSelectedRow] == indexPath)
	{
		
		if ([[[[((SecondMainController *)delegate) tabBarController] detailController]view]superview])
		{
			[[delegate tabBarController] hideDetailController:YES];
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return nil;
	}
	
	return indexPath;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	DNTJController *dc = [[DNTJController alloc] initWithStyle:UITableViewStylePlain];
	dc.tit = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
	dc.condition = [[tableView cellForRowAtIndexPath:indexPath]tag];
	NSLog(@"dc.condition==%d",dc.condition);
	MPTabBarController *tabbarController = [delegate tabBarController];
	[tabbarController showDetailController:dc animated:YES];
	[dc release];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	if(!bLandScape)
	{
		NSIndexPath *index = [tblView indexPathForSelectedRow];
		if(index)
		{
			//self.selectedIndexPath = nil;
			[tblView deselectRowAtIndexPath:index animated:YES];
			//[theApp.tabBarController hideDetailController:YES];
		}
		
		if(!scrollView.decelerating && scrollView.dragging)
		{
			[[delegate tabBarController] hideDetailController:YES];
		}
		
	}
}


#pragma mark -
#pragma mark  rotate
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	bLandScape = NO;
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		bLandScape = YES;
	}
	
	
	return YES;
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	////NSLog(@"willAnimateFirstHalfOfRotationToInterfaceOrientation");
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration
{
	////NSLog(@"willAnimateSecondHalfOfRotationFromInterfaceOrientation");
}

- (void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	////NSLog(@"didAnimateFirstHalfOfRotationToInterfaceOrientation");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	////NSLog(@"didRotateFromInterfaceOrientation");
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
	   interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		bLandScape = YES;
	}
	
	else 
	{
		bLandScape = NO;
	}
	
	
	if(bLandScape)
	{
		tblView.frame = CGRectMake(0, 43, self.view.bounds.size.width , self.view.bounds.size.height - 43 );
	}
	
	else 
	{
		tblView.frame = CGRectMake(0, 43, self.view.bounds.size.width, self.view.bounds.size.height - 43 );
	}
	
	
	imageViewBg.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
	
	////NSLog(@"checkinsVIeContollerviweBound = %@", NSStringFromCGRect(self.view.frame));
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
    [super dealloc];
	
	[tblView release];
	[imageViewBg release];
	[resultArray release];
}


@end

