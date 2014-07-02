#import "infoViewController.h"
#import "Constants.h"

@implementation infoViewController


//移除自己控制器
- (IBAction)dismissAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
//对象释放
- (void)dealloc
{
	[super dealloc];
}


@end
