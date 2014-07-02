    //
//  ResumeViewController.m
//  IPAD
//
//  Created by  careers on 12-2-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ResumeViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation ResumeViewController
@synthesize personName,unitName,del,personImageString,personID;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
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
	UIImageView *background=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
	background.image = [UIImage imageNamed:@"mingcebackground.png"];
	background.userInteractionEnabled = YES;
	[self.view addSubview:background];
	[background release];
	
	UIImageView *jianli1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 58, 150)];
	jianli1.image=[UIImage imageNamed:@"jianlicontact.png"];
	[background addSubview:jianli1];
	[jianli1 release];	
	
	connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[connectButton setTitle:@"联系方式" forState:UIControlStateNormal];
	connectButton.frame = CGRectMake(900,25, 80, 35);
	[connectButton addTarget:self
					  action:@selector(goConnect)
			forControlEvents:UIControlEventTouchUpInside];
	[background addSubview:connectButton];
	myWebView=[[UIWebView alloc]initWithFrame:CGRectMake(100, 70, 895, 675)];
    [self dateBackupRestore];
	NSString *filePath;
	
	NSString *file_bundlePath = [Utilities bundlePath:kPersonResumeHtmlName];
	NSString *file_documentPath = [Utilities documentsPath:kPersonResumeHtmlName];
	 
	
	if ([Utilities isFileExist:file_documentPath])
	{
		
		filePath = file_documentPath;
	}
	else 
	{
		
		filePath = file_bundlePath;
	}
	
	NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
    NSString *newHTMLString=[htmlstring stringByAppendingString:@"<script language=\"javascript\">document.ontouchstart=function(e){          document.location=\"myweb:touch:start:\"+e.touches[0].pageX+ \":\" + e.touches[0].pageY ;  }; document.ontouchend=function(e){          document.location=\"myweb:touch:end:\"+e.touches[0].pageX+ \":\" + e.touches[0].pageY ;  }; document.ontouchmove=function(e){          document.location=\"myweb:touch:move:\"+e.touches[0].pageX+ \":\" + e.touches[0].pageY ;  }  </script>"];
    [myWebView loadHTMLString:newHTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [htmlstring release];
	myWebView.scalesPageToFit =YES;
    myWebView.delegate =self;
	myWebView.detectsPhoneNumbers = NO;
	myWebView.backgroundColor=[UIColor clearColor];
	[self.view addSubview:myWebView];
	
	arr = [[NSArray alloc] init];
	clickCount = 0;
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 688, 50,60)];//(50, 688, 50,60)
    [backButton setBackgroundImage:[UIImage imageNamed:@"thirdBack.png"]
				forState:UIControlStateNormal];
	[backButton addTarget:self 
				   action:@selector(back)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	[backButton release];
	connectButton.userInteractionEnabled = NO;
	indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
	 UIActivityIndicatorViewStyleGray];
	[indicator setCenter:CGPointMake(500, 392)];
	[self.view addSubview:indicator];
	[indicator startAnimating];
	loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(520, 367, 150, 50)];
	loadImageView.image = [UIImage imageNamed:@"excel_loading.png"];
	[self.view addSubview:loadImageView];
	
}

//数据备份
- (void)dateBackupRestore{	
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
    (NSLibraryDirectory, NSUserDomainMask, YES); 
    NSString *libraryDir = [libraryPaths objectAtIndex:0];
    NSString *databaseBackupPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:databaseBackupPath]) {
        NSString *backupFile = [libraryDir stringByAppendingPathComponent:@"Backup"]; 
        NSString *testBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/test.db"]; 
        NSString *databaseBackupFile = [libraryDir stringByAppendingPathComponent:@"Backup/Databases.db"];
        NSString *databaseFormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases"];
        NSString *file0FormerPath = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases/file__0"];
        
        NSFileManager *NFM = [NSFileManager defaultManager];
        BOOL isDir = YES;
        if (![NFM fileExistsAtPath:databaseFormerPath isDirectory:&isDir]) {
            if (![NFM createDirectoryAtPath:databaseFormerPath attributes:nil]) {
                //build forder
            }
        }
        if (![NFM fileExistsAtPath:file0FormerPath isDirectory:&isDir]) {
            if (![NFM createDirectoryAtPath:file0FormerPath attributes:nil]) {
                //build forder
            }
        }
        
        NSString *databaseFormerFile = [databaseFormerPath stringByAppendingPathComponent:@"/Databases.db"];
        NSString *testFormerFile = [file0FormerPath stringByAppendingPathComponent:@"/test.db"];
        
        NSData *databaseData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:databaseBackupFile]];
        NSData *testData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:testBackupFile]];
        
        
        [databaseData writeToFile:databaseFormerFile atomically:YES];
        [testData writeToFile:testFormerFile atomically:YES];
        
        [databaseData release];
        [testData release];
        [[NSFileManager defaultManager] removeItemAtPath:backupFile error:nil];
    }
}

