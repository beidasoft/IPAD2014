//
//  HistoryListController.m
//  IPAD
//
//  Created by  careers on 12-5-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryListController.h"
#import "Utilities.h"


@implementation HistoryListController
@synthesize historyArray;
@synthesize isCleared;

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

// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set. Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.

- (void)viewDidLoad 
{
    [super viewDidLoad];
	UIImageView *headerView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 350, 45)];
	headerView.image = [UIImage imageNamed:@"historylist.png"];
	headerView.userInteractionEnabled = YES;
	self.tableView.tableHeaderView = (UIView *)headerView;
	clearButton = [[UIButton alloc] initWithFrame:CGRectMake(270,5,70, 35)];
	[clearButton setBackgroundImage:[UIImage imageNamed:@"clearButton.png"]
						   forState:UIControlStateNormal];
	[clearButton addTarget:self
					action:@selector(clearSomeOne)
		  forControlEvents:UIControlEventTouchUpInside];
	clearButton.backgroundColor = [UIColor clearColor];
	[headerView addSubview:clearButton];
	[headerView release];
}

//弹出确认清空记录的alert视图
-(void)clearSomeOne
{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"确认清空历史记录？"
													message:nil
												   delegate:self
										  cancelButtonTitle:@"否"
										   otherButtonTitles:@"是",nil] autorelease];
	[alert show];
}
#pragma mark -
#pragma mark UIAlertView delegate
//UIAlertView的点击代理实现方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (buttonIndex==1)
   {
	   NSMutableArray *tempHistoryArray = [NSMutableArray arrayWithContentsOfFile:[Utilities documentsPath:@"historyFile.plist"]];
	   [[historyArray objectAtIndex:0]removeAllObjects];
	   [[historyArray objectAtIndex:1]removeAllObjects];
	   [[historyArray objectAtIndex:2]removeAllObjects];
	   [tempHistoryArray removeAllObjects];
	   [tempHistoryArray writeToFile:[Utilities documentsPath:@"historyFile.plist"] atomically:YES];
	   [self.tableView reloadData];
	   isCleared = YES;
   }
	else
	{
		isCleared = NO;	
	}

}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}
#pragma mark -
#pragma mark Table view data source
//UITableView代理，返回UITableView的section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

//UITableView代理，返回UITableView中section的title值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *timeString;
   if (section == 0)
   {
	   timeString = @"今天";
   }
   else if(section == 1)
   {
	   timeString = @"本周";
   }
   else if(section == 2)
   {
       timeString = @"更早";
   }
	return timeString;

}

//UITableView代理，返回UITableView的section中cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0)
	{
		return [[historyArray objectAtIndex:0] count]+1;
	}
	else if(section==1)
	{
		return [[historyArray objectAtIndex:1] count]+1;
	}
	else 
	{
		return [[historyArray objectAtIndex:2] count]+1;
	}
}

//UITableView代理，返回UITableView的cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row==0)
   {
	   return 40;
   }
	else {
		return 50;
	}

}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	else
	{
		for(UILabel *ul in [cell subviews])
		{
		   if ([ul isKindOfClass:[UILabel class]])
		   {
			   [ul removeFromSuperview];
		   }
			else if([ul isKindOfClass:[UIImageView class]])
			{
				[ul removeFromSuperview];
			}
		}
	}
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.accessoryType = UITableViewCellAccessoryNone;
    // Configure the cell...
	if (indexPath.row==0)
	{
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 350, 40)];
		image.image = [UIImage imageNamed:@"keyWord.png"];
		[cell addSubview:image];
		[image release];
		
	}
	else
	{
		UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 150, 40)];
		label1.textAlignment = UITextAlignmentLeft;
		label1.backgroundColor = [UIColor clearColor];
		label1.tag = 44;
		label1.font = [UIFont boldSystemFontOfSize:20];
		UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 150, 40)];
		label2.textAlignment = UITextAlignmentCenter;
		label2.backgroundColor = [UIColor clearColor];
		label2.tag = 55;
		label2.font = [UIFont boldSystemFontOfSize:20];
		[cell addSubview:label1];
		[cell addSubview:label2];
		[label1 release];
		[label2 release];
		
		if (indexPath.section==0)
		{
			label1.text = [[[[historyArray objectAtIndex:0] objectAtIndex:indexPath.row-1] allValues] objectAtIndex:0];
			label2.text = [[[[historyArray objectAtIndex:0] objectAtIndex:indexPath.row-1] allKeys] objectAtIndex:0];

		}
		else if (indexPath.section==1)
		{
			label1.text = [[[[historyArray objectAtIndex:1] objectAtIndex:indexPath.row-1] allValues] objectAtIndex:0];
			label2.text = [[[[historyArray objectAtIndex:1] objectAtIndex:indexPath.row-1] allKeys] objectAtIndex:0];
		}
		else
		{
			label1.text = [[[[historyArray objectAtIndex:2] objectAtIndex:indexPath.row-1] allValues] objectAtIndex:0];
			label2.text = [[[[historyArray objectAtIndex:2] objectAtIndex:indexPath.row-1] allKeys] objectAtIndex:0];
		}
	}
      return cell;
}

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return  UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable. Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return NO;
    }
	else {
		return YES;
	}
    
}

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{  
    return YES;
}

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change. After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:[Utilities documentsPath:@"historyFile.plist"]];
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        if (indexPath.section==0)
		{
			if (indexPath.row!=0)
			{
				for(int i=0;i<[tempArray count];i++)
				{
					if ([[[tempArray objectAtIndex:i] objectAtIndex:0] isEqualToString:[[[[historyArray objectAtIndex:0] objectAtIndex:indexPath.row-1]allValues]objectAtIndex:0]])
					{
						[tempArray removeObjectAtIndex:i];
					}
				}
				[[historyArray objectAtIndex:0] removeObjectAtIndex:indexPath.row-1];
				
			}
		}
		else if(indexPath.section==1)
		{
			if (indexPath.row!=0)
			{
				for(NSMutableArray *ma in tempArray)
				{
					if ([[ma objectAtIndex:0] isEqualToString:[[historyArray objectAtIndex:0] objectAtIndex:indexPath.row-1]])
					{
						[tempArray removeObject:ma];
					}
				}
				[[historyArray objectAtIndex:1] removeObjectAtIndex:indexPath.row-1];
				
			}
		}
		else
		{
			if (indexPath.row!=0)
			{
				for(NSMutableArray *ma in tempArray)
				{
					if ([[ma objectAtIndex:0] isEqualToString:[[historyArray objectAtIndex:0] objectAtIndex:indexPath.row-1]])
					{
						[tempArray removeObject:ma];
					}
				}
				[[historyArray objectAtIndex:2] removeObjectAtIndex:indexPath.row-1];
				
			}
		}
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tempArray writeToFile:[Utilities documentsPath:@"historyFile.plist"] atomically:YES];
    }   
}



