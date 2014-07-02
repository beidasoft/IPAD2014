
//
//  DetailController.h
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistinguishWordOrExcel.h"
#import "DisplayExcelController.h"

@interface GBFXSecond : UITableViewController {
	NSMutableArray *resultArray;
	DistinguishWordOrExcel *dwe;
}
@property(nonatomic, assign) id *delegate;
@property(nonatomic, copy) NSString *tit;
@property(nonatomic, assign) int condition;
@end
