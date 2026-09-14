#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <sys/stat.h>
#import <dlfcn.h>

typedef NS_ENUM(NSInteger, AppLanguage) {
    LangSorani = 0,
    LangBadini,
    LangEnglish
};

typedef NS_ENUM(NSInteger, MenuSection) {
    SectionESP = 0,
    SectionAimbot,
    SectionMemory,
    SectionSkins,
    SectionSettings
};

@interface ModMenuManager : NSObject
@property (nonatomic, assign) BOOL isAuthorized;
@property (nonatomic, assign) AppLanguage currentLang;
@property (nonatomic, assign) MenuSection currentSection;

// ESP Features
@property (nonatomic, assign) BOOL isLineEnabled;
@property (nonatomic, assign) BOOL isBoxEnabled;
@property (nonatomic, assign) BOOL isDistanceEnabled;
@property (nonatomic, assign) BOOL isHealthEnabled;

// Aimbot Features
@property (nonatomic, assign) BOOL isAimbotEnabled;
@property (nonatomic, assign) BOOL isAutoShootEnabled;
@property (nonatomic, assign) BOOL isFovEnabled;
@property (nonatomic, assign) BOOL isRecoilEnabled;

// Memory / Fly & Speed Features
@property (nonatomic, assign) BOOL isFlyEnabled;
@property (nonatomic, assign) BOOL isHighJumpEnabled;
@property (nonatomic, assign) BOOL isSpeedEnabled;
@property (nonatomic, assign) BOOL isWallHackEnabled;

// Skins Features
@property (nonatomic, assign) BOOL isWeaponSkinsEnabled;
@property (nonatomic, assign) BOOL isCharacterSkinsEnabled;
@property (nonatomic, assign) BOOL isVehicleSkinsEnabled;

// UI Elements
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIStackView *tabStackView;
@property (nonatomic, strong) UIStackView *contentStackView;
@end

@implementation ModMenuManager

+ (instancetype)sharedInstance {
    static ModMenuManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ModMenuManager alloc] init];
        shared.currentLang = LangSorani;
        shared.currentSection = SectionESP;
        shared.isAuthorized = NO;
    });
    return shared;
}

- (UIWindow *)getMainWindow {
    UIWindow *foundWindow = nil;
    for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    foundWindow = window;
                    break;
                }
            }
        }
    }
    if (!foundWindow) {
        foundWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    return foundWindow;
}

- (void)validateKey:(NSString *)key completion:(void(^)(BOOL isValid))completion {
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxxyyxjr.supabase.co/rest/v1/keys?key_text=eq.%@", key];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"apikey"];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) {
            completion(NO);
            return;
        }
        
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError && [jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
            NSDictionary *keyData = jsonArray[0];
            if ([keyData[@"is_active"] boolValue] == YES) {
                completion(YES);
                return;
            }
        }
        completion(NO);
    }];
    [task resume];
}

- (void)syncWithServerFeature:(NSString *)featureName status:(BOOL)status {
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxxyyxjr.supabase.co/rest/v1/mod_logs"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"apikey"];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *jsonBody = @{@"feature": featureName, @"status": status ? @(YES) : @(NO)};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:nil];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];
    [task resume];
}

