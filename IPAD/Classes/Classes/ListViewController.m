//
//  ListViewController.m
//  IpadTest
//
//  Created by yang on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "PersonsInfo.h"

@interface ListViewController()
@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;
- (void)configureSections;
@end


@implementation ListViewController

@synthesize	personsArray, sectionsArray, collation,letterImageView;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
		//self.view.frame = CGRectMake(12, 34, 100,934);
		self.view.frame = CGRectMake(195,129,199,608);//112
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle

// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"人员列表";
	letterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50,
																	300, 100, 100)];
	timer = nil;
	
	[[self.view superview] addSubview:letterImageView];
	
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

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return ((interfaceOrientation==UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}


#pragma mark -
#pragma mark Table view data source
//UITableView代理,返回section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    return [validSectionArray count];
}

//UITableView代理,返回section下cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	// The number of time zones in the section is the count of the array associated with the section in the sections array.
	NSArray *personsInSection = [sectionsArray objectAtIndex:[[validSectionArray objectAtIndex:section]intValue]];
	
    return [personsInSection count];
}

//UITableView代理,UITableView的cell视图加载
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Get the time zone from the array associated with the section index in the sections array.
	NSArray *personsInSection = [sectionsArray objectAtIndex:[[validSectionArray objectAtIndex:indexPath.section]intValue]];
	//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//cell.imageView.image = [UIImage imageNamed:@"xuanzhong.png"];
	//UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, cell.frame.size.height)];
	//cellImage.image = [UIImage imageNamed:@"xuanzhong.png"];
	//cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
	// Configure the cell with the time zone's name.
	PersonsInfo *person = [personsInSection objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    UILabel *idlabel = [[UILabel alloc] init];
    [idlabel setHidden:YES];
    idlabel.text = person.personID;
    [cell addSubview:idlabel];
    return cell;
}
/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[collation sectionTitles] objectAtIndex:[[validSectionArray objectAtIndex:section]intValue]];
}

//UITableView代理,返回section的title名称的数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [collation sectionIndexTitles];
}

//UITableView代理,返回section个数
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

//移除letterImageView的视图
- (void)removieLetterView
{
	if ([letterImageView superview]) {
		[letterImageView removeFromSuperview];
	}
	timer = nil;
}

//UITableView代理,返回section的北京视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *titleString = [self tableView:tableView titleForHeaderInSection:section];
	if (titleString == nil)
	{
		return nil;
	}

	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
	UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
	headerImage.image = [UIImage imageNamed:@"Pinyinbg.png"];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
	titleLabel.text = titleString;
	titleLabel.backgroundColor = [UIColor clearColor];
	[headerImage addSubview:titleLabel];
	[headerView addSubview:headerImage];
	[titleLabel release];
	[headerImage release];
	return headerView;
}

//UITableView代理,cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	NSIndexPath *indexPathNext = [NSIndexPath indexPathForRow:indexPath.row + 1
//													inSection:indexPath.section];
	//[tableView cellForRowAtIndexPath:indexPath].imageView.image = [UIImage imageNamed:@"xuan.png"];
    //消息中心，发送消息
	[[NSNotificationCenter defaultCenter] postNotificationName:@"select" object:indexPath];
}


#pragma mark -
#pragma mark Set the data array and configure the section data
//重置personsArray的数据
- (void)setPersonsArray:(NSMutableArray *)newDataArray {
	if (validSectionArray == nil)
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

//tableView的section按字母分栏排序
- (void)configureSections {
	
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
			
		}
		
	}
}


#pragma mark -
#pragma mark Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//    // ...
//    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    [detailViewController release];
//	 */
//}


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
- (void)dealloc {
	[validSectionArray release];
	[letterImageView release];
	[personsArray release];
	[sectionsArray release];
	[collation release];
    [super dealloc];
}


@end

