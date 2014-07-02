//
//  Delete.h
//  IPAD
//
//  Created by  careers on 12-5-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Delete : NSObject
{

}
/*
    @method     
    @author      weijuanmin
    @date        2012-12-20 
    @description 删除旧的数据信息
    @param       databasePathString，sqlPathString
    @result      无
*/
- (void)deleteOldDate:(NSString *)databasePathString  sqlFilePath:(NSString *)sqlPathString;

/*
 @method     
 @author      wangb
 @date        2013-1-26 
 @description 删除文件
 @param       fileName:文件名
 @result      无
 */
-(void)deleteFileAtPath:(NSString *)fileName;
@end
