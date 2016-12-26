#import "DelegateProxies.h"
#import "Utils.h"
#import "SocketClass.h"
#import "CustomURLProtocol.h"


// Nice global
extern SocketClass *gsocket;


@implementation GenericDelegateProx


@synthesize originalDelegate;


- (id) initWithOriginalDelegate:(id)origDeleg {
    self = [super init];

    if (self) { // Store original delegate
        [self setOriginalDelegate:(origDeleg)];
    }
    return self;
}


- (BOOL)respondsToSelector:(SEL)aSelector {
    return [originalDelegate respondsToSelector:aSelector];
}


- (id)forwardingTargetForSelector:(SEL)sel {
    return originalDelegate;
}


- (void)dealloc {
    [originalDelegate release];
    [super dealloc];
}
@end


@implementation UIApplicationDelegateProxForURL

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        BOOL origResult = [originalDelegate application:application handleOpenURL:url];
    
    //get url info
    NSDictionary * urlDict = [Utils convertURL: url];
   
    NSString * urlStr = [Utils getJsonStrWithDic:urlDict andType:@"URLScheme"];
    [gsocket SendSocket:urlStr];

    
    return origResult;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL origResult = [originalDelegate application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    //get url info
    NSDictionary * urlDict = [Utils convertURL: url];
    NSString * urlStr = [Utils getJsonStrWithDic:urlDict andType:@"URLScheme"];
    [gsocket SendSocket:urlStr];
    
    return origResult;
}

- (void)applicationWillTerminate:(UIApplication *)application{
    
    
    [gsocket SendSocket:@"DONE"];
    //make sure the socket message is sent
    int i = 0;
    while (i < 100)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
        i++;
    }
    
    [originalDelegate applicationWillTerminate:application];
    
    return;
}

@end

@implementation UIApplicationDelegateProxForTraffic

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [NSURLProtocol registerClass:[CustomURLProtocol class]];
    BOOL origResult = [originalDelegate application: application didFinishLaunchingWithOptions:launchOptions];
    return origResult;
}

@end


//@implementation NSURLConnectionDelegateProx
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
//    id origResult = [originalDelegate connection:connection willCacheResponse:cachedResponse];
//    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:willCacheResponse:"];
//    [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) connection] withKey:@"connection"];
//    [tracer addArgFromPlistObject:[PlistObjectConverter convertNSCachedURLResponse: cachedResponse] withKey:@"cachedResponse"];
//    [tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSCachedURLResponse:origResult]];
//    [traceStorage saveTracedCall:tracer];
//    [tracer release];
//    return origResult;
//}
//
//
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
//    id origResult = [originalDelegate connection:connection willSendRequest:request redirectResponse:redirectResponse];
//    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSURLConnectionDelegate" andMethod:@"connection:willSendRequest:redirectResponse:"];
//    [tracer addArgFromPlistObject:[NSNumber numberWithUnsignedInt: (unsigned int) connection] withKey:@"connection"];
//    [tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLRequest:request] withKey:@"request"];
//    [tracer addArgFromPlistObject:[PlistObjectConverter convertNSURLResponse:redirectResponse] withKey:@"redirectResponse"];
//    [tracer addReturnValueFromPlistObject: [PlistObjectConverter convertNSURLRequest:origResult]];
//    [traceStorage saveTracedCall:tracer];
//    [tracer release];
//    return origResult;
//}
//
//@end
