#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

// زانیارییەکانی سێرڤەری Supabaseـەکەت (لێرەدا دایبنێ)
#define SUPABASE_URL @"https://لێرە_لینکەکەی_سۆپابەیس_دانە.supabase.co/rest/v1/keys?key_text=eq.%@"
#define SUPABASE_ANON_KEY @"لێرە_ئەپای_کەی_گشتی_سۆپابەیس_دانە"

@interface MamaHalaMenu : NSObject
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation MamaHalaMenu

+ (instancetype)sharedInstance {
    static MamaHalaMenu *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MamaHalaMenu alloc] init];
    });
    return sharedInstance;
}

- (void)showMenu {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.window) return;
        
        UIWindowScene *scene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
        self.window = [[UIWindow alloc] initWithFrame:scene.coordinateSpace.bounds];
        self.window.windowLevel = UIWindowLevelAlert + 1;
        self.window.hidden = NO;
        self.window.backgroundColor = [UIColor clearColor];
        
        UIViewController *vc = [[UIViewController alloc] init];
        self.window.rootViewController = vc;
        
        // دروستکردنی چوارچێوەی سەرەکی مێنوی هاک
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, 280, 320)];
        self.menuView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.92];
        self.menuView.layer.cornerRadius = 16;
        self.menuView.layer.borderWidth = 1.5;
        self.menuView.layer.borderColor = [UIColor systemRedColor].CGColor;
        [vc.view addSubview:self.menuView];
        
        // سەردێڕی مێنوەکە (ناوێكی شاز)
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 260, 30)];
        titleLabel.text = @"🔥 MamaHala VIP Menu 🔥";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.menuView addSubview:titleLabel];
        
        // هێڵی ڕازاندنەوە
        UIView *krdFlagBar = [[UIView alloc] initWithFrame:CGRectMake(20, 52, 240, 4)];
        krdFlagBar.backgroundColor = [UIColor redColor];
        [self.menuView addSubview:krdFlagBar];
        
        // خانەی نووسینی کلیل (TextField)
        self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 75, 240, 40)];
        self.keyTextField.placeholder = @" لێرە کلیلەکەت بنووسە...";
        self.keyTextField.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        self.keyTextField.textColor = [UIColor whiteColor];
        self.keyTextField.layer.cornerRadius = 8;
        self.keyTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.menuView addSubview:self.keyTextField];
        
        // دوگمەی پشکنینی کلیل (Check Button)
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkButton.frame = CGRectMake(20, 130, 240, 45);
        [checkButton setTitle:@"پشکنینی کلیل (Check Key)" forState:UIControlStateNormal];
        [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkButton.backgroundColor = [UIColor systemBlueColor];
        checkButton.layer.cornerRadius = 8;
        [checkButton addTarget:self action:@selector(verifyKeyServer) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:checkButton];
        
        // نیشاندەری دۆخ (Status Label)
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 240, 60)];
        self.statusLabel.text = @"دۆخ: چاوەڕێی کلیل...";
        self.statusLabel.textColor = [UIColor yellowColor];
        self.statusLabel.font = [UIFont systemFontOfSize:13];
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.menuView addSubview:self.statusLabel];
        
        // دوگمەی داخستن
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        closeButton.frame = CGRectMake(90, 265, 100, 35);
        [closeButton setTitle:@"پەنهان کردن" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:closeButton];
    });
}

- (void)hideMenu {
    self.window.hidden = YES;
    self.window = nil;
}

// فەنکشنی پشکنینی کلیل لەگەڵ سێرڤەری سۆپابەیس (کیبۆرد لێرەدا بە خۆکاری دەکەوێتەوە)
- (void)verifyKeyServer {
    // داخستنی کیبۆرد بۆ ئەوەی دوگمەکە بە ئاسانی کار بکات
    [self.menuView endEditing:YES];
    
    NSString *userKey = self.keyTextField.text;
    if (userKey.length == 0) {
        self.statusLabel.text = @"❌ تکایە کلیلەکەت بنووسە!";
        self.statusLabel.textColor = [UIColor redColor];
        return;
    }
    
    self.statusLabel.text = @"⏳ خەریکە دەپشکنرێت...";
    self.statusLabel.textColor = [UIColor orangeColor];
    
    NSString *urlString = [NSString stringWithFormat:SUPABASE_URL, userKey];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:SUPABASE_ANON_KEY forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", SUPABASE_ANON_KEY] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.statusLabel.text = @"❌ کێشەی هێڵ هەیە!";
                self.statusLabel.textColor = [UIColor redColor];
                return;
            }
            
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonArray && [jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
                NSDictionary *keyData = jsonArray[0];
                NSNumber *isActive = keyData[@"is_active"];
                
                if ([isActive boolValue] == YES) {
                    self.statusLabel.text = @"✅ کلیلەکە دروستە! هاک کارا بوو.";
                    self.statusLabel.textColor = [UIColor greenColor];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self hideMenu];
                    });
                } else {
                    self.statusLabel.text = @"⚠️ ئەم کلیلە ناچالاک کراوە!";
                    self.statusLabel.textColor = [UIColor redColor];
                }
            } else {
                self.statusLabel.text = @"❌ کلیلەکە هەڵەیە یان بوونی نییە!";
                self.statusLabel.textColor = [UIColor redColor];
            }
        });
    }];
    [task resume];
}

@end

__attribute__((constructor)) void entryPoint() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MamaHalaMenu sharedInstance] showMenu];
    });
}
