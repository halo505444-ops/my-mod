#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <sys/utsname.h>
#import <dlfcn.h>

// زانیارییەکانی سێرفەری Supabase
static NSString * const SUPABASE_URL = @"https://narkhdockqhlwxxyyxjr.supabase.co";
static NSString * const SUPABASE_ANON_KEY = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA";
static NSString * const ADMIN_TG_USER = @"Mama_Hala0";

// لینکە ڕاستەوخۆکانی لۆگۆ و ڤیدیۆ لە GitHub
static NSString * const LOGO_IMAGE_URL = @"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/Zoro%20rasm.JPG";
static NSString * const INTRO_VIDEO_URL = @"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/Mama.MP4";

static UIWindow* getActiveKeyWindow() {
    UIWindow *foundWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *w in windowScene.windows) {
                    if (w.isKeyWindow) {
                        foundWindow = w;
                        break;
                    }
                }
                if (!foundWindow && windowScene.windows.count > 0) {
                    foundWindow = windowScene.windows.firstObject;
                }
            }
        }
    }
    if (!foundWindow) {
        foundWindow = [UIApplication sharedApplication].keyWindow;
    }
    if (!foundWindow && [UIApplication sharedApplication].windows.count > 0) {
        foundWindow = [[UIApplication sharedApplication].windows firstObject];
    }
    return foundWindow;
}

// ١. ناسینەوەی جۆری پۆبجی و وەشانی ئەپدەیتەکە بە شێوەی 100% ڕاستەقینە
static NSString* getPubgRegionAndVersion() {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleID = [infoDict objectForKey:@"CFBundleIdentifier"];
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    if (!version) version = @"Unknown";

    NSString *regionName = @"PUBG Mobile";
    if ([bundleID isEqualToString:@"com.tencent.ig"]) {
        regionName = @"PUBG Global";
    } else if ([bundleID isEqualToString:@"com.vng.pubgmobile"]) {
        regionName = @"PUBG Vietnam (VN)";
    } else if ([bundleID isEqualToString:@"com.pubg.krmobile"]) {
        regionName = @"PUBG Korea (KR)";
    } else if ([bundleID isEqualToString:@"com.rekoo.pubgm"]) {
        regionName = @"PUBG Taiwan (TW)";
    } else if ([bundleID isEqualToString:@"com.pubg.imobile"]) {
        regionName = @"BGMI (India)";
    } else {
        NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"] ?: [infoDict objectForKey:@"CFBundleName"];
        if (appName) regionName = appName;
    }

    return [NSString stringWithFormat:@"%@ (v%@)", regionName, version];
}

// ٢. وەرگرتنی ناسنامەی مۆبایل
static NSString* getDeviceID() {
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (!deviceID || deviceID.length == 0) {
        deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"CustomFallbackUUID"];
        if (!deviceID) {
            deviceID = [[NSUUID UUID] UUIDString];
            [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:@"CustomFallbackUUID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return deviceID;
}

// ٣. وەرگرتنی جۆری ئایفۆن و وەشانی iOS
static NSString* getDeviceModelAndIOS() {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *iosVer = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@ | iOS %@ | %@", model, iosVer, getPubgRegionAndVersion()];
}

// ٤. دەنگی نەرمی سیستەم بێ پێویستی بە Linker
static void playSafeTapSound() {
    static void (*soundFunc)(uint32_t) = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox", RTLD_LAZY);
        if (handle) {
            soundFunc = (void (*)(uint32_t))dlsym(handle, "AudioServicesPlaySystemSound");
        }
    });
    if (soundFunc) {
        soundFunc(1104);
    }
}

@interface MamaHalaKeyMenu : NSObject <UITextFieldDelegate>
@property (nonatomic, strong) UIVisualEffectView *blurOverlay;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) UILabel *announcementLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) UIView *statusDot;
@property (nonatomic, strong) UILabel *serverStatusText;

// لۆگۆی سەرەوەی ناوەڕاست
@property (nonatomic, strong) UIImageView *topLogoView;

// پەخشکەری ڤیدیۆی دوای کلیل
@property (nonatomic, strong) UIView *videoContainerView;
@property (nonatomic, strong) id videoPlayer;
@property (nonatomic, strong) CALayer *videoPlayerLayer;
@property (nonatomic, strong) NSDate *pendingExpiryDate;
@property (nonatomic, assign) NSInteger pendingTotalHours;

// پێوەری FPSـی ڕاستەقینە
@property (nonatomic, strong) UIView *fpsPillView;
@property (nonatomic, strong) UILabel *fpsLabel;
@property (nonatomic, strong) id displayLink;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
@property (nonatomic, assign) NSInteger frameCount;

+ (instancetype)sharedInstance;
- (void)setupTopCenterLogo;
- (void)playIntroVideoThenShowUIWithExpiry:(NSDate *)expiryDate totalHours:(NSInteger)totalHours;
- (void)startRealTimeFPSMonitor;
- (void)showLoginMenuWithMessage:(NSString *)msg isError:(BOOL)isError;
- (void)showWelcomeBannerWithExpiryDate:(NSDate *)expiryDate totalHours:(NSInteger)totalHours;
- (void)checkServerSettingsAndStart;
- (void)verifyKey:(NSString *)enteredKey isAutoLogin:(BOOL)autoLogin;
@end

