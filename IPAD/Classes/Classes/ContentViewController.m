    //
//  ContentViewController.m
//  IpadTest
//
//  Created by yang on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"
#import "SQLiteOptions.h"
#import <QuartzCore/QuartzCore.h>
#import "PersonsInfo.h"

@implementation ContentViewController

@synthesize delegate;

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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) 
												 name:@"select" 
											   object:nil];
	personImage = [[UIImageView alloc]initWithFrame:CGRectMake(32,25 ,KPICTURERECT_WIDTH,KPICTURERECT_HEIGHT)];
	UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(200, 45, 70, 20)];
	name.backgroundColor = [UIColor clearColor];
	name.text = @"姓名：";
	name.textAlignment = UITextAlignmentCenter;
	
	UILabel *zhiwu = [[UILabel alloc]initWithFrame:CGRectMake(200, 75, 70, 130)];//(200, 115, 70, 20)
	zhiwu.backgroundColor = [UIColor clearColor];
	zhiwu.text = @"职务：";
	zhiwu.textAlignment = UITextAlignmentCenter;
	zhiwu.font = [UIFont fontWithName:@"helvetica" size:20];

	zhiwuLabel = [[UILabel alloc] init];
	
	
	nameLable = [[UILabel alloc]initWithFrame:CGRectMake(270,35, 200, 40)];
	nameLable.backgroundColor = [UIColor clearColor];
	nameLable.font = [UIFont fontWithName:@"helvetica" size:20];
	name.font = [UIFont fontWithName:@"helvetica" size:20];
	nameLable.textAlignment = UITextAlignmentLeft;
	workNumber = [[UILabel alloc]initWithFrame:CGRectMake(35, 234, 120, 40)];
	address = [[UILabel alloc]initWithFrame:CGRectMake(35,284,120, 40)];
	homeNumber = [[UILabel alloc]initWithFrame:CGRectMake(35,334,120, 40)];
	phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(35,384,145,40)];
	workNumber.backgroundColor = [UIColor clearColor];
	address.backgroundColor = [UIColor clearColor];
	homeNumber.backgroundColor = [UIColor clearColor];
	phoneNumber.backgroundColor = [UIColor clearColor];
	workNumberContent = [[UILabel alloc]initWithFrame:CGRectMake(155, 234, 400, 40)];
	addressContent = [[UILabel alloc]initWithFrame:CGRectMake(155,284,400,40)];
	homeNumberContent = [[UILabel alloc]initWithFrame:CGRectMake(155,334,400,40)];
	phoneNumberContent = [[UILabel alloc]initWithFrame:CGRectMake(180,384,400,40)];
	workNumberContent.backgroundColor = [UIColor clearColor];
	//workNumberContent.layer.cornerRadius = 10;//设置那个圆角的有多圆
//	workNumberContent.layer.borderWidth =1 ;//设置边框的宽度，当然可以不要
//	workNumberContent.layer.borderColor = [[UIColor blackColor] CGColor];//设置边框的颜色
//	workNumberContent.layer.masksToBounds = YES;//设为NO去试试
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
	self.view.frame = CGRectMake(325, 70, 570, 677);
    UIImageView	*backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 565, 665)];
	backgroundImage.image = [UIImage imageNamed:@"bg.png"];
	[self.view addSubview:backgroundImage];
	[backgroundImage addSubview:workNumber];
	[backgroundImage addSubview:address];
	[backgroundImage addSubview:homeNumber];
	[backgroundImage addSubview:phoneNumber];
	[backgroundImage addSubview:workNumberContent];
	[backgroundImage addSubview:addressContent];
	[backgroundImage addSubview:homeNumberContent];
	[backgroundImage addSubview:phoneNumberContent];
	[backgroundImage addSubview:personImage];
	[backgroundImage addSubview:nameLable];
	[backgroundImage addSubview:name];
	[backgroundImage addSubview:zhiwu];
	[backgroundImage addSubview:zhiwuLabel];
	[zhiwu release];
	[name release];
	[backgroundImage release];
	selectCount=0;
}

