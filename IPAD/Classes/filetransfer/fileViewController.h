#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface fileViewController : UIViewController
{
    //展示文件的webview
	IBOutlet UIWebView *webView;
	IBOutlet UIImageView *imageView;
    //文件类型
	NSString *mimetype;
	NSString *root;
}

@property(nonatomic, retain) NSString *root;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 初始化fileViewController对象
 @param       titel，rt：文件的路径
 @result      fileViewController对象
 */
- (id)initWithFileName:(NSString *)titel withRoot:(NSString*)rt;

@end
