//
//  Update.h
//  IPAD
//
//  Created by yang on 11-12-24.
//  Copyright 2011 __Careers__. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface Update : NSObject 
{
	int updateCount;
}
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 更新数据信息
 @param       databasePathString，sqlPathArray
 @result      无
*/
- (void)updateNewData:(NSString *)databasePathString  updateStringPath:(NSArray *)sqlPathArray;
/*
 @method     
 @author      weijuanmin
 @date        2012-12-20 
 @description 删除制定的文件
 @param       fileName
 @result      无
*/
- (void)deleteFileAtPath:(NSString *)fileName;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-20 
    @description 更新数据库的版本信息
    @param       versionString
    @result      无
*/
- (void)updateVersion:(NSString *)versionString; 

//王渤 2012－9－14 备份数据文件
- (void)dateBackup;

/*
 @method     
 @author      wangb
 @date        2013-1-26 
 @description 删除文件
 @param       fileName:文件名
 @result      无
 */
-(void)deleteFileAtPath:(NSString *)fileName;

/*
 @method     
 @author      wangb
 @date        2013-1-26 
 @description 更新版本号
 @param       versionString:版本号
 @result      无
 */
-(void)updateVersion:(NSString *)versionString;
@end
