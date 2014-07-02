//
//  SQLiteOptions.m
//  IpadTest
//
//  Created by Sun Yu on 11-11-22.
//  Copyright 2011 careers. All rights reserved.
//

#import "SQLiteOptions.h"
#import "NSData+Base64.h"
#import "PersonsInfo.h"
//数据库名称
#define kSQLITEBASENAME @"test.db"

static sqlite3 *database = nil;
static SQLiteOptions *sharedSQLite;

@implementation SQLiteOptions
+ (sqlite3 *)getDatabase
{
	return database;
}
+ (id)sharedSQLiteOptions
{
	if(sharedSQLite == nil)
		sharedSQLite = [[super alloc] init];
    return sharedSQLite;	
}

- (BOOL)openSQLiteDatabase
{
	//获取数据库路径
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains 
	(NSLibraryDirectory, NSUserDomainMask, YES); 
	NSString *libraryDir = [libraryPaths objectAtIndex:0]; 
	NSString *databasePath = [libraryDir stringByAppendingPathComponent:@"WebKit/Databases/file__0/"]; 
	NSString *databaseFile = [databasePath stringByAppendingPathComponent:kSQLITEBASENAME]; 
	
    //打开数据库
	if (sqlite3_open([databaseFile UTF8String], &database) != SQLITE_OK)
	{
		sqlite3_close(database);
		return NO;
	}
	
	return YES;
}


- (BOOL)closeSQLiteDatabase
{
    //判断是否存在数据库操作对象，并关闭数据库
	if (database) 
	{
		sqlite3_close(database);
	}
	return YES;
}


- (BOOL)isTableExists:(NSString *)tableName
{
	[self openSQLiteDatabase];
	BOOL ret = NO;
	NSString *query = [NSString stringWithFormat:@"pragma table_info(%@);", tableName];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database,  [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		if (sqlite3_step(stmt) == SQLITE_ROW)
			ret = YES;
		sqlite3_finalize(stmt);
	}
	[self closeSQLiteDatabase];
	return ret;
}



- (NSArray *)getTableHeaderAndTypeByTN:(NSString *)tableName;
{
	[self openSQLiteDatabase];
	
	NSMutableArray *ret = [NSMutableArray array];
	NSString *query = [NSString stringWithFormat:@"pragma table_info(%@);",tableName];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database,  [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			const unsigned char *colName = sqlite3_column_text(stmt, 1);
			//NSString *colString = [NSString stringWithUTF8String:(const char *)colName];
			NSString *colString = [[NSString alloc] initWithUTF8String:(const char *)colName];
			const unsigned char *colType = sqlite3_column_text(stmt, 2);
			//NSString *colTpyeString = [NSString stringWithUTF8String:(const char *)colType];
			NSString *colTpyeString = [[NSString alloc] initWithUTF8String:(const char *)colType];
			NSDictionary *dictionary = [NSDictionary dictionaryWithObject:colTpyeString forKey:colString];
			
			
			[ret addObject:dictionary];
			[colString release];
			[colTpyeString release];
		}
		
		sqlite3_finalize(stmt);
	}
	
	[self closeSQLiteDatabase];
	return ret;
}
static int clearCount = 0;
-(BOOL)clearDataFromDatabase
{
	NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSString *getTableNameSql = @"select name from sqlite_master where type='table' order by name";
	
	[self openSQLiteDatabase];
	sqlite3_stmt *selectStmt;
	if (sqlite3_prepare_v2( database,  [getTableNameSql UTF8String], -1, &selectStmt, nil) == SQLITE_OK) 
	{
        //查询到结果
		while (sqlite3_step(selectStmt) == SQLITE_ROW)
		{
			const unsigned char *colName = sqlite3_column_text(selectStmt, 0);
			NSString *colString = [[NSString alloc] initWithUTF8String:(const char *)colName];
            [ret addObject:colString];
			[colString release];
		}
		sqlite3_finalize(selectStmt);
	}
    //错误信息
	const char *errorMsg;
    for(NSString *tableNameString in ret)
	{
        //判断名称是不是符合databaseVersion、sqlite_sequence、MAIN_TABLE
		if ([tableNameString isEqualToString:@"databaseVersion"]||[tableNameString isEqualToString:@"sqlite_sequence"]||[tableNameString isEqualToString:@"MAIN_TABLE"]) 
		{
			
		}
		else
		{
            //清楚表内容
			NSString *clearSql = [NSString stringWithFormat:@"delete from %@",tableNameString];
			if(sqlite3_exec(database,[clearSql UTF8String],NULL,NULL,&errorMsg) == SQLITE_OK)
			{
				clearCount++;
			}
			else {
				NSLog(@"%@",[NSString stringWithUTF8String:errorMsg]);
			}

		}
	}
    //判断清除计数
	if (clearCount == ([ret count]-3))
	{
		NSString *vaString = @"VACUUM";
		const char *sql = [vaString cStringUsingEncoding:4];
		if (sqlite3_exec(database, sql, NULL, NULL, nil)==SQLITE_OK)
		{
			[self closeSQLiteDatabase];
			[ret release];
			return YES;
		}
		
	}
	else
	{
		[ret release];
		return NO;
	}
	
}


