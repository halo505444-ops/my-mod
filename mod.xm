#import <UIKit/UIKit.h>

@interface UIApplication (OpenURL)
- (void)openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^)(BOOL success))completion;
@end

static void openTelegramLink() {
    NSURL *url = [NSURL URLWithString:@"https://t.me/Mama_Hala0"];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

static UIWindow *globalModWindow = nil;
static UIView *globalBlackScreen = nil;
static UITextField *globalKeyField = nil;
static void verifyKeyOnSupabase(NSString *enteredKey);

static void dismissKeyboard() {
    if (globalKeyField) {
        [globalKeyField resignFirstResponder];
    }
}

static void pasteKeyAction() {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string && globalKeyField) {
        globalKeyField.text = [pasteboard.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

static void loginAction() {
    if (globalKeyField) {
        [globalKeyField resignFirstResponder];
        NSString *cleanedKey = [globalKeyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        verifyKeyOnSupabase(cleanedKey);
    }
}

static void telegramAction() {
    openTelegramLink();
}

static void showMovingBypassText(UIWindow *targetWindow) {
    if (!targetWindow) return;
    
    CGRect screenBounds = targetWindow.bounds;
    
    UILabel *bypassLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 160, 40)];
    bypassLabel.text = @"BYPASS 🟢";
    bypassLabel.textColor = [UIColor greenColor];
    bypassLabel.font = [UIFont boldSystemFontOfSize:22];
    bypassLabel.textAlignment = NSTextAlignmentCenter;
    bypassLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    bypassLabel.layer.cornerRadius = 8;
    bypassLabel.clipsToBounds = YES;
    bypassLabel.userInteractionEnabled = NO;
    
    [targetWindow addSubview:bypassLabel];
    [targetWindow bringSubviewToFront:bypassLabel];
    
    __block void (^moveBlock)(void) = nil;
    __weak UILabel *weakLabel = bypassLabel;
    
    moveBlock = ^{
        UILabel *strongLabel = weakLabel;
        if (!strongLabel) return;
        
        CGFloat randomX = arc4random_uniform((uint32_t)(screenBounds.size.width - 180));
        CGFloat randomY = arc4random_uniform((uint32_t)(screenBounds.size.height - 100));
        
        [UIView animateWithDuration:4.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            strongLabel.frame = CGRectMake(randomX, randomY, 160, 40);
        } completion:^(BOOL finished) {
            if (moveBlock) {
                moveBlock();
            }
        }];
    };
    moveBlock();
}

static void showToastNotification(NSString *message, UIView *parentView) {
    UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, parentView.bounds.size.width - 40, 45)];
    toastLabel.backgroundColor = [[UIColor colorWithRed:0.0 green:0.8 blue:0.4 alpha:0.95] colorWithAlphaComponent:0.95];
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.font = [UIFont boldSystemFontOfSize:15];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.text = message;
    toastLabel.layer.cornerRadius = 12;
    toastLabel.clipsToBounds = YES;
    toastLabel.alpha = 0.0;
    
    [parentView addSubview:toastLabel];
    [parentView bringSubviewToFront:toastLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        toastLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                toastLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                [toastLabel removeFromSuperview];
            }];
        });
    }];
}

static void verifyKeyOnSupabase(NSString *enteredKey) {
    if (enteredKey.length == 0) return;
    
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxyyyxjr.supabase.co/rest/v1/keys?key_text=eq.%@&is_active=eq.true", enteredKey];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"apikey"];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error || !data) {
                if (globalKeyField) {
                    globalKeyField.layer.borderColor = [UIColor redColor].CGColor;
                    globalKeyField.placeholder = @"❌ کێشەی هێڵ / توریا!";
                    globalKeyField.text = @"";
                }
                return;
            }
            
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:enteredKey forKey:@"MamaHalaSavedKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                showToastNotification(@"⚡️ MAMAHALA VIP Activated Successfully!", globalBlackScreen);
                
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
                    [UIView animateWithDuration:0.8 animations:^{
                        if (globalModWindow) {
                            globalModWindow.alpha = 0.0;
                        }
                    } completion:^(BOOL finished) {
                        [globalModWindow setHidden:YES];
                        globalModWindow = nil;
                        globalBlackScreen = nil;
                        
                        showMovingBypassText(targetWindow);
                    }];
                });
            } else {
                if (globalKeyField) {
                    globalKeyField.layer.borderColor = [UIColor redColor].CGColor;
                    globalKeyField.placeholder = @"❌ کلیل بەدەست بێنە!";
                    globalKeyField.text = @"";
                }
                openTelegramLink();
            }
        });
    }];
    [task resume];
}

