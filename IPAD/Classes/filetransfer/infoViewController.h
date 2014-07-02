#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface infoViewController : UIViewController
{
    //系统控件搜索框
	UISearchBar	*mySearchBar;
	IBOutlet UIView *selfview;
	IBOutlet UIWindow *venster;
}
//移除控制器
- (IBAction)dismissAction:(id)sender;


@end
