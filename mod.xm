#import <UIKit/UIKit.h>

static void openTelegramLink() {
    NSURL *url = [NSURL URLWithString:@"https://t.me/Mama_Hala0"];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [app openURL:url options:@{} completionHandler:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [app openURL:url];
#pragma clang diagnostic pop
    }
}

static UIWindow *globalModWindow = nil;
static UIView *globalBlackScreen = nil;
static UITextField *globalKeyField = nil;
static NSString *currentSelectedLanguage = @"ku";
static void verifyKeyOnSupabase(NSString *enteredKey);
static void showKeyInputUI(NSString *language, CGRect screenBounds);

@interface MamaHalaHelper : NSObject
+ (instancetype)sharedInstance;
- (void)dismissKeyboard;
- (void)pasteKey;
- (void)loginAction;
- (void)telegramAction;
- (void)langButtonTapped:(UIButton *)sender;
@end

@implementation MamaHalaHelper
+ (instancetype)sharedInstance {
    static MamaHalaHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MamaHalaHelper alloc] init];
    });
    return instance;
}

- (void)dismissKeyboard {
    if (globalKeyField) {
        [globalKeyField resignFirstResponder];
    }
}

- (void)pasteKey {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string && globalKeyField) {
        globalKeyField.text = [pasteboard.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

- (void)loginAction {
    if (globalKeyField) {
        [globalKeyField resignFirstResponder];
        NSString *cleanedKey = [globalKeyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([currentSelectedLanguage isEqualToString:@"ar"]) {
            globalKeyField.placeholder = @"🔄 جاري الاتصال بالخادم...";
        } else if ([currentSelectedLanguage isEqualToString:@"ur"]) {
            globalKeyField.placeholder = @"🔄 سرور سے সংযোগ ہو رہا ہے...";
        } else if ([currentSelectedLanguage isEqualToString:@"ku"]) {
            globalKeyField.placeholder = @"🔄 پەیوەندی بە سەვەرەوە دەکرێت...";
        } else {
            globalKeyField.placeholder = @"🔄 Connecting Server...";
        }
        
        verifyKeyOnSupabase(cleanedKey);
    }
}

- (void)telegramAction {
    openTelegramLink();
}

- (void)langButtonTapped:(UIButton *)sender {
    NSArray *codes = @[@"ku", @"ar", @"en", @"ur"];
    NSInteger tag = sender.tag;
    currentSelectedLanguage = (tag >= 0 && tag < codes.count) ? codes[tag] : @"ku";
    
    UIView *rootView = globalModWindow.rootViewController.view;
    [rootView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    showKeyInputUI(currentSelectedLanguage, globalModWindow.bounds);
}
@end

static void showMovingBypassText(UIWindow *targetWindow, NSString *language) {
    if (!targetWindow) return;
    
    CGRect screenBounds = targetWindow.bounds;
    
    // قەبارەی بایپاس بچووککراوە و ڕێکخراوە
    UILabel *bypassLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, 110, 30)];
    
    NSString *bypassText = @"BYPASS 🟢";
    if ([language isEqualToString:@"ar"]) {
        bypassText = @"تخطي 🟢";
    } else if ([language isEqualToString:@"ur"]) {
        bypassText = @"بای پاس 🟢";
    } else if ([language isEqualToString:@"ku"]) {
        bypassText = @"لادان 🟢";
    }
    
    bypassLabel.text = bypassText;
    bypassLabel.textColor = [UIColor greenColor];
    bypassLabel.font = [UIFont boldSystemFontOfSize:14];
    bypassLabel.textAlignment = NSTextAlignmentCenter;
    bypassLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    bypassLabel.layer.cornerRadius = 6;
    bypassLabel.clipsToBounds = YES;
    bypassLabel.userInteractionEnabled = NO;
    
    [targetWindow addSubview:bypassLabel];
    [targetWindow bringSubviewToFront:bypassLabel];
    
    __weak UILabel *weakLabel = bypassLabel;
    
    void (^moveAction)(void) = ^{
        UILabel *strongLabel = weakLabel;
        if (!strongLabel) return;
        
        CGFloat randomX = arc4random_uniform((uint32_t)(screenBounds.size.width - 130));
        CGFloat randomY = arc4random_uniform((uint32_t)(screenBounds.size.height - 80));
        
        [UIView animateWithDuration:4.0 animations:^{
            strongLabel.frame = CGRectMake(randomX, randomY, 110, 30);
        }];
    };
    
    moveAction();
    [NSTimer scheduledTimerWithTimeInterval:4.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        moveAction();
    }];
}

static void showToastNotification(NSString *message, UIView *parentView) {
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, parentView.bounds.size.width - 40, 40)];
    toastLabel.backgroundColor = [[UIColor colorWithRed:0.0 green:0.8 blue:0.4 alpha:0.95] colorWithAlphaComponent:0.95];
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.font = [UIFont boldSystemFontOfSize:14];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.text = message;
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds = YES;
    toastLabel.alpha = 1.0;
    
    [parentView addSubview:toastLabel];
    [parentView bringSubviewToFront:toastLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastLabel removeFromSuperview];
    });
}

