//
//  Yearcontroller.h
//  IPAD
//
//  Created by  careers on 12-3-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Yearcontroller : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tv;
}

@property(nonatomic,retain)NSMutableArray *yearArray;
@property(nonatomic,retain)NSMutableArray *pictureArray;
@end
