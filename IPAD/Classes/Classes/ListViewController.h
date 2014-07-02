//
//  ListViewController.h
//  IpadTest
//
//  Created by yang on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ListViewController : UITableViewController 
{
	NSMutableArray *personsArray;
	NSMutableArray *sectionsArray;
	UILocalizedIndexedCollation *collation;
	
	NSMutableArray *validSectionArray;
	UIImageView *letterImageView;
	NSTimer *timer;
	
}

@property (nonatomic, retain) NSMutableArray *personsArray;
@property(nonatomic,retain) UIImageView *letterImageView;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 移除letterImageView的视图
 @param       无
 @result      无
 */
- (void)removieLetterView;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description 重置personsArray的数据
 @param       newDataArray:新数据
 @result      无
 */
- (void)setPersonsArray:(NSMutableArray *)newDataArray;

/*
 @method     
 @author      wangbo
 @date        2012-1-28 
 @description tableView的section按字母分栏排序
 @param       无
 @result      无
 */
- (void)configureSections;
@end
