//
//  ProfileController.h
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistinguishWordOrExcel.h"
#import "DisplayExcelController.h"


@interface ProfileController : UIViewController
<UITableViewDelegate,
UITableViewDataSource>{
	NSMutableArray *resultArray;
	UITableView *tblView;
	DistinguishWordOrExcel *dwe;
	
	DisplayExcelController *myExcelController;

}

@property(nonatomic, assign) id *delegate;
@property(nonatomic, retain) UITableView *tblView;

@end
