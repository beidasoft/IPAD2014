#import "NavController.h"
#import "fileViewController.h"
#import "Constants.h"
#import "infoViewController.h"
#import "IPADAppDelegate.h"
#import "audioPlayerViewController.h"
//http server
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAdresses.h"

#import "SynopsisPageController.h"


enum PageIndices
{
	kPageOneIndex	= 0,
	kPageTwoIndex	= 1,
	kPageThreeIndex = 2,
	kPageFourIndex	= 3,
	kPageFiveIndex	= 4
};

enum FileType
{
	kFileTypeAudio		= 0,
	kFileTypeVideo		= 1,
	kFileTypeImage		= 2,
	kFileTypeOther		= 3,
	kFileTypeUnknown	= 4,
	kFileTypeFolder		= 5,
};


//@end
@implementation NavController
@synthesize ipAddress, httpServer, addresses;
@synthesize menuList, listModeTabbar, sharingView, listTableView, kindTableView, optionBalk, _WorkingDirectory;

- (id)initWithWorkingDir:(NSString *)workingDir isRoot:(BOOL)isRoot;
{
	self = [super init];
	if (self)
	{
		// this will appear as the title in the navigation bar
		_WorkingDirectory = [[NSString alloc] initWithString:workingDir];
		_isRoot = isRoot;
		
	}
	return self;
}


- (void)setWorkingDirectory:(NSString*)workingDirectory
{
	NSLog(@"setWorkingDirectory");
	_WorkingDirectory = [[NSString alloc] initWithString:workingDirectory];
}

- (void)setIsRoot:(BOOL)isRoot
{
	_isRoot = isRoot;
}

- (NSString*) getPathForFileName:(NSString*)fileName
{
	return [_WorkingDirectory stringByAppendingPathComponent:fileName];	
}

//- (void)setSelectedTab:(int)index
//{
//	NSLog(@"setSelectedTab : %i",index);
//	[listModeTabbar setSelectedItem:[[listModeTabbar items] objectAtIndex:index]];
//	[self tabBar:listModeTabbar didSelectItem:[[listModeTabbar items] objectAtIndex:index]];
//}