//返回上一层控制器
- (void)back
{
	UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	CGRect endFrame = CGRectMake(1024, 0, 1024, 768);
	
	[UIView beginAnimations:nil context:nil];
	for (UIImageView *img in [navagation.view subviews])
	{
		if (110 == img.tag || 150 == img.tag) 
		{
			img.frame = endFrame;
		}
		
	}
	[UIView setAnimationDuration:1.2];
	[UIView commitAnimations];
	[self.del resue];
	if (connectView)
	{
		for(UIView *v in [connectView subviews])
		{
			[v removeFromSuperview];
		}
		[connectView removeFromSuperview];
		myWebView.userInteractionEnabled = YES;
	}
	[self.view removeFromSuperview];
}

//加载联系人信息
-(void)goConnect
{
	++clickCount;
	if (clickCount==1)
	{
		if(connectView)
		{
		   for(UIView *v in [connectView subviews])
		   {
			   [v removeFromSuperview];
		   }
			[connectView removeFromSuperview];
		}
		[connectButton setTitle:@"取消" forState:UIControlStateNormal];
		myWebView.userInteractionEnabled = NO;
		connectView = [[UIImageView alloc] initWithFrame:CGRectMake(980, 70, 0, 0)];//900,100
		connectView.image = [UIImage imageNamed:@"lianxibg.png"];
		connectView.layer.cornerRadius = 10;
		connectView.layer.borderColor = [[UIColor blackColor] CGColor];
		connectView.layer.masksToBounds = YES;
		[self.view addSubview:connectView];
		UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 75, 70, 20)];//250,60
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.text = @"姓名：";
		nameLabel.textAlignment = UITextAlignmentCenter;
		nameLabel.font = [UIFont fontWithName:@"helvetica" size:20];
		
		
		UILabel *zhiwu = [[UILabel alloc]initWithFrame:CGRectMake(245, 100, 80, 100)];//70
		zhiwu.backgroundColor = [UIColor clearColor];
		zhiwu.text = @"职务：";
		zhiwu.textAlignment = UITextAlignmentCenter;
		zhiwu.font = [UIFont fontWithName:@"helvetica" size:20];
		UILabel *zhiwuLabel = [[UILabel alloc] init];
		if (self.unitName !=nil)
		{
			CGSize labelSize = [self.unitName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]
										 constrainedToSize:CGSizeMake(540, 100) 
											 lineBreakMode:UILineBreakModeCharacterWrap];
			zhiwuLabel.frame = CGRectMake(330, 100, labelSize.width, 100);
			zhiwuLabel.text = self.unitName;
			zhiwuLabel.backgroundColor = [UIColor clearColor];
			//zhiwuLabel.font = [UIFont boldSystemFontOfSize:20.0f];
			zhiwuLabel.numberOfLines = 0;
			zhiwuLabel.lineBreakMode = UILineBreakModeCharacterWrap; 
		}
		nameContent = [[UILabel alloc]initWithFrame:CGRectMake(330,75, 500, 20)];
		nameContent.backgroundColor = [UIColor clearColor];
		nameContent.font = [UIFont fontWithName:@"helvetica" size:20];
		nameContent.textAlignment = UITextAlignmentLeft;
		nameContent.text = self.personName;
		
		workNumber = [[UILabel alloc]initWithFrame:CGRectMake(35, 334, 120, 40)];
		address = [[UILabel alloc]initWithFrame:CGRectMake(35,384,120, 40)];
		homeNumber = [[UILabel alloc]initWithFrame:CGRectMake(35,434,120, 40)];
		phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(35,484,145,40)];
		workNumber.backgroundColor = [UIColor clearColor];
		address.backgroundColor = [UIColor clearColor];
		homeNumber.backgroundColor = [UIColor clearColor];
		phoneNumber.backgroundColor = [UIColor clearColor];
		
		
		workNumberContent = [[UILabel alloc]initWithFrame:CGRectMake(155, 334, 400, 40)];
		addressContent = [[UILabel alloc]initWithFrame:CGRectMake(155,384,400,40)];
		homeNumberContent = [[UILabel alloc]initWithFrame:CGRectMake(155,434,400,40)];
		phoneNumberContent = [[UILabel alloc]initWithFrame:CGRectMake(180,484,400,40)];
		workNumberContent.backgroundColor = [UIColor clearColor];
		addressContent.backgroundColor = [UIColor clearColor];
		homeNumberContent.backgroundColor = [UIColor clearColor];
		phoneNumberContent.backgroundColor = [UIColor clearColor];
		workNumber.text = @"工作电话：";
		address.text = @"家庭住址：";
		homeNumber.text = @"住宅电话：";
		phoneNumber.text = @"移动通讯号码：";
		addressContent.font = [UIFont fontWithName:@"helvetica" size:20];
		workNumberContent.font = [UIFont fontWithName:@"helvetica" size:20];
		homeNumberContent.font = [UIFont fontWithName:@"helvetica" size:20];
		phoneNumberContent.font = [UIFont fontWithName:@"helvetica" size:20];
		workNumber.font = [UIFont fontWithName:@"helvetica" size:20];
		address.font = [UIFont fontWithName:@"helvetica" size:20];
		homeNumber.font = [UIFont fontWithName:@"helvetica" size:20];
		phoneNumber.font = [UIFont fontWithName:@"helvetica" size:20];
		workNumberContent.textAlignment = UITextAlignmentLeft;
		addressContent.textAlignment = UITextAlignmentLeft;
		homeNumberContent.textAlignment = UITextAlignmentLeft;
		phoneNumberContent.textAlignment = UITextAlignmentLeft;
		
		personImage = [[UIImageView alloc]initWithFrame:CGRectMake(37,30 ,KPICTURERECT_WIDTH,KPICTURERECT_HEIGHT)];
		[connectView addSubview:nameLabel];
		[connectView addSubview:zhiwu];
		[connectView addSubview:zhiwuLabel];
		[connectView addSubview:nameContent];
		[connectView addSubview:workNumber];
		[connectView addSubview:workNumberContent];
		[connectView addSubview:phoneNumber];
		[connectView addSubview:phoneNumberContent];
		[connectView addSubview:homeNumber];
		[connectView addSubview:homeNumberContent];
		[connectView addSubview:addressContent];
		[connectView addSubview:address];
		[connectView addSubview:personImage];
		connectView.clipsToBounds = YES;
		[nameLabel release];
		[zhiwu release];
		[zhiwuLabel release];
		CGRect endFrame = CGRectMake(100, 70, 895, 675);//190,145,580
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		connectView.frame = endFrame;
		[UIView commitAnimations];
		[self addInfo];
	}
	else if(clickCount ==2)
	{
		clickCount = 0;
		myWebView.userInteractionEnabled = YES;
		[connectButton setTitle:@"联系方式" forState:UIControlStateNormal];
		CGRect endFrame = CGRectMake(980, 70, 0, 0);//140
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		connectView.frame = endFrame;
		connectView.clipsToBounds = YES;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(move)];
		[UIView commitAnimations];
	}
	
}

