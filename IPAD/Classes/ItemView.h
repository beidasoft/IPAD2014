//
//  ItemView.h
//  FirstNavigation
//
//  Created by Lyz on 11-11-22.
//  Copyright 2011 careers. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemView : UIView {
	//声明图片对象
	UIImageView *imageView;
}
@property (nonatomic ,retain)NSString *imageNameString;
@property (nonatomic ,retain)NSString *titleString;
@property (nonatomic ,retain)NSString *linkString;

/*
 @method     
 @author      luyuze
 @date        2011-11-22 
 @description 初始化图片和label文字
 @param       array:存储图片和label文字
 @result      self
 */
- (id)initWithFrame:(CGRect)frame andItemArray:(NSArray *)array;
@end
