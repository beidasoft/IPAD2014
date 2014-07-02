//
//  BianZhiInfoController.h
//  IPAD
//
//  Created by  careers on 12-5-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BianZhiInfoController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *bianzhiTabView;
    NSString *banziCompany;
	NSMutableArray *bianzhiResultArray;
    NSMutableArray *mingchengArr;
    NSMutableArray *yingpeiArr;
    NSMutableArray *shipeiArr;
    NSMutableArray *chaoqueArr;
	UIImageView *contentOut2;
	NSString *tit;
}
@property(nonatomic,retain) NSMutableArray *bianzhiResultArray;
@property(nonatomic,retain) NSString       *tit;
@property(nonatomic,retain) UIImageView    *contentOut2;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 根据字符大小和lable宽度，计算字符串有几行
 @param       string：字符串；size：字体大小；width：lable的宽度
 @result      字符串所占的行数
 */
-(int)autoHeight:(NSString *)string fontSize:(int)size labelWidth:(int)width;

//设置属性bianzhiResultArray的值
/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 设置属性bianzhiResultArray的值
 @param       resultArray：编制信息
 @result      无
 */
-(void)setBianzhiResultArray:(NSMutableArray *)resultArray;
@end
