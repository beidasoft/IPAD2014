#import <Foundation/Foundation.h>


@interface NSNumber (DDNumber)

//解析nsstring,转换成长整型
+ (BOOL)parseString:(NSString *)str intoSInt64:(SInt64 *)pNum;
//解析nsstring,转换成无符号长整型
+ (BOOL)parseString:(NSString *)str intoUInt64:(UInt64 *)pNum;

//解析nsstring,转换成int
+ (BOOL)parseString:(NSString *)str intoNSInteger:(NSInteger *)pNum;
//解析nsstring,转换成无符号int
+ (BOOL)parseString:(NSString *)str intoNSUInteger:(NSUInteger *)pNum;

@end
