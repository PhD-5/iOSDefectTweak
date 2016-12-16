#import <substrate.h>
#import <CommonCrypto/CommonCryptor.h>
#import "SocketClass.h"
#import "CCCryptHook.h"
#import "Utils.h"

extern SocketClass *gsocket;

static size_t getIVLength(CCAlgorithm alg) {
    switch(alg) {
        case kCCAlgorithmAES128:
            return kCCBlockSizeAES128;
        case kCCAlgorithmDES:
            return kCCBlockSizeDES;
        case kCCAlgorithm3DES:
            return kCCBlockSize3DES;
        case kCCAlgorithmCAST:
            return kCCBlockSizeCAST;
        case kCCAlgorithmRC2:
            return kCCBlockSizeRC2;
        default:
            return 0;
    }
}

static NSString* getOperation(CCOperation op){
    switch (op) {
        case kCCEncrypt:
            return @"Encrypt";
        case kCCDecrypt:
            return @"Decrypt";
        default:
            return @"unknown";
    }
}

static NSString* getAlgName(CCAlgorithm alg){
    switch (alg) {
        case kCCAlgorithmAES128:
            return @"AES128";
        case kCCAlgorithmDES:
            return @"DES";
        case kCCAlgorithm3DES:
            return @"3DES";
        case kCCAlgorithmCAST:
            return @"CAST";
        case kCCAlgorithmRC4:
            return @"RC4";
        case kCCAlgorithmRC2:
            return @"RC2";
        default:
            return @"unknown";
    }
}

static NSString* getOption(CCOptions options){
    switch (options) {
        case 0:
            return @"CBCMode";
        case kCCOptionPKCS7Padding:
            return @"PKCS7Padding | CBCMode";
        case kCCOptionECBMode:
            return @"ECBMode";
        case 3:
            return @"PKCS7Padding | ECBMode";
        default:
            return @"unknown";
    }
}


static CCCryptorStatus (*original_CCCrypt)(
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

static CCCryptorStatus replaced_CCCrypt(
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

    
    ///////////////////////my code socket use string////////////////
    /*
    //get key 
    NSData *keyData = [NSData dataWithBytes:key length:keyLength];
    NSString *keyStr = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding]; 
    //get input 
    NSData *inData = [NSData dataWithBytes:dataIn length:dataInLength];
    NSString *inStr = [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
    if(inStr == nil){
        inStr = @"";
    }
    //get iv
    NSString *ivStr;
    if(iv == nil)
        ivStr = @"";
    else{
        NSData *ivData = [NSData dataWithBytes:iv length:(unsigned int)getIVLength(alg)];
        ivStr = [[NSString alloc] initWithData:ivData encoding:NSUTF8StringEncoding];
    }
    //call orig
    CCCryptorStatus result = original_CCCrypt(op,alg,options,key,keyLength,iv,dataIn,dataInLength,dataOut,dataOutAvailable,dataOutMoved);
    //get output
    NSData *outData = [NSData dataWithBytes:dataOut length:(NSUInteger)*dataOutMoved];
    NSString *outStr = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    if(outStr==nil){
        outStr = @"";
    }
    //set socket data
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    [mDict setObject:@"CCCrypt" forKey:@"function"];
    [mDict setObject:[NSNumber numberWithInt:op] forKey:@"op"];
    [mDict setObject:[NSNumber numberWithInt:alg] forKey:@"alg"];
    [mDict setObject:[NSNumber numberWithInt:options] forKey:@"options"];
    [mDict setObject:keyStr forKey:@"key"];
    [mDict setObject:ivStr forKey:@"iv"];
    [mDict setObject:inStr forKey:@"inputData"];
    [mDict setObject:outStr forKey:@"outputData"];
    */
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    [mDict setValue:@"CCCrypt" forKey:@"function"];
//    if(op==0){ //encrypt
        [mDict setValue:getOperation(op) forKey:@"op"];
        [mDict setValue:getAlgName(alg) forKey:@"alg"];
        [mDict setValue:getOption(options) forKey:@"options"];
        
        //get key
        NSData *keyData = [Utils convertCBuffer:key withLength:keyLength];
        [mDict setValue:[[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding] forKey:@"key"];
        
        //get iv
        NSData *ivData = [Utils convertCBuffer:iv withLength:getIVLength(alg)];
        [mDict setValue:[[NSString alloc] initWithData:ivData encoding:NSUTF8StringEncoding] forKey:@"iv"];
        
        //get input data
//        NSData *inputData = [Utils convertCBuffer:dataIn withLength:dataInLength];
//        [mDict setValue:[[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding] forKey:@"inputData"];
        
        //socket send
//        SocketClass *socket = [[SocketClass alloc] init];
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:mDict options:0 error:nil];  
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; 
        [gsocket SendSocket:myString];
//    }
    
    
    
    //call orig
    CCCryptorStatus result = original_CCCrypt(op,alg,options,key,keyLength,iv,dataIn,dataInLength,dataOut,dataOutAvailable,dataOutMoved);
//    [mDict setValue:[Utils convertCBuffer:dataOut withLength:*dataOutMoved] forKey:@"outputData"];
//    [mDict setValue:[NSNumber numberWithInt:dataOutAvailable] forKey:@"dataOutAvailable"];
    
    
//    if(![inStr isEqualToString:@"null"] && ![outStr isEqualToString:@"null"]){ 
//    NSError *error;
//    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)mDict
//                                                               format:NSPropertyListXMLFormat_v1_0 
//                                                              options:0
//                                                                error:&error];
//    NSString *plistStr = [[NSString alloc] initWithData:plist encoding:NSASCIIStringEncoding];
    
//    NSLog(@"yujianbo-----%@",myString);
//    [mDict release];
//    [myString release];
//    [socket release];
//    }
    return result;
}

@implementation CCCryptHook

+ (void)enableHook{
    MSHookFunction((void *) CCCrypt,(void *)  replaced_CCCrypt, (void **) &original_CCCrypt);  
}

@end
