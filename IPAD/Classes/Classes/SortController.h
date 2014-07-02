//
//  SortController.h
//  IPAD
//
//  Created by  careers on 12-5-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SortController : UIViewController 
{
	NSMutableArray *sortArray;
}

@property(nonatomic,retain) NSMutableArray *sortArray;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 点击事件
 @param       无
 @result      无
 */
-(void)clicked:(id)sender;

@end