static void activateSuccess(NSString *enteredKey) {
    [[NSUserDefaults standardUserDefaults] setObject:enteredKey forKey:@"MamaHalaSavedKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *successMsg = @"⚡️ MAMAHALA VIP Activated Successfully!";
    if ([currentSelectedLanguage isEqualToString:@"ar"]) {
        successMsg = @"⚡️ تم تفعيل ماماهالا بنجاح!";
    } else if ([currentSelectedLanguage isEqualToString:@"ur"]) {
        successMsg = @"⚡️ کامیابی کے ساتھ فعال ہو گیا!";
    } else if ([currentSelectedLanguage isEqualToString:@"ku"]) {
        successMsg = @"⚡️ مەماهالا ڤایپ بە سەرکەوتوویی چالاک بوو!";
    }
    
    showToastNotification(successMsg, globalBlackScreen);
    
    UIWindow *targetWindow = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (windowScene.windows.count > 0) {
                targetWindow = windowScene.windows.firstObject;
                break;
            }
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (globalModWindow) {
            [globalModWindow setHidden:YES];
            globalModWindow = nil;
            globalBlackScreen = nil;
        }
        showMovingBypassText(targetWindow, currentSelectedLanguage);
    });
}

static void verifyKeyOnSupabase(NSString *enteredKey) {
    if (enteredKey.length == 0) return;
    
    NSArray *serverFallbackKeys = @[@"5054", @"SHAZAandMamaHala", @"shazavipnomber1o"];
    
    NSString *encodedKey = [enteredKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxyyyxjr.supabase.co/rest/v1/keys?key_text=eq.%@&is_active=eq.true", encodedKey];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (!url) {
        if ([serverFallbackKeys containsObject:enteredKey]) {
            activateSuccess(enteredKey);
        } else {
            if (globalKeyField) {
                globalKeyField.layer.borderColor = [UIColor redColor].CGColor;
                globalKeyField.placeholder = [currentSelectedLanguage isEqualToString:@"ar"] ? @"❌ مفتاح خاطئ!" : ([currentSelectedLanguage isEqualToString:@"ku"] ? @"❌ کلیلەکە هەڵەیە!" : @"❌ Invalid Key!");
                globalKeyField.text = @"";
            }
        }
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *anonKey = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA";
    [request setValue:anonKey forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", anonKey] forHTTPHeaderField:@"Authorization"];
    [request setTimeoutInterval:10.0];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.allowsCellularAccess = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (error || !data || httpResponse.statusCode != 200) {
                if ([serverFallbackKeys containsObject:enteredKey]) {
                    activateSuccess(enteredKey);
                } else {
                    if (globalKeyField) {
                        globalKeyField.layer.borderColor = [UIColor redColor].CGColor;
                        globalKeyField.placeholder = [currentSelectedLanguage isEqualToString:@"ar"] ? @"❌ مفتاح غير صالح!" : ([currentSelectedLanguage isEqualToString:@"ku"] ? @"❌ کلیلەکە هەڵەیە یان ناچالاکە!" : @"❌ Invalid or Inactive Key!");
                        globalKeyField.text = @"";
                    }
                    openTelegramLink();
                }
                return;
            }
            
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
                activateSuccess(enteredKey);
            } else {
                if ([serverFallbackKeys containsObject:enteredKey]) {
                    activateSuccess(enteredKey);
                } else {
                    if (globalKeyField) {
                        globalKeyField.layer.borderColor = [UIColor redColor].CGColor;
                        globalKeyField.placeholder = [currentSelectedLanguage isEqualToString:@"ar"] ? @"❌ مفتاح غير صالح!" : ([currentSelectedLanguage isEqualToString:@"ku"] ? @"❌ کلیلەکە هەڵەیە یان ناچالاکە!" : @"❌ Invalid or Inactive Key!");
                        globalKeyField.text = @"";
                    }
                    openTelegramLink();
                }
            }
        });
    }];
    [task resume];
}