-(void)refresh
{
	
	
	NSString *path = _WorkingDirectory;

	NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	
	[menuList removeAllObjects];
	[fileKindCount removeAllObjects];
	
	//将标识存入字典
	[fileKindCount setObject:[NSNumber numberWithInt:0] forKey:@"Audio"];
	[fileKindCount setObject:[NSNumber numberWithInt:0] forKey:@"Video"];
	[fileKindCount setObject:[NSNumber numberWithInt:0] forKey:@"Image"];
	[fileKindCount setObject:[NSNumber numberWithInt:0] forKey:@"Other"];
	[fileKindCount setObject:[NSNumber numberWithInt:0] forKey:@"File"];
	[fileKindCount setObject:[NSNumber numberWithInt:0] forKey:@"Folder"];
	
	
	for (NSString *fname in array)
    {
		
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fname] error:nil];
		//        NSString *modDate = [[fileDict objectForKey:NSFileModificationDate] description];
		
		int fileType = kFileTypeUnknown;
		NSString *iconpng = @"pdf.png";
		
		NSString *explaination;
		
		explaination = @"Unknown filetype";
		
		if ([[fileDict objectForKey:NSFileType] isEqualToString: @"NSFileTypeDirectory"]){
			fileType = kFileTypeFolder;
			explaination = @"Folder";
			iconpng = @"Folder.png";
		}
		
		if (![fname hasPrefix:@"."])
		{
			
			
			
			
			if ([[fname lowercaseString] hasSuffix:@".pdf"]){
				iconpng = @"pdf.png";
				explaination = @"PDF";
				fileType = kFileTypeOther;
			}
			if ([[fname lowercaseString] hasSuffix:@".png"]){
				iconpng = @"jpg.png";
				explaination = @"Image";
				fileType = kFileTypeImage;
			}
			if ([[fname lowercaseString] hasSuffix:@".gif"]){
				iconpng = @"jpg.png";
				explaination = @"Image";
				fileType = kFileTypeImage;
			}
			if ([[fname lowercaseString] hasSuffix:@".jpg"]){
				iconpng = @"jpg.png";
				explaination = @"Image";
				fileType = kFileTypeImage;
			}
			if ([[fname lowercaseString] hasSuffix:@".mp3"]){
				iconpng = @"mp3.png";
				explaination = @"Audio";
				fileType = kFileTypeAudio;
			}
			if ([[fname lowercaseString] hasSuffix:@".rtf"]){
				iconpng = @"rtf.png";
				explaination = @"Text";
				fileType = kFileTypeOther;
			}
			if ([[fname lowercaseString] hasSuffix:@".wav"]){
				iconpng = @"mp3.png";
				explaination = @"Audio";
				fileType = kFileTypeAudio;
			}		
			if ([[fname lowercaseString] hasSuffix:@".html"]){
				iconpng = @"html.png";
				explaination = @"HTML";
				fileType = kFileTypeOther;
			}			
			if ([[fname lowercaseString] hasSuffix:@".htm"]){
				iconpng = @"html.png";
				explaination = @"HTML";
				fileType = kFileTypeOther;
			}
			if ([[fname lowercaseString] hasSuffix:@".txt"]){
				iconpng = @"rtf.png";
				explaination = @"Text";
				fileType = kFileTypeOther;
			}
			
			if ([[fname lowercaseString] hasSuffix:@".mov"] ||
				[[fname lowercaseString] hasSuffix:@".mp4"] ||
				[[fname lowercaseString] hasSuffix:@".m4v"] ||
				[[fname lowercaseString] hasSuffix:@".mpg"]){
				iconpng = @"mp4.png";
				explaination = @"Video";
				fileType = kFileTypeVideo;
			}		
			
			switch (fileType) {
				case kFileTypeVideo:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Video"] intValue]+1] forKey:@"Video"];
					break;
				case kFileTypeAudio:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Audio"] intValue]+1] forKey:@"Audio"];
					break;
				case kFileTypeImage:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Image"] intValue]+1] forKey:@"Image"];
					break;
				case kFileTypeOther:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Other"] intValue]+1] forKey:@"Other"];
					break;
				case kFileTypeFolder:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Folder"] intValue]+1] forKey:@"Folder"];
					break;					
				default:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Unknown"] intValue]+1] forKey:@"Unknown"];
					break;
			}
			
			
			[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								 [NSString stringWithFormat:@"%@",fname], kTitleKey,
								 explaination, kExplainKey,
								 iconpng,kIconKey,
								 [NSNumber numberWithInt:fileType], kFileTypeKey,
								 nil]];
			
			
			
		}
	}
	
	[listTableView reloadData];
	[kindTableView reloadData];	
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

// Interaction with the uialertview's
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet.tag == 101) // Empty folder
	{
		
		if (buttonIndex == 0) {
			
			NSString *filePath = [self getPathForFileName:inputField.text];
			[[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:NULL error:nil];
			
			[self refresh];
		}
		
	}
	else if (actionSheet.tag == 102) // Empty file
	{
		
		if (buttonIndex == 0) {
			NSLog(@"Creating empty file..");
			
			NSString *filePath = [self getPathForFileName:inputField.text];
			NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath isDirectory:NO];
			
			NSLog(@"url : %@",url);
			
			NSData *emptyData = [[NSString stringWithString:@" "] dataUsingEncoding:NSASCIIStringEncoding];
			[emptyData writeToURL:url options:NSDataWritingAtomic error:NULL];
			[url release];
			
			[self refresh];
			
		}
		
		
	}
	
}

