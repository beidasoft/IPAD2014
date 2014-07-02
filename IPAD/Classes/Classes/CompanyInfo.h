//
//  CompanyInfo.h
//  IPAD
//
//  Created by  careers on 12-2-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "ListViewController.h"
#import "ResumeViewController.h"
#import "Yearcontroller.h"
#import "FormView.h"
#import "BianZhiInfoController.h"


@interface CompanyInfo : UIViewController 
<UITableViewDelegate,
UITableViewDataSource,UIWebViewDelegate,UIPopoverControllerDelegate,UIScrollViewDelegate,stopDelegate>
{
	
	NSString *tit;
	UITableView *xiaoziliaoTabView;
	UITextView *sanfangTextView;
	UIImageView *tongxunBacgroundView;
	UITextView *fengongTextView;
	ContentViewController *content;
	ListViewController *list;
	BianZhiInfoController *bianzhiView;
	
	
	
	NSMutableArray *tabViewArr; //多个tableView的数组
	UIView *currentTabView;//当前显示的tableView
	UIView *lastTabView;
	NSMutableArray *resultArray;//
	NSMutableArray *kaoheArr;
	NSMutableArray *sanArr;
	NSMutableArray *fengongArr;
	
	NSArray *btArray;
	
	
	UILocalizedIndexedCollation *collation;//小资料中用的变量
	NSMutableArray *personsArray;
	NSMutableArray *sectionsArray;
	NSMutableArray *validSectionArray;
	
	NSMutableArray *bianzhiArray;//编制变量
	NSMutableArray *bianzhiContentArr;
	
	NSMutableArray *personsNew;//tongxunlu
	
	UIImageView *background ;
	
	ResumeViewController *resumeController;
	
	UILabel *titleText;
	UIPageControl *pageControl;
	UIScrollView *scroll;
	UIActivityIndicatorView *prompt;
	UIButton *yButton;
	Yearcontroller *yc;
	UIPopoverController *pop;
	FormView *fv;
	
	
	int clickCount;
	int finishiCount;
	int pageNumbers;
	int detailInfoLines;
	int detailInfosLines;
	int personNumbers;//某单位下总的人数
	NSMutableArray *oldVisiableArray;
	
}
@property(nonatomic, assign) id *delegate;
@property (nonatomic,assign)UIView *currentTabView;
@property(nonatomic,retain)NSString *condition;
@property(nonatomic,retain)NSString *year;
@property (nonatomic,retain) NSString *tit;
@property(nonatomic,retain)NSString *tableName;
@property (nonatomic, retain) NSMutableArray *personsArray;
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
    @author      weijuanmin
    @date        2012-12-19 
    @description 加载一屏包含图片
    @param       无
    @result      无
*/
-(void)loadImagesForOnscreenRows;

/*
 @method     
 @author      wangbo
 @date        2013-1-28 
 @description 查询图片
 @param       无
 @result      无
 */
-(void)startImageSearch:(NSIndexPath *)indexPath;

/*
 @method     
 @author      wangbo
 @date        2013-1-28 
 @description 选择年份，查看图表响应的事件
 @param       无
 @result      无
 */
-(void)didChanged:(NSNotification *)nontification;

/*
 @method     
 @author      wangbo
 @date        2013-1-28 
 @description 返回父控制器
 @param       无
 @result      无
 */
- (void)back;

/*
 @method     
 @author      wangbo
 @date        2013-1-28 
 @description 返回父控制器时，移除并释放本视图的所有东西
 @param       无
 @result      无
 */
-(void)clearView;

/*
 @method     
 @author      wangbo
 @date        2013-1-28 
 @description 点击左边六个按钮时，响应的事件
 @param       无
 @result      无
 */
- (void)clicked:(UIButton *)sender;

/*
 @method     
 @author      wangbo
 @date        2013-1-28 
 @description 重置当前视图
 @param       无
 @result      无
 */
-(void)resetCurrentView;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 重置button的状态
 @param       无
 @result      无
 */
-(void)resetButton;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 重置personsArray的数据
 @param       newDataArray:新数据
 @result      无
 */
- (void)setPersonsArray:(NSMutableArray *)newDataArray;

@end
