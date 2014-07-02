//
//  GBMCThirdController.h
//  IPAD
//
//  Created by  careers on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailInfosController.h"
#import "ConnectController.h"
#import "CompanyInfo.h"

@interface GBMCThirdController : UITableViewController 
{
	NSMutableArray *resultArray;
	DetailInfosController *sc;
	ConnectController *ic;
}
@property(nonatomic, assign) id *delegate;
@property(nonatomic, copy) NSString *tit;
@property(nonatomic,assign)NSString *condition;
@property(nonatomic,retain)NSMutableArray *resultArray;
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
 @description 手向右滑，视图消失
 @param       无
 @result      无
 */
- (void)detailSwipeFromLeft;

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
 @description 查询数据库,添加、显示新视图
 @param       无
 @result      无
 */
-(void)show;
@end