static void showKeyInputUI(NSString *language, CGRect screenBounds) {
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] init];
    [bgTap addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        dismissKeyboard();
    }]];
    bgTap.cancelsTouchesInView = NO;
    [globalBlackScreen addGestureRecognizer:bgTap];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, screenBounds.size.width - 40, 25)];
    statusLabel.text = @"● Server Online 🟢";
    statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.4 alpha:1.0];
    statusLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.alpha = 0.0;
    [globalBlackScreen addSubview:statusLabel];
    
    UILabel *bismillahLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, screenBounds.size.width - 40, 40)];
    bismillahLabel.text = @"﷽";
    bismillahLabel.textAlignment = NSTextAlignmentCenter;
    bismillahLabel.font = [UIFont boldSystemFontOfSize:32];
    bismillahLabel.textColor = [UIColor yellowColor];
    bismillahLabel.alpha = 0.0;
    [globalBlackScreen addSubview:bismillahLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, screenBounds.size.width - 40, 50)];
    titleLabel.text = @"MAMAHALA";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:40];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.alpha = 0.0;
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
        tgBtnText = @"💬 بۆ دەست کەوتنی کلیل";
    } else if ([language isEqualToString:@"ar"]) {
        placeholderText = @"🔑 أدخل المفتاح هنا ...";
        loginBtnText = @"🚀 تحقق وتسجيل الدخول";
        tgBtnText = @"💬 للحصول على المفتاح";
    } else if ([language isEqualToString:@"ur"]) {
        placeholderText = @"🔑 یہاں کلید درج کریں ...";
        loginBtnText = @"🚀 لاگ ان کریں";
        tgBtnText = @"💬 کلید حاصل کرنے کے لیے";
    }
    
    globalKeyField.placeholder = placeholderText;
    [globalKeyField setValue:[UIColor colorWithWhite:0.6 alpha:1.0] forKeyPath:@"placeholderLabel.textColor"];
    globalKeyField.layer.cornerRadius = 12;
    globalKeyField.layer.borderWidth = 1.5;
    globalKeyField.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.8].CGColor;
    globalKeyField.alpha = 0.0;
    [globalBlackScreen addSubview:globalKeyField];
    
    UIButton *pasteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pasteBtn.frame = CGRectMake(boxX + boxWidth + 8, screenBounds.size.height / 2 - 25, 42, 50);
    [pasteBtn setTitle:@"📋" forState:UIControlStateNormal];
    pasteBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    pasteBtn.backgroundColor = [UIColor colorWithWhite:0.18 alpha:0.95];
    pasteBtn.layer.cornerRadius = 12;
    pasteBtn.layer.borderWidth = 1;
    pasteBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.8].CGColor;
    pasteBtn.alpha = 0.0;
    [pasteBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        pasteKeyAction();
    }] forControlEvents:UIControlEventTouchUpInside];
    [globalBlackScreen addSubview:pasteBtn];
    
    CGFloat fullWidth = boxWidth + 50;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(boxX, screenBounds.size.height / 2 + 35, fullWidth, 45);
    [loginBtn setTitle:loginBtnText forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    loginBtn.layer.cornerRadius = 12;
    loginBtn.alpha = 0.0;
    [loginBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        loginAction();
    }] forControlEvents:UIControlEventTouchUpInside];
    [globalBlackScreen addSubview:loginBtn];
    
    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(boxX, screenBounds.size.height / 2 + 90, fullWidth, 45);
    [tgBtn setTitle:tgBtnText forState:UIControlStateNormal];
    [tgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    tgBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.55 blue:0.9 alpha:1.0];
    tgBtn.layer.cornerRadius = 12;
    tgBtn.alpha = 0.0;
    [tgBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        telegramAction();
    }] forControlEvents:UIControlEventTouchUpInside];
    [globalBlackScreen addSubview:tgBtn];
    
    [globalBlackScreen bringSubviewToFront:globalKeyField];
    [globalBlackScreen bringSubviewToFront:pasteBtn];
    [globalBlackScreen bringSubviewToFront:loginBtn];
    [globalBlackScreen bringSubviewToFront:tgBtn];
    
    [UIView animateWithDuration:0.8 animations:^{
        statusLabel.alpha = 1.0;
        bismillahLabel.alpha = 1.0;
        titleLabel.alpha = 1.0;
        globalKeyField.alpha = 1.0;
        pasteBtn.alpha = 1.0;
        loginBtn.alpha = 1.0;
        tgBtn.alpha = 1.0;
    }];
}

