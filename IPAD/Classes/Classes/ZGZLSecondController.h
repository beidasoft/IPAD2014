//
//  ZGZLSecondController.h
//  IPAD
//
//  Created by yang on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZGZLSecondController : UITableViewController 
{
    NSMutableArray *resultsArray;
}

@property(nonatomic, assign) id *delegate;
@property(nonatomic, copy) NSString *tit;
@property(nonatomic, assign) int condition;
@end
