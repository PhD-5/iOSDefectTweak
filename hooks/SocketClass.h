//
//  SocketClass.h
//  actionlisten
//
//  Created by 梁伟 on 13-12-2.
//
//

#import <Foundation/Foundation.h>


#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface SocketClass : NSObject

-(void)SendSocket:(NSString *)data;
@end
