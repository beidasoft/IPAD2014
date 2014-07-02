//
//  PersonsInfo.h
//  IpadTest
//
//  Created by yang on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersonsInfo : NSObject 
{
    NSMutableString *name;
	NSMutableString *namePinyin;
	NSMutableString *detailInfo;
	NSMutableString *detailInfos;
	NSMutableString *image;
	NSMutableString *personID;
	
}
@property(nonatomic,retain)NSMutableString *name;
@property(nonatomic,retain)NSMutableString *namePinyin;
@property(nonatomic,retain)NSMutableString *detailInfo;
@property(nonatomic,retain)NSMutableString *detailInfos;
@property(nonatomic,retain)NSMutableString *image;
@property(nonatomic,retain)NSMutableString *personID;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 初始化PersonsInfo对象
    @param       dictionary
    @result      
*/
-(id)initWithDictionary:(NSDictionary *)dictionary;
/*
    @method     
    @author      weijuanmin
    @date        2012-12-19 
    @description 初始化PersonsInfo对象
    @param       _name，_namePinyin，_detailInfo，_detailInfos，_image，_ID
    @result      PersonsInfo对象
*/
- (id)initWithData:(NSMutableString*)_name
			PinYIn:(NSMutableString*)_namePinyin
        detailInfo:(NSMutableString*)_detailInfo
       detailInfos:(NSMutableString*)_detailInfos
             image:(NSMutableString*)_image
		        ID:(NSMutableString*)_ID;
@end