- (NSArray *)queryWithTableName:(NSString *)tableName andCondition:(NSString *)condition
{
    
    //根据表名查询内容
	NSMutableArray *ret = [NSMutableArray array];
	NSString *query = [NSString stringWithFormat:@"select * from %@",tableName];
	if (condition)
	{
		query = [NSString stringWithFormat:@"%@ WHERE %@",query,condition];
	}
	
	NSArray *arrayHeader = [self getTableHeaderAndTypeByTN:tableName];
	int columnsCount = [arrayHeader count];
	int row = 0;
	
	[self openSQLiteDatabase];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database,  [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			for (int i = 0; i < columnsCount; i++ ) 
			{
				const unsigned char *colName;
				NSString *colString ;
				NSString *head;
				
				if([[[[arrayHeader objectAtIndex:i] allValues]objectAtIndex:0] isEqualToString:@"BLOB" ])
				{
					colString = [[NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)]base64EncodedString];
					head = @" NSData";
				}
				else 
				{
					colName = sqlite3_column_text(stmt, i);
					colString = [NSString stringWithUTF8String:(const char *)colName];
					head = [[[arrayHeader objectAtIndex:i] allKeys]objectAtIndex:0];
				}
                
				if (row > 0) 
				{
					head = [NSString stringWithFormat:@"%@%d",head,row];
				}
                //将获取的值赋给一个字典对象
				NSDictionary *dictionary = [NSDictionary dictionaryWithObject:colString forKey:head];
				
				[ret addObject:dictionary];
			}
			row++ ;
		}
		
		sqlite3_finalize(stmt);
	}
	
	[self closeSQLiteDatabase];
	return ret;
}


