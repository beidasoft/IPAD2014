//
//  NSDataAESEncrypt.m
//  IpadTest
//
//  Created by Sun Yu 11-11-12.
//  Copyright 2011 careers. All rights reserved.
//


#import "NSDataAESEncrypt.h"

@implementation NSData (AES)



/*
    @history
    1.~~~~~~
*/

- (NSData*)decryptWithkey:(NSString *)keyString andIV:(NSString *)ivString
{
    NSData *result = nil;
	NSData *key = [keyString dataUsingEncoding:4];
	NSData *iv  = [ivString  dataUsingEncoding:4];
	
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
	bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
	
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
	size_t bufferSize = [self length] + FBENCRYPT_BLOCK_SIZE;
	void *buffer = malloc(bufferSize);
	
    // do decrypt
	size_t decryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
										  cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [self bytes],
                                          [self length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
	
	if (cryptStatus == kCCSuccess) {
		result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
	} else {
        free(buffer);
        NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }
	
	return result;
}

- (NSData*)encryptWithkey:(NSString *)keyString andIV:(NSString *)ivString
{
    NSData* result = nil;
	
	NSData *key = [keyString dataUsingEncoding:4];
	NSData *iv  = [ivString  dataUsingEncoding:4];
	
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
	bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
	
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
	size_t bufferSize = [self length] + FBENCRYPT_BLOCK_SIZE;
	void *buffer = malloc(bufferSize);
	
    // do encrypt
	size_t encryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [self bytes],
                                          [self length],
                                          buffer,
                                          bufferSize,
										  &encryptedSize);
	if (cryptStatus == kCCSuccess) {
		result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
	} else {
        free(buffer);
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
	
	return result;
}




@end
