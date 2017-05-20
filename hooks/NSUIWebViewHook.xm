%hook UIWebView
#define PREFERENCE_PATH @"/private/var/mobile/Library/Preferences/com.softsec.iosdefect.socket.plist"
    
- (void)loadRequest:(NSURLRequest *)request
{
    NSDictionary *prefDic = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    NSString *IPaddress = [prefDic objectForKey:@"MITMIP"];
    NSString *hook_url_to = [[NSString alloc] initWithFormat:@"https://%@/UIWebView.html", IPaddress];

    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_url_to]];
    NSLog(@"ChangeURL NSUIWebViewHook:orig url:%@",[request URL]);
    //重定向URL
    %orig(hookUrlRequest);
    
    
//    调用原来的方法，保证应用的正常运行  
//    2016.12.26 无法恢复之前的访问/无法重定向
//    %orig(request);
//    return;
}

%end
