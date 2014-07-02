//
//  SearchController.h
//  IPAD
//
//  Created by  careers on 12-5-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortController.h"
#import "HistoryListController.h"
#import "RefreshView.h"


@interface SearchController : UIViewController
<UISearchBarDelegate,UIPopoverControllerDelegate,
UITableViewDelegate,UITableViewDataSource,RefreshViewDelegate> 
{
    UISearchBar           *searchArea;
	
	UIPopoverController   *categoryPop;//分类的popoverController
	UIPopoverController   *historyPop;//历史列表的popoverController
	
	UIButton              *sortButton;//查看类别按钮
	UIButton              *historyButton;
	UIButton              *searchButton;
	UIButton              *backButton;
	
	HistoryListController *historyList;//历史列表
	SortController        *sortListController;
	
	NSMutableArray        *sortImageArray;
	NSString              *currentSort;//当前类别
	UITableView           *showTableView;
	NSMutableArray        *historyArray;
	
	NSString              *personSearchSQL;//人员查询语句
	NSMutableArray        *resultArray;//人员信息临时搜索结果
	NSMutableArray        *totalDataArray;//人员信息总搜索结果
	int                   numbers;//人员搜索结果总数
	int                   currentNumer;//下拉刷新当前查询到第几个
	
	int                   searchCount;//搜索了几次
	
	UILabel               *alertLabel;//如果搜索内容为空时提示内容
	
	RefreshView           *refreshView;
	
	UIAlertView           *isLoadDataAlertView;
	
	BOOL  isFirstPage;
	
	NSArray               *caracterArray;
	//NSMutableArray        *oldVisiableIndexPathArray;
    
    int contentNum;//位移差值 王渤 2012-8-14
    int lastContentSetY;//位移值 王渤 2012-8-14
    BOOL loaded;//是否加载过了 王渤 2012-8-14
}

@property(nonatomic,retain)UISearchBar *searchArea;
@property(nonatomic)BOOL  isFirstPage;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 是否包含特殊字符，如;:%
    @param       string:搜索的字符串
    @result      YES:包含；NO:不包含
*/
-(BOOL)containSpecialCharacter:(NSString *)string;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 弹出提示框，且几秒后消失
    @param       无
    @result      无
*/
-(void)showAlertLabel;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 返回到主目录控制器
 @param       无
 @result      无
 */
-(void)backToMenu;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 清除视图
 @param       无
 @result      无
 */
-(void)clearView;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 显示分类视图
 @param       无
 @result      无
 */
-(void)showSort;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 选择分类
 @param       无
 @result      无
 */
-(void)changeSort:(NSNotification *)non;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 选择搜索内容
 @param       无
 @result      无
 */
-(void)changeSearchContent:(NSNotification *)non;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 显示搜索历史列表
 @param       无
 @result      无
 */
-(void)showHisotryList;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 按照关键字进行搜索
 @param       无
 @result      无
 */
-(void)searchWithKeyword:(NSString *)string;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 显示alwet视图
 @param       无
 @result      无
 */
-(void)showAlert;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 移除alertlable的动画效果
 @param       无
 @result      无
 */
-(void)disappearAlertLable;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 获取文件路径
    @param       无
    @result      无
*/
-(NSString *)getFilePath;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 将新搜索的字符串和类别记入文件中
    @param       findString：搜索的字符串；categryString：分类的字符串
    @result      无
*/
-(void)updateFile:(NSString *)findString andString:(NSString *)categryString;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 查询数据库，更新reloadArray数据，重置显示内容的数组
    @param       无
    @result      无
*/
- (void)reloadArrayData;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 根据关键字搜索内容
    @param       无
    @result      无
*/
-(void)searchWithKeyword;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 判断是否是汉字和拼音混合的字符串
    @param       string：需要判断的字符串
    @result      YES：是混合型的字符串；NO：不是混合型的字符串
*/
-(BOOL)isMixedCaracterWithHanzi:(NSString *)string;
/*
 @method     
 @author      wangbo
 @date        2012－8－14 
 @description 判断滑动过程中的速度
 @param       scrollView
 @result      无
 */
- (void)velocity:(UIScrollView *)scrollView;//王渤 2012－8－14 判断滑动过程中的速度


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
