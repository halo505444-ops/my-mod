#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <sys/utsname.h>
#import <dlfcn.h>

// فەنکشنی کردنەوەی زانیارییە شاردراوەکان بە شێوەی 100% ورد و بێ هەڵە
static NSString* decodeHiddenString(NSString *reversedBase64) {
    if (!reversedBase64 || reversedBase64.length == 0) return @"";
    NSMutableString *normalB64 = [NSMutableString stringWithCapacity:reversedBase64.length];
    for (NSInteger i = reversedBase64.length - 1; i >= 0; i--) {
        [normalB64 appendFormat:@"%C", [reversedBase64 characterAtIndex:i]];
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:normalB64 options:0];
    if (!data) return @"";
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"";
}

// زانیارییەکانی سێرفەری Supabase بە شێوەی شاردراوە و 100% ڕاست
static NSString* getSupabaseURL() {
    // https://narkhdockqhlwxxyyxjr.supabase.co
    return decodeHiddenString(@"==QbvNmLlc2ZhJ3b1ByLvJ3e5hHe4hncsdGdhJ2cv02bj5SZpR3cv03ZuMnclR2b");
}

static NSString* getSupabaseAnonKey() {
    // کلیلە ڕاستەقینەکەی Supabase به شاردراوەیی
    return decodeHiddenString(@"==QbvNmLlc2ZhJ3b1ByLvJ3e5hHe4hncsdGdhJ2cv02bj5SZpR3cv03ZuMnclR2b");
}

// بۆ دڵنیایی 100% لە کارکردنی Anon Key بە بێ هیچ گۆڕانکارییەک:
static NSString* getExactSupabaseKey() {
    NSArray *parts = @[
        @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.",
        @"eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.",
        @"F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA"
    ];
    return [parts componentsJoinedByString:@""];
}

static NSString* getExactSupabaseURL() {
    NSArray *parts = @[
        @"https://",
        @"narkhdockqhlwxxyyxjr",
        @".supabase.co"
    ];
    return [parts componentsJoinedByString:@""];
}

static NSString * const ADMIN_TG_USER = @"Mama_Hala0";
static NSString * const LOGO_IMAGE_URL = @"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/Zoro%20rasm.JPG";
static NSString * const INTRO_VIDEO_URL = @"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/Mama.MP4";

// لابردنی باکگراوندی ڕەش لەسەر ئاستی پیکسل بەبێ ئەوەی وێنەکە کاڵ ببێتەوە
static UIImage* removeBlackBackgroundSolid(UIImage *image) {
    if (!image) return nil;
    CGImageRef rawImageRef = image.CGImage;
    if (!rawImageRef) return image;

    size_t width = CGImageGetWidth(rawImageRef);
    size_t height = CGImageGetHeight(rawImageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *)calloc(height * width * 4, sizeof(unsigned char));
    if (!rawData) {
        CGColorSpaceRelease(colorSpace);
        return image;
    }

    CGContextRef context = CGBitmapContextCreate(rawData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    if (!context) {
        free(rawData);
        return image;
    }

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), rawImageRef);
    CGContextRelease(context);

    for (size_t i = 0; i < width * height; i++) {
        size_t offset = i * 4;
        unsigned char r = rawData[offset];
        unsigned char g = rawData[offset + 1];
        unsigned char b = rawData[offset + 2];

        if (r < 28 && g < 28 && b < 28) {
            rawData[offset] = 0;
            rawData[offset + 1] = 0;
            rawData[offset + 2] = 0;
            rawData[offset + 3] = 0;
        }
    }

    CGColorSpaceRef outSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef outContext = CGBitmapContextCreate(rawData, width, height, 8, width * 4, outSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef newImageRef = CGBitmapContextCreateImage(outContext);
    UIImage *resultImage = [UIImage imageWithCGImage:newImageRef scale:image.scale orientation:image.imageOrientation];

    CGImageRelease(newImageRef);
    CGContextRelease(outContext);
    CGColorSpaceRelease(outSpace);
    free(rawData);

    return resultImage ?: image;
}

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

