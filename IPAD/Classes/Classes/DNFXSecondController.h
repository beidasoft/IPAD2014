//
//  DNFXSecondController.h
//  IPAD
//
//  Created by  careers on 12-2-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DNFXSecondController : UITableViewController 
{
	NSMutableArray *resultArray;

}
@property(nonatomic, assign) id *delegate;
@property(nonatomic, copy) NSString *tit;
@property(nonatomic, assign) int condition;

@end
