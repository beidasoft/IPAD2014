//
//  UINavigationCustomAnimation.m
//  IpadTest
//
//  Created by Sun Yu on 11-12-10.
//  Copyright 2011 careers. All rights reserved.
//

#import "UINavigationCustomAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationController (animation) 

- (void)pushViewController:(UIViewController *)viewController withAnimationName:(NSString *)animationName
{
    //声明一个动画对象
	CATransition *animation = [CATransition animation];
	//动画时间间隔
    [animation setDuration:1];
	//设置动画类型
    [animation setType: animationName];
	//动画弹出方向
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //推入控制器
	[self pushViewController:viewController animated:NO];
    //添加动画效果
	[self.view.layer addAnimation:animation forKey:nil];
}

@end
