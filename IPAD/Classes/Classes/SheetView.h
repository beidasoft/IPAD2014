//
//  SheetView.h
//  OrganizationInqury
//
//  Created by careers on 12-2-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ExcelSheetDelegate<NSObject>
	
-(void)displayAllSheet;
-(void)displayOneSheet:(int)_sheetId;

@end


@interface SheetView : UIView <UIWebViewDelegate>{
	//excel的文件名
	NSString *excelName;
    //sheet的大小
	CGRect sheetFrame;
    //sheet的初始大小
	CGRect originFrame;
	//sheet所属id
    int sheetId;
    //记载sheet的webview
	UIWebView *sheetWebView;
	//sheet是否解析完
	BOOL clicked;
	BOOL sheetScaleToFit;
    //sheet的加载次数
	unsigned char  loadTime;
    //所属excel的sheet个数
	int sheetNum;
	/* 1- allSheet  2- oneSheet*/
    unsigned char myStyle;  
}
@property (nonatomic,copy)NSString *excelName;
@property (nonatomic)BOOL sheetScaleToFit;
@property (nonatomic)BOOL clicked;
//hasClicked
@property (nonatomic)BOOL hasClicked;

@property (nonatomic)int sheetNum;
@property (nonatomic)int sheetId;
@property unsigned char myStyle;

@property (nonatomic)CGRect sheetFrame;
@property (nonatomic)CGRect originFrame;


@property (nonatomic,assign)id<ExcelSheetDelegate>delegate;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 初始化一个sheet的所属的excel，大小和它是excel中的第几个sheet
 @param       _excelName：excel名称；_frame：大小；_frame：第几个sheet
 @result      SheetView对象
 */
-(id)initWithName:(NSString *)_excelName andFrame:(CGRect)_frame andSheetId:(int)_frame;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 将要加载的excel表中的sheet加载到webview上
    @param       
    @result      
*/
-(void)showSheet;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-19 
 @description 停止加载sheet到webview上
 @param       无
 @result      无
*/
-(void)stopMyLoading;
@end
