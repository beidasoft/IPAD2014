//
//  DetailInfosController.h
//  IPAD
//
//  Created by  careers on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeViewController.h"

@interface DetailInfosController : UIViewController
<UITableViewDelegate,
UITableViewDataSource> {
	UITableView *detailTabView;
	NSMutableArray *resultArray;
	UILocalizedIndexedCollation *collation;
	NSMutableArray *personsArray;
	NSMutableArray *sectionsArray;
	
	NSMutableArray *validSectionArray;
	
	ResumeViewController *resumeController;
	UIImageView *letterImageView;
	NSTimer *timer;
}
@property(nonatomic, assign) id *delegate;
@property(nonatomic, copy) NSString *tit;
@property(nonatomic, assign) int condition;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;
@property (nonatomic, retain) NSMutableArray *personsArray;
@property (nonatomic, retain) NSMutableArray *sectionsArray;


- (void)configureSections;

@end
