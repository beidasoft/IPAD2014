    //
//  ConnectController.m
//  IPAD
//
//  Created by yang on 12-2-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectController.h"
#import "SQLiteOptions.h"
#import "PersonsInfo.h"


@implementation ConnectController
@synthesize condition,tit;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = self.tit;
	UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tong.png"]];
	
	self.view.frame = CGRectMake(0,0,1024,768);
	v.frame = self.view.frame;
	[self.view addSubview:v];
	[v release];
	listController = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	contentController = [[ContentViewController alloc] init];
	contentController.view.frame = CGRectMake(440, 135, 572, 620);//450
	[contentController setDelegate:listController];
	[self.view addSubview:listController.view];
	[self.view addSubview:contentController.view];
	NSString *sql = [NSString stringWithFormat:@"select * from persons where parent_id = %d",self.condition];
	NSMutableArray *personInfos = [[NSMutableArray alloc]init];
	NSArray *personsInfo = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:sql];
    for(int i=0;i<[personsInfo count];i++)
		{ 
			  NSString *nameContent = [[personsInfo objectAtIndex:i]objectForKey:@"name"];
			  NSString *pinyinContent = [[personsInfo objectAtIndex:i] objectForKey:@"pinyin"];
			[personInfos addObject:[NSDictionary dictionaryWithObject:nameContent forKey:pinyinContent]];
		}
		NSMutableArray *persons = [[NSMutableArray alloc] initWithCapacity:[personInfos count]];
		
		for (NSDictionary *personName in personInfos) {
			PersonsInfo *personWrapper =  [[PersonsInfo alloc] initWithDictionary:personName];
			[persons addObject:personWrapper];
			[personWrapper release];
		}
		listController.personsArray = persons;
		[persons release];
	[personInfos release];
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 698, 80, 70)];
    [backButton setImage:[UIImage imageNamed:@"thirdBack.png"]
				forState:UIControlStateNormal];
	[backButton addTarget:self 
				   action:@selector(back)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backButton];
	[backButton release];
}

//返回上一级视图控制器
- (void)back
{
	UINavigationController *navagation = [(IPADAppDelegate *)[[UIApplication sharedApplication] delegate] navigationController];
	CGRect endFrame = CGRectMake(1024, 0, 1024, 768);
	
	[UIView beginAnimations:nil context:nil];
    
    //遍历属于navagation.view的视图
	for (UIImageView *img in [navagation.view subviews])
	{
        //根据tag值判断视图
		if (101 == img.tag ) 
		{
			img.frame = endFrame;
		}
	}
	[UIView setAnimationDuration:1.2];
	[UIView commitAnimations];
}

// Override to allow rotation. Default returns YES only for UIInterfaceOrientationPortrait
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    //return YES;
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
    [super dealloc];
	[listController release];
	[contentController release];
}
@end