//移除视图
-(void)move
{
    //遍历view属于connectView的视图
   for(UIView *v in [connectView subviews])
   {
       [v release];
	   v=nil;
    }
	[connectView removeFromSuperview];
	connectView = nil;
	
}

//添加联系方式的信息
-(void)addInfo
{
	NSString *sqlString = [NSString stringWithFormat:@"select * from IPAD_A01 where A00 = '%@';",self.personID];
	NSArray *personInfo = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString];
	
	NSURL *url = [NSURL URLWithString:self.personImageString];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *ret = [UIImage imageWithData:imageData];
	[personImage setImage:ret];
	
	int n;
	for(int i=0;i<[personInfo count];i++)
	{
		workNumberContent.text = [[personInfo objectAtIndex:i] objectForKey:@"A3707A"];
		NSString *s = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
		if(s.length>20)
		{
			if (s.length%20==0)
			{
				n = s.length/20;
				addressContent.numberOfLines=n;
				address.frame = CGRectMake(35,384,200,40*n);
				addressContent.frame = CGRectMake(155,384,400,40*n);
				homeNumber.frame = CGRectMake(35, (384+40*n+10), 120, 40);
				phoneNumber.frame = CGRectMake(35, (384+40*n+10+10+40), 145, 40);
				homeNumberContent.frame = CGRectMake(155,(384+40*n+10),200, 40);
				phoneNumberContent.frame = CGRectMake(180,(384+40*n+10+10+40) , 200, 40);
			}
			else {
				n = s.length/20+1;
				addressContent.numberOfLines=n;
				address.frame = CGRectMake(35,384,200,40*n);
				addressContent.frame = CGRectMake(155,384,400,40*n);
				homeNumber.frame = CGRectMake(35, (384+40*n+10), 120, 40);
				phoneNumber.frame = CGRectMake(35, (384+40*n+10+10+40), 145, 40);
				homeNumberContent.frame = CGRectMake(155,(384+40*n+10),200, 40);
				phoneNumberContent.frame = CGRectMake(180,(384+40*n+10+10+40) , 200, 40);
			}
			addressContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
			homeNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707B"];
			phoneNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707C"];
		}
		else {
			address.frame = CGRectMake(35,384,120, 40);
			homeNumber.frame = CGRectMake(35,434,120, 40);
			phoneNumber.frame = CGRectMake(35,484,145,40);
			addressContent.frame=CGRectMake(155,384,400,40);//40,160
			homeNumberContent.frame = CGRectMake(155,434,400,40);//190
			phoneNumberContent.frame = CGRectMake(180,484,400,40);//240
			workNumberContent.text = [[personInfo objectAtIndex:i] objectForKey:@"A3707A"];
			addressContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
			homeNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707B"];
			phoneNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707C"];
		}
	}
	
}
//-(void)touchesMoved{
//	int xOffset=endPointX-beginPointX;
//	int yOffset=endPointY-beginPointY;
//	if (xOffset>0&&abs(yOffset)<=2) {
//		
//		//for (UIView * vie in [myWebView subviews]) 
////		{
////			if ([vie isKindOfClass:[UIScrollView class]]) 
////			{
////				UIScrollView *scrollerView = (UIScrollView *)vie;
////				if (scrollerView.zoomScale == scrollerView.minimumZoomScale) {
////					[UIView beginAnimations:nil context:self.view];
////					[UIView setAnimationDuration:0.5];
////					[UIView setAnimationRepeatCount:1];
////					self.view.frame=CGRectMake(1024, 
////											   0,
////											   self.view.frame.size.width,
////											   self.view.frame.size.height);
////					[UIView commitAnimations];
////				}
////			}
////		}
//		
//	}
//	
//	
//	
//	
//}
#pragma mark -
#pragma mark touch事件
//点击事件，开始点击
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch=[touches anyObject];
	CGPoint beginPoint=[touch locationInView:self.view];
	beginPointX=beginPoint.x;
}

