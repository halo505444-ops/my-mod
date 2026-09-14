#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <sys/stat.h>
#import <dlfcn.h>

typedef NS_ENUM(NSInteger, AppLanguage) {
    LangSorani = 0,
    LangBadini,
    LangEnglish
};

@interface ModMenuManager : NSObject
@property (nonatomic, assign) BOOL isAuthorized;
@property (nonatomic, assign) AppLanguage currentLang;
@property (nonatomic, assign) BOOL isLineEnabled;
@property (nonatomic, assign) BOOL isNationEnabled;
@property (nonatomic, assign) BOOL isEnemyEnabled;
@property (nonatomic, assign) BOOL isBoxEnabled;
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISegmentedControl *langSelector;
@property (nonatomic, strong) UIButton *lineBtn;
@property (nonatomic, strong) UIButton *nationBtn;
@property (nonatomic, strong) UIButton *enemyBtn;
@property (nonatomic, strong) UIButton *boxBtn;
@end

@implementation ModMenuManager

+ (instancetype)sharedInstance {
    static ModMenuManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ModMenuManager alloc] init];
        shared.currentLang = LangSorani;
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
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxxyyxjr.supabase.co/rest/v1/keys?key=eq.%@", key];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) {
            completion(NO);
            return;
        }
        
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError && [jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
            completion(YES);
        } else {
            completion(NO);
        }
    }];
    [task resume];
}

- (void)syncWithServerFeature:(NSString *)featureName status:(BOOL)status {
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxxyyxjr.supabase.co/rest/v1/mod_logs"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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

        self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.floatingButton.frame = CGRectMake(50, 100, 55, 55);
        self.floatingButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.85];
        [self.floatingButton setTitle:@"⚙️" forState:UIControlStateNormal];
        self.floatingButton.titleLabel.font = [UIFont systemFontOfSize:28];
        self.floatingButton.layer.cornerRadius = 27.5;
        self.floatingButton.layer.borderWidth = 1.5;
        self.floatingButton.layer.borderColor = [[UIColor systemCyanColor] CGColor];
        self.floatingButton.layer.zPosition = 99999;
        [self.floatingButton addTarget:self action:@selector(handleFloatingButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.floatingButton addGestureRecognizer:pan];
        [window addSubview:self.floatingButton];

        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(120, 100, 260, 320)];
        self.menuView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.18 alpha:0.96];
        self.menuView.layer.cornerRadius = 16;
        self.menuView.hidden = YES;
        self.menuView.layer.zPosition = 99998;
        
        CAShapeLayer *dashedBorder = [CAShapeLayer layer];
        dashedBorder.strokeColor = [[UIColor blackColor] CGColor];
        dashedBorder.fillColor = nil;
        dashedBorder.lineDashPattern = @[@6, @4];
        dashedBorder.lineWidth = 2.5;
        dashedBorder.frame = self.menuView.bounds;
        dashedBorder.path = [UIBezierPath bezierPathWithRoundedRect:self.menuView.bounds cornerRadius:16].CGPath;
        [self.menuView.layer addSublayer:dashedBorder];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 32)];
        self.titleLabel.text = @"👑 M ᴀ ᴍ ᴀ 𝐇 ᴀ ʟ ᴀ 👑";
        self.titleLabel.textColor = [UIColor systemYellowColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.menuView addSubview:self.titleLabel];

        // ڕاستکردنەوەی هەڵەی هێڵی قەبارە لێرەدا جێبەجێکراوە
        self.langSelector = [[UISegmentedControl alloc] initWithItems:@[@"کوردی (سۆ)", @"کوردی (باد)", @"English"]];
        self.langSelector.frame = CGRectMake(15, 48, 230, 30);
        self.langSelector.selectedSegmentIndex = 0;
        [self.langSelector addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventValueChanged];
        [self.menuView addSubview:self.langSelector];

        self.lineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lineBtn.frame = CGRectMake(15, 88, 230, 38);
        [self.lineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.lineBtn.layer.cornerRadius = 8;
        [self.lineBtn addTarget:self action:@selector(toggleLine) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:self.lineBtn];

        self.nationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nationBtn.frame = CGRectMake(15, 134, 230, 38);
        [self.nationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nationBtn.layer.cornerRadius = 8;
        [self.nationBtn addTarget:self action:@selector(toggleNation) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:self.nationBtn];

        self.enemyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.enemyBtn.frame = CGRectMake(15, 180, 230, 38);
        [self.enemyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.enemyBtn.layer.cornerRadius = 8;
        [self.enemyBtn addTarget:self action:@selector(toggleEnemy) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:self.enemyBtn];

        self.boxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.boxBtn.frame = CGRectMake(15, 226, 230, 38);
        [self.boxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.boxBtn.layer.cornerRadius = 8;
        [self.boxBtn addTarget:self action:@selector(toggleBox) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:self.boxBtn];

        [window addSubview:self.menuView];
        [self updateUITexts];
    });
}

- (void)handleFloatingButtonTapped {
    if (!self.isAuthorized) {
        [self showKeyPrompt];
    } else {
        self.menuView.hidden = !self.menuView.hidden;
    }
}

- (void)showKeyPrompt {
    UIWindow *window = [self getMainWindow];
    UIViewController *rootVC = window.rootViewController;
    
    UIAlertController *keyAlert = [UIAlertController alertControllerWithTitle:@"🔑 MamaHala Key System" 
        message:@"تکایە کلیلی چالاککردن بنووسە:" 
        preferredStyle:UIAlertControllerStyleAlert];
        
    [keyAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"کلیل لێرە بنووسە...";
        textField.secureTextEntry = NO;
    }];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"پشکنین" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *enteredKey = keyAlert.textFields.firstObject.text;
        [self validateKey:enteredKey completion:^(BOOL isValid) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isValid) {
                    self.isAuthorized = YES;
                    self.menuView.hidden = NO;
                } else {
                    UIAlertAction *errAction = [UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDestructive handler:nil];
                    UIAlertController *errAlert = [UIAlertController alertControllerWithTitle:@"هەڵە" message:@"کلیلەکە هەڵەیە یان بوونی نییە!" preferredStyle:UIAlertControllerStyleAlert];
                    [errAlert addAction:errAction];
                    [rootVC presentViewController:errAlert animated:YES completion:nil];
                }
            });
        }];
    }];
    
    [keyAlert addAction:submitAction];
    [keyAlert addAction:[UIAlertAction actionWithTitle:@"داخستن" style:UIAlertActionStyleCancel handler:nil]];
    [rootVC presentViewController:keyAlert animated:YES completion:nil];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIWindow *window = [self getMainWindow];
    CGPoint translation = [recognizer translationInView:window];
    CGPoint center = recognizer.view.center;
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:window];
}

