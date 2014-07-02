//
//  SetDetailController.h
//  IPAD
//
//  Created by yang on 12-2-8.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetDetailController : UIViewController<UITextFieldDelegate> 
{
   UITextField *oldPassword;
   UITextField *newPassword;
	NSMutableArray *array;
	NSString *strPath;
	UIButton *cancel;
	UIButton *save;
	BOOL isFirst;
}

@property (nonatomic,retain)NSString *itemName;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
-(void)show:(NSString *)formatstring;
@end
