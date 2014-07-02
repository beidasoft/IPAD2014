#import <Foundation/Foundation.h>

@interface NSData (DDData)
//md5加密
- (NSData *)md5Digest;

- (NSData *)sha1Digest;
- (NSString *)hexStringValue;
//base64码加密
- (NSString *)base64Encoded;
//base64码解密
- (NSData *)base64Decoded;

@end