#pragma mark -
#pragma mark Table view delegate

int selectedCount = 0;

//UITableView代理，UITableView的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
  if (indexPath.row!=0)
  {
	  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	  NSString *keyword = [(UILabel *)[cell viewWithTag:44] text];
	  NSString *sort = [(UILabel *)[cell viewWithTag:55]text];
	  NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:keyword,sort,nil];
	  [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSearchContent" object:infoArray];
	 /* if ([[selectedCellArray allKeys] containsObject:indexPath])
	  {
			for(UIView *v in [cell subviews])
			  {
				  if ([v isKindOfClass:[UILabel class]])
				  {
					  UILabel *temp = (UILabel *)v;
					  temp.textColor = [UIColor blackColor];
				  }
				  else if ([v isKindOfClass:[UIImageView class]])
				  {
					  [v removeFromSuperview];
				  }
			  }
		  [selectedCellArray removeObjectForKey:indexPath];
	  }
	  else
	  {
		  if (currentSelectRow == indexPath.row)
		  {
			  selectedCount++;
			  if (selectedCount%2==0)
			  {
				  for(UIView *v in [cell subviews])
				  {
					  if ([v isKindOfClass:[UILabel class]])
					  {
						  UILabel *temp = (UILabel *)v;
						  temp.textColor = [UIColor blackColor];
					  }
					  else if ([v isKindOfClass:[UIImageView class]])
					  {
						  [v removeFromSuperview];
					  }
				  }
				  [selectedCellArray removeObjectForKey:indexPath];
				  selectedCount = 0;
			  }
			  else
			  {
				  for(UIView *v in [cell subviews])
				  {
					  if ([v isKindOfClass:[UILabel class]])
					  {
						  UILabel *temp = (UILabel *)v;
						  temp.textColor = [UIColor colorWithRed:25.0f/255 green:76.0f/255 blue:139.0f/255 alpha:1.0];//r:25  G:76  B:139
					  }
				  }
				  UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 20, 20)];
				  selectImageView.image = [UIImage imageNamed:@"vv.png"];
				  [cell addSubview:selectImageView];
				  [selectImageView release];
				  
				  NSString *keyword = [(UILabel *)[cell viewWithTag:44] text];
				  NSString *sort = [(UILabel *)[cell viewWithTag:55]text];
				  NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:keyword,sort,nil];
				  
				  [selectedCellArray setObject:infoArray forKey:indexPath];
			  }
		  }
		  else
		  {
			  for(UIView *v in [cell subviews])
			  {
				  if ([v isKindOfClass:[UILabel class]])
				  {
					  UILabel *temp = (UILabel *)v;
					  temp.textColor = [UIColor colorWithRed:25.0f/255 green:76.0f/255 blue:139.0f/255 alpha:1.0];//r:25  G:76  B:139
				  }
			  }
			  UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 20, 20)];
			  selectImageView.image = [UIImage imageNamed:@"vv.png"];
			  [cell addSubview:selectImageView];
			  [selectImageView release];
			  
			  NSString *keyword = [(UILabel *)[cell viewWithTag:44] text];
			  NSString *sort = [(UILabel *)[cell viewWithTag:55]text];
			  NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:keyword,sort,nil];
			  
			  [selectedCellArray setObject:infoArray forKey:indexPath];
		  }
	  }
	  currentSelectRow = indexPath.row;*/
  }
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	for(UIView *v in [cell subviews])
//	{
//		if ([v isKindOfClass:[UILabel class]])
//		{
//			UILabel *temp = (UILabel *)v;
//			temp.textColor = [UIColor blackColor];
//		}
//		else if ([v isKindOfClass:[UIImageView class]])
//		{
//			[v removeFromSuperview];
//		}
//	}
//	[selectedCellArray removeObjectForKey:indexPath];
//}

#pragma mark -
#pragma mark Memory management

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc. Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

//对象释放
- (void)dealloc
{
	//[selectedCellArray release];
	[clearButton release];
    [super dealloc];
}


@end

