//
//  FileViewController.h
//  IPAD
//
//  Created by Sun Yu on 12-1-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *webView;
	UIWebView *fileView;
	NSString  *htmlName;
	NSString  *fileName;
}
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIWebView *fileView;
@property (nonatomic,copy) NSString  *htmlName;
@property (nonatomic,copy) NSString  *fileName;

- (id)initWithHtmlName:(NSString *)html andFileName:(NSString *)file;

@end
