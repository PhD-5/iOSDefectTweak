#import "DelegateProxies.h"
//static NSString *preferenceFilePath = @"/private/var/mobile/Library/Preferences/com.yjb.iostraffic.plist";

%hook UIApplication

- (void)setDelegate: (id)delegate {
    UIApplicationDelegateProxForTraffic *delegateProxy = [[UIApplicationDelegateProxForTraffic alloc] initWithOriginalDelegate:delegate];
    %orig(delegateProxy);
    return;
}
    
%end
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.

//    //注册protocol
//    [NSURLProtocol registerClass:[CustomURLProtocol class]];
//    return %orig;
//}

//- (void)applicationWillTerminate:(UIApplication *)application{
//    SocketClass *socket = [[SocketClass alloc] init];
//    [socket SendSocket:@"DONE"];
//    
//    
//    //make sure the socket message is sent
//    int i = 0;
//    while (i < 100)
//    {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                                 beforeDate:[NSDate distantFuture]];
//        i++;
//    }
//    
//    
//    return %orig;
//}


