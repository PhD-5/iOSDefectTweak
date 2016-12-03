%hook NSURLConnection
#define hook_connection_url_to @"https://192.168.2.74/URLConnection.html"

+ (void)sendAsynchronousRequest:(NSURLRequest*) request
queue:(NSOperationQueue*) queue
completionHandler:(void (^)(NSURLResponse* __nullable response, NSData* __nullable data, NSError* __nullable connectionError)) handler {
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_connection_url_to]];
    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    %orig(hookUrlRequest,queue,handler);
    %orig;
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_connection_url_to]];
    %orig(hookUrlRequest, response, error);
    return %orig;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_connection_url_to]];
    %orig(hookUrlRequest, delegate);
    return %orig;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {
    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_connection_url_to]];
    %orig(hookUrlRequest, delegate, startImmediately);
//    id origResult = %orig(request, delegate, startImmediately);
    return %orig;
}

+(id)connectionWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate {
    NSLog(@"ChangeURL NSURLConnectionHook:orig url:%@",[request URL]);
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_connection_url_to]];
    %orig(hookUrlRequest, delegate);
//    id origResult = %orig(request, delegate);
    return %orig;
}

%end
