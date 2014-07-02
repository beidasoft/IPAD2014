//
//  SecondMainController.h
//  IPAD
//
//  Created by Sun Yu on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPTabBarController.h"
#import "SearchController.h"


@interface SecondMainController : UIViewController <MPTabBarControllerDelegate>
{
	MPTabBarController *tabBarController;	
	@private
	SearchController    *searchController;
}
@property (nonatomic, retain) MPTabBarController *tabBarController;
@property (nonatomic, assign) int initType;
@property (nonatomic, retain) NSMutableArray *titleArray;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 点击首页上的某个模块时，进入并显示相应的内容
    @param       type:点击的是哪个模块
    @result      
*/
- (void) showTabBarController:(int)type;

@end





@interface UINavigationBar(clm)
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 重写navigationcontrollerbar上的图片
    @param       rect：重写的图片大小
    @result      
*/
-(void)drawRect:(CGRect)rect;

@end

@implementation UINavigationBar(clm)


-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	

	NSString *defaultImgStr=(self.tag == 5001)? @"serverTitle.png" :@"nav_bar_bg.png";
	UIImage *image = [UIImage imageNamed:defaultImgStr];

	[image drawInRect:rect];
}
- (CGSize)sizeThatFits:(CGSize)size {
	CGSize newSize;
	if (self.tag == 5001) {
		newSize = CGSizeMake(1024,50);
		return newSize;
	} 
	newSize = CGSizeMake(490,40);
    return newSize;
}
@end



typedef enum
{
	KNAV_BARBUTTONITEM_TYPE_LEFT_Arrow = 1, //左邊有箭頭
	KNAV_BARBUTTONITEM_TYPE_RIGHT_Arrow , //右边有箭头
	KNAV_BARBUTTONITEM_TYPE_ROUNDRECT //无箭头
}Nav_bar_type;







@interface UIBarButtonItem(clm)
+(id)BarButtonItemWithTitle:(NSString *)title  type:(Nav_bar_type)barType target:(id)target action:(SEL)selector;
+(id)BarButtonItemWithImage:(UIImage *)img  type:(Nav_bar_type)barType target:(id)target action:(SEL)selector;

@end

@implementation UIBarButtonItem(clm)

+(id)BarButtonItemWithTitle:(NSString *)title  type:(Nav_bar_type)barType target:(id)target action:(SEL)selector
{
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 60, 30)];
	[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	[btn setTitle:title forState:UIControlStateNormal];
	btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	btn.titleLabel.backgroundColor =[UIColor clearColor];
	btn.showsTouchWhenHighlighted = YES;
	//	btn.titleLabel.frame = CGRectMake(20, 5, 5, 40);
	
    CGSize cs = [title sizeWithFont:[UIFont boldSystemFontOfSize:13]];
	
	float width = 0;
	
	if(barType == KNAV_BARBUTTONITEM_TYPE_LEFT_Arrow)
	{
		//[btn setBackgroundImage:[[UIImage imageNamed:@"nav_backButton_icon.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
		[btn setBackgroundImage:[[UIImage imageNamed:@"nav_backButton_icon.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
		
		width = cs.width > 30 ? (20 + cs.width) : 50;
		
		btn.frame = CGRectMake(0, 5.0, width, 34);
		btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0); 
	}
	
	else
	{
		[btn setBackgroundImage:[[UIImage imageNamed:@"nav_roundrect_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
		//[btn setBackgroundImage:[[UIImage imageNamed:@"options_close.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
		
		width = cs.width > 40 ?  cs.width + 20 : 50;
		btn.frame = CGRectMake(0, 5.0, width, 34);
	}
	
	//btn.titleLabel.textColor = [UIColor  colorWithRed:0.882 green:0.929 blue:0.051 alpha:1.0];
	
	[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//btn.titleLabel.shadowColor = [UIColor blackColor];
	//btn.titleLabel.shadowOffset = CGSizeMake(0.2,  0.2);
	btn.titleLabel.textAlignment = UITextAlignmentCenter;
	//[btn sizeToFit];
	
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	[btn release];
	
	return [backItem autorelease];
}

+(id)BarButtonItemWithImage:(UIImage *)img  type:(Nav_bar_type)barType target:(id)target action:(SEL)selector
{
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 34)];
	[btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	[btn setBackgroundImage:[[UIImage imageNamed:@"nav_roundrect_bg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
	
	UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((btn.frame.size.width - img.size.width) / 2.0 , (btn.frame.size.height - img.size.height) / 2.0 , img.size.width, img.size.height)];
	iv.image  = img;
	[btn addSubview:iv];
	iv.tag = 400;
	iv.center = CGPointMake(20, 17);
	[iv release];
	
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	[btn release];
	
	return [backItem autorelease];
}

@end


//返回
@interface UINavigationController(clm)
-(void)popBackAnimated;
@end

@implementation UINavigationController(clm)
-(void)popBackAnimated;
{
	[self popViewControllerAnimated:YES];
}
@end


//-------------------------------------------------------------------------------------------------------------
//
// tabbar double click protocol
//
//--------------------------------------------------------------------------------------------------------------

@protocol ControllerInTabbarDelegate

@optional
/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 当前视图滚到最前前面
 @param       无
 @result      无
 */
-(void)ViewScrollToTop;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 强制刷新视图
 @param       无
 @result      无
 */
-(void)ViewFreshData;

/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 取消选择
 @param       无
 @result      无
 */
-(void)ViewDeselectCurrentSelect; //
@end


