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

static UIView *globalBlackScreen = nil;
static UITextField *globalKeyField = nil;
static UIButton *globalLoginBtn = nil;
static UIButton *globalTgBtn = nil;

static void showMovingBypassText(UIWindow *window) {
    if (!window) return;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    UILabel *bypassLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 160, 40)];
    bypassLabel.text = @"BYPASS 🟢";
    bypassLabel.textColor = [UIColor greenColor];
    bypassLabel.font = [UIFont boldSystemFontOfSize:22];
    bypassLabel.textAlignment = NSTextAlignmentCenter;
    bypassLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    bypassLabel.layer.cornerRadius = 8;
    bypassLabel.clipsToBounds = YES;
    bypassLabel.userInteractionEnabled = NO;
    
    [window addSubview:bypassLabel];
    [window bringSubviewToFront:bypassLabel];
    
    __block void (^moveBlock)(void) = ^{
        CGFloat randomX = arc4random_uniform((uint32_t)(screenBounds.size.width - 180));
        CGFloat randomY = arc4random_uniform((uint32_t)(screenBounds.size.height - 100));
        
        [UIView animateWithDuration:4.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            bypassLabel.frame = CGRectMake(randomX, randomY, 160, 40);
        } completion:^(BOOL finished) {
            moveBlock();
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
    
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxyyyxjr.supabase.co/rest/v1/keys?key_column=eq.%@", enteredKey];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"apikey"];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error || !data) return;
            
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:enteredKey forKey:@"MamaHalaSavedKey"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                showToastNotification(@"⚡️ MAMAHALA VIP Activated Successfully!", globalBlackScreen);
                
                UIWindow *window = globalBlackScreen.window;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.8 animations:^{
                        if (globalBlackScreen) {
                            globalBlackScreen.alpha = 0.0;
                        }
                    } completion:^(BOOL finished) {
                        [globalBlackScreen removeFromSuperview];
                        globalBlackScreen = nil;
                        
                        showMovingBypassText(window);
                    }];
                });
            } else {
                if (globalKeyField) {
                    globalKeyField.layer.borderColor = [UIColor redColor].CGColor;
                    globalKeyField.placeholder = @"❌ Invalid Key!";
                    globalKeyField.text = @"";
                }
            }
        });
    }];
    [task resume];
}

static void showKeyInputUI(NSString *language, CGRect screenBounds) {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [tapGesture addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        if (globalKeyField) {
            [globalKeyField resignFirstResponder];
        }
    }]];
    tapGesture.cancelsTouchesInView = NO;
    [globalBlackScreen addGestureRecognizer:tapGesture];
    
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
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (pasteboard.string) {
            globalKeyField.text = pasteboard.string;
        }
    }] forControlEvents:UIControlEventTouchUpInside];
    [globalBlackScreen addSubview:pasteBtn];
    
    CGFloat fullWidth = boxWidth + 50;
    
    globalLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    globalLoginBtn.frame = CGRectMake(boxX, screenBounds.size.height / 2 + 35, fullWidth, 45);
    [globalLoginBtn setTitle:loginBtnText forState:UIControlStateNormal];
    [globalLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    globalLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    globalLoginBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    globalLoginBtn.layer.cornerRadius = 12;
    globalLoginBtn.alpha = 0.0;
    [globalLoginBtn addTarget:nil action:@selector(verifyKeyAction)