- (void)setupMenu {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self getMainWindow];
        if (!window) return;

        // دوگمەی سەرەکی گەڕۆک
        self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.floatingButton.frame = CGRectMake(50, 100, 50, 50);
        self.floatingButton.backgroundColor = [UIColor clearColor];
        [self.floatingButton setTitle:@"⚙️" forState:UIControlStateNormal];
        self.floatingButton.titleLabel.font = [UIFont systemFontOfSize:32];
        self.floatingButton.layer.zPosition = 99999;
        [self.floatingButton addTarget:self action:@selector(handleFloatingButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *panBtn = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanButton:)];
        [self.floatingButton addGestureRecognizer:panBtn];
        [window addSubview:self.floatingButton];

        // دروستکردنی شێوەی سێگۆشەی مێنۆ
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(110, 100, 300, 400)];
        self.menuView.backgroundColor = [UIColor colorWithRed:0.95 green:0.93 blue:0.98 alpha:0.98];
        self.menuView.hidden = YES;
        self.menuView.layer.zPosition = 99998;
        
        UIBezierPath *trianglePath = [UIBezierPath bezierPath];
        [trianglePath moveToPoint:CGPointMake(150, 0)];
        [trianglePath addLineToPoint:CGPointMake(300, 400)];
        [trianglePath addLineToPoint:CGPointMake(0, 400)];
        [trianglePath closePath];
        
        CAShapeLayer *triangleMask = [CAShapeLayer layer];
        triangleMask.path = trianglePath.CGPath;
        self.menuView.layer.mask = triangleMask;
        
        CAShapeLayer *triangleBorder = [CAShapeLayer layer];
        triangleBorder.path = trianglePath.CGPath;
        triangleBorder.strokeColor = [UIColor purpleColor].CGColor;
        triangleBorder.lineWidth = 3.0;
        triangleBorder.fillColor = nil;
        [self.menuView.layer addSublayer:triangleBorder];

        // ناونیشان
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 200, 30)];
        self.titleLabel.text = @"👑 M ᴀ ᴍ ᴀ 𝐇 ᴀ ʟ ᴀ 👑";
        self.titleLabel.textColor = [UIColor purpleColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.menuView addSubview:self.titleLabel];

        // بەشەکانی سەرەوە (Tabs)
        self.tabStackView = [[UIStackView alloc] initWithFrame:CGRectMake(25, 80, 250, 32)];
        self.tabStackView.axis = UILayoutConstraintAxisHorizontal;
        self.tabStackView.distribution = UIStackViewDistributionFillEqually;
        self.tabStackView.spacing = 4;
        
        NSArray *tabs = @[@"ESP", @"Aim", @"Fly", @"Skins", @"Lang"];
        for (int i = 0; i < tabs.count; i++) {
            UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tabBtn setTitle:tabs[i] forState:UIControlStateNormal];
            tabBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tabBtn.backgroundColor = [UIColor darkGrayColor];
            tabBtn.layer.cornerRadius = 6;
            tabBtn.tag = i;
            [tabBtn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabStackView addArrangedSubview:tabBtn];
        }
        [self.menuView addSubview:self.tabStackView];

        // شوێنی سکڕۆڵ بۆ ناوەڕۆک
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(35, 125, 230, 240)];
        self.contentScrollView.showsVerticalScrollIndicator = YES;
        [self.menuView addSubview:self.contentScrollView];

        self.contentStackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 230, 240)];
        self.contentStackView.axis = UILayoutConstraintAxisVertical;
        self.contentStackView.distribution = UIStackViewDistributionFillEqually;
        self.contentStackView.spacing = 10;
        [self.contentScrollView addSubview:self.contentStackView];

        // جووڵاندنی مێنۆ بە دەست
        UIPanGestureRecognizer *panMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanMenu:)];
        [self.menuView addGestureRecognizer:panMenu];

        [window addSubview:self.menuView];
        [self reloadMenuButtons];
    });
}

- (void)handleFloatingButtonTapped {
    if (!self.isAuthorized) {
        [self showKeyPrompt];
    } else {
        self.menuView.hidden = !self.menuView.hidden;
    }
}

- (void)handlePanButton:(UIPanGestureRecognizer *)recognizer {
    UIWindow *window = [self getMainWindow];
    CGPoint translation = [recognizer translationInView:window];
    CGPoint center = recognizer.view.center;
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:window];
}

- (void)handlePanMenu:(UIPanGestureRecognizer *)recognizer {
    UIWindow *window = [self getMainWindow];
    CGPoint translation = [recognizer translationInView:window];
    CGPoint center = recognizer.view.center;
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:window];
}

- (void)switchTab:(UIButton *)sender {
    self.currentSection = (MenuSection)sender.tag;
    [self reloadMenuButtons];
}

