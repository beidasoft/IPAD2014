//
//  SettingController.h
//  IPAD
//
//  Created by yang on 12-2-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingController : UIViewController 
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
