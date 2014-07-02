//
//  WebViewController.h
//  IpadTest
//
//  Created by Sun Yu on 11-12-2.
//  Copyright 2011 careers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "SQLiteOptions.h"

#import "FileViewController.h"
@interface WebViewController : UIViewController <UIWebViewDelegate,UIAlertViewDelegate> {
	
	NSString *htmlTemplate;
	NSString *queryCondition;

	NSString *nextHtmlTemplate;
	NSString *nextQueryCondition; 
	
	UIActivityIndicatorView *activityIndicator;
	NSURLRequest *nsrequest;
	
	BOOL isFirstLoad;
}

@property (nonatomic,copy)NSString *htmlTemplate;
@property (nonatomic,copy)NSString *queryCondition;

@property (nonatomic,copy)NSString *nextHtmlTemplate;
@property (nonatomic,copy)NSString *nextQueryCondition;
@property (nonatomic,copy)NSURLRequest *nsrequest;

- (void)alert:(NSString *)string;

-(id)initWithRequest:(NSURLRequest *)req;
-(id)initWithHtmlTemplate:(NSString *)html andQueryCondition:(NSString *)condition;

@end
