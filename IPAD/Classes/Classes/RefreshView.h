//
//  RefreshView.h
//  TestRefreshView
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

// Refresh view controller show label 
#define REFRESH_LOADING_STATUS @"加载中..."
#define REFRESH_PULL_DOWN_STATUS @"下拉可以刷新..."
#define REFRESH_RELEASED_STATUS @"松开即刷新..."
#define REFRESH_UPDATE_TIME_PREFIX @"最后更新: "
#define REFRESH_HEADER_HEIGHT 60
#define YOFFSET 635
#import <UIKit/UIKit.h>
@protocol RefreshViewDelegate;
@interface RefreshView : UIView {
    // UI
    UIImageView *refreshArrowImageView;
    UIActivityIndicatorView *refreshIndicator;
    UILabel *refreshStatusLabel;
    UILabel *refreshLastUpdatedTimeLabel;
    
    // 安装到哪个UIScrollView中
    UIScrollView *owner;
    
    // control
    BOOL isLoading;
    BOOL isDragging;
    int cellCount;
	
    // 触发有效事件后的delegate
    id<RefreshViewDelegate>delegate;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *refreshIndicator;
@property (nonatomic, retain) IBOutlet UILabel *refreshStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *refreshLastUpdatedTimeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *refreshArrowImageView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, retain) UIScrollView *owner;
@property (nonatomic, assign) id<RefreshViewDelegate>delegate;
@property  int cellCount;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 初始化refreshView
    @param       owner，delegate
    @result      
*/
- (void)setupWithOwner:(UIScrollView *)owner delegate:(id)delegate;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 开始加载动画
    @param       无
    @result      无
*/
- (void)startLoading;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 结束加载动画
    @param       无
    @result      无
*/
- (void)stopLoading;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 刚开始拖动时
    @param       scrollView
    @result      
*/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 拖动过程中
    @param       scrollView
    @result      
*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 拖动结束后
    @param       scrollView
    @result      
*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@protocol RefreshViewDelegate <NSObject>
// 只有向下拉时，有效的触发事件对外才是真正有用的
- (void)refreshViewDidCallBack;
@end
