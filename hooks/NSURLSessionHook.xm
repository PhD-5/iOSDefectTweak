%hook NSURLSession
#define PREFERENCE_PATH @"/private/var/mobile/Library/Preferences/com.softsec.iosdefect.socket.plist"

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(id)completionHandler{
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/URLSession.html", IPaddress];

    NSLog(@"ChangeURL NSURLSessionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_url_to]];
    %orig(hookUrlRequest,completionHandler);
    return %orig;
}
- (id)dataTaskWithURL:(NSURL *)url completionHandler:(id)completionHandler{
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/URLSession.html", IPaddress];

    NSLog(@"ChangeURL NSURLSessionHook:orig url:%@",url);
    NSURL *hookUrl = [NSURL URLWithString:hook_url_to];
    %orig(hookUrl,completionHandler);
    return %orig;
}

%end