static void showLanguageMenu(CGRect screenBounds) {
    NSMutableArray *langViews = [NSMutableArray array];
    
    CGFloat btnWidth = screenBounds.size.width - 100;
    if (btnWidth > 280) btnWidth = 280;
    CGFloat btnX = (screenBounds.size.width - btnWidth) / 2;
    CGFloat startY = screenBounds.size.height / 2 - 110;
    
    NSArray *languages = @[
        @{@"code": @"ku", @"title": @"کوردی (Kurdish)"},
        @{@"code": @"ar", @"title": @"العربية (Arabic)"},
        @{@"code": @"en", @"title": @"English"},
        @{@"code": @"ur", @"title": @"اردو (Urdu/Pakistani)"}
    ];
    
    for (int i = 0; i < languages.count; i++) {
        NSDictionary *dict = languages[i];
        
        UIButton *langBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        langBtn.frame = CGRectMake(btnX, startY + (i * 60), btnWidth, 45);
        [langBtn setTitle:dict[@"title"] forState:UIControlStateNormal];
        [langBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        langBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        langBtn.backgroundColor = [UIColor colorWithWhite:0.18 alpha:0.95];
        langBtn.layer.cornerRadius = 12;
        langBtn.layer.borderWidth = 1;
        langBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        langBtn.alpha = 0.0;
        
        [langBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            [UIView animateWithDuration:0.5 animations:^{
                for (UIView *v in langViews) {
                    v.alpha = 0.0;
                }
            } completion:^(BOOL finished) {
                for (UIView *v in langViews) {
                    [v removeFromSuperview];
                }
                showKeyInputUI(dict[@"code"], screenBounds);
            }];
        }] forControlEvents:UIControlEventTouchUpInside];
        
        [globalModWindow.rootViewController.view addSubview:langBtn];
        [langViews addObject:langBtn];
    }
    
    for (int i = 0; i < langViews.count; i++) {
        UIButton *btn = langViews[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.1 * i) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                btn.alpha = 1.0;
            }];
        });
    }
}

static void runMamaHalaMod() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindowScene *activeScene = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                activeScene = (UIWindowScene *)scene;
                break;
            }
        }
        
        if (activeScene) {
            // بەکارهێنانی قەبارەی ویندۆ بێ بەکارهێنانی coordinateSpace
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
                [UIView animateWithDuration:0.6 animations:^{
                    for (UILabel *lbl in charLabels) {
                        lbl.alpha = 0.0;
                    }
                } completion:^(BOOL finished) {
                    for (UILabel *lbl in charLabels) {
                        [lbl removeFromSuperview];
                    }
                    showLanguageMenu(screenBounds);
                }];
            });
        }
    });
}

__attribute__((constructor)) static void initializer() {
    runMamaHalaMod();
}