- (void)reloadMenuButtons {
    for (UIView *subview in self.contentStackView.arrangedSubviews) {
        [subview removeFromSuperview];
    }
    
    if (self.currentSection == SectionESP) {
        [self addSwitchRowToStack:@"Line" status:self.isLineEnabled action:@selector(toggleLine:)];
        [self addSwitchRowToStack:@"Box" status:self.isBoxEnabled action:@selector(toggleBox:)];
        [self addSwitchRowToStack:@"Distance" status:self.isDistanceEnabled action:@selector(toggleDistance:)];
        [self addSwitchRowToStack:@"Health" status:self.isHealthEnabled action:@selector(toggleHealth:)];
    } 
    else if (self.currentSection == SectionAimbot) {
        [self addSwitchRowToStack:@"Aimbot" status:self.isAimbotEnabled action:@selector(toggleAimbot:)];
        [self addSwitchRowToStack:@"Auto Shoot" status:self.isAutoShootEnabled action:@selector(toggleAutoShoot:)];
        [self addSwitchRowToStack:@"FOV Circle" status:self.isFovEnabled action:@selector(toggleFov:)];
        [self addSwitchRowToStack:@"No Recoil" status:self.isRecoilEnabled action:@selector(toggleRecoil:)];
    } 
    else if (self.currentSection == SectionMemory) {
        [self addSwitchRowToStack:@"Fly Hack" status:self.isFlyEnabled action:@selector(toggleFly:)];
        [self addSwitchRowToStack:@"High Jump" status:self.isHighJumpEnabled action:@selector(toggleHighJump:)];
        [self addSwitchRowToStack:@"Speed Hack" status:self.isSpeedEnabled action:@selector(toggleSpeed:)];
        [self addSwitchRowToStack:@"WallHack" status:self.isWallHackEnabled action:@selector(toggleWallHack:)];
    } 
    else if (self.currentSection == SectionSkins) {
        [self addSwitchRowToStack:@"Weapon Skins" status:self.isWeaponSkinsEnabled action:@selector(toggleWeaponSkins:)];
        [self addSwitchRowToStack:@"Character Skins" status:self.isCharacterSkinsEnabled action:@selector(toggleCharacterSkins:)];
        [self addSwitchRowToStack:@"Vehicle Skins" status:self.isVehicleSkinsEnabled action:@selector(toggleVehicleSkins:)];
    } 
    else if (self.currentSection == SectionSettings) {
        [self addLangButtonToStack:@"کوردی (سۆرانى)" langIndex:LangSorani];
        [self addLangButtonToStack:@"کوردی (بادینی)" langIndex:LangBadini];
        [self addLangButtonToStack:@"English" langIndex:LangEnglish];
    }
}

- (void)addSwitchRowToStack:(NSString *)title status:(BOOL)status action:(SEL)action {
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
    rowView.backgroundColor = [UIColor whiteColor];
    rowView.layer.cornerRadius = 10;
    rowView.layer.borderWidth = 1.5;
    rowView.layer.borderColor = [UIColor purpleColor].CGColor;
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(12, 5, 50, 30)];
    sw.on = status;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [rowView addSubview:sw];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 140, 30)];
    lbl.text = title;
    lbl.font = [UIFont boldSystemFontOfSize:13];
    lbl.textColor = [UIColor darkTextColor];
    [rowView addSubview:lbl];
    
    [self.contentStackView addArrangedSubview:rowView];
}

