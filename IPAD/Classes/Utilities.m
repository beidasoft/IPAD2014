//
//  Utilities.m
//  IpadTest
//
//  Created by Sun Yu 11-11-12.
//  Copyright 2011 careers. All rights reserved.
//


#import "Utilities.h"
#import "SQLiteOptions.h"

@implementation Utilities

+(NSString *)bundlePath:(NSString *)fileName 
{
    //返回路径
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName 
{
    //document路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //document文件夹路径
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//返回完整的路径名称
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (BOOL)isFileExist:(NSString *)filePath
{
    //文件管理器对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
	//判断是否存在文件
    if ([fileManager fileExistsAtPath:filePath]) 
	{
		return YES;
	}
	return NO;
}
+ (BOOL)copyFile:(NSString *)sourcePath to:(NSString *)targetPath
{
    //文件管理器对象
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//错误对象
    NSError *error;
	//判断copy文件是否成功
    if (![fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error]) 
	{
		return NO;
	}
	return YES;
}
+(BOOL)createHtmlTemplate
{
    
    //数组
	NSMutableArray *ret = [NSMutableArray array];
	//获取文件夹
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
    //获取模板路径
	NSString *templatePath = [documentDir stringByAppendingPathComponent:@"htmlTemplate/"];
    //获取文件管理对象
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//判断是否存在文件
	if (![Utilities isFileExist:templatePath]) 
	{   
		//不存在文件的话，创建文件
		[fileManager createDirectoryAtPath:templatePath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];
		
	}
	else
	{
		//删除所有模板文件  不包括文件夹
		NSArray *templateArray = [fileManager contentsOfDirectoryAtPath:templatePath
																  error:nil];
		for(NSString *string in templateArray)
		{
            
			NSError *error;
            //判断是否删除成功
			if([fileManager removeItemAtPath:[templatePath stringByAppendingPathComponent:string]  error:&error]);
		}
	}
	
	//生成所有模板文件
	SQLiteOptions *sqliteO = [SQLiteOptions sharedSQLiteOptions];
	[sqliteO openSQLiteDatabase];
	//查询语句
	NSString *sqlString = @"select FILE,FILE_NAME from IPAD_TEMPLATE";
    //生命sql对象
	sqlite3_stmt *stmt;
	const char *sql = [sqlString cStringUsingEncoding:4];
    //判断是否准备成功
	if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
            //声明列号
			const unsigned char *colName = sqlite3_column_text(stmt,1);
			if (colName == nil)
			{
				
			}
			else {
                //将char的colName根据utf—8规则转为列字符串
				NSString *newColString = [NSString stringWithUTF8String:(const char *)colName];
				NSString *colString = [NSString stringWithFormat:@"%@",newColString];
				const unsigned char *colType = sqlite3_column_blob(stmt, 0);
				NSData *data = [NSData dataWithBytes:(const char *)colType length:sqlite3_column_bytes(stmt, 0)];
                //将查询出来的data添加到字典中
				NSDictionary *dictionary = [NSDictionary dictionaryWithObject:data forKey:colString];
				[ret addObject:dictionary];
			}
			
			
		}
		sqlite3_finalize(stmt);
	}
    //关闭数据库
	[sqliteO closeSQLiteDatabase];
    //是否成功的标示
	BOOL success;
    //计数
	int count=0;
    
	for (NSDictionary *dirctionary in ret) {
        //从其中将字典的key读出
		NSString *key = [[dirctionary allKeys]objectAtIndex:0];
		//拼出路径
        NSString *fileApp = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"htmlTemplate/%@",key]];
        //判断写到路径下是否成功并将返回值赋给sucess
		success=[[dirctionary objectForKey:key] writeToFile:fileApp atomically:YES];
		if (success == YES)
		{
			++count;
		}
	}
	if(count != [ret count])
	{
	    return NO;
	}
	return YES;
	[fileManager release];
}