- (NSArray *)queryWithSQL:(NSString *)SQL
{
    
    NSArray *sqlArray = [SQL componentsSeparatedByString:@";"];
    
	NSMutableArray *ret = [NSMutableArray array];
    NSArray *arrayField;
    NSString *tableName;
    int fromIndex;
    NSArray *arrayHeader;
    int columnsCount,row;
    
    for (NSString *sql in sqlArray) 
	{
        if (![sql isEqualToString:@""]) {
            NSString *sqlString = [sql lowercaseString];     
            arrayField = [sqlString componentsSeparatedByString:@" "];
            fromIndex = [arrayField indexOfObject:@"from"];
            tableName = [arrayField objectAtIndex:fromIndex+1];
            arrayHeader = [self getTableHeaderAndTypeByTN:tableName];
            columnsCount = [arrayHeader count];
            row = 0;
            [self openSQLiteDatabase];
            sqlite3_stmt *stmt;
            if (sqlite3_prepare_v2( database,  [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
			{
                while (sqlite3_step(stmt) == SQLITE_ROW)
				{
					NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                    for (int i = 0; i < columnsCount; i++ ) 
					{
                        NSString *colString ;
                        NSString *head;
                        
                        if([[[[[arrayHeader objectAtIndex:i] allValues]objectAtIndex:0] lowercaseString] isEqualToString:@"blob"  ])
						{
                            colString = [[NSString alloc] initWithString:[[NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)] base64EncodedString]];
						}
                        else 
						{
                            if(sqlite3_column_text(stmt, i))
                                colString = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];//[NSString stringWithUTF8String:(const char *)colName];
                            else
                                colString =@" ";
						}
                        head = [[[arrayHeader objectAtIndex:i] allKeys]objectAtIndex:0];
                        
                        [dictionary setObject:colString forKey:head];
                        [colString release];
						colString = nil;
                        
					}
					[ret addObject:dictionary];
					[dictionary release];
					dictionary = nil;
                    row++ ;
				}
            }
            sqlite3_finalize(stmt);
            [self closeSQLiteDatabase];
        }
	}
	
	return ret;
}

-(NSArray *)searchPersons:(NSString *)condition
{
	NSMutableArray *ret = [NSMutableArray array];

    NSString *sql = [NSString stringWithFormat:@"select A0101,A0102,a02_a0215_all_MingCe,GetPersonBaseInf,FILE,A00 from IPAD_A01_Function where A0201B='%@' order by A02_Order",condition];
            [self openSQLiteDatabase];
            sqlite3_stmt *stmt;
            if (sqlite3_prepare_v2( database,  [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
			{
                while (sqlite3_step(stmt) == SQLITE_ROW)
				{
					const unsigned char *colName1 = sqlite3_column_text(stmt, 0);
					const unsigned char *colName2 = sqlite3_column_text(stmt, 1);
					const unsigned char *colName3 = sqlite3_column_text(stmt, 2);
					const unsigned char *colName4 = sqlite3_column_text(stmt, 3);
					const unsigned char *colName5 = sqlite3_column_text(stmt, 4);
					const unsigned char *colName6 = sqlite3_column_text(stmt, 5);
					NSString *col1 = [NSString stringWithUTF8String:(const char *)colName1];
					NSString *col2 = [NSString stringWithUTF8String:(const char *)colName2];
					NSString *col3 = [NSString stringWithUTF8String:(const char *)colName3];
					NSString *col4 = [NSString stringWithUTF8String:(const char *)colName4];
					NSString *col5 = [NSString stringWithUTF8String:(const char *)colName5];
					NSString *col6 = [NSString stringWithUTF8String:(const char *)colName6];
					PersonsInfo *person = [[PersonsInfo alloc] initWithData:col1
																		 PinYIn:col2
																	 detailInfo:col3
																	detailInfos:col4
																		  image:[NSString stringWithFormat:@"data:image/png;base64,%@",col5]
																		 ID:col6];
					[ret addObject:person];
					[person release];
				}
            }
            sqlite3_finalize(stmt);
            [self closeSQLiteDatabase];
	return ret;
}

-(NSMutableArray *)getPersonsInfo:(NSString *)unitID
{
    NSString *sqlString = [NSString stringWithFormat:@"select A0101,A0102,a02_a0215_all_MingCe,GetPersonBaseInf,FILE from IPAD_A01_Function where A0201B='%@' order by A02_Order",unitID];
	const char *sql = [sqlString cStringUsingEncoding:4];
	NSMutableArray *ret = [NSMutableArray array];
	NSMutableArray *headerArray = [NSMutableArray arrayWithObjects:@"A0101",@"A0102",@"a02_a0215_all_MingCe",@"GetPersonBaseInf",@"FILE",nil];
	[self openSQLiteDatabase];
	sqlite3_stmt *selectStmt;
	if (sqlite3_prepare_v2(database, sql, -1, &selectStmt, nil)==SQLITE_OK)
	{
		while (sqlite3_step(selectStmt) == SQLITE_ROW)
		{
			NSMutableArray *onePersonArray = [NSMutableArray array];
			for (int i=0; i<[headerArray count]; i++)
			{
				NSString *colString;
				if ([[headerArray objectAtIndex:i] isEqualToString:@"FILE"])
				{
					NSString *tempString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(selectStmt, i)];
					
					colString = [NSString stringWithFormat:@"data:image/png;base64,%@",tempString];
					[onePersonArray addObject:colString];
				}
				else
				{
					colString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(selectStmt, i)];
					[onePersonArray addObject:colString];
				}

			}
			[ret addObject:onePersonArray];
			
		}
		sqlite3_close(selectStmt);
	}
	[self closeSQLiteDatabase];
	return ret;
}

-(NSArray *)queryInTemplate
{
	 NSMutableArray *ret = [NSMutableArray array];
     NSString *sqlString = @"select ID,NAME,SQLITE,FILE_NAME from IPAD_TEMPLATE";
	 const char *sql = [sqlString cStringUsingEncoding:4];
	 NSArray *headerArray = [NSArray arrayWithObjects:@"ID",@"NAME",@"SQLITE",@"FILE_NAME",nil];
	 sqlite3_stmt *stmt;
	 int rows=0;
	[self openSQLiteDatabase];
	if (sqlite3_prepare_v2( database,  sql, -1, &stmt, nil) == SQLITE_OK) 
	{
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
			for (int i=0; i<[headerArray count]; i++)
			{
				const unsigned char *colName;
				NSString *colString ;
				NSString *head;
				colName = sqlite3_column_text(stmt,i);
				if (colName!=nil)
				{
					colString = [NSString stringWithUTF8String:(const char *)colName];
				}
				else {
					colString = @" ";
				}
				head = [headerArray objectAtIndex:i];
				
				[dictionary setObject:colString forKey:head];
			}
			[ret addObject:dictionary];
			rows++;
		}
		
		
	}
	sqlite3_finalize(stmt);
	[self closeSQLiteDatabase];
	return ret;
}


-(NSArray *)queryWithName:(NSString *)name
{
	NSMutableArray *ret = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,FILE FROM IPAD_A01_Function WHERE A0101='%@'",name];
	const char *sql = [sqlString cStringUsingEncoding:4];
	NSArray *headerArray = [NSArray arrayWithObjects:@"A0101",@"A0102",@"GetPersonBaseInf",@"a02_a0215_all_MingCe",@"FILE",nil];
	sqlite3_stmt *stmt;
	int rows = 0;
	[self openSQLiteDatabase];
	if (sqlite3_prepare_v2( database,  sql, -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
			for (int i=0; i<[headerArray count]; i++)
			{
				const unsigned char *colName;
				NSString *colString ;
				NSString *head;
				
				if (i<4) 
				{
					colName = sqlite3_column_text(stmt,i);
					if (colName!=nil)
					{
						colString = [NSString stringWithUTF8String:(const char *)colName];
					}
					else {
						colString = @" ";
					}
					
				}
				else
				{
					 colString = [[NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)] base64EncodedString];
				}

				
				head = [headerArray objectAtIndex:i];
				[dictionary setObject:colString forKey:head];
			}
			[ret addObject:dictionary];
			rows++;
		}
		
		sqlite3_finalize(stmt);
	}
	[self closeSQLiteDatabase];
	
	return ret;
	
}