- (void)addLangButtonToStack:(NSString *)title langIndex:(AppLanguage)lang {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    BOOL isSelected = (self.currentLang == lang);
    [btn setTitle:[NSString stringWithFormat:@"%@%@", title, isSelected ? @" ✔" : @""] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = isSelected ? [UIColor systemBlueColor] : [UIColor darkGrayColor];
    btn.layer.cornerRadius = 8;
    btn.tag = lang;
    [btn addTarget:self action:@selector(selectLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentStackView addArrangedSubview:btn];
}

- (void)selectLanguage:(id)sender {
    self.currentLang = (AppLanguage)((UIView *)sender).tag;
    [self reloadMenuButtons];
}

// تووگلەکانی Switch
- (void)toggleLine:(UISwitch *)sender { self.isLineEnabled = sender.isOn; [self syncWithServerFeature:@"Line" status:sender.isOn]; }
- (void)toggleBox:(UISwitch *)sender { self.isBoxEnabled = sender.isOn; [self syncWithServerFeature:@"Box" status:sender.isOn]; }
- (void)toggleDistance:(UISwitch *)sender { self.isDistanceEnabled = sender.isOn; [self syncWithServerFeature:@"Distance" status:sender.isOn]; }
- (void)toggleHealth:(UISwitch *)sender { self.isHealthEnabled = sender.isOn; [self syncWithServerFeature:@"Health" status:sender.isOn]; }

- (void)toggleAimbot:(UISwitch *)sender { self.isAimbotEnabled = sender.isOn; [self syncWithServerFeature:@"Aimbot" status:sender.isOn]; }
- (void)toggleAutoShoot:(UISwitch *)sender { self.isAutoShootEnabled = sender.isOn; [self syncWithServerFeature:@"AutoShoot" status:sender.isOn]; }
- (void)toggleFov:(UISwitch *)sender { self.isFovEnabled = sender.isOn; [self syncWithServerFeature:@"FOV" status:sender.isOn]; }
- (void)toggleRecoil:(UISwitch *)sender { self.isRecoilEnabled = sender.isOn; [self syncWithServerFeature:@"NoRecoil" status:sender.isOn]; }

- (void)toggleFly:(UISwitch *)sender { self.isFlyEnabled = sender.isOn; [self syncWithServerFeature:@"Fly" status:sender.isOn]; }
- (void)toggleHighJump:(UISwitch *)sender { self.isHighJumpEnabled = sender.isOn; [self syncWithServerFeature:@"HighJump" status:sender.isOn]; }
- (void)toggleSpeed:(UISwitch *)sender { self.isSpeedEnabled = sender.isOn; [self syncWithServerFeature:@"Speed" status:sender.isOn]; }
- (void)toggleWallHack:(UISwitch *)sender { self.isWallHackEnabled = sender.isOn; [self syncWithServerFeature:@"WallHack" status:sender.isOn]; }

- (void)toggleWeaponSkins:(UISwitch *)sender { self.isWeaponSkinsEnabled = sender.isOn; [self syncWithServerFeature:@"WeaponSkins" status:sender.isOn]; }
- (void)toggleCharacterSkins:(UISwitch *)sender { self.isCharacterSkinsEnabled = sender.isOn; [self syncWithServerFeature:@"CharacterSkins" status:sender.isOn]; }
- (void)toggleVehicleSkins:(UISwitch *)sender { self.isVehicleSkinsEnabled = sender.isOn; [self syncWithServerFeature:@"VehicleSkins" status:sender.isOn]; }

- (void)showKeyPrompt {
    UIWindow *window = [self getMainWindow];
    UIViewController *rootVC = window.rootViewController;
    
    UIAlertController *keyAlert = [UIAlertController alertControllerWithTitle:@"🔑 MamaHala Key System" 
        message:@"تکایە کلیلی چالاککردن بنووسە:" 
        preferredStyle:UIAlertControllerStyleAlert];
        
    [keyAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"کلیل لێرە بنووسە...";
    }];
    
    // دوگمەی بۆ دەستکەوتنی کلیل (تێلیگرام)
    UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"💬 بۆ دەست کەوتنی کلیل دەست لێرە دە" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/MAMA_HALA0"];
        if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
            [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
        }
        // دوبارە پیشاندانەوەی مێنۆی کلیل تا بەکارهێنەر کلیلەکەی تێدا بنووسێت پاش هاتنەوە
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showKeyPrompt];
        });
    }];
    [keyAlert addAction:telegramAction];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"پشکنین" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *enteredKey = keyAlert.textFields.firstObject.text;
        [self validateKey:enteredKey completion:^(BOOL isValid) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isValid) {
                    self.isAuthorized = YES;
                    self.menuView.hidden = NO;
                } else {
                    UIAlertController *errAlert = [UIAlertController alertControllerWithTitle:@"هەڵە" message:@"کلیلەکە هەڵەیە یان ناچالاکە!" preferredStyle:UIAlertControllerStyleAlert];
                    [errAlert addAction:[UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDestructive handler:nil]];
                    [rootVC presentViewController:errAlert animated:YES completion:nil];
                }
            });
        }];
    }];
    
    [keyAlert addAction:submitAction];
    [keyAlert addAction:[UIAlertAction actionWithTitle:@"داخستن" style:UIAlertActionStyleCancel handler:nil]];
    [rootVC presentViewController:keyAlert animated:YES completion:nil];
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ModMenuManager sharedInstance] setupMenu];
    });
}
