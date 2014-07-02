//
//  ZGZLFirstController.h
//  IPAD
//
//  Created by yang on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZGZLFirstController : UIViewController 
<UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate>
{
	BOOL bLandScape;
	
	UITableView *tblView;
	UIImageView *imageViewBg;
	
	NSMutableArray *resultArray;
}
@property(nonatomic, retain) UITableView *tblView;
@property(nonatomic, assign) id *delegate;
@end
