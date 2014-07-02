//
//  ConnectController.h
//  IPAD
//
//  Created by yang on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "ContentViewController.h"


@interface ConnectController : UIViewController 
{
	ListViewController *listController;
	ConnectController  *contentController;

}

@property(nonatomic, assign) int condition;
@property(nonatomic,retain) NSString *tit;

/*
 @method     
 @author      wangbo
 @date        2013-1-28 
 @description 返回上一级视图控制器
 @param       无
 @result      无
 */
- (void)back;
@end
