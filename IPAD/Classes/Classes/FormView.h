//
//  FormView.h
//  IPAD
//
//  Created by  careers on 12-3-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol stopDelegate<NSObject>

-(void)stopLoad;

@end

@interface FormView : UIView <UIWebViewDelegate>
{
	UIWebView *formView; //webView视图对象
	CGRect    viewFrame; //view坐标信息
	int       pageId;    //页面编号
}
@property(nonatomic,assign)NSString *condition;
@property(nonatomic,assign)NSString *pathString;
@property(nonatomic,assign)NSString *yearString;


@property (nonatomic,assign)id<stopDelegate>delegate;

//初始化对象
-(id)initWithFrame:(CGRect)_frame andPageId:(int)_PageId;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 显示班子考核信息中的图表
    @param       无
    @result      无
*/
-(void)showForm;

//UIWebView代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

//UIWebView代理方法,加载web页面
- (void)webViewDidFinishLoad:(UIWebView *)webView;
@end
