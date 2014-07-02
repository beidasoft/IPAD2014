//
//  RCFXSecondController.h
//  IPAD
//
//  Created by yang on 12-2-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RCFXSecondController : UITableViewController
{
	NSMutableArray *resultsArray;
}
@property(nonatomic, assign) id *delegate;
@property(nonatomic, copy) NSString *tit;
@property(nonatomic, assign) int condition;
@end
