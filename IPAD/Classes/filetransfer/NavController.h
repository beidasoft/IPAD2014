#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class   HTTPServer;
@interface NavController : UIViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITabBarDelegate, UITextFieldDelegate>
{
    //菜单列表
	NSMutableArray *menuList;
	UITableView *listTableView;
	UITableView *kindTableView;
    //视频播放对象
	MPMoviePlayerViewController *mMoviePlayer;
	UITabBar *listModeTabbar;
	UITabBar *optionBalk;
	UIView *sharingView;
	
	NSMutableDictionary *fileKindCount;
	//释放在编辑
	BOOL isEditing;
    //编辑按钮
	IBOutlet UIBarButtonItem *editBtn;
    //加载按钮
	IBOutlet UIBarButtonItem *reloadBtn;

	// IP Address for the sharing panel
	IBOutlet UILabel *ipLbl;

	// We remember the working directory, and if it's the root directory. If so, we can get any higher so we hide the back button
	NSString *_WorkingDirectory;
	BOOL _isRoot;

	// For the uialertview input
	UITextField *inputField;
	
	//http server
	HTTPServer *httpServer;
	NSDictionary *addresses;
    //ip地址
	NSString *ipAddress;
	//刷新按钮
	UIButton *refrashBtn;
	BOOL bSelector ;
    //提示栏
	UIImageView *imageAlert;
	UILabel *label;
	UISegmentedControl *segmentedControl;
}

//初始化NavController
- (id)initWithWorkingDir:(NSString *)workingDir isRoot:(BOOL)isRoot;

/*
    @method     
    @author      weijuanmin
    @date        2012-12-20 
    @description 设置WorkingDirectory的值
    @param       workingDirectory值
    @result      nil
*/
- (void)setWorkingDirectory:(NSString*)workingDirectory;
//-(IBAction)reload:(id)sender;
//- (void)setSelectedTab:(int)index;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) NSString *_WorkingDirectory;
@property (nonatomic, retain) IBOutlet UITableView *listTableView;
@property (nonatomic, retain) IBOutlet UITableView *kindTableView;
@property (nonatomic, retain) IBOutlet UITabBar *listModeTabbar;
@property (nonatomic, retain) IBOutlet UITabBar *optionBalk;
@property (nonatomic, retain) IBOutlet UIView *sharingView;
@property (nonatomic, retain) HTTPServer *httpServer;
@property (nonatomic, retain) NSDictionary *addresses;

@property (nonatomic, retain) NSString *ipAddress;


/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 开启ipad服务器时，更新ip地址
 @param       notification
 @result      nil
 */
- (void)displayInfoUpdate:(NSNotification *) notification;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 获取本机ip
 @param       nil
 @result      nil
 */
- (NSString*)getIpAddress;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 关闭ipad服务器时
 @param       nil
 @result      nil
 */
- (IBAction) startStopServer:(id)sender;
@end
