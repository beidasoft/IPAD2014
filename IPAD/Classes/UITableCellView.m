//
//  UITableCellView.m
//  IPAD
//
//  Created by  careers on 12-3-1.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UITableCellView.h"


@implementation UITableCellView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	//默认图片名称
	NSString *defaultImgStr= (self.tag == 5001)? @"cellsousuo.png" :@"history.png";
	//默认图片
    UIImage *image = [UIImage imageNamed:defaultImgStr];
	//绘图
	[image drawInRect:rect];
}


- (void)dealloc {
    [super dealloc];
}


@end
