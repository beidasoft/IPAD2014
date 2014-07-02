//
//  DetailInfosController.m
//  IPAD
//
//  Created by  careers on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailInfosController.h"
#import "SecondMainController.h"
#import "SQLiteOptions.h"
#import "PersonsInfo.h"
#import "ResumeViewController.h"
@implementation DetailInfosController
@synthesize delegate,tit,condition,collation,personsArray,sectionsArray;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	if (nil == detailTabView)
	{
		CGRect rcTable = CGRectMake(170, 140 ,830, 600);
		detailTabView = [[UITableView alloc] initWithFrame:rcTable];//style:UITableViewStylePlain];
		detailTabView.delegate = self;
		detailTabView.dataSource = self;
		detailTabView.backgroundColor = [UIColor whiteColor]; // kTableBackgroundColor;
		detailTabView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.5]; // [UIColor greenColor];
		detailTabView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -20, -20);
		detailTabView.clipsToBounds = YES;
		detailTabView.bounces = NO;
		//detailTabView.
		
	}
	//detailTabView = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	//detailTabView.title = self.tit;
	NSString *sql = [NSString stringWithFormat:@"select * from persons where parent_id = %d limit 0,100",self.condition];
	resultArray = [[NSMutableArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions]queryWithSQL:sql]];
	
	/*detailTabView.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithTitle:@"返回" 
																			   type:KNAV_BARBUTTONITEM_TYPE_LEFT_Arrow 
																			 target:detailTabView.navigationController 
	NSLOGaction:@selector(popBackAnimated)];*/
	NSMutableArray *personInfos = [[NSMutableArray alloc]init];
	//NSArray *personsInfo = [resultArray copy];//[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql];
    for(int i=0;i<[resultArray count];i++)
	{ 
		NSMutableArray *infoArr = [[NSMutableArray alloc]init];
		NSString *nameContent = [[resultArray objectAtIndex:i]objectForKey:@"name"];
		[infoArr addObject:nameContent];
		NSString *pinyinContent = [[resultArray objectAtIndex:i] objectForKey:@"pinyin"];
		[infoArr addObject:pinyinContent];
		NSString *detailinfoContent = [[resultArray objectAtIndex:i] objectForKey:@"detailInfo"];
		[infoArr addObject:detailinfoContent];
		NSString *detailInfos = [[resultArray objectAtIndex:i] objectForKey:@"detailInfos"];
		[infoArr addObject:detailInfos];
		NSString *image = [NSString stringWithFormat:@"data:image/png;base64,%@",[[resultArray objectAtIndex:i]
																				  objectForKey:@"image"]];
		[infoArr addObject:image];
		[personInfos addObject:infoArr];
		[infoArr release];

		
	}
	
	NSMutableArray *persons = [[NSMutableArray alloc] initWithCapacity:[personInfos count]];
	for (int i=0;i<[personInfos count];i++)
	{
		PersonsInfo *personWrapper =  [[PersonsInfo alloc] initWithData:[[personInfos objectAtIndex:i] objectAtIndex:0] 
																 PinYIn:[[personInfos objectAtIndex:i] objectAtIndex:1] 
															 detailInfo:[[personInfos objectAtIndex:i] objectAtIndex:2] 
															detailInfos:[[personInfos objectAtIndex:i] objectAtIndex:3]
																  image:[[personInfos objectAtIndex:i] objectAtIndex:4]];
		[persons addObject:personWrapper];
		[personWrapper release];
	}
	
	
	[self setPersonsArray:persons];
	
	//[self configureSections];
	self.view.backgroundColor = [UIColor clearColor];
	UIImageView *scBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	scBg.image = [UIImage imageNamed:@"jianlibg.png"];
	[self.view addSubview:scBg];
	
	UIImageView *titleBg = [[UIImageView alloc]initWithFrame:CGRectMake(45, 100, 55, 120)];
	titleBg.image = [UIImage imageNamed:@"mingceziliao.png"];
	[self.view addSubview:titleBg];
	[self.view addSubview:detailTabView];
	[persons release];
	[titleBg release];
	[scBg release];
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 698, 80, 70)];
    [backButton setImage:[UIImage imageNamed:@"thirdBack.png"]
				forState:UIControlStateNormal];
	[backButton addTarget:self 
				   action:@selector(back)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	[backButton release];
	
	resumeController=[[ResumeViewController alloc]init];
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:resumeController action:@selector(moveRight)];
	swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
	[resumeController.view addGestureRecognizer:swipeGesture];
	[swipeGesture release];
	
	
	letterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(512,
																	350, 100, 100)];
	timer = nil;
	[self.view addSubview:letterImageView];
	UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(180, 90, 300, 50)];
	titleName.font = [UIFont systemFontOfSize:24];
	titleName.backgroundColor = [UIColor clearColor];
	titleName.textColor = [UIColor whiteColor];
	titleName.text = self.tit;
	[self.view addSubview:titleName];
	[titleName release];
	
}

