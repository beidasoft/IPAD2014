//
//  ItemView.m
//  FirstNavigation
//
//  Created by Lyz on 11-11-21.
//  Copyright 2011 careers. All rights reserved.
//

#import "ItemView.h"
#import "Utilities.h"

#define LEFTBLANKSIZE 50
#define TITLEHEIGHT 50
#define TOPBLANKSIZE 70
#define BOTTOMBLANKSIZE 

@implementation ItemView
@synthesize imageNameString,titleString,linkString;

- (id)initWithFrame:(CGRect)frame andItemArray:(NSArray *)array{
    
    self = [super initWithFrame:frame];
    if (self) {
		
        //初始化一些属性，包括图片名称、标题名称、链接名称
		self.imageNameString = [array objectAtIndex:0];
		self.titleString = [array objectAtIndex:1];
		self.linkString = [array objectAtIndex:2];
		

		imageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFTBLANKSIZE, 
																 TOPBLANKSIZE,
																 self.frame.size.width-0.5*LEFTBLANKSIZE, 
																 self.frame.size.height -TITLEHEIGHT- 0.1*LEFTBLANKSIZE)];
        //获取图片路径
		NSString *imageDocPath = [Utilities documentsPath:imageNameString];
		if ([Utilities isFileExist:imageDocPath])
		{
			imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageDocPath]];
		}
		else {
			imageView.image = [UIImage imageNamed:imageNameString];
		}
        [self addSubview:imageView];
        imageView.userInteractionEnabled = NO;
        [imageView release];
    }
    return self;
}

//点击触发事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([titleString isEqualToString:@"其它资料"]) {
        //发送名为@“push1”的通知
		[[NSNotificationCenter defaultCenter] postNotificationName:@"push1" object:nil];
	}
	else {
        //发送名为“push”的通知
		[[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:[NSNumber numberWithInt:self.tag]];
	}


	


}
//对象释放
- (void)dealloc 
{
	[imageNameString release];
	[titleString release];
	[linkString release];
    [super dealloc];
}


@end
