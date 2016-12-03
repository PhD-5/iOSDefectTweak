#import <substrate.h>
#import <Security/SecureTransport.h>
#import "SocketClass.h"
#import "SSLWriteHook.h"

//static NSString *preferenceFilePath = @"/private/var/mobile/Library/Preferences/com.softsec.iosdefect.plist";
//
//static BOOL getBoolFromPreferences(NSMutableDictionary *preferences, NSString *preferenceValue) {
//    id value = [preferences objectForKey:preferenceValue];
//    if (value == nil) {
//        return YES; // default to YES
//    }
//    return [value boolValue];
//}

//Hook the SSLWrite()
static OSStatus (*original_SSLWrite)(
                         SSLContextRef context, 
                         const void *data, 
                         size_t dataLength, 
                         size_t *processed);

static OSStatus replaced_SSLWrite(SSLContextRef context, 
                                  const void *data, 
                                  size_t dataLength, 
                                  size_t *processed){
    SocketClass *socket = [[SocketClass alloc] init];
    NSString *bundleID = [[NSBundle mainBundle]bundleIdentifier];
//    NSString *appName = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSLog(@"%@ SSLWrite len :%zu",bundleID,dataLength);
    NSData *ocData = [NSData dataWithBytes:data length:dataLength];
    NSString *ocStr = [[NSString alloc] initWithData:ocData encoding:NSUTF8StringEncoding];
//    [socket SendSocket:ocStr];
//    NSLog(@"SSLWrite data:%@",ocStr);
    NSArray *infoArray = [ocStr componentsSeparatedByString:@"\r\n"];
    
    int count = infoArray.count;
    for(int i=0;i<count;i++){
        NSString *info = [infoArray objectAtIndex:i];
        NSLog(@"%@ SSLWrite data:%@",bundleID,info);
        
        
        //判断URL是否是tweak重定向的，并根据路径判断是哪一类
        NSRange range1 = [info rangeOfString:@"/URLConnection.html"];
        if(range1.location != NSNotFound){
            NSLog(@"%@ SSLWrite :NSURLConnection has MITM",bundleID);
            
            [socket SendSocket:@"SSLWrite :NSURLConnection has MITM"];
        }
        
        NSRange range2 = [info rangeOfString:@"/UIWebView.html"];
        if(range2.location != NSNotFound){
            NSLog(@"%@ SSLWrite :UIWebView has MITM",bundleID);
            
            [socket SendSocket:@"SSLWrite :UIWebView has MITM"];
        }
        
        NSRange range3 = [info rangeOfString:@"/URLSession.html"];
        if(range3.location != NSNotFound){
            NSLog(@"%@ SSLWrite :NSURLSession has MITM",bundleID);
            
            [socket SendSocket:@"SSLWrite :NSURLSession has MITM"];
        }
    }
    
    return original_SSLWrite(context,data,dataLength,processed);
}

@implementation SSLWriteHook

+ (void)enableHook{
    NSLog(@"yujianbo: enable ssl hook");
    MSHookFunction((void *) SSLWrite,(void *)  replaced_SSLWrite, (void **) &original_SSLWrite);
}

@end

//%ctor {
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    NSString *appId = [[NSBundle mainBundle] bundleIdentifier];
//    // Load  preferences
//    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:preferenceFilePath];
//    id shouldHook = [preferences objectForKey:appId];
//    if ( (shouldHook == nil) || (! [shouldHook boolValue]) ) {
//        [preferences release];
//        [pool drain];
//        return;
//    }
//    
//    if (getBoolFromPreferences(preferences, @"MITM")) {
//         
//        
//    }
//    
//    [preferences release];
//    [pool drain];
//
//}