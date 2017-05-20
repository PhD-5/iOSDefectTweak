%hook NSURLConnection
#define PREFERENCE_PATH @"/private/var/mobile/Library/Preferences/com.softsec.iosdefect.socket.plist"


+ (void)sendAsynchronousRequest:(NSURLRequest*) request
queue:(NSOperationQueue*) queue
completionHandler:(void (^)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError)) handler {
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/URLConnection.html", IPaddress];

    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_url_to]];
    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    %orig(hookUrlRequest,queue,handler);
    %orig;
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/URLConnection.html", IPaddress];

    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_url_to]];
    %orig(hookUrlRequest, response, error);
    return %orig;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/URLConnection.html", IPaddress];

    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_url_to]];
    %orig(hookUrlRequest, delegate);
    return %orig;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/URLConnection.html", IPaddress];

    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_url_to]];
    %orig(hookUrlRequest, delegate, startImmediately);
//    id origResult = %orig(request, delegate, startImmediately);
    return %orig;
}

+(id)connectionWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/URLConnection.html", IPaddress];

    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_url_to]];
    %orig(hookUrlRequest, delegate);
//    id origResult = %orig(request, delegate);
    return %orig;
}

%end
