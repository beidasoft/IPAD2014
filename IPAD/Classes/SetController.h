//
//  SetController.h
//  IPAD
//
//  Created by yang on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetControllerDelegate<NSObject>

-(void)popoForTouch:(int)row;

@end

@interface SetController : UITableViewController {

    NSMutableArray *cellTitleArray;
    
}
//代理
@property (nonatomic,assign)id<SetControllerDelegate>delegate;


// Default is 1 if not implemented
/*
 @method     
 @author      UITableView代理
 @date        2013-1-28 
 @description 返回tableview中section个数
 @param       无
 @result      无
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

/*
 @method     
 @author      UITableView代理
 @date        2013-1-28 
 @description 返回tableview的section中的行数
 @param       无
 @result      无
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/*
 @method     
 @author      UITableView代理
 @date        2013-1-28 
 @description tableview中加载cell的view
 @param       无
 @result      无
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 @method     
 @author      UITableView代理
 @date        2013-1-28 
 @description 返回tableview的cell行高
 @param       无
 @result      无
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/*
 @method     
 @author      UITableView代理
 @date        2013-1-28 
 @description tableview的cell点击事件
 @param       无
 @result      无
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end