static void showKeyInputUI(NSString *language, CGRect screenBounds) {
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:[MamaHalaHelper sharedInstance] action:@selector(dismissKeyboard)];
    bgTap.cancelsTouchesInView = NO;
    [globalBlackScreen addGestureRecognizer:bgTap];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, screenBounds.size.width - 40, 25)];
    statusLabel.text = @"● Server Online 🟢";
    statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.4 alpha:1.0];
    statusLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [globalBlackScreen addSubview:statusLabel];
    
    UILabel *bismillahLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, screenBounds.size.width - 40, 40)];
    bismillahLabel.text = @"﷽";
    bismillahLabel.textAlignment = NSTextAlignmentCenter;
    bismillahLabel.font = [UIFont boldSystemFontOfSize:32];
    bismillahLabel.textColor = [UIColor yellowColor];
    [globalBlackScreen addSubview:bismillahLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, screenBounds.size.width - 40, 50)];
    titleLabel.text = @"MAMAHALA";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:40];
    titleLabel.textColor = [UIColor whiteColor];
    [globalBlackScreen addSubview:titleLabel];
    
    CGFloat boxWidth = screenBounds.size.width - 120;
    if (boxWidth > 280) boxWidth = 280;
    CGFloat boxX = (screenBounds.size.width - (boxWidth + 45)) / 2;
    
    globalKeyField = [[UITextField alloc] initWithFrame:CGRectMake(boxX, screenBounds.size.height / 2 - 25, boxWidth, 50)];
    globalKeyField.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.95];
    globalKeyField.textColor = [UIColor whiteColor];
    globalKeyField.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    globalKeyField.textAlignment = NSTextAlignmentCenter;
    
    NSString *savedKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"MamaHalaSavedKey"];
    if (savedKey && savedKey.length > 0) {
        globalKeyField.text = savedKey;
    }
    
    NSString *placeholderText = @"🔑 Enter Key ...";
    NSString *loginBtnText = @"🚀 Login";
    NSString *tgBtnText = @"💬 Get Key on Telegram";
    
    if ([language isEqualToString:@"ku"]) {
        placeholderText = @"🔑 کلیلەکەت لێرە بنووسە ...";
        loginBtnText = @"🚀 پشکنین و چوونەژوورەوە";
        tgBtnText = @"💬 بۆ دەست کەوتنی کلیل لە تێلیگرام";
    } else if ([language isEqualToString:@"ar"]) {
        placeholderText = @"🔑 أدخل المفتاح هنا ...";
        loginBtnText = @"🚀 تحقق وتسجيل الدخول";
        tgBtnText = @"💬 للحصول على المفتاح عبر تلغرام";
    } else if ([language isEqualToString:@"ur"]) {
        placeholderText = @"🔑 یہاں کلید درج کریں ...";
        loginBtnText = @"🚀 لاگ ان کریں";
        tgBtnText = @"💬 ٹیلیگرام پر کلید حاصل کریں";
    }
    
    globalKeyField.placeholder = placeholderText;
    [globalKeyField setValue:[UIColor colorWithWhite:0.6 alpha:1.0] forKeyPath:@"placeholderLabel.textColor"];
    globalKeyField.layer.cornerRadius = 12;
    globalKeyField.layer.borderWidth = 1.5;
    globalKeyField.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.8].CGColor;
    [globalBlackScreen addSubview:globalKeyField];
    
    UIButton *pasteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pasteBtn.frame = CGRectMake(boxX + boxWidth + 8, screenBounds.size.height / 2 - 25, 42, 50);
    [pasteBtn setTitle:@"📋" forState:UIControlStateNormal];
    pasteBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    pasteBtn.backgroundColor = [UIColor colorWithWhite:0.18 alpha:0.95];
    pasteBtn.layer.cornerRadius = 12;
    pasteBtn.layer.borderWidth = 1;
    pasteBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.8].CGColor;
    [pasteBtn addTarget:[MamaHalaHelper sharedInstance] action:@selector(pasteKey) forControlEvents:UIControlEventTouchUpInside];
    [globalBlackScreen addSubview:pasteBtn];
    
    CGFloat fullWidth = boxWidth + 50;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(boxX, screenBounds.size.height / 2 + 35, fullWidth, 45);
    [loginBtn setTitle:loginBtnText forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    loginBtn.layer.cornerRadius = 12;
    [loginBtn addTarget:[MamaHalaHelper sharedInstance] action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [globalBlackScreen addSubview:loginBtn];
    
    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(boxX, screenBounds.size.height / 2 + 90, fullWidth, 45);
    [tgBtn setTitle:tgBtnText forState:UIControlStateNormal];
    [tgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    tgBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.55 blue:0.9 alpha:1.0];
    tgBtn.layer.cornerRadius = 12;
    [tgBtn addTarget:[MamaHalaHelper sharedInstance] action:@selector(telegramAction) forControlEvents:UIControlEventTouchUpInside];
    [globalBlackScreen addSubview:tgBtn];
}

static void showLanguageMenu(CGRect screenBounds) {
    CGFloat btnWidth = screenBounds.size.width - 100;
    if (btnWidth > 280) btnWidth = 280;
    CGFloat btnX = (screenBounds.size.width - btnWidth) / 2;
    CGFloat startY = screenBounds.size.height / 2 - 110;
    
    NSArray *titles = @[@"کوردی (Kurdish)", @"العربية (Arabic)", @"English", @"اردو (Urdu/Pakistani)"];
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *langBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        langBtn.frame = CGRectMake(btnX, startY + (i * 60), btnWidth, 45);
        [langBtn setTitle:titles[i] forState:UIControlStateNormal];
        [langBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        langBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        langBtn.backgroundColor = [UIColor colorWithWhite:0.18 alpha:0.95];
        langBtn.layer.cornerRadius = 12;
        langBtn.layer.borderWidth = 1;
        langBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        langBtn.tag = i;
        
        [langBtn addTarget:[MamaHalaHelper sharedInstance] action:@selector(langButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [globalModWindow.rootViewController.view addSubview:langBtn];
    }
}

__attribute__((constructor)) static void initializer() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindowScene *activeScene = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                activeScene = (UIWindowScene *)scene;
                break;
            }
        }
        
        if (activeScene) {
            CGRect screenBounds = activeScene.windows.firstObject ? activeScene.windows.firstObject.bounds : CGRectMake(0, 0, 414, 896);
            if (screenBounds.size.width == 0) {
                screenBounds = CGRectMake(0, 0, 414, 896);
            }
            
            globalModWindow = [[UIWindow alloc] initWithWindowScene:activeScene];
            globalModWindow.frame = screenBounds;
            globalModWindow.windowLevel = UIWindowLevelAlert + 100;
            globalModWindow.backgroundColor = [UIColor clearColor];
            
            UIViewController *rootVC = [[UIViewController alloc] init];
            rootVC.view.backgroundColor = [UIColor blackColor];
            globalModWindow.rootViewController = rootVC;
            
            [globalModWindow makeKeyAndVisible];
            
            globalBlackScreen = rootVC.view;
            globalBlackScreen.userInteractionEnabled = YES;
            
            NSString *welcomeText = @"WELCOME TO SERVER MAMAHALA";
            NSMutableArray *charLabels = [NSMutableArray array];
            
            for (int i = 0; i < welcomeText.length; i++) {
                unichar c = [welcomeText characterAtIndex:i];
                NSString *charStr = [NSString stringWithFormat:@"%C", c];
                
                UILabel *charLbl = [[UILabel alloc] init];
                charLbl.text = charStr;
                charLbl.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.25 alpha:1.0];
                charLbl.font = [UIFont boldSystemFontOfSize:30];
                [charLbl sizeToFit];
                charLbl.alpha = 0.0;
                [globalBlackScreen addSubview:charLbl];
                [charLabels addObject:charLbl];
            }
            
            __block CGFloat currentX = (screenBounds.size.width - [welcomeText sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:30]}].width) / 2;
            
            for (int i = 0; i < charLabels.count; i++) {
                UILabel *lbl = charLabels[i];
                CGSize size = [lbl.text sizeWithAttributes:@{NSFontAttributeName:lbl.font}];
                lbl.frame = CGRectMake(currentX, (screenBounds.size.height / 2) - 20, size.width, size.height);
                currentX += size.width;
                
                double delay = 0.03 * i;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.2 animations:^{
                        lbl.alpha = 1.0;
                    }];
                });
            }
            
            double totalAnimationTime = (0.03 * welcomeText.length) + 1.2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(totalAnimationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    for (UILabel *lbl in charLabels) {
                        lbl.alpha = 0.0;
                    }
                } completion:^(BOOL finished) {
                    for (UILabel *lbl in charLabels) {
                        [lbl removeFromSuperview];
                    }
                    showLanguageMenu(screenBounds);
                });
            });
        }
    });
}
