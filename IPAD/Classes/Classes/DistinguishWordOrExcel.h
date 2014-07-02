//
//  DistinguishWordOrExcel.h
//  IPAD
//
//  Created by  careers on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol backDelegate<NSObject>

-(void)deselected;

@end

@interface DistinguishWordOrExcel : UIViewController
<UIWebViewDelegate>
{
    //模块标题
	NSString *tableName;	
	
	//展示内容的web视图
    UIWebView  *webView;
    //内容标题
	UILabel *titleLabel;
    //返回按钮
	UIButton *backButton;

}
@property(nonatomic,assign) NSString *tableName;
@property(nonatomic, assign) int condition;
@property(nonatomic, copy) NSString *tit;
@property (nonatomic,assign)id<backDelegate>delegate;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 添加查看文档页面的title
    @param       _titleBg：title对应的UIImageView
    @result      
*/
-(void)addTitle:(UIImageView *)_titleBg;
@end
