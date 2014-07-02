//
//  SQLiteOptions.h
//  IpadTest
//
//  Created by Sun Yu on 11-11-22.
//  Copyright 2011 careers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"
#import <sqlite3.h>


@interface SQLiteOptions : NSObject {

}

/*
	@method    
	@author      sunyu
	@date        2011-11-22 
	@description 获取单实例对象
	@param       nil；
	@result      SQLiteOptions对象；
 */
+ (id)sharedSQLiteOptions;

/*
	@method    
	@author      sunyu
	@date        2011-11-22 
	@description 打开数据库
	@param       nil；
	@result      yes为打开成功，no为打开失败；
*/
- (BOOL)openSQLiteDatabase;

/*
	@method    
	@author      sunyu
	@date        2011-11-22 
	@description 关闭数据库
	@param       nil；
	@result      yes为关闭成功，no为关闭失败；
*/
- (BOOL)closeSQLiteDatabase;


/*
	@method    
	@author      sunyu
	@date        2011-11-24 
	@description 判断表是否存在
	@param       tableName：表名称；
	@result      yes为存在，no为不存在
*/

- (BOOL)isTableExists:(NSString *)tableName;




- (NSArray *)getTableHeaderAndTypeByTN:(NSString *)tableName;

/*
	@method    
	@author      sunyu
	@date        2011-11-24 
	@description 数据库查询
	@param       tableName：表名称；
				 condition：查询条件
	@result      返回查询结果，数组中每一项为dictionary-》（typeName，data）
*/

- (NSArray *)queryWithTableName:(NSString *)tableName andCondition:(NSString *)condition; 

/*
 @method    
 @author      luyuze
 @date        2011-11-26 
 @description 通过ddl查看与父表关联的字表（一对一）
 @param       ddl：建表语句
 @result      返回由字表名和对应ID号
 */
- (NSArray *)getRelationTableAndId:(NSString *)ddl;

/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 模板查询
 @param       

 @result      返回查询结果，数组中每一项为dictionary-》（ID,NAME,SQLITE,FILE_NAME）
 */
-(NSArray *)queryInTemplate;

/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 根据指定的sql语句数据库查询
 @param       
 
 @result      返回查询结果
 */
- (NSArray *)queryWithSQL:(NSString *)SQL;


/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 根据指定的sql语句数据库查询
 @param       
 
 @result      返回查询结果
 */
-(NSArray *)queryWithSqlString:(NSString *)sql;

/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 根据指定的sql语句数据库查询
 @param       
 
 @result      返回查询结果
 */
-(NSArray *)queryWithsql:(NSString *)sql;


/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 获取数据库
 @param       
 
 @result      返回数据库对象
 */
+ (sqlite3 *)getDatabase;

/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 从IPAD_A01_Function表中查询结果
 @param       
 
 @result       返回查询结果，数组中每一项为dictionary-》（DISTINCT A0101,A0102,GetPersonBaseInf,a02_a0215_all_MingCe,FILE）
 */
-(NSArray *)queryWithName:(NSString *)name;


/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 通过限定的那个条件的的sql语句数据库查询
 @param       
 @result      返回查询结果
 */
-(NSArray *)queryWithSearchSQL:(NSString *)searchSQL andNumber:(int)number andLastNumber:(int)lnumber;

/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 通过unitID获取个人信息
 @param       unitID:
 @result      返回查询结果,数组中每一项为dictionary-》（A0101,A0102,a02_a0215_all_MingCe,GetPersonBaseInf,FILE）
 */
-(NSMutableArray *)getPersonsInfo:(NSString *)unitID;

/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 获取数据库
 @param       
 @result      是否清除成功
 */
-(BOOL)clearDataFromDatabase;


/*
 @method    
 @author      sunyu
 @date        2011-11-24 
 @description 通过parentID到IPAD_Analysis_Group_File查询，并获取查询信息
 @param       parentID
 @result      返回查询结果,数组中每一项为dictionary-》（ID,FILE_NAME,ParentID,BaseParentID,Title）
 */
-(NSArray *)queryWithCondition:(int)parentID;  //lijie


@end






















