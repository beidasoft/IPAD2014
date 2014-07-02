//
//  PopoChangeViewController.m
//  IPAD
//
//  Created by Careers on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PopoChangeViewController.h"

@interface PopoChangeViewController ()

@end

@implementation PopoChangeViewController
@synthesize changeArray;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(-10, -12, 200, 135)];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView release];
        
    changeTableView = [[UITableView alloc] initWithFrame:CGRectMake(-10, -12, 200, 135) style:UITableViewStyleGrouped];
    changeTableView.backgroundView = bgView;
    changeTableView.delegate = self;
    changeTableView.dataSource = self;
    changeTableView.scrollEnabled = NO;
    
    [self.view addSubview:changeTableView];
    
}

#pragma mark - Table view data source
//UITableView代理，返回section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//UITableView代理，返回section中cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [changeArray count];
}


// returns nil if cell is not visible or index path is out of range
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [self.changeArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    
    return cell;
}

//UITableView代理，返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - Table view delegate
//UITableView代理，tableview的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate changeTableArray:indexPath.row];
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//对象释放
- (void)dealloc{
    [self.changeArray release];
    [changeTableView release];
    [super dealloc];
}
@end
