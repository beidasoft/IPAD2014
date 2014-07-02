//
//  ViewAnimations.h
//  SmartShapes
//
//  Created by Mac Pro on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewAnimations : NSObject {

}

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 更改目标视图的位置
 @param       frame:更改后的位置
              time:更改所用的时间
              targetView:所要更改的view 
 @result      nil
 */
+(void)changeFrame:(CGRect)frame time: (float)time targetView:(UIView *)targetView;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 更改视图大小
 @param       frame:更改后的大小
              time:更改所用的时间
              targetView:所要更改的view
              yesOrno：是否返回初始大小
 @result      nil
 */
+(void)changeSize: (int)size time:(float)time targetView:(UIView *)targetView recovery:(BOOL)yesOrno;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 动画渐淡效果
 @param       targetView:要添加动画效果的视图
              time:动画持续时间
              name：动画效果
 @result      nil
 */
+(void)addAnimation:(UIView *)targetView time:(float)time typeName:(NSString *)name;

@end
