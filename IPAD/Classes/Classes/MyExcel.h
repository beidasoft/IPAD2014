//
//  MyExcel.h
//  OrganizationInqury
//
//  Created by careers on 12-2-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SheetView.h"

@interface MyExcel : UIView <UIWebViewDelegate,ExcelSheetDelegate,UIScrollViewDelegate>{
	//excel的文件名
	NSString *myName;
	CGRect myFrame;
	//excel中sheet的个数
	unsigned int excelNum;
    //当前展示sheet的id
	int currentSheetId;
    
	BOOL clicked;
    //所有sheet是否加载完
	BOOL finishLoad;
    /* YES --is small(super_scrollView)  NO---is big (super_self)  */
	BOOL sheetStatus;
	
    //存储所有sheet名字的数组
	NSMutableArray *sheetNames;
    //存储所有SheetView的数组
	NSMutableArray *sheetArray;	
	
	//装载所有SheetView的容器
	UIView *contentView;
	UIScrollView *myScrollView;	
    //sheet个数提示控件
	UIPageControl *pageControl;
    //风火轮
	UIActivityIndicatorView *spinner;
    //"双击"提示图片
	UIImageView *doubleClickView;
    //sheet的名字
	UILabel *sheetTitle;
	
	//改变sheet大小的按钮
	UIButton *changeStyleButton;
	
}
@property (nonatomic,copy)NSString *myName;
@property (nonatomic,retain)NSString *realFileName;

@property BOOL finishLoad;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 初始化视图，加载一些button、title等控件，为加载excel准备
 @param       excel文件名
 @result      视图大小
 */
-(id)initWithExcelName:(NSString *)_excelName andFrame:(CGRect)_frame;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 加载xls表中的所有sheet
    @param       无
    @result      无
*/
-(void)loadAllSheet;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 查看放大之后的sheet内容
    @param       _sheetId：第几个sheet
    @result      无
*/
-(void)displayOneSheet:(int)_sheetId;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 放大与缩小每个sheet页面的转换，及相应一些内容的重新加载
    @param       无
    @result      无
*/
-(void)changeStyle;   /* button */
@end
