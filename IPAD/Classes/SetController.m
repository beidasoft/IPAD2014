//
//  SetController.m
//  IPAD
//
//  Created by yang on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SetController.h"

@implementation SetController
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle
// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.scrollEnabled = NO;
    cellTitleArray = [[NSMutableArray alloc] init];
    [cellTitleArray addObject:@"修改密码"];
    [cellTitleArray addObject:@"数据安全"];
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source
//UITableView代理，返回tableview中section个数
// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//UITableView代理，返回tableview的section中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

//UITableView代理，tableview中加载cell的view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSLog(@"cellTitleArray ==== %@,indexPath.row ==== %d",cellTitleArray,indexPath.row);
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[cellTitleArray objectAtIndex:indexPath.row]];
    return cell;
}
//UITableView代理，返回tableview的cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark -
#pragma mark Table view delegate
//UITableView代理，tableview的cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
//   [[NSNotificationCenter defaultCenter] postNotificationName:@"selected" object:nil]; 
    [self.delegate popoForTouch:indexPath.row];
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
    [cellTitleArray release];
	[super dealloc];
}


@end

