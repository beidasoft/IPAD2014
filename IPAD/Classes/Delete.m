//
//  Delete.m
//  IPAD
//
//  Created by  careers on 12-5-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Delete.h"
#import <sqlite3.h>
#import "Utilities.h"
#import "SQLiteOptions.h"



#define LINE_SIZE_DEFAULT 102400*100//100

static sqlite3 *database = nil;
@implementation Delete

- (id)init {
    
    self = [super init];
    if (self) {
       
    }
    return self;
}
-(void)deleteOldDate:(NSString *)databasePathString sqlFilePath:(NSString *)sqlPathString
{
	NSLog(@"%@",sqlPathString);
	int sqlCount;
    int buff_size = LINE_SIZE_DEFAULT ;
	FILE *fin;
    char *one_line;    
    // 读入的一行
	if( ( fin = fopen([[Utilities documentsPath:sqlPathString] UTF8String], "r") ) == NULL ) 
	{
        printf("can not open file %s\n",[sqlPathString UTF8String]);
        exit (-1); 
    };
	one_line = (char *) malloc(buff_size * sizeof(char));
	
	if(fgets(one_line, buff_size,fin) !=NULL)
	{
		sqlCount  = [[[[NSString stringWithUTF8String:one_line]componentsSeparatedByString:@","] objectAtIndex:1] intValue];
	}
	//打开sqlite数据库
	if (sqlite3_open([databasePathString UTF8String], &database) == SQLITE_OK)
	{
        //sqlite事务开始
		int rc = sqlite3_exec(database,"BEGIN",0,0,0);
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		while ( fgets(one_line, buff_size,fin) !=NULL)
		{
			
			const char *sql = one_line;
			const char *errorMsg;
            //执行sql语句
			if(sqlite3_exec(database,sql,NULL,NULL,&errorMsg ) == SQLITE_OK)
			{
                //发送消息，更新界面
				 [[NSNotificationCenter defaultCenter] postNotificationName:@"updataBar" object:[NSNumber numberWithFloat:1.0/sqlCount]];
			}
			else 
			{
				NSLog(@"fail");
				NSLog(@"%@",[NSString stringWithUTF8String:errorMsg]);
				rc = sqlite3_exec(database,"ROLLBACK",0,0,0);
				if (rc == SQLITE_OK)
				{
					fclose(fin);
				}
			}
		}
        //sqlite事务提交
		rc=sqlite3_exec(database,"COMMIT",0,0,0);
		if(rc != SQLITE_OK)
		{
			NSString *newSql = @"VACUUM";
			const char *sql = [newSql cStringUsingEncoding:4];
			if(sqlite3_exec(database,sql,NULL,NULL,nil ) == SQLITE_OK)
			{
			}
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
															message:@"出错！"
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		else 
		{
            //完成操作，发送消息
			[[NSNotificationCenter defaultCenter] postNotificationName:@"finish" object:nil];
			[self deleteFileAtPath:@"delete.sql"];
			
		}
	   [pool release];
	}
	sqlite3_close(database);
}

-(void)deleteFileAtPath:(NSString *)fileName
{
    //获取文件处理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//获取document路径
	NSString *documentsDirectory = [paths objectAtIndex:0];
    //删除目录下的文件
	[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fileName]
							error:nil];
	//[fileManager release];
}

-(void)dealloc
{
	[super dealloc];
}
@end
