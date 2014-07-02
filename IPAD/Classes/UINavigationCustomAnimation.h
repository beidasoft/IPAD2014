//
//  UINavigationCustomAnimation.h
//  IpadTest
//
//  Created by Sun Yu on 11-12-10.
//  Copyright 2011 careers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UINavigationController (animation) 

//@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
/*
 @method     
 @author      luyuze
 @date        2011-11-21 
 @description 推送指定控制器
 @param       viewController:指定控制器
              animationName:推送时候指定的动画效果
 @result      
 */
- (void)pushViewController:(UIViewController *)viewController withAnimationName:(NSString *)animationName;

@end
