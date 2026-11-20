#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <dlfcn.h>

typedef void (*MSHookMessageExFunc)(Class _class, SEL message, IMP hook, IMP *old);

static void hookMethod(Class cls, SEL sel, IMP replacement, IMP *orig) {
    static MSHookMessageExFunc hookFunc = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/usr/lib/libsubstrate.dylib", RTLD_LAZY);
        if (!handle) {
            handle = dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY);
        }
        if (!handle) {
            handle = dlopen("@rpath/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY);
        }
        if (handle) {
            hookFunc = (MSHookMessageExFunc)dlsym(handle, "MSHookMessageEx");
        }
    });

    if (hookFunc && cls && sel) {
        hookFunc(cls, sel, replacement, orig);
    }
}

static void openTelegramURL(NSString *urlString) {
    Class appClass = NSClassFromString(@"UIApplication");
    Class urlClass = NSClassFromString(@"NSURL");
    if (!appClass || !urlClass) return;

    id sharedApp = ((id (*)(id, SEL))objc_msgSend)(appClass, NSSelectorFromString(@"sharedApplication"));
    if (!sharedApp) return;

    id url = ((id (*)(id, SEL, NSString *))objc_msgSend)(urlClass, NSSelectorFromString(@"URLWithString:"), urlString);
    if (!url) return;

    BOOL canOpen = ((BOOL (*)(id, SEL, id))objc_msgSend)(sharedApp, NSSelectorFromString(@"canOpenURL:"), url);
    if (!canOpen) return;

    ((void (*)(id, SEL, id, NSDictionary *, id))objc_msgSend)(
        sharedApp,
        NSSelectorFromString(@"openURL:options:completionHandler:"),
        url,
        @{},
        nil
    );
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

static IMP orig_setDelegate = NULL;

static void replaced_setDelegate(id self, SEL _cmd, id delegate) {
    if (orig_setDelegate) {
        ((void (*)(id, SEL, id))orig_setDelegate)(self, _cmd, delegate);
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        checkSubscriptionAndRedirect();
    });
}

__attribute__((constructor))
static void initMod(void) {
    Class appClass = NSClassFromString(@"UIApplication");
    if (appClass) {
        hookMethod(appClass, @selector(setDelegate:), (IMP)replaced_setDelegate, &orig_setDelegate);
    }

    Class notifCenterClass = NSClassFromString(@"NSNotificationCenter");
    if (!notifCenterClass) return;

    id center = ((id (*)(id, SEL))objc_msgSend)(notifCenterClass, NSSelectorFromString(@"defaultCenter"));
    if (!center) return;

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
        NSSelectorFromString(@"addObserverForName:object:queue:usingBlock:"),
        @"UIApplicationDidBecomeActiveNotification",
        nil,
        nil,
        block
    );
}
