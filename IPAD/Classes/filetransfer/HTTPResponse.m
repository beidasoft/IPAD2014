#import "HTTPResponse.h"


@implementation HTTPFileResponse

- (id)initWithFilePath:(NSString *)filePathParam
{
	if(self = [super init])
	{
		filePath = [filePathParam copy];
		fileHandle = [[NSFileHandle fileHandleForReadingAtPath:filePath] retain];
	}
	return self;
}
//对象释放
- (void)dealloc
{
	[filePath release];
	[fileHandle closeFile];
	[fileHandle release];
	[super dealloc];
}
//返回内容的长度
- (UInt64)contentLength
{
	NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
	
	NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
	
	return (UInt64)[fileSize unsignedLongLongValue];
}
//返回偏移量
- (UInt64)offset
{
	return (UInt64)[fileHandle offsetInFile];
}
//设置偏移量
- (void)setOffset:(UInt64)offset
{
	[fileHandle seekToFileOffset:offset];
}
//读取文件内容
- (NSData *)readDataOfLength:(unsigned int)length
{
	return [fileHandle readDataOfLength:length];
}

- (NSString *)filePath
{
	return filePath;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation HTTPDataResponse

- (id)initWithData:(NSData *)dataParam
{
	if(self = [super init])
	{
		offset = 0;
		data = [dataParam retain];
	}
	return self;
}
//对象释放
- (void)dealloc
{
	[data release];
	[super dealloc];
}
//内容的长度
- (UInt64)contentLength
{
	return (UInt64)[data length];
}
//偏移量
- (UInt64)offset
{
	return offset;
}
//设置偏移量
- (void)setOffset:(UInt64)offsetParam
{
	offset = offsetParam;
}
//读取文件内容
- (NSData *)readDataOfLength:(unsigned int)lengthParameter
{
	unsigned int remaining = [data length] - offset;
	unsigned int length = lengthParameter < remaining ? lengthParameter : remaining;
	
	void *bytes = (void *)([data bytes] + offset);
	
	offset += length;
	
	return [NSData dataWithBytesNoCopy:bytes length:length freeWhenDone:NO];
}

@end
