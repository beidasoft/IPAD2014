//
//  LoginViewController.h
//  Login
//
//  Created by Lyz on 2011-11-21.
//  Copyright 2011 careers. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController<UITextFieldDelegate> {

	//声明输入文本框对象
	UITextField *passwordTextField; 
	
	//密码输入错误次数
	int      errorCount;
	//警告框
	UIAlertView *alert;
    
    UIAlertView *beAlert;
    //删除计时器
    NSTimer *deleteTimer;
    //控制器	
    FirstNavigationViewController *FNVC;
    
    //计时剩余时间
    int surplusTime;
    
    //销毁时间的计时器
    NSTimer *destoryTime;
}

/*
    @method     
    @author      luyuze
    @date        2011-11-21 
    @description 定义点击return键的事件
    @param       textField：响应对象
    @result      YES
*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField;


/*
 @method     
 @author      wangbo
 @date        2012-12-21 
 @description 完成编辑事件
 @param       textField：响应对象
 @result      YES
 */
- (void)textFieldDidEndEditing:(UITextField *)textField;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 开始检查网络连接，删除数据
 @param       无
 @result      无
 */
- (void)beginThreadDelete;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 开始多线程操作
 @param       无
 @result      无
 */
- (void)runDeleteData;

/*
 @method     
 @author      wangbo
 @date        2013-1-27 
 @description 检测网络连接
 @param       无
 @result      无
 */
- (BOOL)connectedToNetwork;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 显示警告框
 @param       无
 @result      无
 */
- (void)showDeleteData;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 开始进行清除数据
 @param       无
 @result      无
 */
- (void)destoryData;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 清除销毁数据，给出alert提示
 @param       无
 @result      无
 */
- (void)clearAndShow;

/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 清除数据
 @param       无
 @result      无
 */
-(BOOL)clearData;
@end