@implementation MamaHalaKeyMenu

+ (instancetype)sharedInstance {
    static MamaHalaKeyMenu *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MamaHalaKeyMenu alloc] init];
    });
    return instance;
}

// ================= لۆگۆی سەر سەرەوە لە ناوەڕاست (بەبێ خشتە ڕەشەکەی پشتی) =================
- (void)setupTopCenterLogo {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        if (self.topLogoView) {
            [window bringSubviewToFront:self.topLogoView];
            return;
        }

        CGFloat logoW = 68;
        CGFloat logoH = 68;
        self.topLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((window.bounds.size.width - logoW) / 2.0, 4, logoW, logoH)];
        self.topLogoView.contentMode = UIViewContentModeScaleAspectFit;
        self.topLogoView.backgroundColor = [UIColor clearColor];
        self.topLogoView.userInteractionEnabled = NO;

        // لابردنی باکگراوندە ڕەشەکەی پشتی وێنەکە
        self.topLogoView.layer.compositingFilter = @"plusL";

        [window addSubview:self.topLogoView];

        NSURL *imgUrl = [NSURL URLWithString:LOGO_IMAGE_URL];
        [[[NSURLSession sharedSession] dataTaskWithURL:imgUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error && data) {
                UIImage *img = [UIImage imageWithData:data];
                if (img) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.topLogoView.image = img;
                        [window bringSubviewToFront:self.topLogoView];
                    });
                }
            }
        }] resume];
    });
}

// ================= پەخشکردنی ڤیدیۆی Mama.MP4 لە کاتی لێدانی کلیلی ڕاستدا =================
- (void)playIntroVideoThenShowUIWithExpiry:(NSDate *)expiryDate totalHours:(NSInteger)totalHours {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        self.pendingExpiryDate = expiryDate;
        self.pendingTotalHours = totalHours;

        Class AVPlayerItemClass = NSClassFromString(@"AVPlayerItem");
        Class AVPlayerClass = NSClassFromString(@"AVPlayer");
        Class AVPlayerLayerClass = NSClassFromString(@"AVPlayerLayer");

        if (!AVPlayerItemClass || !AVPlayerClass || !AVPlayerLayerClass) {
            [self setupTopCenterLogo];
            if (expiryDate) [self showWelcomeBannerWithExpiryDate:expiryDate totalHours:totalHours];
            return;
        }

        self.videoContainerView = [[UIView alloc] initWithFrame:window.bounds];
        self.videoContainerView.backgroundColor = [UIColor blackColor];
        [window addSubview:self.videoContainerView];

        NSURL *videoURL = [NSURL URLWithString:INTRO_VIDEO_URL];
        id playerItem = ((id (*)(id, SEL, id))objc_msgSend)(AVPlayerItemClass, @selector(playerItemWithURL:), videoURL);
        self.videoPlayer = ((id (*)(id, SEL, id))objc_msgSend)(AVPlayerClass, @selector(playerWithPlayerItem:), playerItem);

        self.videoPlayerLayer = ((CALayer * (*)(id, SEL, id))objc_msgSend)(AVPlayerLayerClass, @selector(playerLayerWithPlayer:), self.videoPlayer);
        self.videoPlayerLayer.frame = self.videoContainerView.bounds;
        [self.videoPlayerLayer setValue:@"AVLayerVideoGravityResizeAspect" forKey:@"videoGravity"];
        [self.videoContainerView.layer addSublayer:self.videoPlayerLayer];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoDidFinishPlaying:)
                                                     name:@"AVPlayerItemDidPlayToEndTimeNotification"
                                                   object:playerItem];

        UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        skipBtn.frame = CGRectMake(window.bounds.size.width - 95, window.bounds.size.height - 55, 75, 32);
        skipBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.11 alpha:0.85];
        skipBtn.layer.cornerRadius = 10;
        skipBtn.layer.borderWidth = 1.2;
        skipBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:0.9].CGColor;
        [skipBtn setTitle:@"Skip ⏭" forState:UIControlStateNormal];
        [skipBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.82 blue:0.1 alpha:1.0] forState:UIControlStateNormal];
        skipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [skipBtn addTarget:self action:@selector(finishVideoAndProceed) forControlEvents:UIControlEventTouchUpInside];
        [self.videoContainerView addSubview:skipBtn];

        [self setupTopCenterLogo];

        if ([self.videoPlayer respondsToSelector:@selector(play)]) {
            ((void (*)(id, SEL))objc_msgSend)(self.videoPlayer, @selector(play));
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.videoContainerView) {
                [self finishVideoAndProceed];
            }
        });
    });
}

- (void)videoDidFinishPlaying:(NSNotification *)notification {
    [self finishVideoAndProceed];
}

