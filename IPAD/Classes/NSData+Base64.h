//
//  NSData+Base64.h
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
	const char *inputBuffer,
	size_t length,
	size_t *outputLength);

char *NewBase64Encode(
	const void *inputBuffer,
	size_t length,
	bool separateLines,
	size_t *outputLength);

@interface NSData (Base64)
/*
 @method     
 @author      luyuze
 @date        2011-11-21 
 @description 从64位编码字符串转换为NSDATA
 @param       64位编码字符串
 @result      64位编码的NSDATA
 */
+ (NSData *)dataFromBase64String:(NSString *)aString;

/*
 @method     
 @author      luyuze
 @date        2011-11-21 
 @description 将传入的data进行64位编码
 @param       
 @result      加密过后的字符串
 */
- (NSString *)base64EncodedString;

// added by Hiroshi Hashiguchi
/*
 @method     
 @author      luyuze
 @date        2011-11-21 
 @description 将字符串进行64位编码
 @param       是否用分割线
 @result      64位编码的字符串
 */
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;

@end
