//
//  TempFileWebViewController.h
//  IpadTest
//
//  Created by pc h on 12/8/11.
//  Copyright 2011 careers. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TempFileWebViewController : UIViewController <UIWebViewDelegate>{

    //显示的webview
	UIWebView *webView1;


}
@property(nonatomic,retain)NSString *fileName;
/*
 @method     
 @author      luyuze
 @date        2011-11-21 
 @description 数据备份
 @param       
 @result      YES
 */
- (void)dateBackupRestore;

@end