- (void)finishVideoAndProceed {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.videoContainerView) return;

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVPlayerItemDidPlayToEndTimeNotification" object:nil];
        if ([self.videoPlayer respondsToSelector:@selector(pause)]) {
            ((void (*)(id, SEL))objc_msgSend)(self.videoPlayer, @selector(pause));
        }
        self.videoPlayer = nil;

        [UIView animateWithDuration:0.35 animations:^{
            self.videoContainerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.videoContainerView removeFromSuperview];
            self.videoContainerView = nil;

            [self setupTopCenterLogo];
            if (self.pendingExpiryDate) {
                [self showWelcomeBannerWithExpiryDate:self.pendingExpiryDate totalHours:self.pendingTotalHours];
            }
        }];
    });
}

// ================= پێوانەکردنی FPSـی 100% ڕاستەقینە =================
- (void)startRealTimeFPSMonitor {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.fpsPillView) return;

        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        CGFloat pillW = 195;
        CGFloat pillH = 26;
        self.fpsPillView = [[UIView alloc] initWithFrame:CGRectMake(16, 44, pillW, pillH)];
        self.fpsPillView.backgroundColor = [UIColor colorWithRed:0.06 green:0.06 blue:0.09 alpha:0.88];
        self.fpsPillView.layer.cornerRadius = 13;
        self.fpsPillView.layer.borderWidth = 1.2;
        self.fpsPillView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:0.85].CGColor;

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragFpsPill:)];
        [self.fpsPillView addGestureRecognizer:pan];

        self.fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, pillW - 16, pillH)];
        self.fpsLabel.textAlignment = NSTextAlignmentCenter;
        self.fpsLabel.font = [UIFont monospacedDigitSystemFontOfSize:11 weight:UIFontWeightBold];
        self.fpsLabel.textColor = [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
        self.fpsLabel.text = [NSString stringWithFormat:@"FPS: -- | @%@", ADMIN_TG_USER];
        [self.fpsPillView addSubview:self.fpsLabel];

        [window addSubview:self.fpsPillView];

        Class CADisplayLinkClass = NSClassFromString(@"CADisplayLink");
        if (CADisplayLinkClass) {
            self.lastTimestamp = 0;
            self.frameCount = 0;
            self.displayLink = ((id (*)(id, SEL, id, SEL))objc_msgSend)(CADisplayLinkClass, @selector(displayLinkWithTarget:selector:), self, @selector(updateFPS:));
            ((void (*)(id, SEL, id, id))objc_msgSend)(self.displayLink, @selector(addToRunLoop:forMode:), [NSRunLoop mainRunLoop], NSRunLoopCommonModes);
        }
    });
}

- (void)updateFPS:(id)link {
    NSTimeInterval currentTimestamp = [[link valueForKey:@"timestamp"] doubleValue];
    if (self.lastTimestamp == 0) {
        self.lastTimestamp = currentTimestamp;
        return;
    }

    self.frameCount++;
    NSTimeInterval delta = currentTimestamp - self.lastTimestamp;

    if (delta >= 0.5) {
        NSInteger realFPS = (NSInteger)round(self.frameCount / delta);
        self.frameCount = 0;
        self.lastTimestamp = currentTimestamp;

        UIColor *fpsColor = [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
        if (realFPS < 45) {
            fpsColor = [UIColor colorWithRed:1.0 green:0.35 blue:0.35 alpha:1.0];
        } else if (realFPS < 58) {
            fpsColor = [UIColor orangeColor];
        }

        self.fpsLabel.textColor = fpsColor;
        self.fpsLabel.text = [NSString stringWithFormat:@"⚡ %ld FPS | @%@", (long)realFPS, ADMIN_TG_USER];
        
        if (self.fpsPillView.superview) {
            [self.fpsPillView.superview bringSubviewToFront:self.fpsPillView];
        }
        if (self.topLogoView.superview) {
            [self.topLogoView.superview bringSubviewToFront:self.topLogoView];
        }
    }
}

- (void)dragFpsPill:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.fpsPillView.superview];
    self.fpsPillView.center = CGPointMake(self.fpsPillView.center.x + translation.x, self.fpsPillView.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.fpsPillView.superview];
}

- (void)addGoldShimmerToView:(UIView *)targetView {
    Class CAGradientLayerClass = NSClassFromString(@"CAGradientLayer");
    Class CABasicAnimationClass = NSClassFromString(@"CABasicAnimation");
    if (!CAGradientLayerClass || !CABasicAnimationClass) return;

    CALayer *gradient = ((CALayer * (*)(id, SEL))objc_msgSend)(CAGradientLayerClass, @selector(layer));
    gradient.frame = CGRectMake(-targetView.bounds.size.width, 0, targetView.bounds.size.width * 3, targetView.bounds.size.height);
    [gradient setValue:@[
        (id)[UIColor clearColor].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.45].CGColor,
        (id)[UIColor clearColor].CGColor
    ] forKey:@"colors"];
    [gradient setValue:@[@0.35, @0.5, @0.65] forKey:@"locations"];
    [gradient setValue:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.5)] forKey:@"startPoint"];
    [gradient setValue:[NSValue valueWithCGPoint:CGPointMake(1.0, 0.5)] forKey:@"endPoint"];

    id shimmerAnim = ((id (*)(id, SEL, id))objc_msgSend)(CABasicAnimationClass, @selector(animationWithKeyPath:), @"transform.translation.x");
    [shimmerAnim setValue:@(-targetView.bounds.size.width) forKey:@"fromValue"];
    [shimmerAnim setValue:@(targetView.bounds.size.width) forKey:@"toValue"];
    [shimmerAnim setValue:@(2.2) forKey:@"duration"];
    [shimmerAnim setValue:@(HUGE_VALF) forKey:@"repeatCount"];
    [gradient addAnimation:shimmerAnim forKey:@"shimmer"];

    targetView.layer.masksToBounds = YES;
    [targetView.layer addSublayer:gradient];
}

