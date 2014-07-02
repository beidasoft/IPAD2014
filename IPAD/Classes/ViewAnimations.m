//
//  ViewAnimations.m
//  SmartShapes
//
//  Created by Mac Pro on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewAnimations.h"

@implementation ViewAnimations 



+(void)changeFrame:(CGRect)frame time: (float)time targetView:(UIView *)targetView
{
	if ([targetView superview]) {
		[[targetView superview]bringSubviewToFront:targetView];
	}
    //执行动画效果
	[UIView beginAnimations:nil context:nil];
    //动画间隔
	[UIView setAnimationDuration:time];
	//最终位置
    targetView.frame = frame;
	//执行动画
    [UIView commitAnimations];
}

+(void)changeSize: (int)size time:(float)time targetView:(UIView *)targetView recovery:(BOOL)yesOrno
{
    //将目标视图移到最前面来
	if ([targetView superview]) {
		[[targetView superview]bringSubviewToFront:targetView];
	}
    //执行动画效果
	[UIView beginAnimations:nil context:nil];
    //动画间隔
	[UIView setAnimationDuration:time];
	//动画效果
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//最终位置
    targetView.frame = CGRectInset(targetView.frame, size, size);
	//最终位置
    [UIView commitAnimations];
    //判断是否需要还原成原视图
	if (yesOrno) 
	{
        //组成数组
		NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:time],[NSNumber numberWithInt:-size],targetView,nil];
        //在time时间后执行revoery方法
		[NSTimer scheduledTimerWithTimeInterval:time  target:self selector:@selector(recovery:) userInfo:array repeats:NO];
		
	}
}
	 
+(void)recovery:(NSTimer *)timer
{
    //恢复至厨师大小
	UIView *targetView = [[timer userInfo]objectAtIndex:2];
    //恢复所用时间
	int time = [[[timer userInfo]objectAtIndex:0]intValue];
	//恢复至大小
    int size = [[[timer userInfo]objectAtIndex:1]intValue];
    //开始动画
	[UIView beginAnimations:nil context:nil];
	//时间间隔
    [UIView setAnimationDuration:time];
	//动画效果
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//设定最终的位置
    targetView.frame = CGRectInset(targetView.frame, size, size);
	//执行动画
    [UIView commitAnimations];
}



//@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"

+(void)addAnimation:(UIView *)targetView time:(float)time typeName:(NSString *)name
{
    //动画效果
	CATransition *transition = [CATransition animation];
	transition.duration = time;          /*  间隔时间*/
    //动画效果
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	//动画类型
    transition.type = name;  
	//动画方向
    transition.subtype =  kCATransitionFromBottom;
	//是否在播放完成后移除
    transition.removedOnCompletion = YES;
    //填充模式
	transition.fillMode = kCAFillModeBackwards;
	//代理
    transition.delegate = targetView;
	//添加动画
    [targetView.layer addAnimation:transition forKey:nil];  
}


@end
