#import "Utils.h"
#import "SocketClass.h"

extern SocketClass *gsocket;


//-----------------------------------NSDictionary-----------------------------------//
%hook NSDictionary 
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:path forKey:@"filepath"];
    [dict setObject:@"NSDictionary" forKey:@"sourceType"];
    [dict setObject:[self description] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
    [gsocket SendSocket:str];
    BOOL result = %orig;
    return result;
}

- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:url forKey:@"url"];
    [dict setObject:@"NSDictionary" forKey:@"sourceType"];
    [dict setObject:[self description] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
    [gsocket SendSocket:str];
    BOOL result = %orig;
    return result;
}

%end 

//-----------------------------------NSArray-----------------------------------//
%hook NSArray
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:path forKey:@"filepath"];
    [dict setObject:@"NSArray" forKey:@"sourceType"];
    [dict setObject:[self description] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
    [gsocket SendSocket:str];
    BOOL result = %orig;
    return result;
}
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:url forKey:@"url"];
    [dict setObject:@"NSArray" forKey:@"sourceType"];
    [dict setObject:[self description] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
    [gsocket SendSocket:str];
    BOOL result = %orig;
    return result;
}
%end

//-----------------------------------NSData-----------------------------------//
%hook NSData
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:path forKey:@"filepath"];
    NSString *dataStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if(dataStr!=nil){
        [dict setObject:dataStr forKey:@"content"];
        [dict setObject:@"NSData" forKey:@"sourceType"];
        NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
        [gsocket SendSocket:str]; 
    }
    
    BOOL result = %orig;
    return result;
}
- (BOOL)writeToFile:(NSString *)path 
options:(NSDataWritingOptions)writeOptionsMask 
error:(NSError * _Nullable *)errorPtr{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:path forKey:@"filepath"];
    NSString *dataStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if(dataStr!=nil){
        [dict setObject:dataStr forKey:@"content"];
        [dict setObject:@"NSData" forKey:@"sourceType"];
        NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
        [gsocket SendSocket:str];
    }
    [dict setObject:dataStr forKey:@"NSData"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
    [gsocket SendSocket:str];
    
    BOOL result = %orig;
    return result;
}
- (BOOL)writeToURL:(NSURL *)url 
atomically:(BOOL)atomically
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:url forKey:@"url"];
    NSString *dataStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if(dataStr!=nil){
        [dict setObject:dataStr forKey:@"content"];
        [dict setObject:@"NSData" forKey:@"sourceType"];
        NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
        [gsocket SendSocket:str];
    }
    
    BOOL result = %orig;
    return result;
}
- (BOOL)writeToURL:(NSURL *)url 
options:(NSDataWritingOptions)writeOptionsMask 
error:(NSError * _Nullable *)errorPtr{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:url forKey:@"url"];
    NSString *dataStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if(dataStr!=nil){
        [dict setObject:dataStr forKey:@"content"];
        [dict setObject:@"NSData" forKey:@"sourceType"];
        NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
        [gsocket SendSocket:str];
    }
    
    BOOL result = %orig;
    return result;
}
%end

//-----------------------------------NSString-----------------------------------//
%hook NSString
- (BOOL)writeToFile:(NSString *)path 
atomically:(BOOL)useAuxiliaryFile 
encoding:(NSStringEncoding)enc 
error:(NSError * _Nullable *)error{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:path forKey:@"filepath"];
    [dict setObject:@"NSString" forKey:@"sourceType"];
    [dict setObject:self forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
    [gsocket SendSocket:str];
    BOOL result = %orig;
    return result;
}

- (BOOL)writeToURL:(NSURL *)url 
atomically:(BOOL)useAuxiliaryFile 
encoding:(NSStringEncoding)enc 
error:(NSError * _Nullable *)error{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:url forKey:@"url"];
    [dict setObject:@"NSString" forKey:@"sourceType"];
    [dict setObject:self forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"Plist"];
    [gsocket SendSocket:str];
    BOOL result = %orig;
    return result;
}
%end