//-(NSArray *)queryWithName:(NSString *)name andNumber:(int)number andLastNumber:(int)lnumber
//{
//    NSString *sqlString = [NSString stringWithFormat:@"select DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,FILE,A00 FROM IPAD_A01_Function WHERE A0101 like '%@%@%@' or A0102 LIKE '%@%@%@' ORDER BY A0102 limit %d,%d",@"%",name,@"%",@"%",name,@"%",number,lnumber];
//	const char *sql = [sqlString cStringUsingEncoding:4];
//	NSMutableArray *ret = [NSMutableArray array];
//	NSArray *headerArray = [NSArray arrayWithObjects:@"A0101",@"A0102",@"GetPersonBaseInf",@"a02_a0215_all_MingCe",@"FILE",@"A00",nil];
//	sqlite3_stmt *stmt;
//	int rows = 0;
//	[self openSQLiteDatabase];
//	if (sqlite3_prepare_v2( database,  sql, -1, &stmt, nil) == SQLITE_OK) {
//		while (sqlite3_step(stmt) == SQLITE_ROW)
//		{
//			NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//			for (int i=0; i<[headerArray count]; i++)
//			{
//				const unsigned char *colName;
//				NSString *colString ;
//				NSString *head;
//			
//					colName = sqlite3_column_text(stmt,i);
//					if (colName!=nil)
//					{
//						colString = [[NSString alloc] initWithUTF8String:(const char *)colName];//[NSString stringWithUTF8String:(const char *)colName];
//					}
//					else {
//						colString = [[NSString alloc] initWithString:@" "];
//					}
//				head = [headerArray objectAtIndex:i];
//				[dictionary setObject:colString forKey:head];
//				[colString release];
//			}
//			[ret addObject:dictionary];
//			[dictionary release];
//			rows++;
//		}
//		
//		sqlite3_finalize(stmt);
//	}
//	[self closeSQLiteDatabase];
//	
//	return ret;
//}