//查询数据库，显示个人信息等信息的视图
-(void)show:(NSNotification *)notification
{
	++selectCount;
	nowIndexPath = [(NSIndexPath *)[notification object]copy];
	//PersonsInfo *thePerson = [[sectionsArray objectAtIndex:[[validSectionArray objectAtIndex:nowIndexPath.section]intValue]] objectAtIndex:nowIndexPath.row];
    NSInteger currentArrIndex = nowIndexPath.section;
    //PersonsInfo *currentPerson = [[delegate personsArray] objectAtIndex:currentArrIndex];
    //NSString *condition = currentPerson.personID;
	//NSString *condition =  [[[[delegate tableView] cellForRowAtIndexPath:nowIndexPath]textLabel]text];
    //add by zyy 2014-05-13修改为ID过滤，ID藏在了cell的一个subview里
    NSString *condition =  [[[[[delegate tableView] cellForRowAtIndexPath:nowIndexPath]subviews] objectAtIndex:2] text];
	NSString *sqlString = [NSString stringWithFormat:@"select * from IPAD_A01 where A00 = '%@';",condition];
	//NSString *sqlString1 = [NSString stringWithFormat:@"select * from IPAD_A01_Function where A0101 = '%@';",condition];
	//NSArray  *imageArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString1];
	NSArray *personInfo = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString];
	for(PersonsInfo *thePerson in [delegate personsArray])
	{
	   if ([thePerson.personID isEqualToString:condition])
	   {
		   CGSize labelSize = [thePerson.detailInfo
							   sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]
							   constrainedToSize:CGSizeMake(290, 130) //(270, 115, 270, 20)
							   lineBreakMode:UILineBreakModeCharacterWrap];  
		   zhiwuLabel.frame = CGRectMake(270, 75, labelSize.width, 130);
		   zhiwuLabel.text = thePerson.detailInfo;
		   zhiwuLabel.backgroundColor = [UIColor clearColor];
		   zhiwuLabel.numberOfLines = 0;    
		   zhiwuLabel.lineBreakMode = UILineBreakModeCharacterWrap; 
		   nameLable.text = thePerson.name;
		   NSString *image = thePerson.image;
		   NSURL *url = [NSURL URLWithString:image];
		   NSData *imageData = [NSData dataWithContentsOfURL:url];
		   UIImage *ret = [UIImage imageWithData:imageData];
		   [personImage setImage:ret];
		   int n;
		   for(int i=0;i<[personInfo count];i++)
		   {
			   //if([thePerson.detailInfo isEqualToString:[[personInfo objectAtIndex:i]objectForKey:@"A0215"]])
//			   {
				   workNumberContent.text = [[personInfo objectAtIndex:i] objectForKey:@"A3707A"];
				   NSString *s = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
				   if(s.length>20)
				   {
					   if (s.length%20==0)
					   {
						   n = s.length/20;
						   addressContent.numberOfLines=n;
						   address.frame = CGRectMake(35,284,200,40*n);
						   addressContent.frame = CGRectMake(155,284,400,40*n);
						   homeNumber.frame = CGRectMake(35, (284+40*n+10), 120, 40);
						   phoneNumber.frame = CGRectMake(35, (284+40*n+10+10+40), 145, 40);
						   homeNumberContent.frame = CGRectMake(155,(284+40*n+10),200, 40);
						   phoneNumberContent.frame = CGRectMake(180,(284+40*n+10+10+40) , 200, 40);
					   }
					   else {
						   n = s.length/20+1;
						   addressContent.numberOfLines=n;
						   address.frame = CGRectMake(35,284,200,40*n);
						   addressContent.frame = CGRectMake(155,284,400,40*n);
						   homeNumber.frame = CGRectMake(35, (284+40*n+10), 120, 40);
						   phoneNumber.frame = CGRectMake(35, (284+40*n+10+10+40), 145, 40);
						   homeNumberContent.frame = CGRectMake(155,(284+40*n+10),200, 40);
						   phoneNumberContent.frame = CGRectMake(180,(284+40*n+10+10+40) , 200, 40);
					   }
					   addressContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
					   homeNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707B"];
					   phoneNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707C"];
				   }
				   else {
					   address.frame = CGRectMake(35,284,120, 40);
					   homeNumber.frame = CGRectMake(35,334,120, 40);
					   phoneNumber.frame = CGRectMake(35,384,145,40);
					   addressContent.frame=CGRectMake(155,284,400,40);//40,160
					   homeNumberContent.frame = CGRectMake(155,334,400,40);//190
					   phoneNumberContent.frame = CGRectMake(180,384,400,40);//240
					   workNumberContent.text = [[personInfo objectAtIndex:i] objectForKey:@"A3707A"];
					   addressContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
					   homeNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707B"];
					   phoneNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707C"];
				   }
				  // break;
			   //}
			   
			   
		   }
		  // break;
	   }
	}
	
	cell = [[delegate tableView] cellForRowAtIndexPath:nowIndexPath];
	if (selectCount >1)
	{
		cell = [[delegate tableView] cellForRowAtIndexPath:indexPathNow];
		cell.selected = NO;
		cell = [[delegate tableView] cellForRowAtIndexPath:nowIndexPath];
	}
}

