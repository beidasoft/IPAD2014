//
//  YearView.h
//  IPAD
//
//  Created by  careers on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YearView : UIView<UITableViewDelegate,UITableViewDataSource>
{
	UITableView *tv;
	UIButton    *yearButton;
	UILabel     *buttonTitle;
    BOOL showList;
	CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}

@property(nonatomic,assign)NSMutableArray *yearArray;
@property(nonatomic,retain)UILabel *buttonTitle;
@property(nonatomic,retain)UIButton *yearButton;
@end