-(NSArray *)queryWithSearchSQL:(NSString *)searchSQL andNumber:(int)number andLastNumber:(int)lnumber
{

	NSString *sqlString = [NSString stringWithFormat:@"%@ limit %d,%d",searchSQL,number,lnumber];
	const char *sql = [sqlString cStringUsingEncoding:4];
	NSMutableArray *ret = [NSMutableArray array];
	
	NSString *columnString;
	NSString *afterSelectString = [[searchSQL componentsSeparatedByString:@" "]objectAtIndex:1];
	
    if ([[afterSelectString uppercaseString] isEqualToString:@"DISTINCT"]) 
	{
		columnString = [[searchSQL componentsSeparatedByString:@" "] objectAtIndex:2];
	}
	else 
	{
		columnString = [[searchSQL componentsSeparatedByString:@" "] objectAtIndex:1];
	}
	NSArray *headerArray = [columnString componentsSeparatedByString:@","];
	sqlite3_stmt *stmt;
	int rows = 0;
	[self openSQLiteDatabase];
	if (sqlite3_prepare_v2( database,  sql, -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
			for (int i=0; i<[headerArray count]; i++)
			{
				const unsigned char *colName;
				NSString *colString ;
				NSString *head;
				
				colName = sqlite3_column_text(stmt,i);
				if (colName!=nil)
				{
					colString = [[NSString alloc] initWithUTF8String:(const char *)colName];//[NSString stringWithUTF8String:(const char *)colName];
				}
				else {
					colString = [[NSString alloc] initWithString:@" "];
				}
				head = [headerArray objectAtIndex:i];
				[dictionary setObject:colString forKey:head];
				[colString release];
			}
			[ret addObject:dictionary];
			[dictionary release];
			rows++;
		}
		
		sqlite3_finalize(stmt);
	}
	[self closeSQLiteDatabase];
	
	return ret;
}


- (NSArray *)getRelationTableAndId:(NSString *)ddl {
	NSRange range1 = [ddl rangeOfString:@"REFERENCES"];
	NSString *str1 = [ddl substringFromIndex:range1.location+range1.length+1];
	NSRange range2 = [str1 rangeOfString:@" ON "];
	NSString *str2 = [str1 substringToIndex:range2.location];
	NSRange range3 = [str2 rangeOfString:@"("];
	NSString *str3 = [str2 substringToIndex:range3.location];
	NSString *str4 = [str2 substringFromIndex:range3.location];
	NSRange range4 = [str4 rangeOfString:@"("];
	NSRange range5 = [str4 rangeOfString:@")"];
	NSString *str5 = [str4 substringFromIndex:range4.location+1];
	NSString *str6 = [str5 substringToIndex:range5.location-1];
	NSArray *tableArray = [NSArray arrayWithObjects:str3,str6,nil];
	return tableArray;
}