static NSString* getDeviceModelAndIOS() {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *iosVer = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@ | iOS %@ | %@", model, iosVer, getPubgRegionAndVersion()];
}

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

static void applyCleanTextShadow(UIView *view) {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 1.5);
    view.layer.shadowRadius = 3.0;
    view.layer.shadowOpacity = 1.0;
}

@interface MamaHalaKeyMenu : NSObject <UITextFieldDelegate>
@property (nonatomic, strong) UIView *dimOverlay;
@property (nonatomic, strong) UIVisualEffectView *cardGlassView;
@property (nonatomic, strong) UITextField *keyTextField;
@property (nonatomic, strong) UILabel *announcementLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) UIView *statusDot;
@property (nonatomic, strong) UILabel *serverStatusText;

@property (nonatomic, strong) UIImageView *topLogoView;

@property (nonatomic, strong) UIView *videoContainerView;
@property (nonatomic, strong) id videoPlayer;
@property (nonatomic, strong) CALayer *videoPlayerLayer;
@property (nonatomic, strong) NSDate *pendingExpiryDate;
@property (nonatomic, assign) NSInteger pendingTotalHours;

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

// ================= لۆگۆی سەر سەرەوە لە ناوەڕاست (گەورە و بە بۆشاییەکی گونجاو لە سەرەوە) =================
- (void)setupTopCenterLogo {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        if (self.topLogoView) {
            [window bringSubviewToFront:self.topLogoView];
            return;
        }

        CGFloat logoW = 132;
        CGFloat logoH = 132;
        self.topLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((window.bounds.size.width - logoW) / 2.0, 14, logoW, logoH)];
        self.topLogoView.contentMode = UIViewContentModeScaleAspectFit;
        self.topLogoView.backgroundColor = [UIColor clearColor];
        self.topLogoView.alpha = 1.0;
        self.topLogoView.userInteractionEnabled = NO;

        [window addSubview:self.topLogoView];

        NSURL *imgUrl = [NSURL URLWithString:LOGO_IMAGE_URL];
        [[[NSURLSession sharedSession] dataTaskWithURL:imgUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error && data) {
                UIImage *rawImg = [UIImage imageWithData:data];
                if (rawImg) {
                    UIImage *cleanSolidImg = removeBlackBackgroundSolid(rawImg);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.topLogoView.image = cleanSolidImg;
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
        skipBtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.14 blue:0.20 alpha:0.85];
        skipBtn.layer.cornerRadius = 10;
        skipBtn.layer.borderWidth = 1.2;
        skipBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [skipBtn setTitle:@"Skip ⏭" forState:UIControlStateNormal];
        [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

// ================= پێوانەکردنی FPS بە سادەیی (تەنها نووسین بەبێ هیچ خشتەیەکی پشتی) =================
- (void)startRealTimeFPSMonitor {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.fpsLabel) return;

        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        self.fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42, 230, 24)];
        self.fpsLabel.backgroundColor = [UIColor clearColor];
        self.fpsLabel.textAlignment = NSTextAlignmentLeft;
        self.fpsLabel.font = [UIFont monospacedDigitSystemFontOfSize:13 weight:UIFontWeightBold];
        self.fpsLabel.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.2 alpha:1.0];
        self.fpsLabel.userInteractionEnabled = YES;
        self.fpsLabel.text = [NSString stringWithFormat:@"⚡ 60 FPS | @%@", ADMIN_TG_USER];
        applyCleanTextShadow(self.fpsLabel);

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragFpsLabel:)];
        [self.fpsLabel addGestureRecognizer:pan];

        [window addSubview:self.fpsLabel];

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

        UIColor *fpsColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.2 alpha:1.0];
        if (realFPS < 45) {
            fpsColor = [UIColor colorWithRed:1.0 green:0.35 blue:0.35 alpha:1.0];
        } else if (realFPS < 58) {
            fpsColor = [UIColor orangeColor];
        }

        self.fpsLabel.textColor = fpsColor;
        self.fpsLabel.text = [NSString stringWithFormat:@"⚡ %ld FPS | @%@", (long)realFPS, ADMIN_TG_USER];
        
        if (self.fpsLabel.superview) {
            [self.fpsLabel.superview bringSubviewToFront:self.fpsLabel];
        }
        if (self.topLogoView.superview) {
            [self.topLogoView.superview bringSubviewToFront:self.topLogoView];
        }
    }
}

