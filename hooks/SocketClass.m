//
//  SocketClass.m
//  actionlisten
//
//  Created by 梁伟 on 13-12-2.
//
//

#import "SocketClass.h"


#define PREFERENCE_PATH @"/var/mobile/Library/Preferences/SocketServerConfig.plist"

//NSString *gstring ;

@implementation SocketClass



-(void)SendSocket:(NSString *)string_send
{
    
//    NSString *processName = [[NSProcessInfo processInfo] processName];
  
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
//    NSString *isListening = [prefDic objectForKey:@"isListening"];
//    NSLog(@"lw: islistening %@",isListening);
//    if (TRUE)
//    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            NSString *IPaddress = [prefDic objectForKey:@"IP"];
            NSString *IPport = [prefDic objectForKey:@"PORT"];
//            NSString *IPaddress = @"192.168.3.209";
//            NSString *IPport = @"9001";
//            NSLog(@"IPaddress is qwe %@,%@",IPaddress,string_send);
            const char *sendmsg = [string_send UTF8String];
            int sockfd;
            struct sockaddr_in des_addr;
            
            
            sockfd = socket(AF_INET, SOCK_STREAM, 0);//创建socket
                if (sockfd < 0)
                {
                perror("socket error");
                return ;
                }
            
            /* 设置连接目的地址 */
            des_addr.sin_family = AF_INET;
            des_addr.sin_port = htons([IPport intValue]);
            des_addr.sin_addr.s_addr = inet_addr([IPaddress UTF8String]);
            bzero(&(des_addr.sin_zero), 8);
            
            /* 发送连接请求 */
                if (connect(sockfd, (struct sockaddr *)&des_addr, sizeof(struct sockaddr)) < 0)
                {
                perror("connect failed");
                return ;
                }
            
            if (send(sockfd, sendmsg, strlen(sendmsg) + 1, 0) < 0)
                {//发送信息
                printf("send msg failed!");
                
                return ;
                }
            
        close(sockfd);
            
        });
    }
     
//}

 
@end