- (void)checkServerSettingsAndStart {
    [self setupTopCenterLogo];

    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/app_settings?id=eq.1&select=*", SUPABASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:SUPABASE_ANON_KEY forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", SUPABASE_ANON_KEY] forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL isMaintenance = NO;
        NSString *announcement = @"بەخێربێن بۆ سیستەمی MAMAHALA VIP 👑";

        if (!error && data) {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                NSDictionary *settings = arr[0];
                isMaintenance = [settings[@"is_maintenance"] boolValue];
                if (settings[@"announcement"] != [NSNull null]) {
                    announcement = settings[@"announcement"];
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (isMaintenance) {
                [self showLoginMenuWithMessage:@"🛠️ سێرفەر لەژێر چاکسازیدایە، تکایە دواتر هەوڵبدەرەوە!" isError:YES];
                self.announcementLabel.text = announcement;
                self.loginButton.enabled = NO;
                self.loginButton.alpha = 0.5;
                self.statusDot.backgroundColor = [UIColor orangeColor];
                self.serverStatusText.text = @"Maintenance";
                self.serverStatusText.textColor = [UIColor orangeColor];
                return;
            }

            NSString *savedKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"SavedUserKey"];
            if (savedKey.length > 0) {
                [self verifyKey:savedKey isAutoLogin:YES];
            } else {
                [self showLoginMenuWithMessage:nil isError:NO];
                self.announcementLabel.text = announcement;
            }
        });
    }];
    [task resume];
}

- (void)shakeCardWithErrorColor {
    UINotificationFeedbackGenerator *feedback = [[UINotificationFeedbackGenerator alloc] init];
    [feedback notificationOccurred:UINotificationFeedbackTypeError];

    self.cardView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.25 alpha:1.0].CGColor;
    self.cardView.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.25 blue:0.25 alpha:0.6].CGColor;

    Class CAKeyframeAnimationClass = NSClassFromString(@"CAKeyframeAnimation");
    if (CAKeyframeAnimationClass) {
        id animation = ((id (*)(id, SEL, id))objc_msgSend)(CAKeyframeAnimationClass, @selector(animationWithKeyPath:), @"transform.translation.x");
        [animation setValue:@(0.45) forKey:@"duration"];
        [animation setValue:@[@(-12.0), @(12.0), @(-10.0), @(10.0), @(-6.0), @(6.0), @(0.0)] forKey:@"values"];
        [self.cardView.layer addAnimation:animation forKey:@"shake"];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cardView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:1.0].CGColor;
        self.cardView.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:0.5].CGColor;
    });
}