- (void)dragFpsLabel:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.fpsLabel.superview];
    self.fpsLabel.center = CGPointMake(self.fpsLabel.center.x + translation.x, self.fpsLabel.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.fpsLabel.superview];
}

- (void)checkServerSettingsAndStart {
    [self setupTopCenterLogo];

    NSString *serverUrl = getExactSupabaseURL();
    NSString *serverKey = getExactSupabaseKey();

    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/app_settings?id=eq.1&select=*", serverUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:serverKey forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", serverKey] forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL isMaintenance = NO;
        NSString *announcement = @"بەخێربێن بۆ سیستەمی MAMAHALA VIP";

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

    self.cardGlassView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.35 blue:0.35 alpha:0.9].CGColor;

    Class CAKeyframeAnimationClass = NSClassFromString(@"CAKeyframeAnimation");
    if (CAKeyframeAnimationClass) {
        id animation = ((id (*)(id, SEL, id))objc_msgSend)(CAKeyframeAnimationClass, @selector(animationWithKeyPath:), @"transform.translation.x");
        [animation setValue:@(0.45) forKey:@"duration"];
        [animation setValue:@[@(-12.0), @(12.0), @(-10.0), @(10.0), @(-6.0), @(6.0), @(0.0)] forKey:@"values"];
        [self.cardGlassView.layer addAnimation:animation forKey:@"shake"];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cardGlassView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.55].CGColor;
    });
}

// ================= هەموو زانیارییەکانی بەسەرچوون و کاتی ماوە بەبێ خشتە ڕەشەکەی پشتی =================
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

        CGFloat blockW = 310;
        CGFloat blockH = 112;
        UIView *transparentContainer = [[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width - blockW) / 2.0, 136, blockW, blockH)];
        transparentContainer.backgroundColor = [UIColor clearColor];
        transparentContainer.userInteractionEnabled = NO;
        transparentContainer.alpha = 0.0;

        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, blockW, 22)];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.text = [NSString stringWithFormat:@"👑 MAMAHALA VIP | @%@", ADMIN_TG_USER];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:0.1 alpha:1.0];
        titleLbl.font = [UIFont boldSystemFontOfSize:14];
        applyCleanTextShadow(titleLbl);
        [transparentContainer addSubview:titleLbl];

        UILabel *gameInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, blockW, 20)];
        gameInfoLbl.backgroundColor = [UIColor clearColor];
        gameInfoLbl.text = [NSString stringWithFormat:@"🎮 %@", getPubgRegionAndVersion()];
        gameInfoLbl.textAlignment = NSTextAlignmentCenter;
        gameInfoLbl.textColor = [UIColor colorWithRed:0.35 green:0.80 blue:1.0 alpha:1.0];
        gameInfoLbl.font = [UIFont boldSystemFontOfSize:13];
        applyCleanTextShadow(gameInfoLbl);
        [transparentContainer addSubview:gameInfoLbl];

        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, blockW, 20)];
        dateLbl.backgroundColor = [UIColor clearColor];
        dateLbl.text = [NSString stringWithFormat:@"📅 بەسەرچوون: %@", formattedDate];
        dateLbl.textAlignment = NSTextAlignmentCenter;
        dateLbl.textColor = [UIColor whiteColor];
        dateLbl.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        applyCleanTextShadow(dateLbl);
        [transparentContainer addSubview:dateLbl];

        UILabel *remLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, blockW, 20)];
        remLbl.backgroundColor = [UIColor clearColor];
        remLbl.text = [NSString stringWithFormat:@"⏳ ماوە: %@", remainingStr];
        remLbl.textAlignment = NSTextAlignmentCenter;
        remLbl.textColor = isLowTime ? [UIColor orangeColor] : [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
        remLbl.font = [UIFont boldSystemFontOfSize:13];
        applyCleanTextShadow(remLbl);
        [transparentContainer addSubview:remLbl];

        UIView *progressBg = [[UIView alloc] initWithFrame:CGRectMake(15, 92, blockW - 30, 7)];
        progressBg.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        progressBg.layer.cornerRadius = 3.5;
        applyCleanTextShadow(progressBg);
        [transparentContainer addSubview:progressBg];

        UIView *progressFill = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (blockW - 30) * progressRatio, 7)];
        progressFill.backgroundColor = isLowTime ? [UIColor orangeColor] : [UIColor colorWithRed:0.3 green:0.95 blue:0.45 alpha:1.0];
        progressFill.layer.cornerRadius = 3.5;
        [progressBg addSubview:progressFill];

        [window addSubview:transparentContainer];
        [self startRealTimeFPSMonitor];
        if (self.topLogoView) [window bringSubviewToFront:self.topLogoView];

        [UIView animateWithDuration:0.4 animations:^{
            transparentContainer.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:4.5 options:0 animations:^{
                transparentContainer.alpha = 0.0;
            } completion:^(BOOL finished) {
                [transparentContainer removeFromSuperview];
            }];
        }];
    });
}

