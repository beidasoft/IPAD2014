//
//  NSDataMD5Encrypt.h
//  IpadTest
//  Test md5
//  Created by Lyz on 2011-11-22.
//  Copyright 2011 careers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString(MD5)
/*
    @method     
    @author      luyuze
    @date        2011-11-21 
    @description 用分类实现md5对字符串进行加密
    @param       null
    @result      用md5对加密后的字符串
 */
- (NSString *)md5HashDigest;
@end
