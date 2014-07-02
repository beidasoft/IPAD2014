    //
//  DNFXController.m
//  IPAD
//
//  Created by  careers on 12-2-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DNFXController.h"
#import "MPTabBarController.h"
#import "SQLiteOptions.h"



@implementation DNFXController
@synthesize tblView,delegate;

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
	titleLabel.text = @"党内分析";
	[titleView addSubview:titleLabel];
	[titleLabel release];
	
	
	resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:@"SELECT * FROM dangneifenxi where perant_id = -1"]];
	
}


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
	cell.tag =[[[[resultArray objectAtIndex:indexPath.row]allObjects] objectAtIndex:1]intValue];

    // Configure the cell...
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

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
#pragma mark Memory management

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	DNFXSecondController *dc = [[DNFXSecondController alloc] initWithStyle:UITableViewStylePlain];
	
	dc.tit = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
	
	dc.condition = [[tableView cellForRowAtIndexPath:indexPath]tag];

	
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
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