//点击事件，拖动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch=[touches anyObject];
	CGPoint endPoint=[touch locationInView:self.view];
	endPointX=endPoint.x;
}

//点击事件，点击结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.del resue];
	if (clickCount==2)
	{
		for(UIView *v in [connectView subviews])
		{
			[v removeFromSuperview];
		}
		[connectView removeFromSuperview];
		myWebView.userInteractionEnabled = YES;
	}
	
}
#pragma mark -
#pragma mark 向右滑动事件
//手势识别向右滑动
- (void)moveRight
{
	
	[UIView beginAnimations:nil context:self.view];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationRepeatCount:1];
	self.view.frame=CGRectMake(1024, 
							   0,
							   self.view.frame.size.width,
							   self.view.frame.size.height);
	[UIView commitAnimations];
    [self.del resue];
	if (connectView)
	{
		for(UIView *v in [connectView subviews])
		{
			[v removeFromSuperview];
		}
		[connectView removeFromSuperview];
		myWebView.userInteractionEnabled = YES;
	}
}
#pragma mark -
#pragma mark UIWebView delegate
//UIWebView代理方法，开始加载webView视图
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"asssssssss%@",[components objectAtIndex:2]);
			NSString *string=[components objectAtIndex:2];
			if ([string isEqualToString:@"start"]) {
				//[self touchesBegan];
				beginPointX=[[components objectAtIndex:3]intValue];
				beginPointY=[[components objectAtIndex:4]intValue];
			}
			else if([string isEqualToString:@"move"]){
				//[self touchesMoved];
				endPointX=[[components objectAtIndex:3]intValue];
				endPointY=[[components objectAtIndex:4]intValue];
			}
			else if([string isEqualToString:@"end"]){
				//[self touchesEnded];
			}
        }
        return NO;
    }
    return YES;
}

