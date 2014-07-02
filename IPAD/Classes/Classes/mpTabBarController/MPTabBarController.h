//
//  MPTabBarController.h
//  maopao
//
//  Created by Wonderful Live on 11-5-23.
//  Copyright 2011 gooogle.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPTabBarControllerDelegate;
@class MPTabBar;
//@protocol MPTabBarDelegate;

@protocol MPTabBarDelegate<NSObject>
@optional
- (void)mpTabBar:(MPTabBar *)tabBar didSelectItem:(UITabBarItem *)item;
@end

@interface MPTabBarController : UIViewController <MPTabBarDelegate, UINavigationControllerDelegate>
{
	NSUInteger selectedIndex;
	UIViewController *selectedViewController;
	
	MPTabBar *tabBar;
	NSArray *viewControllers;
	id<MPTabBarControllerDelegate> delegate;
	
	//右侧详细视图
	UIViewController *detailController; 
	
	//铺满整个屏幕的第3个视图
	UIViewController *thirdController;
	UIView *thirdBgView;
	
	BOOL bLandScape;
	UIButton *btnLogout ;
	UIButton *btnSetting;
	BOOL isButtonAdd;
	
	
	
	UIImageView *imageViewLeftShadow;
	UIImageView *imageViewRightShadow;
	UIImageView *imageViewHighLight;
	UIImageView *imageViewSelected;
	NSIndexPath *currentIndexPath;
}

@property(nonatomic) NSUInteger selectedIndex;
@property(nonatomic, assign) UIViewController *selectedViewController;
@property(nonatomic,readonly) MPTabBar *tabBar;
@property(nonatomic, retain) NSArray *viewControllers;
@property(nonatomic, assign) id<MPTabBarControllerDelegate> delegate;
@property(nonatomic, retain) UIViewController *detailController;
@property(nonatomic, retain) UIViewController *thirdController;

@property(nonatomic, retain) UIImageView *imageViewLeftShadow;
@property(nonatomic, retain) UIImageView *imageViewRightShadow;
@property(nonatomic, retain) UIImageView *imageViewSelected;


-(void)setBadgeValue:(NSString *)value index:(int)index;

//详细视图的
-(void)showDetailController:(UIViewController *)viewController animated:(BOOL)animated;
-(void)hideDetailController:(BOOL)animated;
-(void)hideDetailControllerBackGround;


-(void)presentThirdController:(UIViewController	 *)viewController animated:(BOOL)animated;

//移除视图控制器
-(void)disMissThirdController:(BOOL)animated;

//动画结束
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

//展示视图控制器
-(void)showSimpleDetailController:(UIViewController *)viewController animated:(BOOL)animated;

//详细视图从左向右的滑动手势
-(void)detailSwipeFromLeft;

//刷新当前的视图
-(void)freshCurrentMasterViewController;

//private
-(void)setting:(id)sender;

-(void)showDetailController:(UIViewController *)viewController animated:(BOOL)animated andIndex:(NSIndexPath *)indexPath isTableView:(BOOL)is;



@end

@protocol MPTabBarControllerDelegate<NSObject>
@optional
- (void)mpTabBarController:(MPTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
- (BOOL)mpTabBarController:(MPTabBarController *)t_tabBarController shouldSelectViewController:(UIViewController *)viewController;
@end


//-----------------------------------------------------------------------------------------------------
//
//    MPTabbar
//
//-----------------------------------------------------------------------------------------------------

//@protocol MPTabBarDelegate;

@interface MPTabBar : UIScrollView
{
	NSArray *items; 
	UITabBarItem *selectedItem;
	UIImage *backImage;
	id<MPTabBarDelegate> delegate;
	
	NSMutableArray *arrNormalImages; //正常状态下的图片
	NSMutableArray *arrSelectedImages; //选中状态下的图片
	NSMutableArray *highLightImages;//上面显示的被选中的图片
	
	NSUInteger selectedIndex;
	
	
	//按钮有状态
	int  nIndexTouched;
	BOOL bSelectedShow;
	//private
	
}

@property(nonatomic, assign) UITabBarItem *selectedItem;
@property(nonatomic, retain) NSArray *items;
@property(nonatomic, retain) UIImage *backImage;
@property(nonatomic, assign) id<MPTabBarDelegate> delegate;

@property(nonatomic, retain) NSMutableArray *arrNormalImages;
@property(nonatomic, retain) NSMutableArray *arrSelectedImages;
@property(nonatomic, retain) NSMutableArray *highLightImages;
@property(nonatomic) NSUInteger selectedIndex;

- (void) clearSelection ;
//选中了某个tabbaritem
-(void)didSelectedIndex:(int)index;

@end








