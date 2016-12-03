%hook NSURLSession
#define hook_session_url_to @"https://192.168.2.74/URLSession.html"

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(id)completionHandler{
    NSLog(@"ChangeURL NSURLSessionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_session_url_to]];
    %orig(hookUrlRequest,completionHandler);
    return %orig;
}
- (id)dataTaskWithURL:(NSURL *)url completionHandler:(id)completionHandler{
    NSLog(@"ChangeURL NSURLSessionHook:orig url:%@",url);
    NSURL *hookUrl = [NSURL URLWithString:hook_session_url_to];
    %orig(hookUrl,completionHandler);
    return %orig;
}

%end
