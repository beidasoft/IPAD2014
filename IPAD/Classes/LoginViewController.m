//
//  LoginViewController.m
//  Login
//
//  Created by Lyz on 2011-11-21.
//  Copyright 2011 careers. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstNavigationViewController.h"
#import "NSStringMD5Encrypt.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netdb.h>

@implementation LoginViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	// 初始化数据
    //登陆涉及到的文件路径
	NSString *login_bundlePath = [Utilities bundlePath:kLogionImageName];
	NSString *login_documentPath = [Utilities documentsPath:kLogionImageName];
	//登陆所用数据
    NSData * login_Data;
    //背景图片
	UIImage *bgImage;
    //查询字符串
    NSString *sqlString = @"select * from databaseVersion where id=1;";
    //将查询返回值返给versionArray
	NSArray *versionArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
    //获取版本号
    NSString *database = [NSString stringWithFormat:[[versionArray objectAtIndex:0] objectForKey:@"version"]];
    //设置版本号为userdefault
    [[NSUserDefaults standardUserDefaults] setObject:database forKey:@"sqldatabase"];
    //判断是否存在登陆文档
	if ([Utilities isFileExist:login_documentPath])
	{
		//读取路径下的文件内容
		login_Data = [NSData dataWithContentsOfFile:login_documentPath];
		bgImage = [UIImage imageWithData:login_Data];
	}
	else 
	{
		//读取路径下的文件内容
		login_Data = [NSData dataWithContentsOfFile:login_bundlePath];
		
		bgImage = [UIImage imageWithData:login_Data];
	}
	//加载背景图片
	UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];//Image:[UIImage imageNamed:@"login.png"]];
	background.image = bgImage;
	[self.view addSubview:background];
	[background release];
	
    //密码输入框
	passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(300, 412, 410, 40)];//290, 465, 445, 35
    //默认文字
	passwordTextField.placeholder = @"password";
	//字体
    passwordTextField.font = [UIFont fontWithName:@"helvetica" size:30];
	//弹出键盘右下角按钮
    passwordTextField.returnKeyType = UIReturnKeyDone;
    //背景颜色
    passwordTextField.backgroundColor = [UIColor clearColor];
	//文本框输入加密，不显示输入数字
	passwordTextField.secureTextEntry = YES;
    //添加在有文字输入后，添加清空文字的按钮
	passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	passwordTextField.delegate = self;
	[self.view addSubview:passwordTextField];
	
	errorCount = 0;

    //开启消息中心，接收消息执行beginThreadDelete方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginThreadDelete) 
												 name:@"beginThreadDelete" 
											   object:nil];//多线程检测网络

}

/*
//ios7状态栏适配
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    CGRect frame = self.view.frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        frame.origin.y = 20;
        frame.size.height = self.view.frame.size.height - 20;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        frame.origin.x = 0;
    }
    self.view.frame = frame;
}
*/

//开始进行多线程检测网络，进行删除数据的判断
- (void)beginThreadDelete{
    //判断deleteTimer是否存在，不存在进行多线程检测网络。
    if (deleteTimer) {
        NSLog(@"qw");
    }
    else {
        if ([isCanDeleteData boolValue]) {
            //删除数据
            [NSThread detachNewThreadSelector:@selector(runDeleteData) toTarget:self withObject:nil]; 
            [self showDeleteData];
        }
    }

}

- (void)reloadLoginView{
    
}

//开始多线程操作
- (void)runDeleteData{

    @autoreleasepool { 
        NSRunLoop *timerRunLoop = [NSRunLoop currentRunLoop];
        	//计时器
            deleteTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(showDeleteData) userInfo:nil repeats:YES];
        [timerRunLoop run];
    }

}

#pragma mark -
#pragma mark NetworkTest
//检测网络连接
- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