// Tabbar inplementation
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	

	
	if ([tabBar isEqual:listModeTabbar])
	{
		if ([item isEqual:[[tabBar items] objectAtIndex:0]])
		{
			
			SynopsisPageController *Spc = [[SynopsisPageController alloc] init];
			[self.navigationController pushViewController:Spc animated:YES];

			
			NSLog(@"met opties!!");
			
			[Spc release];
			ipAddress = [NSString alloc];
			NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *docDir = [documentPaths objectAtIndex:0];
			NSString *fileFolder = [docDir stringByAppendingPathComponent:@"/file"];
			
				
				httpServer = [HTTPServer new];
				[httpServer setType:@"_http._tcp."];
				[httpServer setConnectionClass:[MyHTTPConnection class]];
				[httpServer setDocumentRoot:[NSURL fileURLWithPath:fileFolder]];
				
				
				[[NSNotificationCenter defaultCenter] addObserver:self 
														 selector:@selector(displayInfoUpdate:) 
															 name:@"LocalhostAdressesResolved" 
														   object:nil];
				[localhostAdresses performSelectorInBackground:@selector(list) withObject:nil];
				
				[self displayInfoUpdate:nil];
				NSError *error;
				if(![httpServer start:&error])
				{
					NSLog(@"Error starting HTTP Server: %@", error);
				}

				bSelector = YES;


			[self refresh];
		}
		else if ([item isEqual:[[tabBar items] objectAtIndex:1]])
		{
			
			if (!isEditing)
			 {
			 isEditing = TRUE;
			 [listTableView setEditing:YES animated:YES];
			 [kindTableView setEditing:YES animated:YES];
			// item.image = [UIImage imageNamed:@"icon.png"]; 
			 
			//	 [self showAlertView];
				 
				 
			 [UIView beginAnimations:nil context:nil];
			 [UIView setAnimationDuration:0.50];
			 [UIView setAnimationDelegate:self];
			 [optionBalk setCenter:CGPointMake(optionBalk.center.x + 320, optionBalk.center.y)];
			 [UIView commitAnimations];

			 }
			 else {
			 isEditing = FALSE;
			 [listTableView setEditing:NO animated:YES];
			 [kindTableView setEditing:NO animated:YES];
				 
			 [UIView beginAnimations:nil context:nil];
			 [UIView setAnimationDuration:0.50];
			 [UIView setAnimationDelegate:self];
			 [optionBalk setCenter:CGPointMake(optionBalk.center.x - 320, optionBalk.center.y)];
			 [UIView commitAnimations];
			
			[self refresh];
			}
		
			
		}	

		
	}
	

}
-(void) showAlertView {
	label = [[UILabel alloc] initWithFrame:CGRectMake(400, 600, 200, 50)];
	//imageAlert = [[UIImageView alloc] initWithFrame:CGRectMake(400, 600, 200, 50)];
	label.backgroundColor = [UIColor lightGrayColor];

	label.text = @"进入编辑状态,点击返回";
	label.font = [UIFont fontWithName:@"Arial" size:18];
	label.textAlignment = UITextAlignmentCenter;

	label.adjustsFontSizeToFitWidth = NO;
	
	[self.view addSubview:label];
	[label release];
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideAlertView) userInfo:nil repeats:NO];
} 
-(void)hideAlertView {
	if (label) {
		[label removeFromSuperview];
	}
	
}
- (void)viewDidLoad
{
	self.view.frame = CGRectMake(0, 0, 1024, 768);
	inputField = [[UITextField alloc] initWithFrame:CGRectMake(16,83,252,30)];
	inputField.keyboardAppearance = UIKeyboardAppearanceAlert;
	inputField.delegate = self;
	[inputField becomeFirstResponder];
	[inputField setBorderStyle:UITextBorderStyleRoundedRect];
	bSelector = NO;
	self.navigationController.navigationBar.tag = 5001;
	//设置返回按钮
	UIImage *buttonImage = [UIImage imageNamed:@"excel_back.png"];
	
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
	
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
	//button.frame = CGRectMake(0, 0, 80, 50);

    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
	//self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"excel_back.png"];
	
	// Cleanup
	[customBarItem release];
	//重建navigationBar
	segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 NSLocalizedString(@"Server", @""),
											 NSLocalizedString(@"Edit", @"Done"),
											 nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, -60, 200, kCustomButtonHeight);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
	//结束
	self.navigationItem.rightBarButtonItem = segmentBarItem;
	[segmentBarItem release];
	NSLog(@"viewDidLoad");
	self.menuList = [[NSMutableArray alloc] init];
    //self.title = [[_WorkingDirectory lastPathComponent] stringByDeletingPathExtension]; // Get the name of the working directory
	fileKindCount = [[NSMutableDictionary alloc] init];
	[listModeTabbar setSelectedItem:[[listModeTabbar items] objectAtIndex:0]];
	[listModeTabbar setDelegate:self];
	[optionBalk setDelegate:self];
	[self refresh];
}
-(void)back {
    // Tell the controller to go back
	[[NSNotificationCenter defaultCenter]postNotificationName:@"setIsDianJi" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
	//UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
	if (segmentedControl.selectedSegmentIndex == 0) {
		SynopsisPageController *Spc = [[SynopsisPageController alloc] init];
		[self.navigationController pushViewController:Spc animated:YES];
		
		
		NSLog(@"met opties!!");
		
		
		ipAddress = [NSString alloc];
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDir = [documentPaths objectAtIndex:0];
		
		
		NSString *fileFolder = [docDir stringByAppendingPathComponent:@"/file"];
		NSLog(@"fileFolder%@",fileFolder);
		NSFileManager *NSFm= [NSFileManager defaultManager]; 
		BOOL isDir=YES;
		
		if(![NSFm fileExistsAtPath:fileFolder isDirectory:&isDir]){
		
			if(![NSFm createDirectoryAtPath:fileFolder attributes:nil])
				NSLog(@"Error: Create folder failed");
		}
		
		httpServer = [HTTPServer new];
		[httpServer setType:@"_http._tcp."];
		[httpServer setConnectionClass:[MyHTTPConnection class]];
		[httpServer setDocumentRoot:[NSURL fileURLWithPath:fileFolder]];
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(displayInfoUpdate:) 
													 name:@"LocalhostAdressesResolved" 
												   object:nil];
		[localhostAdresses performSelectorInBackground:@selector(list) withObject:nil];
		
		[self displayInfoUpdate:nil];
		NSError *error;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
		
		bSelector = YES;
	}else {
		if (!isEditing)
		{
			isEditing = TRUE;
			[listTableView setEditing:YES animated:YES];
			[kindTableView setEditing:YES animated:YES];
			// item.image = [UIImage imageNamed:@"icon.png"]; 
			
			//	 [self showAlertView];
			
			
			
			//重建navigationBar
			segmentedControl = [[UISegmentedControl alloc] initWithItems:
								[NSArray arrayWithObjects:
								 NSLocalizedString(@"Server", @""),
								 NSLocalizedString(@"Done", @""),
								 nil]];
			[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
			segmentedControl.frame = CGRectMake(0, 0, 200, kCustomButtonHeight);
			segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
			segmentedControl.momentary = YES;
			
			//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
			
			UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
			[segmentedControl release];
			//结束
			
			self.navigationItem.rightBarButtonItem = segmentBarItem;
			[segmentBarItem release];

			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.50];
			[UIView setAnimationDelegate:self];
			[optionBalk setCenter:CGPointMake(optionBalk.center.x + 320, optionBalk.center.y)];
			[UIView commitAnimations];
			//[self refresh];
			
		}
		else {
			isEditing = FALSE;
			[listTableView setEditing:NO animated:YES];
			[kindTableView setEditing:NO animated:YES];
			
			//重建navigationBar
			segmentedControl = [[UISegmentedControl alloc] initWithItems:
								[NSArray arrayWithObjects:
								 NSLocalizedString(@"Server", @""),
								 NSLocalizedString(@"Edit", @""),
								 nil]];
			[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
			segmentedControl.frame = CGRectMake(0, 0, 200, kCustomButtonHeight);
			segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
			segmentedControl.momentary = YES;
			
			//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
			
			UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
			[segmentedControl release];
			//结束
			
			self.navigationItem.rightBarButtonItem = segmentBarItem;
			[segmentBarItem release];
			
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.50];
			[UIView setAnimationDelegate:self];
			[optionBalk setCenter:CGPointMake(optionBalk.center.x - 320, optionBalk.center.y)];
			[UIView commitAnimations];
			
			[self refresh];
		}
	}

}
//-(IBAction)reload:(id)sender
//{
//	[self refresh];	
//
//}
//- (IBAction)toggleEditMode:(id)sender
//{
//		[self refresh];
//}
- (void)dealloc
{
	[httpServer release];
    [listTableView release];
	[kindTableView release];
	[menuList release];
    [super dealloc];
}
// user clicked the "i" button, present info xib
//- (IBAction)showCredits:(id)sender
//{	
//	infoViewController *ivc = [[infoViewController alloc] init];
//	[self presentModalViewController:ivc animated:YES];
//}

