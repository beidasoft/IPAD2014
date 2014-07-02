

//
//  SecondController.m
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GBFXThird.h"
#import "SecondMainController.h"
#import "SQLiteOptions.h"

@implementation GBFXThird

@synthesize delegate,tit,condition;
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
	
	self.title = self.tit;
	NSString *sql = [NSString stringWithFormat:@"select * from ganbuceping where parent_id = %d",self.condition];
	resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql]];
	
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
	//cell.textLabel.text = [NSString stringWithFormat:@"%@ %d", self.title, indexPath.row];
	cell.textLabel.text = [[resultArray objectAtIndex:indexPath.row] objectForKey:@"title"];
	cell.tag = [[[[resultArray objectAtIndex:indexPath.row] allObjects] objectAtIndex:1] intValue];
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
		dwe.condition = [[[resultArray objectAtIndex:indexPath.row]objectForKey:@"id"]intValue];
		NSLog(@"gbfenxi=====%d",dwe.condition);
		dwe.tableName = @"ganbuceping";
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
		NSLog(@"conddition:%d",[[[resultArray objectAtIndex:indexPath.row]objectForKey:@"id"] intValue]);
		DisplayExcelController *myExcelController = [[DisplayExcelController alloc] init];
		
		myExcelController.tableName = @"ganbuceping";		
		myExcelController.condition = [[[resultArray objectAtIndex:indexPath.row]objectForKey:@"id"] intValue];
		
	    myExcelController.view.frame = CGRectMake(1024, 0, 1024, 768);	
		UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];		
		[navagation.view addSubview:myExcelController.view];
		CGRect endFrame = CGRectMake(0, 0, 1024, 768);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		myExcelController.view.frame = endFrame;
		[UIView commitAnimations];
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
}


@end

