//
//  NSDataAESEncrypt.h
//  IpadTest
//
//  Created by sunyu on 2011-11-21 
//  Copyright 2011 careers. All rights reserved.
//
#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>

#define FBENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES256

@interface NSData(AES)

/*
	@method    
	@author       sunyu
	@date         2011-11-21 
	@description  AES解密方法
	@param        keyString：16位密钥字符串；
			      ivString ：32位向量字符串；
	@result       解密后的data；
*/
- (NSData*)decryptWithkey:(NSString *)keyString andIV:(NSString *)ivString;

/*
	@method    
	@author       sunyu
	@date         2011-11-21 
	@description  AES加密方法
	@param        keyString：16位密钥字符串；
			      ivString ：32位向量字符串；
	@result       加密后的data；
 */
- (NSData*)encryptWithkey:(NSString *)keyString andIV:(NSString *)ivString;


@end
