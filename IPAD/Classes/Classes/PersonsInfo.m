//
//  PersonsInfo.m
//  IpadTest
//
//  Created by yang on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonsInfo.h"


@implementation PersonsInfo
@synthesize name,namePinyin,detailInfo,detailInfos,image,personID;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if(self=[super init])
	{
	    namePinyin = [[dictionary allKeys] objectAtIndex:0];
	    name = [[dictionary allValues] objectAtIndex:0];
	}
	return self;
}

//初始化PersonsInfo对象
- (id)initWithData:(NSMutableString*)_name
			PinYIn:(NSMutableString*)_namePinyin
        detailInfo:(NSMutableString*)_detailInfo
       detailInfos:(NSMutableString*)_detailInfos
             image:(NSMutableString*)_image
		        ID:(NSMutableString*)_ID
{
	if(self=[super init])
	{
	    namePinyin = _namePinyin;
	    name = _name;
		detailInfo = _detailInfo;
		detailInfos = _detailInfos;
		image = _image;
		personID = _ID;
	}
	return self;
}

//对象释放
- (void)dealloc {
	[namePinyin release];
	[name release];
	[detailInfo release];
	[detailInfos release];
	[image release];
	[personID release];
	[super dealloc];
}
@end
