%hook UIWebView
#define hook_uiwebview_url_to @"https://192.168.2.74/UIWebView.html"
    
- (void)loadRequest:(NSURLRequest *)request
{
    NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hook_uiwebview_url_to]];
    NSLog(@"ChangeURL NSUIWebViewHook:orig url:%@",[request URL]);
    //重定向URL
    %orig(hookUrlRequest);
    
    
    //调用原来的方法，保证应用的正常运行
    //%orig;
}

%end