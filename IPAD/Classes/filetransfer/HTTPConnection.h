#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
// Note: You may need to add the CFNetwork Framework to your project
#import <CFNetwork/CFNetwork.h>
#endif

@class AsyncSocket;
@class HTTPServer;
@protocol HTTPResponse;


#define HTTPConnectionDidDieNotification  @"HTTPConnectionDidDie"

@interface HTTPConnection : NSObject
{
    //socekt类
	AsyncSocket *asyncSocket;
	//http服务器
    HTTPServer *server;
	//http请求
	CFHTTPMessageRef request;
    //头行的数量
	int numHeaderLines;
	
	NSString *nonce;
	int lastNC;
	//http的回复
	NSObject<HTTPResponse> *httpResponse;
	
	NSMutableArray *ranges;
	NSMutableArray *ranges_headers;
	NSString *ranges_boundry;
	int rangeIndex;
	
	UInt64 postContentLength;
	UInt64 postTotalBytesReceived;
}
//用socket，服务器初始化http连接
- (id)initWithAsyncSocket:(AsyncSocket *)newSocket forServer:(HTTPServer *)myServer;
//判断是否支持此路径
- (BOOL)supportsPOST:(NSString *)path withSize:(UInt64)contentLength;
//判断服务器是否安全
- (BOOL)isSecureServer;
- (NSArray *)sslIdentityAndCertificates;
//是否密码保护
- (BOOL)isPasswordProtected:(NSString *)path;
- (BOOL)useDigestAccessAuthentication;
//返回用户名
- (NSString *)realm;
//返回某用户名的密码
- (NSString *)passwordForUser:(NSString *)username;

- (NSString *)filePathForURI:(NSString *)path;
- (NSObject<HTTPResponse> *)httpResponseForURI:(NSString *)path;
- (void)processPostDataChunk:(NSData *)postDataChunk;

//处理“某版本不支持情况”
- (void)handleVersionNotSupported:(NSString *)version;
//处理认证失败
- (void)handleAuthenticationFailed;
//处理“资源未找到情况”
- (void)handleResourceNotFound;
//处理不合法请求
- (void)handleInvalidRequest:(NSData *)data;
//处理未知方法
- (void)handleUnknownMethod:(NSString *)method;
//处理http的回复
- (NSData *)preprocessResponse:(CFHTTPMessageRef)response;
//处理http失败的回复
- (NSData *)preprocessErrorResponse:(CFHTTPMessageRef)response;

- (void)die;

@end
