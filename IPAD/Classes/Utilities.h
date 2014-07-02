//
//  Utilities.h
//  IpadTest
//
//  Created by sunyu on 11-11-21.
//  Copyright 2011 careers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utilities : NSObject {
}

/*
	 @method    
	 @author      sunyu
	 @date        2011-11-21 
	 @description 获取文件在bundle中的路径
	 @param       fileName：文件名称；
	 @result      文件在bundle中的路径；
*/
+ (NSString *)bundlePath:(NSString *)fileName;

/*
	 @method     
	 @author      sunyu
	 @date        2011-11-21 
	 @description 获取文件在document中的路径
	 @param       fileName：文件名称；
	 @result      文件在document中的路径；
*/
+ (NSString *)documentsPath:(NSString *)fileName;



/*
	@method     
	@author      sunyu
	@date        2011-11-22 
	@description 判断文件是否存在
	@param       filePath：文件路径；
	@result      yes为存在，no为不存在；
*/
+ (BOOL)isFileExist:(NSString *)filePath;

/*
 @method     
 @author      sunyu
 @date        2011-11-23 
 @description 将文件复制到目的地址
 @param       sourcePath：源地址；
              targetPath：目的路径
 @result      yes为复制成功，no为复制没有成功；
 */
 
 
+ (BOOL)copyFile:(NSString *)sourcePath to:(NSString *)targetPath;

/*
 @method     
 @author      luyuze
 @date        2011-12-21 
 @description 在document路径下创建template文件夹及文件
 @param       nil
 @result      yes为复制成功，no为复制没有成功；
 */

+ (BOOL)createTemplate;

/*
 @method     
 @author      wangbo
 @date        2012-12-20 
 @description 在document路径下创建template文件夹下的文件夹及文件
 @param       nil
 @result      
 */
+ (void)createFolder;

/*
 @method     
 @author      luyuze
 @date        2011-12-21 
 @description 在document路径下创建htmlTemplate文件夹及文件
 @param       nil
 @result      yes为复制成功，no为复制没有成功；
 */

+(BOOL)createHtmlTemplate;
@end