//显示警告框
- (void)showDeleteData{
	if ([[NSString stringWithFormat:[[NSUserDefaults standardUserDefaults] objectForKey:@"sqldatabase"]] isEqualToString:@"1.0"]) {

    }
    else {
        //检测是否联网
        if ([self connectedToNetwork]) {
            if (!beAlert) {
                
                if ([deleteDataTime isEqualToString:@"15秒"]) {
                    surplusTime = 15;
                }
                if ([deleteDataTime isEqualToString:@"30秒"]) {
                    surplusTime = 30;
                }
                if ([deleteDataTime isEqualToString:@"60秒"]) {
                    surplusTime = 60;
                }

                //显示链接成功
                beAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"注意，此终端已连接无线网络，请立即退出系统！否则，将在%d秒后删除所有系统数据。",surplusTime] 
                                                     message:[NSString stringWithFormat:@"倒计时%d秒",surplusTime] 
                                                    delegate:self 
                                           cancelButtonTitle:@"退出系统" 
                                           otherButtonTitles:nil,nil];
                beAlert.tag = 201;
                [beAlert show];
                [beAlert release];
                
                if (deleteTimer) {
                    [deleteTimer invalidate];
                    deleteTimer = nil;
                }
                
                
                destoryTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(destoryData) userInfo:nil repeats:YES];


            }
        }

    }

}

//清除数据
- (void)destoryData{
    if (0 == surplusTime) {
        //判断是否清空数据
        if ([self clearData]) {
            if (FNVC) {
                //重新加载页面
                [FNVC reloadMainView];
                [beAlert dismissWithClickedButtonIndex:1 animated:YES];
                //提示用户，成功销毁
                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                                   message:@"数据已经销毁，请重新登录！" 
                                                                  delegate:self 
                                                         cancelButtonTitle:@"确定" 
                                                         otherButtonTitles:nil];
                theAlert.tag = 202;
                [theAlert show];
                if (destoryTime) {
                    [destoryTime invalidate];
                    destoryTime = nil;
                }

            }
        }
        else {
            //提示用户，销毁失败
            alert = [[UIAlertView alloc] initWithTitle:@"提示" 
                                               message:@"数据销毁失败，可能会造成数据损坏，请重新导入数据！" 
                                              delegate:nil 
                                     cancelButtonTitle:@"确定" 
                                     otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else {
        surplusTime--;
//        [beAlert setTitle:[NSString stringWithFormat:@"注意，此终端已连接无限网络，请立即退出系统！否则，将在%d秒后删除所有系统数据。",surplusTime]];
        [beAlert setMessage:[NSString stringWithFormat:@"倒计时%d秒",surplusTime]];
    }
}


//点击警告框上按钮触发的动作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
//需要退出系统
            NSLog(@"退出系统！");
            if (destoryTime) {
                [destoryTime invalidate];
                destoryTime = nil;
            }

            exit(0);
//            [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
        }
    }
    if (alertView.tag == 202) {
        if (buttonIndex == 0) {
            //返回上一级视图
            [FNVC.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

//消息弹出提示
void show (id titleString,id formatstring,id buttonTitle)
{
	UIAlertView *Points = [[[UIAlertView alloc] initWithTitle:titleString 
													 message:formatstring 
													delegate:nil 
										   cancelButtonTitle:buttonTitle 
										   otherButtonTitles:nil]autorelease];
	[Points show];
}

//UITextField输入长度限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 20) 
    {
		errorCount++;
		
		if(errorCount == 1)
		{
		    show(@"输入密码有误",@"您还有四次输入密码机会！",@"OK");
		}
		else if(errorCount == 2)
		{
			show(@"输入密码有误",@"您还有三次输入密码机会！",@"OK");
		}
		else if(errorCount == 3)
		{
			show(@"输入密码有误",@"您还有两次输入密码机会！",@"OK");
		}
		else if(errorCount == 4)
		{
			show(@"输入密码有误",@"您还有一次输入密码机会！",@"OK");
		}
		else if(errorCount == 5)
		{
			//show(@"输入密码有误",@"您输入错误密码已经三次，数据将被销毁！");
			[NSThread detachNewThreadSelector:@selector(clearAndShow) 
									 toTarget:self 
								   withObject:nil];
			
		}
        //show(nil,@"密码长度有误");
        return NO;
    }
    return YES;
	
}

//清除销毁数据，给出alert提示
- (void)clearAndShow{
    if ([self clearData]) {
        [alert dismissWithClickedButtonIndex:0 animated:NO];
        [alert release];
        show(nil, @"数据库已经被销毁",@"OK");
    }
    else {
        [alert dismissWithClickedButtonIndex:0 animated:NO];
        [alert release];
        show(nil, @"数据库销毁失败，可能会造成数据损坏，请重新导入数据",@"OK");
    }

}

//当开始点击textField会调用的方法
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    //配置显示动画信息
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
    //开始执行动画
	[UIView commitAnimations];
	
}

//当textField编辑结束时调用的方法 
- (void)textFieldDidEndEditing:(UITextField *)textField 
{
    //获取密码文件的路径
	NSString *strPath = [Utilities documentsPath:@"password.plist"];
    //将密码文件读为一个数组
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
	
    //将密码输入框中的输入字符进行md5加密后与从本地读入的密码进行比较
	if ([[passwordTextField.text md5HashDigest] isEqualToString: [array objectAtIndex:0]]) 
	{
        if (FNVC) {
            [FNVC release];
        }
        //成功，进入程序
		FNVC = [[FirstNavigationViewController alloc] init];
		[self.navigationController pushViewController:FNVC withAnimationName:@"oglFlip"];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(beginThreadDelete) userInfo:nil repeats:NO];

	}else 
	{
        //失败，失败计数加一
		errorCount++;
	
		if(errorCount == 1)
		{
		    show(@"输入密码有误",@"您还有四次输入密码机会！",@"OK");
		
		}
		else if(errorCount == 2)
		{
			show(@"输入密码有误",@"您还有三次输入密码机会！",@"OK");
		}
		else if(errorCount == 3)
		{
			show(@"输入密码有误",@"您还有两次输入密码机会！",@"OK");
		}
		else if(errorCount == 4)
		{
			show(@"输入密码有误",@"您还有一次输入密码机会！",@"OK");
		}
		else if(errorCount == 5)
		{
			alert = [[UIAlertView alloc] initWithTitle:@"输入密码有误" 
															  message:@"您输入错误密码已经五次，数据库正在被销毁中⋯⋯" 
															 delegate:nil 
													cancelButtonTitle:nil 
													otherButtonTitles:nil];
			[alert show];
			
			[self clearAndShow];
			
		}
		else
		{
			show(@"您的数据库已经被销毁，请重新下载更新脚本更新数据库",nil,@"OK");
		}

	}
    //将view推回原位置
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
	[array release];

}

