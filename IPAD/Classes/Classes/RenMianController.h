//
//  RenMianController.h
//  IPAD
//
//  Created by  careers on 12-6-2.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RenMianController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView    *listTableView;
	UIScrollView   *contentScrollView;
	NSMutableArray *resultArray;
	NSInteger      numberOfPages;
	NSInteger      currentPage;
	
	UIImageView    *prevPageView;
    UIImageView    *currentPageView;
    UIImageView    *nextPageView;
	
	BOOL checkDouble;
	//NSInteger      clickedCount;
}

@property(nonatomic,retain) NSMutableArray *resultArray;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 显示当前选中的人的详细信息
    @param       pageNumber：当前页数
    @result      无
*/
-(void)setWithPageNumber:(NSInteger)pageNumber;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 根据prevPageNumner刷新页面
 @param       prevPageNumber：页面编号
 @result      无
 */
- (void)refreshPageViewAfterPaged:(NSNumber *)prevPageNumber;

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
 @author      wangbo
 @date        2012-1-28 
 @description 移除任免表视图
 @param       无
 @result      无
 */
-(void)remove;
@end
