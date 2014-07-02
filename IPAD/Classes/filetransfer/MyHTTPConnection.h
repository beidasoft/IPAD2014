//
//  This class was created by Nonnus, multi select by Colin
//  who graciously decided to share it with the CocoaHTTPServer community.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"


@interface MyHTTPConnection : HTTPConnection
{
    //文件开始索引
	int dataStartIndex;
	NSMutableArray* multipartData;
	NSData *mykey;    
	NSString *currentRoot;
    //文件数量
	int filecount;
	BOOL redflag; 
    // separator was truncated at end of chunk.
}

@property(nonatomic, retain) NSString *currentRoot;
/**
 * Returns whether or not the requested resource is browseable.
 **/
- (BOOL)isBrowseable:(NSString *)path;
/*
  This method creates a html browseable page.
  Customize to fit your needs
*/
- (NSString *)createBrowseableIndex:(NSString *)path;

@end
