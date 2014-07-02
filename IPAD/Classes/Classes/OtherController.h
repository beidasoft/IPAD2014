//
//  OtherController.h
//  IPAD
//
//  Created by  careers on 12-2-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistinguishWordOrExcel.h"
#import "DisplayExcelController.h"


@interface OtherController : UIViewController 
<UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate>
{
	UITableView *tblView;
	UITableView *subTblView;
	UIImageView *imageViewBg;
	NSMutableArray *resultArray;
	
	BOOL isSecondpage;
	
	//DistinguishWordOrExcel *dwe;
	int linesNumber;
	
	NSString *titleString;//每个cell中显示的字符串
	
	UITableViewCell *selectedCell;
	NSIndexPath *selectIndexPath;
	NSIndexPath *oldIndexPath;
}
@property(nonatomic, assign) id *delegate;
@property(nonatomic, copy) NSString *tit;
@property(nonatomic, assign) int condition;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 根据字符大小和lable宽度，计算字符串有几行
 @param       string：字符串；size：字体大小；width：lable的宽度
 @result      字符串所占的行数
 */
-(int)autoHeight:(NSString *)string fontSize:(int)size labelWidth:(int)width;


-(void)deselected;


- (void)detailSwipeFromLeft;
@end
