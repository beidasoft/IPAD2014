//
//  PopoChangeViewController.h
//  IPAD
//
//  Created by Careers on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoChangeViewControllerDelegate<NSObject> 
@optional
/*
 @method     
 @author      wangbo
 @date        2013-1-30 
 @description 用户选择哪一行的数据，进行处理
 @param       row:选择的那一行的数据
 @result      
 */
- (void)changeTableArray:(int)row;
@end

@interface PopoChangeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *changeTableView;//选择列表
    NSMutableArray *changeArray;//tableview加载的选择的数组
    id<PopoChangeViewControllerDelegate>delegate;//代理
}
@property (nonatomic,retain)NSMutableArray *changeArray;
@property (assign,nonatomic)id<PopoChangeViewControllerDelegate>delegate;


@end
