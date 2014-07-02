//
//  IconNavigationController.h
//  FirstNavigation
//
//  Created by Lyz on 11-11-21.
//  Copyright 2011 careers. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IconNavigationController : UIViewController {
    //存储图片和label文字
	NSArray *itemArray;
}
@property (nonatomic,retain) NSArray *itemArray;

/*
 @method     
 @author      
 @date        2011-11-22 
 @description 初始化内容数组
 @param       array:存储图片和label文字
 @result      self
 */
- (id)initWithItemArray:(NSArray *)array;
@end