//清除数据
-(BOOL)clearData
{
    //读取test，db的路径
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
	(NSLibraryDirectory, NSUserDomainMask, YES); 
	NSString *libraryDir = [libraryPaths objectAtIndex:0]; 	
	
	NSString *databasePath = [libraryDir stringByAppendingPathComponent:@"WebKit/Databases/file__0/"]; 
	NSString *databaseFile = [databasePath 
					stringByAppendingPathComponent:@"test.db"];
	
    // 删除其他资料里面的文件_lijie
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory,NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *filePath = [documentDir stringByAppendingPathComponent:@"file/"];
	
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
    NSString *fileName;
    //如果查询到存在本地文件
    while (fileName= [dirEnum nextObject])
	{
		//移除文件
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",filePath,fileName] error:NULL];
    }
    //移除成功后，重新导入一个test.db
	if ([[NSFileManager defaultManager] removeItemAtPath:databaseFile error:NULL])
	{
		if ([Utilities copyFile:[Utilities bundlePath:@"test.db"] to:databaseFile])
		{
            NSString *sqlString = @"select * from databaseVersion where id=1;";
            NSArray *versionArray = [[NSArray alloc] initWithArray:[[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString]];
            NSString *database = [NSString stringWithFormat:[[versionArray objectAtIndex:0] objectForKey:@"version"]];
            [[NSUserDefaults standardUserDefaults] setObject:database forKey:@"sqldatabase"];

            return YES;
		}
        else {
            return NO;
        }
	}

}

//UITextField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//对象释放
- (void)dealloc 
{
	[passwordTextField release];
    [FNVC release];
    [super dealloc];
}

@end