- (void)showWelcomeBannerWithExpiryDate:(NSDate *)expiryDate totalHours:(NSInteger)totalHours {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        UINotificationFeedbackGenerator *feedback = [[UINotificationFeedbackGenerator alloc] init];
        [feedback notificationOccurred:UINotificationFeedbackTypeSuccess];

        NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
        [localFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [localFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [localFormatter setDateFormat:@"yyyy/MM/dd - hh:mm a"];
        NSString *formattedDate = [localFormatter stringFromDate:expiryDate];

        NSTimeInterval remainingSeconds = [expiryDate timeIntervalSinceNow];
        if (remainingSeconds < 0) remainingSeconds = 0;
        NSInteger days = (NSInteger)(remainingSeconds / 86400);
        NSInteger hours = (NSInteger)((remainingSeconds - (days * 86400)) / 3600);
        NSInteger minutes = (NSInteger)((remainingSeconds - (days * 86400) - (hours * 3600)) / 60);

        NSString *remainingStr = days > 0 ?
            [NSString stringWithFormat:@"%ld ڕۆژ و %ld کاتژمێر و %ld خولەک", (long)days, (long)hours, (long)minutes] :
            [NSString stringWithFormat:@"%ld کاتژمێر و %ld خولەک", (long)hours, (long)minutes];

        double totalSeconds = totalHours > 0 ? (totalHours * 3600.0) : 86400.0;
        double progressRatio = remainingSeconds / totalSeconds;
        if (progressRatio > 1.0) progressRatio = 1.0;
        if (progressRatio < 0.05) progressRatio = 0.05;

        BOOL isLowTime = (remainingSeconds < 7200);

        CGFloat bannerW = 335;
        CGFloat bannerH = 142;
        UIView *banner = [[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width - bannerW)/2, -bannerH, bannerW, bannerH)];
        banner.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.10 alpha:0.97];
        banner.layer.cornerRadius = 18;
        banner.layer.borderWidth = 1.8;
        banner.layer.borderColor = (isLowTime ? [UIColor orangeColor] : [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:1.0]).CGColor;
        banner.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:0.45].CGColor;
        banner.layer.shadowOffset = CGSizeMake(0, 4);
        banner.layer.shadowRadius = 12.0;
        banner.layer.shadowOpacity = 0.85;

        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, bannerW - 24, 22)];
        titleLbl.text = [NSString stringWithFormat:@"👑 MAMAHALA VIP | @%@", ADMIN_TG_USER];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:0.1 alpha:1.0];
        titleLbl.font = [UIFont boldSystemFontOfSize:14];
        [banner addSubview:titleLbl];

        UILabel *gameInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 32, bannerW - 24, 20)];
        gameInfoLbl.text = [NSString stringWithFormat:@"🎮 %@", getPubgRegionAndVersion()];
        gameInfoLbl.textAlignment = NSTextAlignmentCenter;
        gameInfoLbl.textColor = [UIColor colorWithRed:0.35 green:0.80 blue:1.0 alpha:1.0];
        gameInfoLbl.font = [UIFont boldSystemFontOfSize:13];
        [banner addSubview:gameInfoLbl];

        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 56, bannerW - 24, 20)];
        dateLbl.text = [NSString stringWithFormat:@"📅 بەسەرچوون: %@", formattedDate];
        dateLbl.textAlignment = NSTextAlignmentCenter;
        dateLbl.textColor = [UIColor whiteColor];
        dateLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        [banner addSubview:dateLbl];

        UILabel *remLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 78, bannerW - 24, 20)];
        remLbl.text = [NSString stringWithFormat:@"⏳ ماوە: %@", remainingStr];
        remLbl.textAlignment = NSTextAlignmentCenter;
        remLbl.textColor = isLowTime ? [UIColor orangeColor] : [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
        remLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        [banner addSubview:remLbl];

        UIView *progressBg = [[UIView alloc] initWithFrame:CGRectMake(20, 108, bannerW - 40, 8)];
        progressBg.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
        progressBg.layer.cornerRadius = 4;
        [banner addSubview:progressBg];

        UIView *progressFill = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (bannerW - 40) * progressRatio, 8)];
        progressFill.backgroundColor = isLowTime ? [UIColor orangeColor] : [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
        progressFill.layer.cornerRadius = 4;
        [progressBg addSubview:progressFill];

        [window addSubview:banner];
        [self startRealTimeFPSMonitor];
        if (self.topLogoView) [window bringSubviewToFront:self.topLogoView];

        [UIView animateWithDuration:0.55 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:0 animations:^{
            banner.frame = CGRectMake((window.bounds.size.width - bannerW)/2, 78, bannerW, bannerH);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:4.5 options:0 animations:^{
                banner.frame = CGRectMake((window.bounds.size.width - bannerW)/2, -bannerH - 20, bannerW, bannerH);
                banner.alpha = 0.0;
            } completion:^(BOOL finished) {
                [banner removeFromSuperview];
            }];
        }];
    });
}