// change the navigation bar style, also make the status bar match with it

#pragma mark UIViewController delegates

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"wewewewe");
	// Deselect selected row
	NSIndexPath *tableSelection = [listTableView indexPathForSelectedRow];
	 [self.navigationController setNavigationBarHidden:NO animated:YES];
	 [listTableView deselectRowAtIndexPath:tableSelection animated:NO];	tableSelection = [kindTableView indexPathForSelectedRow];
	[kindTableView deselectRowAtIndexPath:tableSelection animated:NO];
	if(bSelector)
	{
		[httpServer stop];
		bSelector = NO;
	}
	[self refresh];
}
-(void)viewWillDisappear:(BOOL)animated{
	//self.navigationController.hidesBottomBarWhenPushed = YES;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	NSLog(@"viewWillDisappear");
}
#pragma mark UITableView delegates
//- (void)didFinishPlayback:(NSNotification *)notification {
//	NSLog(@"didFinishPlayback");
//	// This ends up recursively telling the player that playback ended, thus calling this method, thus…well you get the picture.
//	// What I'm trying to do here is just make the player go away and show my old UI again.
//	//    [self.mo setFullscreen:NO animated:YES];
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *SelectedCell = [tableView cellForRowAtIndexPath:indexPath];
	
	
	if (SelectedCell.tag == kFileTypeVideo)
	{
		
		NSString *filePath = [self getPathForFileName:SelectedCell.textLabel.text];
		
		mMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
		[mMoviePlayer.moviePlayer setUseApplicationAudioSession:NO];
		[mMoviePlayer.moviePlayer prepareToPlay];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPlayback:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];    
		
		[self presentMoviePlayerViewControllerAnimated:mMoviePlayer];
		[mMoviePlayer release]; 
		
	}
	else if (SelectedCell.tag == kFileTypeAudio)
	{
		
		audioPlayerViewController *apvc = [[audioPlayerViewController alloc] initWithFileName:SelectedCell.textLabel.text withRoot:_WorkingDirectory];
		[self presentModalViewController:apvc animated:YES];
		
	}
	else if (SelectedCell.tag == kFileTypeFolder) {
		NavController *navCtrl = [[NavController alloc] initWithWorkingDir:[self getPathForFileName:SelectedCell.textLabel.text] isRoot:NO];
		
		int tabIndex = 0;
		if ([[listModeTabbar selectedItem] isEqual:[[listModeTabbar items] objectAtIndex:1]])
		{
			tabIndex = 1;
		}
		[[self navigationController] pushViewController:navCtrl animated:YES]; 
		//[navCtrl setSelectedTab:tabIndex];

	}
	
	else if (SelectedCell.tag == kFileTypeUnknown)
	{

		fileViewController *fvc = [[fileViewController alloc] initWithFileName:SelectedCell.textLabel.text withRoot:_WorkingDirectory];
		[[self navigationController] pushViewController:fvc animated:YES];
		[fvc release];
	}
	else {
		NSLog(@"fileName:%@--%@",SelectedCell.textLabel.text,_WorkingDirectory);
		fileViewController *fvc = [[fileViewController alloc] initWithFileName:SelectedCell.textLabel.text withRoot:_WorkingDirectory];
		[[self navigationController] pushViewController:fvc animated:YES];
		[fvc release];
		
	}
	
}