- (NSString *)getJSONResultqueryWithSQL:(NSString *)SQL
{
	
	NSMutableString *resultJSONString = [NSMutableString stringWithString:@"["];
    NSArray *sqlArray = [SQL componentsSeparatedByString:@";"];
    
	
    NSArray *arrayField;
    NSString *tableName;
    int fromIndex;
    NSArray *arrayHeader;
    int columnsCount,row;
    
    sqlite3_stmt *stmt;
    
    for (NSString *sql in sqlArray) 
	{
        if (![sql isEqualToString:@""]) {
            sql = [sql lowercaseString];            
            arrayField = [sql componentsSeparatedByString:@" "];
            fromIndex = [arrayField indexOfObject:@"from"];
            tableName = [arrayField objectAtIndex:fromIndex+1];
            arrayHeader = [self getTableHeaderAndTypeByTN:tableName];
            columnsCount = [arrayHeader count];
            row = 0;
            [self openSQLiteDatabase];
            
            
            if (sqlite3_prepare_v2( database,  [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW)
				{
					
					NSMutableString *rowItemJSONString = [NSMutableString stringWithString:@"{"];
                    for (int i = 0; i < columnsCount; i++ ) 
					{
						
                        const unsigned char *colName;
                        //查询的返回值
                        NSString *colString ;
                        NSString *head;
                        
                        if([[[[[arrayHeader objectAtIndex:i] allValues]objectAtIndex:0] lowercaseString] isEqualToString:@"blob"  ])
						{
                            colString = [[NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)] base64EncodedString];
						}
                        else 
						{
                            colName = sqlite3_column_text(stmt, i);
                            if(colName)
                                colString = [NSString stringWithUTF8String:(const char *)colName];
                            else
                                colString =@" ";
						}
                        head = [[[arrayHeader objectAtIndex:i] allKeys]objectAtIndex:0];
						
						if (i != 0) {
							[rowItemJSONString appendFormat:@",\"%@\":\"%@\"",head,colString];
						}
						else {
							[rowItemJSONString appendFormat:@"\"%@\":\"%@\"",head,colString];
						}
                        
					}
                    
                    row++ ;
					[rowItemJSONString appendString:@"}"];
					
					if (row != 1) {
						[resultJSONString appendFormat:@",%@",rowItemJSONString];
					}
					else {
						[resultJSONString appendFormat:@"%@",rowItemJSONString];
					}
				}
                [resultJSONString appendString:@"]"];
                sqlite3_finalize(stmt);
            }
            
            [self closeSQLiteDatabase];
        }
	}
	
	
	return resultJSONString;
}




