#import "Utils.h"
#import "SocketClass.h"

extern SocketClass *gsocket;
//bool hasHook = NO;
%hook NSUserDefaults

- (void)setObject:(id)value forKey:(NSString *)defaultName {
    NSLog(@"yujianbo:%@",[value description]);
    %orig(value,defaultName);
    if(value == nil)
        return;
//    if(hasHook==NO){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:defaultName forKey:@"key"];
        [dict setObject:@"Object" forKey:@"sourceType"];
        [dict setObject:[value description] forKey:@"content"];
        NSString *str = [Utils getJsonStrWithDic:dict andType:@"NSUserDefaults"];
        [gsocket SendSocket:str];
//    }
    return;
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
//    hasHook=YES;
	%orig(value, defaultName);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:defaultName forKey:@"key"];
    [dict setObject:@"Bool" forKey:@"sourceType"];
    [dict setObject:[NSNumber numberWithBool:value] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"NSUserDefaults"];
    [gsocket SendSocket:str];
//    hasHook=NO;
    return;
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName {
//    hasHook=YES;
	%orig(value, defaultName);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:defaultName forKey:@"key"];
    [dict setObject:@"Float" forKey:@"sourceType"];
    [dict setValue:[NSNumber numberWithFloat:value] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"NSUserDefaults"];
    [gsocket SendSocket:str];
//    hasHook=NO;
	return;
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
//    hasHook=YES;
	%orig(value, defaultName);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:defaultName forKey:@"key"];
    [dict setObject:@"Integer" forKey:@"sourceType"];
    [dict setObject:[NSNumber numberWithInteger:value] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"NSUserDefaults"];
    [gsocket SendSocket:str];
//    hasHook=NO;
	return;
}

- (void)setURL:(NSURL *)url forKey:(NSString *)defaultName {
//    hasHook=YES;
	%orig(url, defaultName);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:defaultName forKey:@"key"];
    [dict setObject:@"URL" forKey:@"sourceType"];
    [dict setObject:[url absoluteString] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"NSUserDefaults"];
    [gsocket SendSocket:str];
//    hasHook=NO;
	return;
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName {
//    hasHook=YES;
	%orig(value, defaultName);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:defaultName forKey:@"key"];
    [dict setObject:@"Double" forKey:@"sourceType"];
    [dict setValue:[NSNumber numberWithDouble:value] forKey:@"content"];
    NSString *str = [Utils getJsonStrWithDic:dict andType:@"NSUserDefaults"];
    [gsocket SendSocket:str];
//    hasHook=NO;
	return;
}

%end
