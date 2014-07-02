//
//  HistoryListController.h
//  IPAD
//
//  Created by  careers on 12-5-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HistoryListController : UITableViewController
{
    UIButton *clearButton;
	BOOL isCleared;
}

@property(nonatomic,retain)NSMutableArray *historyArray;
@property(nonatomic)BOOL isCleared;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 弹出确认清空记录的alert视图
 @param       无
 @result      无
 */
-(void)clearSomeOne;

@end