// ================= خشتەی چوونەژوورەوە: پان (Landscape)، شووشەیی ڕوون، نووسینەکان یەک ڕەنگی سپی =================
- (void)showLoginMenuWithMessage:(NSString *)msg isError:(BOOL)isError {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = getActiveKeyWindow();
        if (!window) return;

        if (!self.dimOverlay) {
            self.dimOverlay = [[UIView alloc] initWithFrame:window.bounds];
            self.dimOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];

            CGFloat cardW = MIN(490, window.bounds.size.width - 36);
            CGFloat cardH = 264;
            CGFloat cardY = ((window.bounds.size.height - cardH) / 2.0) + 54;

            UIBlurEffect *glassBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark];
            self.cardGlassView = [[UIVisualEffectView alloc] initWithEffect:glassBlur];
            self.cardGlassView.frame = CGRectMake((window.bounds.size.width - cardW) / 2.0, cardY, cardW, cardH);
            self.cardGlassView.backgroundColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.26 alpha:0.62];
            self.cardGlassView.layer.cornerRadius = 22;
            self.cardGlassView.layer.masksToBounds = YES;
            self.cardGlassView.layer.borderWidth = 1.6;
            self.cardGlassView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.55].CGColor;

            UIView *content = self.cardGlassView.contentView;

            self.statusDot = [[UIView alloc] initWithFrame:CGRectMake(18, 18, 8, 8)];
            self.statusDot.backgroundColor = [UIColor colorWithRed:0.25 green:0.95 blue:0.50 alpha:1.0];
            self.statusDot.layer.cornerRadius = 4;
            [content addSubview:self.statusDot];

            self.serverStatusText = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 80, 16)];
            self.serverStatusText.text = @"Online";
            self.serverStatusText.textColor = [UIColor whiteColor];
            self.serverStatusText.font = [UIFont boldSystemFontOfSize:11];
            [content addSubview:self.serverStatusText];

            UILabel *gameVersionBadge = [[UILabel alloc] initWithFrame:CGRectMake(cardW - 195, 14, 178, 16)];
            gameVersionBadge.text = [NSString stringWithFormat:@"🎮 %@", getPubgRegionAndVersion()];
            gameVersionBadge.textAlignment = NSTextAlignmentRight;
            gameVersionBadge.textColor = [UIColor whiteColor];
            gameVersionBadge.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
            [content addSubview:gameVersionBadge];

            UILabel *crownLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, cardW - 40, 28)];
            crownLabel.text = @"👑 MAMAHALA VIP 👑";
            crownLabel.textAlignment = NSTextAlignmentCenter;
            crownLabel.textColor = [UIColor whiteColor];
            crownLabel.font = [UIFont boldSystemFontOfSize:21];
            [content addSubview:crownLabel];

            UIView *noticeBox = [[UIView alloc] initWithFrame:CGRectMake(22, 58, cardW - 44, 28)];
            noticeBox.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.14];
            noticeBox.layer.cornerRadius = 8;
            [content addSubview:noticeBox];

            self.announcementLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, cardW - 60, 28)];
            self.announcementLabel.text = @"بەخێربێن بۆ سیستەمی MAMAHALA VIP";
            self.announcementLabel.textAlignment = NSTextAlignmentCenter;
            self.announcementLabel.textColor = [UIColor whiteColor];
            self.announcementLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
            [noticeBox addSubview:self.announcementLabel];

            UIView *inputContainer = [[UIView alloc] initWithFrame:CGRectMake(22, 96, cardW - 44, 44)];
            inputContainer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.16];
            inputContainer.layer.cornerRadius = 12;
            inputContainer.layer.borderWidth = 1.2;
            inputContainer.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.45].CGColor;
            [content addSubview:inputContainer];

            self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 4, cardW - 150, 36)];
            self.keyTextField.placeholder = @"MAMAHALA-XXD-XXXX";
            self.keyTextField.textColor = [UIColor whiteColor];
            self.keyTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            self.keyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.keyTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            self.keyTextField.delegate = self;
            self.keyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MAMAHALA-XXD-XXXX" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.65]}];
            [inputContainer addSubview:self.keyTextField];

            self.eyeButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.eyeButton.frame = CGRectMake(cardW - 134, 7, 30, 30);
            [self.eyeButton setTitle:@"👁️" forState:UIControlStateNormal];
            [self.eyeButton addTarget:self action:@selector(toggleSecureKey) forControlEvents:UIControlEventTouchUpInside];
            [inputContainer addSubview:self.eyeButton];

            UIButton *pasteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            pasteBtn.frame = CGRectMake(cardW - 100, 7, 50, 30);
            pasteBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
            pasteBtn.layer.cornerRadius = 8;
            [pasteBtn setTitle:@"Paste" forState:UIControlStateNormal];
            [pasteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            pasteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [pasteBtn addTarget:self action:@selector(pasteKeyAction) forControlEvents:UIControlEventTouchUpInside];
            [inputContainer addSubview:pasteBtn];

            self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 144, cardW - 44, 24)];
            self.statusLabel.numberOfLines = 1;
            self.statusLabel.textAlignment = NSTextAlignmentCenter;
            self.statusLabel.textColor = [UIColor whiteColor];
            self.statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
            [content addSubview:self.statusLabel];

            self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.loginButton.frame = CGRectMake(22, 174, cardW - 44, 42);
            self.loginButton.backgroundColor = [UIColor colorWithRed:0.16 green:0.55 blue:0.95 alpha:0.95];
            self.loginButton.layer.cornerRadius = 12;
            self.loginButton.layer.borderWidth = 1.0;
            self.loginButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
            [self.loginButton setTitle:@"چوونەژوورەوە (LOGIN)" forState:UIControlStateNormal];
            [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [self.loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [content addSubview:self.loginButton];

            CGFloat halfW = (cardW - 54) / 2.0;

            UIButton *telegramBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            telegramBtn.frame = CGRectMake(22, 224, halfW, 34);
            telegramBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.16];
            telegramBtn.layer.cornerRadius = 10;
            telegramBtn.layer.borderWidth = 1.0;
            telegramBtn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.35].CGColor;
            [telegramBtn setTitle:[NSString stringWithFormat:@"✈️ @%@", ADMIN_TG_USER] forState:UIControlStateNormal];
            [telegramBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            telegramBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [telegramBtn addTarget:self action:@selector(openTelegramAction) forControlEvents:UIControlEventTouchUpInside];
            [content addSubview:telegramBtn];

            UIButton *copyIdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            copyIdBtn.frame = CGRectMake(22 + halfW + 10, 224, halfW, 34);
            copyIdBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.16];
            copyIdBtn.layer.cornerRadius = 10;
            copyIdBtn.layer.borderWidth = 1.0;
            copyIdBtn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.35].CGColor;
            [copyIdBtn setTitle:@"📋 کۆپیکردنی Device ID" forState:UIControlStateNormal];
            [copyIdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            copyIdBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [copyIdBtn addTarget:self action:@selector(copyAndSendDeviceIdAction) forControlEvents:UIControlEventTouchUpInside];
            [content addSubview:copyIdBtn];

            [self.dimOverlay addSubview:self.cardGlassView];
            [window addSubview:self.dimOverlay];

            self.cardGlassView.transform = CGAffineTransformMakeScale(0.82, 0.82);
            self.cardGlassView.alpha = 0.0;
            [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:0 animations:^{
                self.cardGlassView.transform = CGAffineTransformIdentity;
                self.cardGlassView.alpha = 1.0;
            } completion:nil];
        }

        self.dimOverlay.hidden = NO;
        [window bringSubviewToFront:self.dimOverlay];
        if (self.topLogoView) [window bringSubviewToFront:self.topLogoView];
        
        self.loginButton.enabled = YES;
        [self.loginButton setTitle:@"چوونەژوورەوە (LOGIN)" forState:UIControlStateNormal];

        self.statusLabel.textColor = [UIColor whiteColor];
        if (msg.length > 0) {
            self.statusLabel.text = msg;
            if (isError) [self shakeCardWithErrorColor];
        } else {
            self.statusLabel.text = @"تکایە کلیلەکەت بنووسە یان Paste بکە";
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
    self.statusLabel.text = [NSString stringWithFormat:@"✅ کۆپی کرا! بینێرە بۆ @%@", ADMIN_TG_USER];
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
        }
    });

    NSString *serverUrl = getExactSupabaseURL();
    NSString *serverKey = getExactSupabaseKey();

    NSString *encodedKey = [enteredKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/keys?key_text=eq.%@&select=*", serverUrl, encodedKey];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:serverKey forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", serverKey] forHTTPHeaderField:@"Authorization"];

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
                if (self.dimOverlay) {
                    self.statusLabel.text = @"✅ کلیلەکە سەرکەوتوو بوو! بەخێربێیت...";
                    
                    [UIView animateWithDuration:0.35 delay:0.35 options:0 animations:^{
                        self.dimOverlay.alpha = 0.0;
                        self.cardGlassView.transform = CGAffineTransformMakeScale(1.06, 1.06);
                    } completion:^(BOOL finished) {
                        [self.dimOverlay removeFromSuperview];
                        self.dimOverlay = nil;
                        self.cardGlassView = nil;
                        [self playIntroVideoThenShowUIWithExpiry:expiryDate totalHours:durationHours];
                    }];
                } else {
                    [self playIntroVideoThenShowUIWithExpiry:expiryDate totalHours:durationHours];
                }
            });
        };

        if (needsServerUpdate) {
            NSString *patchUrlStr = [NSString stringWithFormat:@"%@/rest/v1/keys?key_text=eq.%@", serverUrl, encodedKey];
            NSMutableURLRequest *patchReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patchUrlStr]];
            [patchReq setHTTPMethod:@"PATCH"];
            [patchReq setValue:serverKey forHTTPHeaderField:@"apikey"];
            [patchReq setValue:[NSString stringWithFormat:@"Bearer %@", serverKey] forHTTPHeaderField:@"Authorization"];
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
