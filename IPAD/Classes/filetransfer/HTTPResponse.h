#import <Foundation/Foundation.h>


@protocol HTTPResponse

- (UInt64)contentLength;

- (UInt64)offset;
- (void)setOffset:(UInt64)offset;

- (NSData *)readDataOfLength:(unsigned int)length;

@end

@interface HTTPFileResponse : NSObject <HTTPResponse>
{
    //文件路径
	NSString *filePath;
    //文件操作对象
	NSFileHandle *fileHandle;
}
//用路径初始化对象
- (id)initWithFilePath:(NSString *)filePath;
//返回路径
- (NSString *)filePath;

@end

@interface HTTPDataResponse : NSObject <HTTPResponse>
{
	unsigned offset;
	NSData *data;
}
//用NSData初始化对象
- (id)initWithData:(NSData *)data;

@end
