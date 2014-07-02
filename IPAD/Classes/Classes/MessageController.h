//
//  MessageController.h
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBNTSecond.h"

@interface MessageController : UIViewController
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
