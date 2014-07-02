#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>

@interface audioPlayerViewController : UIViewController <AVAudioPlayerDelegate>
{
	NSString *path;
	
	BOOL isPlaying; // Functions are buggy when in release, a boolean will help us to solve
	AVAudioPlayer *audioPlayer;
	
	// 前一个按钮
	IBOutlet UIButton *prevBtn;
    //播放按钮
	IBOutlet UIButton *playBtn;
    //后一个按钮
	IBOutlet UIButton *nextBtn;
	//进度控制
	IBOutlet UISlider *slider;
	IBOutlet UILabel *positionLbl;
	
	// 标题label
	IBOutlet UILabel *id3TitleLbl;
    //歌手label
	IBOutlet UILabel *id3ArtistLbl;
    //专辑label
	IBOutlet UILabel *id3AlbumLbl;
    //描述label
	IBOutlet UILabel *id3GenreLbl;
    //歌曲年份label
	IBOutlet UILabel *id3YearLbl;
	
	
}

@property(nonatomic, retain) NSString *path;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-20 
    @description 初始化audioPlayerViewController对象
    @param       titel，rt：文件的路径
    @result      audioPlayerViewController对象
*/
- (id)initWithFileName:(NSString *)titel withRoot:(NSString*)rt;

// Player controls
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 按下按钮触发的事件
 @param       sender：被按下的按钮
 @result      无
*/
- (IBAction)playBtnPressed:(id)sender;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 播放进度条
 @param       无
 @result      无
 */
- (IBAction)playerDidScrub:(id)sender;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 该控制器消失
 @param       无
 @result      无
 */
- (IBAction)dismissAction:(id)sender;
@end
