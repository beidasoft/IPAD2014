//
//  Delete.h
//  IPAD
//
//  Created by  careers on 12-5-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
// Note: You may need to add the CFNetwork Framework to your project
#import <CFNetwork/CFNetwork.h>
#endif


@interface HTTPAuthenticationRequest : NSObject
{
	BOOL isBasic;
	BOOL isDigest;
	
	NSString *base64Credentials;
	//用户名
	NSString *username;    
	NSString *realm;
	NSString *nonce;
    //uri
	NSString *uri;
	NSString *qop;
	NSString *nc;
	NSString *cnonce;
    //回复
	NSString *response;
}
//用请求初始化
- (id)initWithRequest:(CFHTTPMessageRef)request;

- (BOOL)isBasic;
- (BOOL)isDigest;

// Basic
- (NSString *)base64Credentials;

// Digest
// 成员变量getter方法
- (NSString *)username;
- (NSString *)realm;
- (NSString *)nonce;
- (NSString *)uri;
- (NSString *)qop;
- (NSString *)nc;
- (NSString *)cnonce;
- (NSString *)response;

@end