+ (BOOL)createTemplate 
{
	//创建存储模板数据的数组
	NSMutableArray *ret = [NSMutableArray array];
    //获取文件路径
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
	NSString *templatePath = [documentDir stringByAppendingPathComponent:@"template/"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//判断是否存在
	if (![Utilities isFileExist:templatePath]) 
	{
		//创建文件
		[fileManager createDirectoryAtPath:templatePath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];
		
	}
	else
	{
		//删除所有模板文件  不包括文件夹
       
		NSArray *templateArray = [fileManager contentsOfDirectoryAtPath:templatePath
														error:nil];
		for(NSString *string in templateArray)
		{
		  NSError *error;
		 if([fileManager removeItemAtPath:[templatePath stringByAppendingPathComponent:string]  error:&error]);
		 }
	}
	
	//生成所有模板文件
	SQLiteOptions *sqliteO = [SQLiteOptions sharedSQLiteOptions];
	[sqliteO openSQLiteDatabase];

	//sql语句
	NSString *sqlString = @"select FILE,FILE_NAME from IPAD_Analysis_Group_File";
	sqlite3_stmt *stmt;
	const char *sql = [sqlString cStringUsingEncoding:4];
	if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
            //获取查询值
			const unsigned char *colName = sqlite3_column_text(stmt,1);
			if (colName == nil)
			{
				
			}
			else {
                //处理查询出来的额列名
				NSString *colString = [NSString stringWithUTF8String:(const char *)colName];
				const unsigned char *colType = sqlite3_column_blob(stmt, 0);
				NSData *data = [NSData dataWithBytes:(const char *)colType length:sqlite3_column_bytes(stmt, 0)];
                //将其加入数据字典中
				NSDictionary *dictionary = [NSDictionary dictionaryWithObject:data forKey:colString];
				[ret addObject:dictionary];
			}

			
		}
		sqlite3_finalize(stmt);
	}
    //关闭数据库
	[sqliteO closeSQLiteDatabase];
    //成功标示
	BOOL success;
    //计数
	int count=0;
	for (NSDictionary *dirctionary in ret) {
        //获取键名
		NSString *key = [[dirctionary allKeys]objectAtIndex:0];
        //组装路径字符串
		NSString *fileApp = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"template/%@",key]];
        //向目标路径中写入数组，将成功标示返给sucess
		success=[[dirctionary objectForKey:key] writeToFile:fileApp atomically:YES];
		if (success == YES)
		{
			++count;
		}
	}
	if(count != [ret count])
	{
	    return NO;
	}
	return YES;
	[fileManager release];
}
+(BOOL)createPersonImgs
{
    //存储数据的数组
	NSMutableArray *ret = [NSMutableArray array];
	//文件管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
	//获取library的路径
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
	(NSLibraryDirectory, NSUserDomainMask, YES); 
	NSString *libraryDir = [libraryPaths objectAtIndex:0]; 
    //得到文件路径
	NSString  *imagesPath = [libraryDir stringByAppendingPathComponent:@"WebKit/Databases/file__0/persons"]; 
	//初始化隐藏标示
	BOOL isHidden = YES;
	//判断是否存在文件
	if (![Utilities isFileExist:imagesPath]) 
	{
		//创建文件夹
		[fileManager createDirectoryAtPath:imagesPath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];
		
	}
	else
	{
		//删除所有模板文件  不包括文件夹
		
		NSArray *templateArray = [fileManager contentsOfDirectoryAtPath:imagesPath
																  error:nil];
		for(NSString *string in templateArray)
		{
			NSError *error;
			if([fileManager removeItemAtPath:[imagesPath stringByAppendingPathComponent:string]  error:&error]);
		}
	}

	//生成所有模板文件
	SQLiteOptions *sqliteO = [SQLiteOptions sharedSQLiteOptions];
	[sqliteO openSQLiteDatabase];
	
    //sql查询语句
	NSString *sqlString = @"select FILE,A0101 from IPAD_A01_Function";
	sqlite3_stmt *stmt;
	const char *sql = [sqlString cStringUsingEncoding:4];
    //查询
	if (sqlite3_prepare_v2([SQLiteOptions getDatabase], sql, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			const unsigned char *colName = sqlite3_column_text(stmt,1);
			if (colName == nil)
			{
				
			}
			else {
                //处理返回值
				NSString *colString = [NSString stringWithUTF8String:(const char *)colName];
				const unsigned char *colType = sqlite3_column_text(stmt, 0);
				NSString *colImage = [NSString stringWithUTF8String:colType];
				NSData *imageData = [NSData dataFromBase64String:colImage];
                //向数据字典填充内容
				NSDictionary *dictionary = [NSDictionary dictionaryWithObject:imageData forKey:colString];
				[ret addObject:dictionary];
			}
			
			
		}
	}
	sqlite3_finalize(stmt);
    //关闭数据库
	[sqliteO closeSQLiteDatabase];
	BOOL success;
	int count=0;
	for (NSDictionary *dirctionary in ret) {
		NSString *key = [[dirctionary allKeys]objectAtIndex:0];
		NSString *fileApp = [NSString stringWithFormat:@"%@/%@",imagesPath,key];
		success=[[dirctionary objectForKey:key] writeToFile:fileApp atomically:YES];
		if (success == YES)
		{
			++count;
		}
	}
	if(count != [ret count])
	{
	    return NO;
	}
	return YES;
	//[fileManager release];
}

+(void)createFolder {
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
    //判断是否存在文件
	if (![Utilities isFileExist:[documentDir stringByAppendingPathComponent:@"template/"]]) {
        //声明各个路径
		NSString *folderPath = [documentDir stringByAppendingPathComponent:@"template/"];
		NSString *folderImagePath = [documentDir stringByAppendingPathComponent:@"template/bd/"];
		NSString *folderJSPath = [documentDir stringByAppendingPathComponent:@"template/js/"];
		NSString *folderCSSPath = [documentDir stringByAppendingPathComponent:@"template/css/"];
        //生命文件管理器
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		//创建相应的文件夹
		[fileManager createDirectoryAtPath:folderPath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];
		[fileManager createDirectoryAtPath:folderImagePath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];
		[fileManager createDirectoryAtPath:folderJSPath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];
		[fileManager createDirectoryAtPath:folderCSSPath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];
	
	}
    //判断是否存在文件
	if (![Utilities isFileExist:[documentDir stringByAppendingPathComponent:@"file/"]]) {
		//拼出文件夹所在路径
        NSString *folderPath = [documentDir stringByAppendingPathComponent:@"file/"];
        //文件管理器
		NSFileManager *fileManager = [NSFileManager defaultManager];
		//在指定路径下创建文件
		
		[fileManager createDirectoryAtPath:folderPath 
			   withIntermediateDirectories:YES attributes:nil error:NULL];

		
	}
    //创建模板
	[self createTemplate];

}

@end