- (void)showLoginMenuWithMessage:(NSString *)msg isError:(BOOL)isError {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        if (!self.blurOverlay) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.blurOverlay = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.blurOverlay.frame = window.bounds;
            self.blurOverlay.alpha = 0.97;

            CGFloat cardW = 335;
            CGFloat cardH = 415;
            self.cardView = [[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width - cardW)/2, (window.bounds.size.height - cardH)/2 + 18, cardW, cardH)];
            self.cardView.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.10 alpha:0.98];
            self.cardView.layer.cornerRadius = 22;
            self.cardView.layer.borderWidth = 2.0;
            self.cardView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:1.0].CGColor;
            
            self.cardView.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:0.5].CGColor;
            self.cardView.layer.shadowOffset = CGSizeMake(0, 0);
            self.cardView.layer.shadowRadius = 18.0;
            self.cardView.layer.shadowOpacity = 0.85;

            self.statusDot = [[UIView alloc] initWithFrame:CGRectMake(18, 18, 8, 8)];
            self.statusDot.backgroundColor = [UIColor colorWithRed:0.2 green:0.95 blue:0.4 alpha:1.0];
            self.statusDot.layer.cornerRadius = 4;
            [self.cardView addSubview:self.statusDot];

            self.serverStatusText = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 80, 16)];
            self.serverStatusText.text = @"Online";
            self.serverStatusText.textColor = [UIColor colorWithRed:0.2 green:0.95 blue:0.4 alpha:1.0];
            self.serverStatusText.font = [UIFont boldSystemFontOfSize:11];
            [self.cardView addSubview:self.serverStatusText];

            UILabel *crownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, cardW, 28)];
            crownLabel.text = @"👑 MAMAHALA VIP 👑";
            crownLabel.textAlignment = NSTextAlignmentCenter;
            crownLabel.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:0.1 alpha:1.0];
            crownLabel.font = [UIFont boldSystemFontOfSize:22];
            [self.cardView addSubview:crownLabel];

            UILabel *gameVersionBadge = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, cardW - 40, 20)];
            gameVersionBadge.text = [NSString stringWithFormat:@"🎮 %@", getPubgRegionAndVersion()];
            gameVersionBadge.textAlignment = NSTextAlignmentCenter;
            gameVersionBadge.textColor = [UIColor colorWithRed:0.35 green:0.80 blue:1.0 alpha:1.0];
            gameVersionBadge.font = [UIFont boldSystemFontOfSize:12];
            [self.cardView addSubview:gameVersionBadge];

            UIView *noticeBox = [[UIView alloc] initWithFrame:CGRectMake(20, 88, cardW - 40, 32)];
            noticeBox.backgroundColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:0.12];
            noticeBox.layer.cornerRadius = 8;
            [self.cardView addSubview:noticeBox];

            self.announcementLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, cardW - 56, 28)];
            self.announcementLabel.text = @"بەخێربێن بۆ سیستەمی MAMAHALA VIP 👑";
            self.announcementLabel.textAlignment = NSTextAlignmentCenter;
            self.announcementLabel.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.3 alpha:1.0];
            self.announcementLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
            [noticeBox addSubview:self.announcementLabel];

            UIView *inputContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 132, cardW - 40, 48)];
            inputContainer.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.17 alpha:1.0];
            inputContainer.layer.cornerRadius = 12;
            inputContainer.layer.borderWidth = 1.0;
            inputContainer.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.18].CGColor;
            [self.cardView addSubview:inputContainer];

            self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 6, cardW - 148, 36)];
            self.keyTextField.placeholder = @"MAMAHALA-XXD-XXXX";
            self.keyTextField.textColor = [UIColor whiteColor];
            self.keyTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
            self.keyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.keyTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            self.keyTextField.delegate = self;
            [self.keyTextField setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
            [inputContainer addSubview:self.keyTextField];

            self.eyeButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.eyeButton.frame = CGRectMake(cardW - 132, 9, 30, 30);
            [self.eyeButton setTitle:@"👁️" forState:UIControlStateNormal];
            [self.eyeButton addTarget:self action:@selector(toggleSecureKey) forControlEvents:UIControlEventTouchUpInside];
            [inputContainer addSubview:self.eyeButton];

            UIButton *pasteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            pasteBtn.frame = CGRectMake(cardW - 98, 9, 52, 30);
            pasteBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:0.22];
            pasteBtn.layer.cornerRadius = 8;
            [pasteBtn setTitle:@"Paste" forState:UIControlStateNormal];
            [pasteBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.82 blue:0.1 alpha:1.0] forState:UIControlStateNormal];
            pasteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [pasteBtn addTarget:self action:@selector(pasteKeyAction) forControlEvents:UIControlEventTouchUpInside];
            [inputContainer addSubview:pasteBtn];

            self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 188, cardW - 40, 36)];
            self.statusLabel.numberOfLines = 2;
            self.statusLabel.textAlignment = NSTextAlignmentCenter;
            self.statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
            [self.cardView addSubview:self.statusLabel];

            self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.loginButton.frame = CGRectMake(20, 232, cardW - 40, 46);
            self.loginButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.80 blue:0.0 alpha:1.0];
            self.loginButton.layer.cornerRadius = 12;
            [self.loginButton setTitle:@"چوونەژوورەوە (LOGIN)" forState:UIControlStateNormal];
            [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [self.loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.cardView addSubview:self.loginButton];
            [self addGoldShimmerToView:self.loginButton];

            UIButton *telegramBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            telegramBtn.frame = CGRectMake(20, 288, cardW - 40, 44);
            telegramBtn.backgroundColor = [UIColor colorWithRed:0.14 green:0.62 blue:0.86 alpha:1.0];
            telegramBtn.layer.cornerRadius = 12;
            [telegramBtn setTitle:[NSString stringWithFormat:@"✈️ کڕینی کلیل لە تێلێگرام (@%@)", ADMIN_TG_USER] forState:UIControlStateNormal];
            [telegramBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            telegramBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [telegramBtn addTarget:self action:@selector(openTelegramAction) forControlEvents:UIControlEventTouchUpInside];
            [self.cardView addSubview:telegramBtn];

            UIButton *copyIdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            copyIdBtn.frame = CGRectMake(20, 342, cardW - 40, 36);
            copyIdBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.06];
            copyIdBtn.layer.cornerRadius = 10;
            [copyIdBtn setTitle:@"📋 کۆپیکردنی کۆدی مۆبایل (Device ID)" forState:UIControlStateNormal];
            [copyIdBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            copyIdBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
            [copyIdBtn addTarget:self action:@selector(copyAndSendDeviceIdAction) forControlEvents:UIControlEventTouchUpInside];
            [self.cardView addSubview:copyIdBtn];

            [self.blurOverlay.contentView addSubview:self.cardView];
            [window addSubview:self.blurOverlay];

            self.cardView.transform = CGAffineTransformMakeScale(0.75, 0.75);
            self.cardView.alpha = 0.0;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:0 animations:^{
                self.cardView.transform = CGAffineTransformIdentity;
                self.cardView.alpha = 1.0;
            } completion:nil];
        }

        self.blurOverlay.hidden = NO;
        [window bringSubviewToFront:self.blurOverlay];
        if (self.topLogoView) [window bringSubviewToFront:self.topLogoView];
        
        self.loginButton.enabled = YES;
        [self.loginButton setTitle:@"چوونەژوورەوە (LOGIN)" forState:UIControlStateNormal];

        if (msg.length > 0) {
            self.statusLabel.text = msg;
            self.statusLabel.textColor = isError ? [UIColor colorWithRed:1.0 green:0.35 blue:0.35 alpha:1.0] : [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
            if (isError) [self shakeCardWithErrorColor];
        } else {
            self.statusLabel.text = @"تکایە کلیلەکەت بنووسە یان Paste بکە";
            self.statusLabel.textColor = [UIColor grayColor];
        }
    });
}