- (void)back
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
   return ([validSectionArray count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSArray *personsInSection = [sectionsArray objectAtIndex:[[validSectionArray objectAtIndex: section]intValue]];
	
    return [personsInSection count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	else {
		for (UIView *subView in [cell subviews]) {
			[subView removeFromSuperview];
		}
	}

	//cell.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 230)];
	

	UIImageView *img =[[UIImageView alloc]init];//WithFrame:CGRectMake(10, 60, 400, 100)];
	img.image = [UIImage imageNamed:@"mingceBg.png"];
	cell.backgroundView = (UIView*)img;
	[img release];
	UIImageView *personImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, KPICTURERECT_WIDTH, KPICTURERECT_HEIGHT)];
	[cell addSubview:personImg];
	
	
	NSArray *personsInSection = [sectionsArray objectAtIndex:[[validSectionArray objectAtIndex:indexPath.section]intValue]];
	PersonsInfo *person ;
	
	
		
	person= [personsInSection objectAtIndex:indexPath.row];
	
		
	
	UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(160, 2, 100, 50)];
	nameLable.backgroundColor = [UIColor clearColor];
	nameLable.tag=111;
	nameLable.text = person.name;
	[nameLable setFont:[UIFont boldSystemFontOfSize:26]];
	[cell addSubview:nameLable];
	[nameLable release];
	
	UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(160, 60, 500, 20)];
	infoLable.backgroundColor = [UIColor clearColor];
	infoLable.text = person.detailInfo;
	[infoLable setFont:[UIFont boldSystemFontOfSize:23]];
	[cell addSubview:infoLable];
	[infoLable release];
	
	
	UILabel *InfosLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 65,600 ,140)];
	InfosLabel.backgroundColor = [UIColor clearColor];
	InfosLabel.text = person.detailInfos;
	InfosLabel.numberOfLines= 3;
	[InfosLabel setFont:[UIFont boldSystemFontOfSize:23]];
	[cell addSubview:InfosLabel];
	[InfosLabel release];

	NSURL *url = [NSURL URLWithString:person.image];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *ret = [UIImage imageWithData:imageData];
	[personImg setImage:ret];
	[personImg release];
	//NSLog(@"cell ====%@",[])
	
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UILabel *nameLabel=(UILabel *)[cell viewWithTag:111];
	NSString *nameString=nameLabel.text;
	
	resumeController.view.frame=CGRectMake(1024, 0, 1024, 768);
	resumeController.personName=nameString;
	[resumeController loadInfomation:nameString];
	UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	if (![resumeController.view superview]) {
		[navagation.view addSubview:resumeController.view];
	}


	
	resumeController.view.tag = 150;
	[UIView beginAnimations:nil context:resumeController.view];
	[UIView setAnimationDuration:1];
	[UIView setAnimationRepeatCount:1];
	resumeController.view.frame=CGRectMake(0, 0, 1024, 768);
	[UIView commitAnimations];
	


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 210;
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	//NSLog(@"sectionIndexTitlesForTableView444444444");
	
	return [collation sectionIndexTitles];

}
- (void)setPersonsArray:(NSMutableArray *)newDataArray {
	if (validSectionArray==nil)
	{
		validSectionArray = [[NSMutableArray alloc]init];
	}
	if (newDataArray != personsArray) {
		[personsArray release];
		personsArray = [newDataArray retain];
	}
	if (personsArray == nil) {
		self.sectionsArray = nil;
	}
	else {
		[self configureSections];
	}
}


- (void)configureSections 
{
	
	// Get the current collation and keep a reference to it.
	
	self.collation = [UILocalizedIndexedCollation currentCollation];
	NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	
	// Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
	
	// Segregate the time zones into the appropriate arrays.
	for (PersonsInfo *person in personsArray) {
		
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [collation sectionForObject:person collationStringSelector:@selector(namePinyin)];
	
		// Get the array for the section.
		NSMutableArray *sectionPersons = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the time zone to the section.
		[sectionPersons addObject:person];
	}
	
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *personsArrayForSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedPersonsArrayForSection = [collation sortedArrayFromArray:personsArrayForSection collationStringSelector:@selector(namePinyin)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedPersonsArrayForSection];
	}
	
	self.sectionsArray = newSectionsArray;
	[newSectionsArray release];	
	
	
	for (int i=0; i<[sectionsArray count]; i++)
	{
		//NSIndexPath *path = [NSIndexPath indexPathWithIndex:i];
		NSArray *personsInSection = [sectionsArray objectAtIndex:i];
		if (0 == [personsInSection count])
		{
		}
		else {
			[validSectionArray addObject:[NSNumber numberWithInt:i]];
			
			//for (int j= 0; j<[personsInSection count]; j++)
//			{
//				PersonsInfo *person = [personsInSection objectAtIndex:j];
//			}
			
			
		}
		
	}
	
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [[collation sectionTitles] objectAtIndex:[[validSectionArray objectAtIndex:section]intValue]];
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (![letterImageView superview]) 
	{
		[self.view addSubview:letterImageView];
	}
	
	if (timer == nil) {
		
	}
	else 
	{
		[timer invalidate];
		timer = nil;
	
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:1
											 target:self
										   selector:@selector(removieLetterView)
										   userInfo:nil
											repeats:NO];

	
	
	
	letterImageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@.png",title]];
	
	for (int i=0; i<[validSectionArray count]; i++)
	{
		if ([[validSectionArray objectAtIndex:i] intValue] == index)
		{
			
			return i;
		}
	}
	return -1;
}


- (void)removieLetterView
{
	if ([letterImageView superview]) {
		[letterImageView removeFromSuperview];
	}
	timer = nil;
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