//UIWebView代理方法，获取数据，移除视图
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	for(UIScrollView *v in [myWebView subviews])
	{
		v.contentOffset = CGPointMake(0, 0);
	}
	arr = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:[NSString stringWithFormat:@"select * from IPAD_RESUME where A00 = '%@'",self.personID]];
	NSString *tagString = @"\\n";
	for (int i=0; i<[arr count]; i++) {
		for (int j=0; j<[[arr objectAtIndex:i]count]; j++) 
		{
			NSMutableString *newContent = [NSMutableString stringWithFormat:@"%@",[[[arr objectAtIndex:i] allValues] objectAtIndex:j]];
			NSRange range = [newContent rangeOfString:tagString];
			
			if (range.length != 0)
			{
			    newContent = [newContent stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br/>"];

				
				NSRange range1 = [newContent rangeOfString:@"<br/><br/>"];
				NSRange range2 = [newContent rangeOfString:@"\""];
				while (range1.length!=0)
				{
					if (range1.location==0)
					{
						[newContent deleteCharactersInRange:range1];
					}
					newContent = [newContent stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"<br/>"];
					range1 = [newContent rangeOfString:@"<br/><br/>"];
				}
				while (range2.length!=0)
				{
					newContent = [newContent stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
					range2= [newContent rangeOfString:@"\""];
				}
			}
			[myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('%@').innerHTML=\"%@\"",[[[arr objectAtIndex:i] allKeys] objectAtIndex:j],newContent]];
		}
		
	}
	
	NSString *idString = [[arr objectAtIndex:0] objectForKey:@"A00"];
	NSString *relationString = [NSString stringWithFormat:@"select * from IPAD_A36 where A00='%@' order by InpFrq asc",idString];
	NSArray *relationArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSqlString:relationString];
	
	for(NSDictionary *dic in relationArray)
	{
		[myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('%@').innerHTML='%@'",[[dic allKeys]objectAtIndex:0],[[dic allValues]objectAtIndex:0]]];
	}
	[myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('image').src = '%@'",self.personImageString]];
	if (clickCount == 1)
	{
		[connectButton setTitle:@"联系方式" forState:UIControlStateNormal];
	}
	clickCount = 0;
	
	connectButton.userInteractionEnabled = YES;
	[indicator stopAnimating];
	[indicator removeFromSuperview];
	[loadImageView removeFromSuperview];
}

// Notifies when rotation begins, reaches halfway point and ends.
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

// Called when the parent application receives a memory warning. Default implementation releases the view if it doesn't have a superview.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//对象释放
- (void)dealloc {
	[personName release];
	[unitName release];
	[workNumber release];
	[workNumberContent release];
	[phoneNumber release];
	[phoneNumberContent release];
	[address release];
	[addressContent release];
	[homeNumber release];
	[homeNumberContent release];
	[personImage release];
	[arr release];
	[imageArray release];
	[connectButton release];
	[personImageString release];
	[personID release];
    [super dealloc];
}


@end