- (void)toggleSecureKey {
    playSafeTapSound();
    self.keyTextField.secureTextEntry = !self.keyTextField.secureTextEntry;
    [self.eyeButton setTitle:(self.keyTextField.secureTextEntry ? @"🙈" : @"👁️") forState:UIControlStateNormal];
}

- (void)openTelegramAction {
    playSafeTapSound();
    NSString *appStr = [NSString stringWithFormat:@"tg://resolve?domain=%@", ADMIN_TG_USER];
    NSString *webStr = [NSString stringWithFormat:@"https://t.me/%@", ADMIN_TG_USER];
    NSURL *tgAppUrl = [NSURL URLWithString:appStr];
    NSURL *tgWebUrl = [NSURL URLWithString:webStr];
    if ([[UIApplication sharedApplication] canOpenURL:tgAppUrl]) {
        [[UIApplication sharedApplication] openURL:tgAppUrl options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:tgWebUrl options:@{} completionHandler:nil];
    }
}

- (void)pasteKeyAction {
    playSafeTapSound();
    NSString *pasteStr = [UIPasteboard generalPasteboard].string;
    if (pasteStr.length > 0) {
        self.keyTextField.text = [pasteStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

- (void)copyAndSendDeviceIdAction {
    playSafeTapSound();
    NSString *infoToCopy = [NSString stringWithFormat:@"Device ID: %@\nInfo: %@", getDeviceID(), getDeviceModelAndIOS()];
    [UIPasteboard generalPasteboard].string = infoToCopy;
    self.statusLabel.text = [NSString stringWithFormat:@"✅ کۆپی کرا! دەتوانیت بینێریت بۆ @%@", ADMIN_TG_USER];
    self.statusLabel.textColor = [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)loginButtonTapped {
    playSafeTapSound();
    [self.keyTextField resignFirstResponder];
    NSString *enteredKey = [self.keyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self verifyKey:enteredKey isAutoLogin:NO];
}

- (void)verifyKey:(NSString *)enteredKey isAutoLogin:(BOOL)autoLogin {
    if (enteredKey.length == 0) {
        [self showLoginMenuWithMessage:@"⚠️ تکایە سەرەتا کلیلێک بنووسە!" isError:YES];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (!autoLogin && self.loginButton) {
            self.loginButton.enabled = NO;
            [self.loginButton setTitle:@"پشکنین..." forState:UIControlStateNormal];
            self.statusLabel.text = @"⏳ پەیوەندی بە سێرفەری MAMAHALA دەکرێت...";
            self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:0.1 alpha:1.0];
        }
    });

    NSString *encodedKey = [enteredKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/keys?key_text=eq.%@&select=*", SUPABASE_URL, encodedKey];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:SUPABASE_ANON_KEY forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", SUPABASE_ANON_KEY] forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) {
            [self showLoginMenuWithMessage:@"❌ هەڵەی پەیوەندی بە ئینتەرنێتەوە هەیە!" isError:YES];
            return;
        }

        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if (jsonError || ![jsonArray isKindOfClass:[NSArray class]] || jsonArray.count == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SavedUserKey"];
            [self showLoginMenuWithMessage:@"❌ ئەم کلیلە بوونی نییە یان هەڵەیە!" isError:YES];
            return;
        }

        NSDictionary *keyData = jsonArray[0];
        BOOL isActive = [keyData[@"is_active"] boolValue];
        if (!isActive) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SavedUserKey"];
            [self showLoginMenuWithMessage:@"⛔ ئەم کلیلە لەلایەن ئەدمینەوە ڕاگیراوە!" isError:YES];
            return;
        }

        NSInteger durationHours = keyData[@"duration_hours"] != [NSNull null] ? [keyData[@"duration_hours"] integerValue] : 24;
        NSInteger maxDevices = keyData[@"max_devices"] != [NSNull null] ? [keyData[@"max_devices"] integerValue] : 1;
        NSArray *usedDevices = [keyData[@"used_devices"] isKindOfClass:[NSArray class]] ? keyData[@"used_devices"] : @[];
        NSArray *deviceInfos = [keyData[@"device_info"] isKindOfClass:[NSArray class]] ? keyData[@"device_info"] : @[];
        id expiresAtObj = keyData[@"expires_at"];

        NSDateFormatter *isoFormatter = [[NSDateFormatter alloc] init];
        [isoFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [isoFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [isoFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"];

        NSDateFormatter *fallbackFormatter = [[NSDateFormatter alloc] init];
        [fallbackFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [fallbackFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [fallbackFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];

        NSDate *now = [NSDate date];
        NSDate *expiryDate = nil;
        NSString *finalExpiryString = @"";
        BOOL needsServerUpdate = NO;

        if (expiresAtObj == [NSNull null] || expiresAtObj == nil) {
            expiryDate = [now dateByAddingTimeInterval:(durationHours * 3600)];
            finalExpiryString = [fallbackFormatter stringFromDate:expiryDate];
            needsServerUpdate = YES;
        } else {
            NSString *expStr = (NSString *)expiresAtObj;
            expiryDate = [isoFormatter dateFromString:expStr];
            if (!expiryDate) expiryDate = [fallbackFormatter dateFromString:expStr];
            finalExpiryString = expStr;

            if (expiryDate && [now compare:expiryDate] == NSOrderedDescending) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SavedUserKey"];
                [self showLoginMenuWithMessage:@"⌛ کاتی ئەم کلیلە بەسەرچووە!" isError:YES];
                return;
            }
        }

        NSString *currentDeviceID = getDeviceID();
        NSMutableArray *updatedDevices = [usedDevices mutableCopy];
        NSMutableArray *updatedDeviceInfos = [deviceInfos mutableCopy];

        if (![updatedDevices containsObject:currentDeviceID]) {
            if (updatedDevices.count >= maxDevices) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SavedUserKey"];
                [self showLoginMenuWithMessage:@"📱 ئەم کلیلە پڕبووەتەوە و بۆ مۆبایلی تر نابێت!" isError:YES];
                return;
            }
            [updatedDevices addObject:currentDeviceID];
            [updatedDeviceInfos addObject:getDeviceModelAndIOS()];
            needsServerUpdate = YES;
        }

        void (^completeLogin)(void) = ^{
            [[NSUserDefaults standardUserDefaults] setObject:enteredKey forKey:@"SavedUserKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.blurOverlay) {
                    self.statusLabel.text = @"✅ کلیلەکە سەرکەوتوو بوو! بەخێربێیت...";
                    self.statusLabel.textColor = [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
                    self.cardView.layer.borderColor = [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0].CGColor;
                    
                    [UIView animateWithDuration:0.35 delay:0.4 options:0 animations:^{
                        self.blurOverlay.alpha = 0.0;
                        self.cardView.transform = CGAffineTransformMakeScale(1.08, 1.08);
                    } completion:^(BOOL finished) {
                        [self.blurOverlay removeFromSuperview];
                        self.blurOverlay = nil;
                        [self playIntroVideoThenShowUIWithExpiry:expiryDate totalHours:durationHours];
                    }];
                } else {
                    [self playIntroVideoThenShowUIWithExpiry:expiryDate totalHours:durationHours];
                }
            });
        };

        if (needsServerUpdate) {
            NSString *patchUrlStr = [NSString stringWithFormat:@"%@/rest/v1/keys?key_text=eq.%@", SUPABASE_URL, encodedKey];
            NSMutableURLRequest *patchReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patchUrlStr]];
            [patchReq setHTTPMethod:@"PATCH"];
            [patchReq setValue:SUPABASE_ANON_KEY forHTTPHeaderField:@"apikey"];
            [patchReq setValue:[NSString stringWithFormat:@"Bearer %@", SUPABASE_ANON_KEY] forHTTPHeaderField:@"Authorization"];
            [patchReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

            NSDictionary *updateBody = @{
                @"expires_at": finalExpiryString,
                @"used_devices": updatedDevices,
                @"device_info": updatedDeviceInfos
            };
            NSData *bodyData = [NSJSONSerialization dataWithJSONObject:updateBody options:0 error:nil];
            [patchReq setHTTPBody:bodyData];

            NSURLSessionDataTask *patchTask = [[NSURLSession sharedSession] dataTaskWithRequest:patchReq completionHandler:^(NSData *pData, NSURLResponse *pRes, NSError *pErr) {
                if (!pErr) {
                    completeLogin();
                } else {
                    [self showLoginMenuWithMessage:@"❌ هەڵە لە تۆمارکردنی داتا لە سێرفەر!" isError:YES];
                }
            }];
            [patchTask resume];
        } else {
            completeLogin();
        }
    }];
    [task resume];
}

@end

%ctor {
    dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore", RTLD_LAZY);
    dlopen("/System/Library/Frameworks/AVFoundation.framework/AVFoundation", RTLD_LAZY);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MamaHalaKeyMenu sharedInstance] checkServerSettingsAndStart];
    });
}
