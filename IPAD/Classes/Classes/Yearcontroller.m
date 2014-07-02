    //
//  Yearcontroller.m
//  IPAD
//
//  Created by  careers on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Yearcontroller.h"


@implementation Yearcontroller
@synthesize pictureArray,yearArray;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CGRect frame = self.view.frame;
	tv = [[UITableView alloc] initWithFrame:frame];
	tv.delegate = self;
	tv.dataSource = self;
	[self.view addSubview:tv];
}
#pragma mark -
#pragma mark Table view data source
//UITableView代理方法,返回section中cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pictureArray count];
}

//UITableView代理方法,返回section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.yearArray count];
}

//UITableView代理方法,设置section的title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.yearArray objectAtIndex:section];
}

//UITableView代理方法,加载cell视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.text = [pictureArray objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	return cell;
}
#pragma mark -
#pragma mark Table view delegate
//UITableView代理方法,cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"picture" object:indexPath];
}

//UITableView代理方法,返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

//UITableView代理方法,返回section高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
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
- (void)dealloc {
    [super dealloc];
}
@end