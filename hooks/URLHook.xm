#import "DelegateProxies.h"
//static NSString *preferenceFilePath = @"/private/var/mobile/Library/Preferences/com.yjb.iostraffic.plist";

%hook UIApplication

- (void)setDelegate: (id)delegate {
    UIApplicationDelegateProxForURL *delegateProxy = [[UIApplicationDelegateProxForURL alloc] initWithOriginalDelegate:delegate];
    %orig(delegateProxy);
    return;
}
    
%end

