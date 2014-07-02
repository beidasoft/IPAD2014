    //
//  SetDetailController.m
//  IPAD
//
//  Created by yang on 12-2-8.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SetDetailController.h"
#import "Utilities.h"
#import "NSStringMD5Encrypt.h"
#import <QuartzCore/QuartzCore.h>

@implementation SetDetailController

@synthesize itemName;
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
	self.title = self.itemName;
	self.view.backgroundColor = [UIColor grayColor];
	isFirst = YES;
	if ([self.itemName isEqualToString:@"密码设置"])
	{
		//strPath = [[NSBundle mainBundle] pathForResource:@"password" ofType:@"plist"];
		strPath = [Utilities documentsPath:@"password.plist"];
		array = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
		oldPassword = [[UITextField alloc] initWithFrame:CGRectMake(170, 100, 435, 31)];
		oldPassword.backgroundColor = [UIColor whiteColor];
		oldPassword.placeholder = @"请输入旧密码";
		oldPassword.font = [UIFont fontWithName:@"helvetica" size:24.0];
		oldPassword.returnKeyType = UIReturnKeyDone;
		oldPassword.secureTextEntry = YES;
		oldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
		oldPassword.adjustsFontSizeToFitWidth = YES;
		oldPassword.borderStyle =  UITextBorderStyleRoundedRect;
		oldPassword.delegate = self;
		newPassword = [[UITextField alloc] initWithFrame:CGRectMake(170,150, 435, 31)];
		newPassword.backgroundColor = [UIColor whiteColor];
		newPassword.placeholder = @"请输入新密码";
		newPassword.font = [UIFont fontWithName:@"helvetica" size:24.0];
		newPassword.returnKeyType = UIReturnKeyDone;
		newPassword.secureTextEntry = YES;
		newPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
		newPassword.adjustsFontSizeToFitWidth = YES;
		newPassword.borderStyle =  UITextBorderStyleRoundedRect;
		newPassword.delegate = self;
		cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		cancel.frame = CGRectMake(200, 200, 100, 40);
		[cancel setTitle:@"取消" forState:UIControlStateNormal];
		[cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
		save = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		save.frame = CGRectMake(420, 200, 100, 40);
		[save setTitle:@"保存" forState:UIControlStateNormal];
		[self.view addSubview:oldPassword];
		[self.view addSubview:newPassword];
		[self.view addSubview:cancel];
		[self.view addSubview:save];
	}
}
-(void)show:(NSString *)formatstring 
{
	UIAlertView *Point = [[[UIAlertView alloc] initWithTitle:nil 
													 message:formatstring 
													delegate:nil 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil]autorelease];
	[Point show];
}

//UITextField输入长度限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 20) 
    {
		[self show:@"密码长度有误"];
        return NO;
    }
    return YES;
	
}
//当开始点击textField会调用的方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
}

//当textField编辑结束时调用的方法 
- (void)textFieldDidEndEditing:(UITextField *)textField 
{
		if ([[oldPassword.text md5HashDigest] isEqualToString: [array objectAtIndex:0]]) 
		{
			[save addTarget:self action:@selector(save_Clicked) forControlEvents:UIControlEventTouchUpInside];
		}
		else 
		{
			if(oldPassword.text == nil)
			{
			
			}
			else
			{
			  [self show:@"请正确的输入旧密码！"];
			}
			
		}
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void) save_Clicked
{
	 if(newPassword.text==nil)
	 {
	     [self show:@"请输入新密码！"];
	 }
	 else 
	 {
		 [array removeAllObjects];
		 [array addObject:[newPassword.text md5HashDigest]];
		 [array writeToFile:[Utilities documentsPath:@"password.plist"] atomically:YES];
		 [self.navigationController popViewControllerAnimated:YES]; 
	 }
}
-(void)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