#pragma mark UITableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == listTableView)
	{
		return 1;
	}
	return 6;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == kindTableView)
	{
		switch (section) {
//			case kFileTypeUnknown:
//				return @"Unknown";
//				break;
//			case kFileTypeAudio:
//				return @"Audio and music";
//				break;
			case kFileTypeImage:
				return @"Images";
				break;
//			case kFileTypeVideo:
//				return @"Video's and movies";
//				break;
			case kFileTypeOther:
				return @"File";
				break;
//			case kFileTypeFolder:
//				return @"Folder";
//				break;				
			default:
				break;
		}
	}
	return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == listTableView)
	{
		return [menuList count];
	}
	else {
		if (section == kFileTypeImage)
		{
			return [[fileKindCount objectForKey:@"Image"] intValue];
		}
		else if (section == kFileTypeOther)
		{
			return [[fileKindCount objectForKey:@"Other"] intValue];
		}
		else if (section == kFileTypeUnknown)
		{
			return [[fileKindCount objectForKey:@"Unknown"] intValue];
		}
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
		if ([menuList count] >= 1) {
			
			[tableView beginUpdates];
			
			
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			
			switch (cell.tag) {
				case kFileTypeVideo:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Video"] intValue]-1] forKey:@"Video"];
					break;
				case kFileTypeAudio:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Audio"] intValue]-1] forKey:@"Audio"];
					break;
				case kFileTypeImage:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Image"] intValue]-1] forKey:@"Image"];
					break;
				case kFileTypeOther:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Other"] intValue]-1] forKey:@"Other"];
					break;
				case kFileTypeFolder:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Folder"] intValue]-1] forKey:@"Folder"];
					break;					
				default:
					[fileKindCount setObject:[NSNumber numberWithInt:[[fileKindCount objectForKey:@"Unknown"] intValue]-1] forKey:@"Unknown"];
					break;
			}
			
			[[NSFileManager defaultManager] removeItemAtPath:[self getPathForFileName:cell.textLabel.text] error:NULL];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
			[menuList removeObjectAtIndex:indexPath.row];
			
			//if ([menuList count] == 0) {
//                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
			
			
			[tableView endUpdates];
			
			
		}
		// remove the row here.
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (tableView == listTableView)
	{
		NSString *identifier = [NSString stringWithFormat:@"Cell %d", indexPath.row]; // The cell row
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										  reuseIdentifier:kCellIdentifier];   
			
			cell.tag = [[[menuList objectAtIndex:indexPath.row] valueForKey:kFileTypeKey] intValue];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			cell.imageView.image = [UIImage imageNamed:[[menuList objectAtIndex:indexPath.row] valueForKey:kIconKey]];
			cell.textLabel.text = [[menuList objectAtIndex:indexPath.row] valueForKey:kTitleKey];
			cell.detailTextLabel.text = [[menuList objectAtIndex:indexPath.row] valueForKey:kExplainKey];
			
		}
		return cell;
		
	}
	else {
		
		// Get all the objects that has the same type as the section, as we use enum's we can compare them and be sure it will match.
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		for (NSDictionary *dict in menuList) {
			if (indexPath.section == [[dict valueForKey:kFileTypeKey] intValue])
			{
				[tempArray addObject:dict];
			}
		}
		
		NSString *identifier = [NSString stringWithFormat:@"Cell %d", indexPath.row]; // The cell row
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		if (cell == nil)
		{
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:kCellIdentifier];   
			
			cell.tag = [[[tempArray objectAtIndex:indexPath.row] valueForKey:kFileTypeKey] intValue]; // We use tag for the filetype
			
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			cell.imageView.image = [UIImage imageNamed:[[tempArray objectAtIndex:indexPath.row] valueForKey:kIconKey]];
			cell.textLabel.text = [[tempArray objectAtIndex:indexPath.row] valueForKey:kTitleKey];
			
			
			cell.detailTextLabel.text = [[tempArray objectAtIndex:indexPath.row] valueForKey:kExplainKey];
		}
		
		// Of course we have memory limits
		[tempArray removeAllObjects];
		[tempArray release];
		
		return cell;
		
	}
	
	
	return nil;
}



//http server
- (void)displayInfoUpdate:(NSNotification *) notification
{
	NSLog(@"displayInfoUpdate:");
	
	if(notification)
	{
		[addresses release];
		addresses = [[notification object] copy];
		NSLog(@"addresses: %@", addresses);
	}
	if(addresses == nil)
	{
		return;
	}
	
	NSString *info;
	//	UInt16 port = [httpServer port];
	
	NSString *localIP = [addresses objectForKey:@"en0"];
	if (!localIP)
	{
		info = @"No Wifi connection!\n";
	}else{
		info = [NSString stringWithFormat:@"%@", localIP];
	}
	
	ipAddress = [[NSString alloc] initWithFormat:@"%@:8080",info];
	
}

- (NSString*)getIpAddress
{
	return ipAddress;
}

- (IBAction)startStopServer:(id)sender
{
	if ([sender isOn])
	{
		NSError *error;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
		[self displayInfoUpdate:nil];
	}
	else
	{
		[httpServer stop];
	}
}



@end

