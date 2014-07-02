//
//  HistoryController.h
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailController.h"
#import "CompanyInfo.h"


@interface HistoryController : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate>

{
	BOOL bLandScape;
	
	UITableView *tblView;
	UIImageView *imageViewBg;
	
	NSMutableArray *resultArray;
	NSIndexPath *currentIndex;
	DetailController *dc;
}
@property(nonatomic, retain) UITableView *tblView;
@property(nonatomic, assign) id *delegate;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 根据字符大小和lable宽度，计算字符串有几行
    @param       string：字符串；size：字体大小；width：lable的宽度
    @result      字符串所占的行数
*/
-(int)autoHeight:(NSString *)string fontSize:(int)size labelWidth:(int)width;
@end
