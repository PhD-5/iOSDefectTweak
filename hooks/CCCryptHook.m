#import <substrate.h>
#import <CommonCrypto/CommonCryptor.h>
#import "SocketClass.h"
#import "CCCryptHook.h"


//static NSString *preferenceFilePath = @"/private/var/mobile/Library/Preferences/com.softsec.iosdefect.plist";
//
//static BOOL getBoolFromPreferences(NSMutableDictionary *preferences, NSString *preferenceValue) {
//    id value = [preferences objectForKey:preferenceValue];
//    if (value == nil) {
//        return YES; // default to YES
//    }
//    return [value boolValue];
//}

CCCryptorStatus (*original_CCCrypt)(
                        CCOperation op,         /* kCCEncrypt, etc. */
                        CCAlgorithm alg,        /* kCCAlgorithmAES128, etc. */
                        CCOptions options,      /* kCCOptionPKCS7Padding, etc. */
                        const void *key,
                        size_t keyLength,
                        const void *iv,         /* optional initialization vector */
                        const void *dataIn,     /* optional per op and alg */
                        size_t dataInLength,
                        void *dataOut,          /* data RETURNED here */
                        size_t dataOutAvailable,
                        size_t *dataOutMoved);

CCCryptorStatus replaced_CCCrypt(
                                 CCOperation op,         /* kCCEncrypt, etc. */
                                 CCAlgorithm alg,        /* kCCAlgorithmAES128, etc. */
                                 CCOptions options,      /* kCCOptionPKCS7Padding, etc. */
                                 const void *key,
                                 size_t keyLength,
                                 const void *iv,         /* optional initialization vector */
                                 const void *dataIn,     /* optional per op and alg */
                                 size_t dataInLength,
                                 void *dataOut,          /* data RETURNED here */
                                 size_t dataOutAvailable,
                                 size_t *dataOutMoved)
{
    SocketClass *socket = [[SocketClass alloc] init];

    // parse key datain and dataout
    /*
    NSData *keyData = [NSData dataWithBytes:key length:keyLength];
    NSString *keyStr = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding]; 
    
    NSData *datainData = [NSData dataWithBytes:dataIn length:dataInLength];
    NSString *datainStr = [[NSString alloc] initWithData:datainData encoding:NSUTF8StringEncoding];
    
    CCCryptorStatus result = original_CCCrypt(op,alg,options,key,keyLength,iv,dataIn,dataInLength,dataOut,dataOutAvailable,dataOutMoved);
    
    NSData *dataoutData = [NSData dataWithBytes:dataOut length:dataOutAvailable];
    NSString *dataoutStr = [[NSString alloc] initWithData:dataoutData encoding:NSUTF8StringEncoding];
    
    NSString *string = [[NSString alloc] initWithFormat:@"op:%u alg:%u key:%@ inlen:%lu outlen:%lu datain:%@ dataout:%@ return:%d",
                        op,alg,keyStr,dataInLength,dataOutAvailable,datainStr,dataoutStr,result];
    [socket SendSocket:string];
     */
    NSData *keyData = [NSData dataWithBytes:key length:keyLength];
    NSString *keyStr = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding]; 
    
    NSData *inData = [NSData dataWithBytes:dataIn length:dataInLength];
    NSString *inStr = [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
    if(inStr == nil){
        inStr = @"null";
    }
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    [mDict setObject:@"CCCrypt" forKey:@"function"];
    [mDict setObject:[NSNumber numberWithInt:op] forKey:@"op"];
    [mDict setObject:[NSNumber numberWithInt:alg] forKey:@"alg"];
    [mDict setObject:[NSNumber numberWithInt:options] forKey:@"options"];
    [mDict setObject:keyStr forKey:@"key"];
    [mDict setObject:inStr forKey:@"inputData"];
    
    CCCryptorStatus result = original_CCCrypt(op,alg,options,key,keyLength,iv,dataIn,dataInLength,dataOut,dataOutAvailable,dataOutMoved);
    
    NSData *outData = [NSData dataWithBytes:dataOut length:dataOutAvailable];
    NSString *outStr = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    if(outStr==nil){
        outStr = @"null";
    }
    
    [mDict setObject:outStr forKey:@"outputData"];
    
//    if(![inStr isEqualToString:@"null"] && ![outStr isEqualToString:@"null"]){ 
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:mDict options:0 error:nil];  
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; 
        [socket SendSocket:myString];
//    }
    return result;
}

@implementation CCCryptHook

+ (void)enableHook{
//    NSLog(@"yujianbo: Start hook cccrypt");
    MSHookFunction((void *) CCCrypt,(void *)  replaced_CCCrypt, (void **) &original_CCCrypt);  
}

@end

//%ctor {NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
//    }
//    
//    [preferences release];
//    [pool drain];
//
//}