//点击触发事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	cell.selected = NO;
	indexPathNext = [NSIndexPath indexPathForRow:nowIndexPath.row + 1
									   inSection:nowIndexPath.section];
	
	if(indexPathNext.row >=[[delegate tableView] numberOfRowsInSection:nowIndexPath.section])
	{
	    indexPathNext = [NSIndexPath indexPathForRow:0
										   inSection:nowIndexPath.section+1];
		
		nowIndexPath = indexPathNext;
	}

	nowIndexPath = [indexPathNext copy];
	NSString *condition =  [[[[delegate tableView] cellForRowAtIndexPath:nowIndexPath]textLabel]text];
	//PersonsInfo *thePerson = [[sectionsArray objectAtIndex:[[validSectionArray objectAtIndex:nowIndexPath.section]intValue]] objectAtIndex:nowIndexPath.row];
	if(condition==nil)
	{
	    
	}
	else
	{
		//PersonsInfo *thePerson = [[sectionsArray objectAtIndex:[[validSectionArray objectAtIndex:nowIndexPath.section]intValue]] objectAtIndex:nowIndexPath.row];
		cell = [[delegate tableView] cellForRowAtIndexPath:nowIndexPath];
		cell.selected = YES;
		NSString *sqlString = [NSString stringWithFormat:@"select * from IPAD_A01 where A0101 = '%@';",condition];
		NSArray *personInfo = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString];
		//NSString *sqlString1 = [NSString stringWithFormat:@"select * from IPAD_A01_Function where A0101 = '%@';",condition];
		//NSArray  *imageArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sqlString1];
		for(PersonsInfo *thePerson in [delegate personsArray])
		{
		   if ([thePerson.name isEqualToString:condition])
		   {
			   nameLable.text = thePerson.name;
			   CGSize labelSize = [thePerson.detailInfo
								   sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]
								   constrainedToSize:CGSizeMake(290, 130) //(270, 115, 270, 20)
								   lineBreakMode:UILineBreakModeCharacterWrap];  
			   zhiwuLabel.frame = CGRectMake(270, 75, labelSize.width, 130);
			   zhiwuLabel.text = thePerson.detailInfo;
			   zhiwuLabel.backgroundColor = [UIColor clearColor];
			   zhiwuLabel.numberOfLines = 0;   
			   zhiwuLabel.lineBreakMode = UILineBreakModeCharacterWrap;   
			   
			   NSString *image = thePerson.image;//[NSString stringWithFormat:@"data:image/png;base64,%@",thePerson.image];
			   NSURL *url = [NSURL URLWithString:image];
			   NSData *imageData = [NSData dataWithContentsOfURL:url];
			   UIImage *ret = [UIImage imageWithData:imageData];
			   [personImage setImage:ret];
			   
			   int n;
			   for(int i=0;i<[personInfo count];i++)
			   {
				   //NSString *image = [NSString stringWithFormat:@"data:image/png;base64,%@",[[imageArray objectAtIndex:i] objectForKey:@"FILE"]];
				   //if([thePerson.detailInfo isEqualToString:[[personInfo objectAtIndex:i]objectForKey:@"A0215"]])
//				   {
					   workNumberContent.text = [[personInfo objectAtIndex:i] objectForKey:@"A3707A"];
					   NSString *s = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
					   if(s.length>20)
					   {
						   if (s.length%20==0)
						   {
							   n = s.length/20;
							   addressContent.numberOfLines=n;
							   address.frame = CGRectMake(35,284,200,40*n);
							   addressContent.frame = CGRectMake(155,284,400,40*n);
							   homeNumber.frame = CGRectMake(35, (284+40*n+10), 120, 40);
							   phoneNumber.frame = CGRectMake(35, (284+40*n+10+10+40), 145, 40);
							   homeNumberContent.frame = CGRectMake(155,(284+40*n+10),200, 40);
							   phoneNumberContent.frame = CGRectMake(180,(284+40*n+10+10+40) , 200, 40);
						   }
						   else {
							   n = s.length/20+1;
							   addressContent.numberOfLines=n;
							   address.frame = CGRectMake(35,284,200,40*n);
							   addressContent.frame = CGRectMake(155,284,400,40*n);
							   homeNumber.frame = CGRectMake(35, (284+40*n+10), 120, 40);
							   phoneNumber.frame = CGRectMake(35, (284+40*n+10+10+40), 145, 40);
							   homeNumberContent.frame = CGRectMake(155,(284+40*n+10),200, 40);
							   phoneNumberContent.frame = CGRectMake(180,(284+40*n+10+10+40) , 200, 40);
						   }
						   addressContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
						   homeNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707B"];
						   phoneNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707C"];
					   }
					   else {
						   address.frame = CGRectMake(35,284,120, 40);
						   homeNumber.frame = CGRectMake(35,334,120, 40);
						   phoneNumber.frame = CGRectMake(35,384,145,40);
						   addressContent.frame=CGRectMake(155,284,400,40);//40,160
						   homeNumberContent.frame = CGRectMake(155,334,400,40);//190
						   phoneNumberContent.frame = CGRectMake(180,384,400,40);//240
						   workNumberContent.text = [[personInfo objectAtIndex:i] objectForKey:@"A3707A"];
						   addressContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
						   homeNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707B"];
						   phoneNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707C"];
					   }
					   addressContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3711"];
					   homeNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707B"];
					   phoneNumberContent.text = [[personInfo objectAtIndex:i]objectForKey:@"A3707C"];
				       //break;
				   //}
			   }
			  // break;
		   }
		}
		
		[self performCurlUp:nil];
	}
	indexPathNow = [nowIndexPath copy];
}

//翻过通讯录详情的当前页，到下一页面
- (void) performCurlUp:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
   // [personImage removeFromSuperview];
   // [self.view bringSubviewToFront:contentView];
    [UIView commitAnimations];
	
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return ((interfaceOrientation==UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
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
	[nameLable release];
	[workNumber release];
	[workNumberContent release];
	[phoneNumber release];
	[phoneNumberContent release];
	[address release];
	[addressContent release];
	[homeNumber release];
	[homeNumberContent release];
	[personImage release];
	[zhiwuLabel release];
    [super dealloc];
}


@end
