//
//  NSDataMD5Encrypt.m
//  IpadTest
//
//  Created by Lyz on 2011-11-22.
//  Copyright 2011 careers. All rights reserved.
//

#import "NSStringMD5Encrypt.h"


@implementation NSString(MD5)

- (NSString *)md5HashDigest
{
	const char *original = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(original, strlen(original), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
	return [hash lowercaseString];
}

@end

