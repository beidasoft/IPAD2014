#import <Foundation/Foundation.h>

@class AsyncSocket;


@interface HTTPServer : NSObject <NSNetServiceDelegate>
{
	// Underlying asynchronous TCP/IP socket
	AsyncSocket *asyncSocket;
	
	// Standard delegate
	id delegate;
	
	// HTTP server configuration
	NSURL *documentRoot;
	Class connectionClass;
	
	// NSNetService and related variables
	NSNetService *netService;
    //域名
	NSString *domain;
    //类型
	NSString *type;
    //名字
	NSString *name;
    //端口
	UInt16 port;
	NSDictionary *txtRecordDictionary;
	
	NSMutableArray *connections;
}
//返回代理类
- (id)delegate;
//设置代理类
- (void)setDelegate:(id)newDelegate;

//根目录的url
- (NSURL *)documentRoot;
//设置根目录的url
- (void)setDocumentRoot:(NSURL *)value;

//返回连接类
- (Class)connectionClass;
//设置连接类
- (void)setConnectionClass:(Class)value;

//返回域名
- (NSString *)domain;
- (void)setDomain:(NSString *)value;

//返回类型
- (NSString *)type;
//设置类型
- (void)setType:(NSString *)value;

//返回名字
- (NSString *)name;
//返回公共名字
- (NSString *)publishedName;
//设置名字
- (void)setName:(NSString *)value;

//返回端口号
- (UInt16)port;
//设置端口号
- (void)setPort:(UInt16)value;

- (NSDictionary *)TXTRecordDictionary;
- (void)setTXTRecordDictionary:(NSDictionary *)dict;

//启动服务
- (BOOL)start:(NSError **)error;
//停止服务
- (BOOL)stop;

- (uint)numberOfHTTPConnections;

@end