- (NSArray *)queryWithSqlString:(NSString *)SQL
{
	NSMutableArray *ret = [NSMutableArray array];
	NSString *query = [SQL lowercaseString];
	NSArray *arrayField = [query componentsSeparatedByString:@" "];
	int fromIndex = [arrayField indexOfObject:@"from"];
	NSString *tableName = [arrayField objectAtIndex:fromIndex+1];
	
	NSArray *arrayHeader = [self getTableHeaderAndTypeByTN:tableName];
	int columnsCount = [arrayHeader count];
	int row = 0;
	
	[self openSQLiteDatabase];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2( database,  [SQL UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			for (int i = 0; i < columnsCount; i++ ) 
			{
				const unsigned char *colName;
				NSData *colString ;
				NSString *head;
				
				if([[[[arrayHeader objectAtIndex:i] allValues]objectAtIndex:0] isEqualToString:@"BLOB" ])
				{
					colString = [NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)];
					head = @" NSData";
				}
				else 
				{
					colName = sqlite3_column_text(stmt, i);
					if (colName != nil)
					{
						colString = [NSString stringWithUTF8String:(const char *)colName];
						head = [[[arrayHeader objectAtIndex:i] allKeys]objectAtIndex:0];
					}
					
				}
				
				if (row > 0) 
				{
					head = [NSString stringWithFormat:@"%@%d",head,row];
				}
				NSDictionary *dictionary = [NSDictionary dictionaryWithObject:colString forKey:head];
				
				[ret addObject:dictionary];
			}
			row++ ;
		}
		
		sqlite3_finalize(stmt);
	}
	
	[self closeSQLiteDatabase];
	return ret;
}
-(NSArray *)queryWithsql:(NSString *)sql
{
	NSString *query = sql;
    NSArray *sqlArray = [query componentsSeparatedByString:@";"];
	NSMutableArray *ret = [[NSMutableArray alloc] init];
	for (int i=0; i<[sqlArray count]; i++)
	{
        NSString *SQL = [NSString stringWithFormat:@"%@",[[sqlArray objectAtIndex:i]lowercaseString]];
		NSArray *arrayField = [SQL componentsSeparatedByString:@" "];
		int fromIndex = [arrayField indexOfObject:@"from"];
		NSString *tableName = [arrayField objectAtIndex:fromIndex+1];
		
		NSArray *arrayHeader = [self getTableHeaderAndTypeByTN:tableName];
		int columnsCount = [arrayHeader count];
		int row = 0;
		
		[self openSQLiteDatabase];
		
		sqlite3_stmt *stmt;
		if (sqlite3_prepare_v2( database,  [[sqlArray objectAtIndex:i] UTF8String], -1, &stmt, nil) == SQLITE_OK) {
			while (sqlite3_step(stmt) == SQLITE_ROW)
			{
				for (int i = 0; i < columnsCount; i++ ) 
				{
					const unsigned char *colName;
					NSData *colString ;
					NSString *head;
					
					if([[[[arrayHeader objectAtIndex:i] allValues]objectAtIndex:0] isEqualToString:@"BLOB" ])
					{
						colString = [NSData dataWithBytes:sqlite3_column_blob(stmt, i) length:sqlite3_column_bytes(stmt, i)];
						head = @" NSData";
					}
					else 
					{
						colName = sqlite3_column_text(stmt, i);
						colString = [NSString stringWithUTF8String:(const char *)colName];
						head = [[[arrayHeader objectAtIndex:i] allKeys]objectAtIndex:0];
					}
					
					if (row > 0) 
					{
						head = [NSString stringWithFormat:@"%@%d",head,row];
					}
					NSDictionary *dictionary = [NSDictionary dictionaryWithObject:colString forKey:head];
					
					[ret addObject:dictionary];
				}
				row++ ;
			}
			
			sqlite3_finalize(stmt);
		}
	}
	[self closeSQLiteDatabase];
	return [ret autorelease];
	
}



// lijie
-(NSArray *)queryWithCondition:(int)parentID
{
	NSMutableArray *ret = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:@"select ID,FILE_NAME,ParentID,BaseParentID,Title from IPAD_Analysis_Group_File where ParentID = %d order by Porder asc",parentID];
	const char *sql = [sqlString cStringUsingEncoding:4];
	NSArray *headerArray = [NSArray arrayWithObjects:@"ID",@"FILE_NAME",@"ParentID",@"BaseParentID",@"Title",nil];
	sqlite3_stmt *stmt;
	int rows=0;
	[self openSQLiteDatabase];
	if (sqlite3_prepare_v2( database,  sql, -1, &stmt, nil) == SQLITE_OK) 
	{
		while (sqlite3_step(stmt) == SQLITE_ROW)
		{
			NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
			for (int i=0; i<[headerArray count]; i++)
			{
				const unsigned char *colName;
				NSString *colString ;
				NSString *head;
				colName = sqlite3_column_text(stmt,i);
				if (colName!=nil)
				{
					colString = [NSString stringWithUTF8String:(const char *)colName];
				}
				else {
					colString = @" ";
				}
				head = [headerArray objectAtIndex:i];
				
				[dictionary setObject:colString forKey:head];
			}
			[ret addObject:dictionary];
			rows++;
		}
		
		
	}
	sqlite3_finalize(stmt);
	[self closeSQLiteDatabase];
	return ret;
}



@end
