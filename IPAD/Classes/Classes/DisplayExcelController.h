//
//  DisplayExcelController.h
//  IPAD
//
//  Created by careers on 12-2-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyExcel.h"

@protocol backDelegate<NSObject>

-(void)deselected;

@end

@interface DisplayExcelController : UIViewController {
	//文件名标题名
	NSString *tableName;
    
    //存储文件信息表中文件对应的id
    int condition;
    //excel文件展示视图
	MyExcel *myExcel;
}
@property(nonatomic,copy) NSString *tableName;
@property(nonatomic) int condition;
@property (nonatomic,assign)id<backDelegate>delegate;

@end
