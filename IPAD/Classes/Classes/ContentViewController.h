//
//  ContentViewController.h
//  IpadTest
//
//  Created by yang on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	UILabel     *nameLable;
	UILabel     *workNumber;
	UILabel     *address;
	UILabel     *homeNumber;
	UILabel     *phoneNumber;
	UILabel     *workNumberContent;
	UILabel     *addressContent;
	UILabel     *homeNumberContent;
	UILabel     *phoneNumberContent;
	UIImageView *personImage;
	NSIndexPath *nowIndexPath;
	NSIndexPath *indexPathNext;
	NSIndexPath *indexPathNow;
	UITableViewCell *cell;
	int selectCount;
	UITableView *titleView;
	UITableView *infoView;
	UILabel *zhiwuLabel;
}

@property(nonatomic,assign)id delegate;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 翻过通讯录详情的当前页，到下一页面
    @param       无
    @result      无
*/
- (void) performCurlUp:(id)sender;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 查询数据库，显示个人信息等信息的视图
 @param       notification
 @result      无
 */
-(void)show:(NSNotification *)notification;
@end
