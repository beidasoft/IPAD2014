//
//  ResumeViewController.h
//  IPAD
//
//  Created by  careers on 12-2-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reuseDelegate<NSObject>
-(void)resue;
-(void)stopLoaded;

@end

@interface ResumeViewController : UIViewController<UIWebViewDelegate> {
	UIWebView *myWebView;
	NSString *personName;
	NSArray *arr;
	NSArray *imageArray;
	CGPoint touchBeganPoint;
	int beginPointX;
	int endPointX;
	int beginPointY;
	int endPointY;
	int clickCount;
	UIImageView *connectView;
	UILabel *nameContent;
	UILabel     *workNumber;
	UILabel     *address;
	UILabel     *homeNumber;
	UILabel     *phoneNumber;
	UILabel     *workNumberContent;
	UILabel     *addressContent;
	UILabel     *homeNumberContent;
	UILabel     *phoneNumberContent;
	UIImageView *personImage;
	UIButton *connectButton;
	UIActivityIndicatorView *indicator;
	UIImageView *loadImageView;
	NSString *personID;
}
@property(nonatomic,retain) NSString *personName;
@property(nonatomic,retain) NSString *unitName;
@property(nonatomic,assign)id<reuseDelegate>del;
@property(nonatomic,retain)NSMutableString *personImageString;
@property(nonatomic,retain)NSString *personID;

/*
 @method     
 @author      luyuze
 @date        2011-11-21 
 @description 数据备份
 @param       
 @result      YES
 */
- (void)dateBackupRestore;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 返回上一层控制器
 @param       无
 @result      无
 */
-(void)back;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 加载联系人信息
 @param       无
 @result      无
 */
-(void)goConnect;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 移除视图
 @param       无
 @result      无
 */
-(void)move;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 添加联系方式的信息
    @param       无
    @result      无
*/
-(void)addInfo;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 手势识别向右滑动
 @param       无
 @result      
 */
- (void)moveRight;
@end