- (void)changeLanguage:(UISegmentedControl *)sender {
    self.currentLang = (AppLanguage)sender.selectedSegmentIndex;
    [self updateUITexts];
}

- (void)updateUITexts {
    if (self.currentLang == LangSorani) {
        [self.lineBtn setTitle:self.isLineEnabled ? @"هێڵی کێشان: داگیرسێنراوە" : @"هێڵی کێشان: کوژاوەتەوە" forState:UIControlStateNormal];
        [self.nationBtn setTitle:self.isNationEnabled ? @"نەتەوە: داگیرسێنراوە" : @"نەتەوە: کوژاوەتەوە" forState:UIControlStateNormal];
        [self.enemyBtn setTitle:self.isEnemyEnabled ? @"دوژمن: داگیرسێنراوە" : @"دوژمن: کوژاوەتەوە" forState:UIControlStateNormal];
        [self.boxBtn setTitle:self.isBoxEnabled ? @"قوتووی ESP: داگیرسێنراوە" : @"قوتووی ESP: کوژاوەتەوە" forState:UIControlStateNormal];
    } else if (self.currentLang == LangBadini) {
        [self.lineBtn setTitle:self.isLineEnabled ? @"هێڵ: پڕکراوە" : @"هێڵ: ڤالا یە" forState:UIControlStateNormal];
        [self.nationBtn setTitle:self.isNationEnabled ? @"نەتەوە: پڕکراوە" : @"نەتەوە: ڤالا یە" forState:UIControlStateNormal];
        [self.enemyBtn setTitle:self.isEnemyEnabled ? @"دوژمن: پڕکراوە" : @"دوژمن: ڤالا یە" forState:UIControlStateNormal];
        [self.boxBtn setTitle:self.isBoxEnabled ? @"قوتو: پڕکراوە" : @"قوتو: ڤالا یە" forState:UIControlStateNormal];
    } else {
        [self.lineBtn setTitle:self.isLineEnabled ? @"Line: ON" : @"Line: OFF" forState:UIControlStateNormal];
        [self.nationBtn setTitle:self.isNationEnabled ? @"Nation: ON" : @"Nation: OFF" forState:UIControlStateNormal];
        [self.enemyBtn setTitle:self.isEnemyEnabled ? @"Enemy: ON" : @"Enemy: OFF" forState:UIControlStateNormal];
        [self.boxBtn setTitle:self.isBoxEnabled ? @"Box: ON" : @"Box: OFF" forState:UIControlStateNormal];
    }
    
    self.lineBtn.backgroundColor = self.isLineEnabled ? [UIColor colorWithRed:0.1 green:0.6 blue:0.2 alpha:1.0] : [UIColor colorWithRed:0.4 green:0.15 blue:0.15 alpha:1.0];
    self.nationBtn.backgroundColor = self.isNationEnabled ? [UIColor colorWithRed:0.1 green:0.6 blue:0.2 alpha:1.0] : [UIColor colorWithRed:0.4 green:0.15 blue:0.15 alpha:1.0];
    self.enemyBtn.backgroundColor = self.isEnemyEnabled ? [UIColor colorWithRed:0.1 green:0.6 blue:0.2 alpha:1.0] : [UIColor colorWithRed:0.4 green:0.15 blue:0.15 alpha:1.0];
    self.boxBtn.backgroundColor = self.isBoxEnabled ? [UIColor colorWithRed:0.1 green:0.6 blue:0.2 alpha:1.0] : [UIColor colorWithRed:0.4 green:0.15 blue:0.15 alpha:1.0];
}

- (void)toggleLine {
    self.isLineEnabled = !self.isLineEnabled;
    [self updateUITexts];
    [self syncWithServerFeature:@"Line" status:self.isLineEnabled];
}

- (void)toggleNation {
    self.isNationEnabled = !self.isNationEnabled;
    [self updateUITexts];
    [self syncWithServerFeature:@"Nation" status:self.isNationEnabled];
}

- (void)toggleEnemy {
    self.isEnemyEnabled = !self.isEnemyEnabled;
    [self updateUITexts];
    [self syncWithServerFeature:@"Enemy" status:self.isEnemyEnabled];
}

- (void)toggleBox {
    self.isBoxEnabled = !self.isBoxEnabled;
    [self updateUITexts];
    [self syncWithServerFeature:@"Box" status:self.isBoxEnabled];
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ModMenuManager sharedInstance] setupMenu];
    });
}
