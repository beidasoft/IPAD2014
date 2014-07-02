//
//  DNFXController.h
//  IPAD
//
//  Created by  careers on 12-2-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"DNFXSecondController.h"


@interface DNFXController : UIViewController
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
