//
//  Update.m
//  IPAD
//
//  Created by yang on 11-12-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Update.h"
#import <sqlite3.h>
#import "Utilities.h"
#import "SQLiteOptions.h"
#define LINE_SIZE_DEFAULT 102400*100//100

static sqlite3 *database = nil;
@implementation Update

- (id)init {
    
    self = [super init];
    if (self) {
        // Initialization code.
		updateCount=0;
    }
    return self;
}


-(void)updateNewData:(NSString *)databasePathString updateStringPath:(NSArray *)sqlPathArray
{
	int sqlCount;
    //FILE *fin;
    //char *one_line;    // 读入的一行
    int buff_size = LINE_SIZE_DEFAULT ; //根据最长行字符定大小
	//NSString *sqlStrings=@"";
	for(NSString *sqlPathString in sqlPathArray)
	{
		FILE *fin;
    if( ( fin = fopen([[Utilities documentsPath:sqlPathString] UTF8String], "r") ) == NULL ) 
	{
        printf("can not open file %s\n",[sqlPathString UTF8String]);
        exit (-1); 
    }; 
	
	//one_line = (char *) malloc(buff_size * sizeof(char));
	char *one_line = (char *) malloc(buff_size * sizeof(char));
	NSString *fileVersion;
	NSString *sqliteVersion;
	
	if(fgets(one_line, buff_size,fin) !=NULL)
	{
		fileVersion = [[[NSString stringWithUTF8String:one_line]componentsSeparatedByString:@","] objectAtIndex:0];
		sqlCount    = [[[[NSString stringWithUTF8String:one_line]componentsSeparatedByString:@","] objectAtIndex:1] intValue];
	}
	//打开sqlite数据库
	if (sqlite3_open([databasePathString UTF8String], &database) == SQLITE_OK)
	{
        //查询数据库版本
		NSString *sqlString = @"select * from databaseVersion where id = 1";
		const char *sql = [sqlString cStringUsingEncoding:4];
		sqlite3_stmt *selectstmt;
		//执行sql语句
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
		{
			while(sqlite3_step(selectstmt) == SQLITE_ROW) 
			{
				sqliteVersion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
			}
		}
		sqlite3_finalize(selectstmt);
	}
		sqlite3_close(database);
	NSString *fileVersionNew = [NSString stringWithFormat:@"%.1f",
								([fileVersion floatValue]-[sqliteVersion floatValue])];
    //判断数据库版本号是否为“0.1”
	if([fileVersionNew isEqualToString:@"0.1"])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"kaishi" object:nil];
		if (sqlite3_open([databasePathString UTF8String], &database) == SQLITE_OK)
		{
             //sqlite事务开始
			 int rc = sqlite3_exec(database,"BEGIN",0,0,0);
			 const char *errorMsg;
			 while ( fgets(one_line, buff_size,fin) !=NULL)
			 {
				
				  const char *sql = one_line;
				  //const char *errorMsg;
				  NSString *sqlStrings = [[NSString alloc] initWithUTF8String:sql];
				 //执行sql语句
                 if(sqlite3_exec(database,sql,NULL,NULL,&errorMsg ) == SQLITE_OK)
				  {
					 NSLog(@"update successfully!");
					 NSLog(@"%f",1.0/sqlCount);
					 NSString *templateString = @"IPAD_TEMPLATE";
					 NSRange range = [sqlStrings rangeOfString:templateString];
					 if (range.length != 0)
					 {
						 NSArray *temp = [sqlStrings componentsSeparatedByString:@" "];
						 //delete的sql语句的情况
                         if ([[[temp objectAtIndex:0] lowercaseString] isEqualToString:@"delete"])
						 {
							 NSString *tempCondition = [[[temp lastObject] componentsSeparatedByString:@"'"] objectAtIndex:1];
							 NSString *temSql = [NSString stringWithFormat:@"select * from IPAD_TEMPLATE where ID = %d",[tempCondition intValue]];
							 NSArray *temArray = [[SQLiteOptions sharedSQLiteOptions] queryWithSQL:temSql];
							 NSString *tableName = [[temArray objectAtIndex:0] objectForKey:@"NAME"];
							 NSString *dropSqlString = [NSString stringWithFormat:@"drop table %@",tableName];
							 const char *dropSql = [dropSqlString cStringUsingEncoding:4];
							 if(sqlite3_exec(database,dropSql,NULL,NULL,&errorMsg ) == SQLITE_OK)
							 {
							     sqlCount +=1;
							 }
						 }
                          //insert的sql语句的情况
						 else if([[[temp objectAtIndex:0] lowercaseString] isEqualToString:@"insert"])
						 {
							 NSArray *ItemArray = [sqlStrings componentsSeparatedByString:@",'"];
							 NSString *lastStirng = [ItemArray objectAtIndex:2];
							 NSArray *newItemArray = [lastStirng componentsSeparatedByString:@";"];
							 NSString *childSqlString = [newItemArray objectAtIndex:0];
							 NSArray *tmpArray = [childSqlString componentsSeparatedByString:@" "];
							 NSString *tableNames = [NSString stringWithFormat:@"%@",[tmpArray objectAtIndex:2]];
							 NSString *tableName = [[tableNames componentsSeparatedByString:@"\""] objectAtIndex:1];
							 if (![[SQLiteOptions sharedSQLiteOptions] isTableExists:tableName])
							 {
								 const char *childSql = [childSqlString cStringUsingEncoding:4];
								 if (sqlite3_exec(database,childSql,NULL,NULL,&errorMsg ) == SQLITE_OK) 
								 {
									 sqlCount+=1;
								 }
							 }	 
						 }
					 }
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
				 [sqlStrings release];
			}
            //sqlite事务提交
			rc=sqlite3_exec(database,"COMMIT",0,0,0);
			//更新出错
            if(rc != SQLITE_OK)
			{
				NSString *newSql = @"VACUUM";
				const char *sql = [newSql cStringUsingEncoding:4];
				if(sqlite3_exec(database,sql,NULL,NULL,nil ) == SQLITE_OK)
				{
				}
				[[NSNotificationCenter defaultCenter]postNotificationName:@"error" object:nil];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
																message:[NSString stringWithUTF8String:errorMsg]//@"对不起数据库更新出错！"
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				
			}
			else {
				NSLog(@"成功！");
				++updateCount;
				[self deleteFileAtPath:sqlPathString];
				[self updateVersion:fileVersion];
				
				if(updateCount==[sqlPathArray count])
				{
					[[NSNotificationCenter defaultCenter] postNotificationName:@"finish" object:nil];
					
					BOOL exist;
					BOOL exists;
                    //生成模板提示
					UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
																   message:@"生成模板中⋯⋯"
																  delegate:nil
														 cancelButtonTitle:nil
														 otherButtonTitles:nil];
					[alert show];
					exist = [Utilities createTemplate];
					exists = [Utilities createHtmlTemplate];
					if(exist == YES&&exists == YES)
					{
						[alert dismissWithClickedButtonIndex:0 animated:NO];
					}
					[alert release];
				 //更新提示
				 UIAlertView *alert1= [[UIAlertView alloc]initWithTitle:nil
															   message:@"您的数据库已更新！" 
															  delegate:self
													 cancelButtonTitle:@"OK"
													 otherButtonTitles:nil];
				 [alert1 show];
				 [alert1 release];
                 //开启自动锁屏 2012－8－16 王渤
                 [UIApplication sharedApplication].idleTimerDisabled = NO;
                 //webkit下数据丢失备份
                    [self dateBackup];
				}
				else 
				{
				    [[NSNotificationCenter defaultCenter] postNotificationName:@"zero" object:nil];
				}

			}
		}
		sqlite3_close(database);
	}
	else
	{
		//版本信息不正确
		[[NSNotificationCenter defaultCenter] postNotificationName:@"finish1" object:nil];
		[Utilities createTemplate];
		[Utilities createHtmlTemplate];
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"对不起,数据库版本错误！"
														   message:[NSString stringWithFormat:
																	@"您的数据库版本已更新至%@最新版本为%@,您需下载%@，至%@之间的所有版本才可更新！",sqliteVersion,fileVersion,sqliteVersion,fileVersion]
														  delegate:self
												 cancelButtonTitle:@"OK" 
												 otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
	}
		fclose(fin);
		free(one_line);

}
	
}	
//将Backup文件夹里的数据库文件copy到webkit目录下
- (void)dateBackup{
    NSString *testBackupName = @"/test.db";
	NSString *databaseBackupName = @"/Databases.db"; 
	
	// Get the path to the Library directory and append the databaseName 
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
	(NSLibraryDirectory, NSUserDomainMask, YES); 
    //library路径
	NSString *libraryDir = [libraryPaths objectAtIndex:0]; 
    
    NSString *databaseBackupPath = [libraryDir stringByAppendingPathComponent:@"Backup"];

    NSFileManager *NFM = [NSFileManager defaultManager];
	BOOL isDir = YES;
    //判断路径下的数据库文件是否存在
	if (![NFM fileExistsAtPath:databaseBackupPath isDirectory:&isDir]) {
        if (![NFM createDirectoryAtPath:databaseBackupPath attributes:nil]) {
            //buile forder
		}
    }
     //原数据库文件路径
    NSString *databaseFormerFile = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases/Databases.db"];
    NSString *testFormerFile = [libraryDir stringByAppendingPathComponent:@"Webkit/Databases/file__0/test.db"];
     //拷贝数据库文件
    NSData *databaseData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:databaseFormerFile]];
    NSData *testData = [[NSData alloc] initWithData:[NSData dataWithContentsOfFile:testFormerFile]];
    
	NSString *testBackupFile = [databaseBackupPath stringByAppendingPathComponent:testBackupName]; 
	NSString *databaseBackupFile = [databaseBackupPath 
					stringByAppendingPathComponent:databaseBackupName];
	 //创建数据库文件
    [databaseData writeToFile:databaseBackupFile atomically:YES];
	[testData writeToFile:testBackupFile atomically:YES];
    
    [databaseData release];
    [testData release];
}
-(void)deleteFileAtPath:(NSString *)fileName
{
     //获取文件处理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
	//获取document路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 //删除目录下的文件
	NSString *documentsDirectory = [paths objectAtIndex:0];
	[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fileName]
							error:nil];
	//[fileManager release];
}
//更新数据库的版本号
-(void)updateVersion:(NSString *)versionString 
{
    //拼接sql语句
	NSString *sqlString  = [NSString stringWithFormat:@"update databaseVersion set version = '%@' where id = 1",versionString];
	const char *sql = [sqlString cStringUsingEncoding:4];
	const char *errorMsg=NULL;
    //执行sql语句
	if(sqlite3_exec(database,sql,NULL,NULL,&errorMsg ) == SQLITE_OK)
	{
		NSLog(@"数据库中版本已更新");
		
	}
	
}

-(void)dealloc
{
	[super dealloc];
}

@end
