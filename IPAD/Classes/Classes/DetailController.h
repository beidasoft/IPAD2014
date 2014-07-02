//
//  DetailController.h
//  LLTTabBarController
//
//  Created by kindy_imac on 12-1-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DetailController : UITableViewController<UIScrollViewDelegate> {
	NSMutableArray *resultArray;
	BOOL           isHasChild;
	NSIndexPath    *selectedIndex;
	UITableViewCell *selectCell;
}
@property(nonatomic,assign)id *delegate;
@property(nonatomic,retain)NSString *tit;
@property(nonatomic,assign)NSString *condition;
@property(nonatomic,assign)int titCondition;
@property(nonatomic)BOOL isHasChild;
@property(nonatomic,assign)UITableViewCell *selectCell;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 根据字符大小和lable宽度，计算字符串有几行
 @param       string：字符串；size：字体大小；width：lable的宽度
 @result      字符串所占的行数
 */
-(int)autoHeight:(NSString *)string fontSize:(int)size labelWidth:(int)width;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 进入下层子单位的按钮的单击事件
 @param       无
 @result      无
 */
-(void)showInfos:(id)sender;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 手向右滑，视图消失
 @param       无
 @result      无
 */
- (void)detailSwipeFromLeft;
@end
