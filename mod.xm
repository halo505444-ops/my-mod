#import <Foundation/Foundation.h>
#import <objc/message.h>

static void openTelegramURL(NSString *urlString) {
    Class appClass = NSClassFromString(@"UIApplication");
    Class urlClass = NSClassFromString(@"NSURL");
    if (!appClass || !urlClass) return;

    SEL sharedAppSel = NSSelectorFromString(@"sharedApplication");
    id sharedApp = ((id (*)(id, SEL))objc_msgSend)(appClass, sharedAppSel);
    if (!sharedApp) return;

    SEL urlWithStrSel = NSSelectorFromString(@"URLWithString:");
    id url = ((id (*)(id, SEL, NSString *))objc_msgSend)(urlClass, urlWithStrSel, urlString);
    if (!url) return;

    SEL canOpenSel = NSSelectorFromString(@"canOpenURL:");
    BOOL canOpen = ((BOOL (*)(id, SEL, id))objc_msgSend)(sharedApp, canOpenSel, url);
    if (!canOpen) return;

    SEL openUrlSel = NSSelectorFromString(@"openURL:options:completionHandler:");
    ((void (*)(id, SEL, id, NSDictionary *, id))objc_msgSend)(sharedApp, openUrlSel, url, @{}, nil);
}

static void checkSubscriptionAndRedirect(void) {
    NSDate *currentDate = [NSDate date];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    // بەرواری دەستپێک: 2026-11-20
    NSDate *oneMonthDate = [formatter dateFromString:@"2026-12-20 00:00:00"];
    NSDate *threeMonthsDate = [formatter dateFromString:@"2027-02-20 00:00:00"];

    // دوای ٣ مانگ: ڕاگرتنی تەواوی بەرنامە
    if ([currentDate compare:threeMonthsDate] != NSOrderedAscending) {
        exit(0);
    }
    // دوای ١ مانگ تا ٣ مانگ: چوونە ناو @Mama_Hala0
    else if ([currentDate compare:oneMonthDate] != NSOrderedAscending) {
        openTelegramURL(@"https://t.me/Mama_Hala0");
    }
    // مانگی یەکەم: چوونە ناو چەناڵی shaz4vip
    else {
        openTelegramURL(@"https://t.me/shaz4vip");
    }
}

%hook UIApplication

- (void)setDelegate:(id)delegate {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        checkSubscriptionAndRedirect();
    });
}

%end

%ctor {
    Class notifCenterClass = NSClassFromString(@"NSNotificationCenter");
    if (!notifCenterClass) return;

    SEL defCenterSel = NSSelectorFromString(@"defaultCenter");
    id center = ((id (*)(id, SEL))objc_msgSend)(notifCenterClass, defCenterSel);

    SEL addObsSel = NSSelectorFromString(@"addObserverForName:object:queue:usingBlock:");
    void (^block)(NSNotification *) = ^(NSNotification * _Nonnull note) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                checkSubscriptionAndRedirect();
            });
        });
    };

    ((id (*)(id, SEL, NSString *, id, id, id))objc_msgSend)(
        center,
        addObsSel,
        @"UIApplicationDidBecomeActiveNotification",
        nil,
        nil,
        block
    );
}
