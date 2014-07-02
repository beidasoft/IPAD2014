//
//  FirstNavigationViewController.h
//  FirstNavigation
//
//  Created by Lyz on 11-11-21.
//  Copyright 2011 careers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Update.h"
#import "IconNavigationController.h"
#import "Delete.h"
#import "SetController.h"
#import "PopoChangeViewController.h"

//@class SearchViewController;
@class SearchController;
@interface FirstNavigationViewController : UIViewController<UISearchBarDelegate,UIWebViewDelegate,UIPopoverControllerDelegate,UITextFieldDelegate,SetControllerDelegate,PopoChangeViewControllerDelegate> 
{
    //html名称
	NSString  *htmlName;
	//升级类对象
    Update    *up;
	//删除类对象
    Delete    *de;
	//数据库路径
    NSString    *databasePath;
	//sql
    NSString    *sqlPath;
	//进度值
    float       progressValue;
    //pop框
	UIPopoverController *pop;
    //图标控制器
	IconNavigationController *iNC;
    //密码框
	UITextField *oldPassword;
	UITextField *newPassword;
    UITextField *newSetPassword;
	//背景图片
    UIImageView *background;
    //设置密码
	//确认按钮
    UIButton *sureButton;
	
    NSMutableArray *array;
    //取消按钮
	UIButton *cancelButton;
    //判断点击
	BOOL isDianJi;
    //版本进度条
	UILabel *versionLabel;
@private
    //进度条
	UIProgressView *progressView_;
    //搜索控制器
	SearchController *searchController;
    //设置视图控制器
    SetController *setController;
    //设置是否联网删除数据
    UISwitch *delOrSave;
    //设置删除时间
    UIButton *deleteTimeBt;
    //删除时间
    UITextField *deleteTimeText;
    //完成数据安全设置
    UIButton *finishDbSafe;
    //选择删除时间的控制器
    PopoChangeViewController *popoChange;
    
}

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description alert弹出窗口
 @param       nil
 @result      
 */
-(void)showAlert:(NSString *)title andMessage:(NSString *)message cancel:(NSString *)cancelString other:(NSString *)otherString;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 开始更新，拷贝数据库文件和数据内容
 @param       nil
 @result      
 */
-(void)start;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 搜索
 @param       nil
 @result      
 */
-(void)search:(NSString *)_string;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 开始修改密码
 @param       nil
 @result      
 */
-(void)animation;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 数据安全设置视图
 @param       nil
 @result      
 */
-(void)databaseSafe;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 取消修改密码
 @param       nil
 @result      
 */
-(void)cancelClicked;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 数据安全设置完成
 @param       nil
 @result      nil
 */
- (void)finishDatabase;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 选择删除时间
 @param       nil
 @result      nil
 */
- (void)changeTime;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 完成修改密码
 @param       nil
 @result      
 */
- (void)finishClicked;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 旧密码输入错误
 @param       nil
 @result      
 */
- (void)finishClicked2;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 推入其他资料的控制器
 @param       nil
 @result      
 */
- (void) push1;

/*
 @method     
 @author      wangbo
 @date        2013-1-23 
 @description 重新加载主界面
 @param       nil
 @result      
 */
- (void)reloadMainView;
@end

