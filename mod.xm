#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <objc/message.h>
#import <dlfcn.h>

static id introPlayer = nil;
static CALayer *introPlayerLayer = nil;
static UIView *videoContainer = nil;
static UIView *menuOverlay = nil;

// کڵاسێکی یارمەتیدەر بۆ مامەڵەکردن لەگەڵ دوگمەکانی Skip و OK
@interface BloodMenuHandler : NSObject
+ (instancetype)shared;
- (void)skipTapped;
- (void)okTapped;
@end

static void playFullScreenVideo(UIWindow *keyWindow) {
    if (!keyWindow) return;
    
    dlopen("/System/Library/Frameworks/AVFoundation.framework/AVFoundation", RTLD_LAZY);
    
    Class AVPlayerItemClass = NSClassFromString(@"AVPlayerItem");
    Class AVPlayerClass = NSClassFromString(@"AVPlayer");
    Class AVPlayerLayerClass = NSClassFromString(@"AVPlayerLayer");
    
    if (!AVPlayerItemClass || !AVPlayerClass || !AVPlayerLayerClass) return;
    
    // بەستەری ڕاستەوخۆی (Raw) ڤیدیۆی Mama.MOV لە گیتهەب
    NSURL *videoURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/Mama.MOV"];
    
    videoContainer = [[UIView alloc] initWithFrame:keyWindow.bounds];
    videoContainer.backgroundColor = [UIColor blackColor];
    videoContainer.userInteractionEnabled = NO;
    videoContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    id playerItem = ((id (*)(Class, SEL, NSURL *))objc_msgSend)(AVPlayerItemClass, sel_registerName("playerItemWithURL:"), videoURL);
    introPlayer = ((id (*)(Class, SEL, id))objc_msgSend)(AVPlayerClass, sel_registerName("playerWithPlayerItem:"), playerItem);
    
    // دەنگی ڤیدیۆکە کراوە بێت
    ((void (*)(id, SEL, BOOL))objc_msgSend)(introPlayer, sel_registerName("setMuted:"), NO);
    
    introPlayerLayer = ((CALayer * (*)(Class, SEL, id))objc_msgSend)(AVPlayerLayerClass, sel_registerName("playerLayerWithPlayer:"), introPlayer);
    introPlayerLayer.frame = videoContainer.bounds;
    [introPlayerLayer setValue:@"AVLayerVideoGravityResizeAspectFill" forKey:@"videoGravity"];
    
    [videoContainer.layer addSublayer:introPlayerLayer];
    [keyWindow addSubview:videoContainer];
    
    ((void (*)(id, SEL))objc_msgSend)(introPlayer, sel_registerName("play"));
    
    // کاتێک ڤیدیۆکە تەواو بوو بە هێواشی لادەچێت
    [[NSNotificationCenter defaultCenter] addObserverForName:@"AVPlayerItemDidPlayToEndTimeNotification"
                                                      object:playerItem
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
        [UIView animateWithDuration:0.5 animations:^{
            videoContainer.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (introPlayer) {
                ((void (*)(id, SEL))objc_msgSend)(introPlayer, sel_registerName("pause"));
            }
            [introPlayerLayer removeFromSuperlayer];
            [videoContainer removeFromSuperview];
            introPlayer = nil;
            introPlayerLayer = nil;
            videoContainer = nil;
        }];
    }];
}

@implementation BloodMenuHandler

+ (instancetype)shared {
    static BloodMenuHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BloodMenuHandler alloc] init];
    });
    return instance;
}

- (void)skipTapped {
    if (!menuOverlay) return;
    [UIView animateWithDuration:0.3 animations:^{
        menuOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [menuOverlay removeFromSuperview];
        menuOverlay = nil;
    }];
}

- (void)okTapped {
    if (!menuOverlay) return;
    UIWindow *parentWindow = menuOverlay.window;
    [UIView animateWithDuration:0.3 animations:^{
        menuOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [menuOverlay removeFromSuperview];
        menuOverlay = nil;
        playFullScreenVideo(parentWindow);
    }];
}

@end

static void showBloodThemedMenu() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) {
                            keyWindow = window;
                            break;
                        }
                    }
                }
            }
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }
        if (!keyWindow) return;
        
        // پاشبنەمای تاریک بۆ پشتی مینیوەکە
        menuOverlay = [[UIView alloc] initWithFrame:keyWindow.bounds];
        menuOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        menuOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        menuOverlay.alpha = 0.0;
        
        // بۆکسی سەرەکی مینیو بە ڕەنگی ڕەش و خوێناوی تۆخ
        CGFloat boxWidth = 290.0;
        CGFloat boxHeight = 165.0;
        UIView *menuBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boxWidth, boxHeight)];
        menuBox.center = CGPointMake(keyWindow.bounds.size.width / 2.0, keyWindow.bounds.size.height / 2.0);
        menuBox.backgroundColor = [UIColor colorWithRed:0.14 green:0.01 blue:0.02 alpha:0.96]; // سووری خوێناوی زۆر تۆخ
        menuBox.layer.cornerRadius = 18.0;
        menuBox.layer.borderWidth = 2.0;
        menuBox.layer.borderColor = [UIColor colorWithRed:0.75 green:0.03 blue:0.06 alpha:1.0].CGColor; // چوارچێوەی خوێناوی
        menuBox.layer.shadowColor = [UIColor colorWithRed:0.85 green:0.0 blue:0.05 alpha:1.0].CGColor;
        menuBox.layer.shadowOffset = CGSizeMake(0, 0);
        menuBox.layer.shadowRadius = 20.0;
        menuBox.layer.shadowOpacity = 0.85;
        menuBox.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        // ناونیشانی Short video
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, boxWidth - 30, 40)];
        titleLabel.text = @"Short video";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:24.0] ?: [UIFont boldSystemFontOfSize:24.0];
        titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.92 blue:0.92 alpha:1.0];
        titleLabel.layer.shadowColor = [UIColor colorWithRed:0.9 green:0.05 blue:0.1 alpha:1.0].CGColor;
        titleLabel.layer.shadowOffset = CGSizeMake(0, 0);
        titleLabel.layer.shadowRadius = 8.0;
        titleLabel.layer.shadowOpacity = 0.9;
        [menuBox addSubview:titleLabel];
        
        // هێڵێکی باریکی خوێناوی لە ژێر ناونیشانەکە
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(35, 72, boxWidth - 70, 1.5)];
        divider.backgroundColor = [UIColor colorWithRed:0.65 green:0.04 blue:0.07 alpha:0.7];
        [menuBox addSubview:divider];
        
        // دوگمەی Skip (لای چەپ)
        UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        skipBtn.frame = CGRectMake(22, 95, 112, 44);
        [skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
        [skipBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.75 blue:0.75 alpha:1.0] forState:UIControlStateNormal];
        skipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        skipBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.03 blue:0.05 alpha:1.0];
        skipBtn.layer.cornerRadius = 12.0;
        skipBtn.layer.borderWidth = 1.2;
        skipBtn.layer.borderColor = [UIColor colorWithRed:0.55 green:0.05 blue:0.08 alpha:1.0].CGColor;
        [skipBtn addTarget:[BloodMenuHandler shared] action:@selector(skipTapped) forControlEvents:UIControlEventTouchUpInside];
        [menuBox addSubview:skipBtn];
        
        // دوگمەی OK (لای ڕاست - خوێناوی تۆخ و درەوشاوە)
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        okBtn.frame = CGRectMake(boxWidth - 134, 95, 112, 44);
        [okBtn setTitle:@"OK" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:17.0] ?: [UIFont boldSystemFontOfSize:17.0];
        okBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.02 blue:0.05 alpha:1.0];
        okBtn.layer.cornerRadius = 12.0;
        okBtn.layer.borderWidth = 1.2;
        okBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.15 blue:0.2 alpha:1.0].CGColor;
        okBtn.layer.shadowColor = [UIColor colorWithRed:0.9 green:0.0 blue:0.05 alpha:1.0].CGColor;
        okBtn.layer.shadowOffset = CGSizeMake(0, 0);
        okBtn.layer.shadowRadius = 8.0;
        okBtn.layer.shadowOpacity = 0.8;
        [okBtn addTarget:[BloodMenuHandler shared] action:@selector(okTapped) forControlEvents:UIControlEventTouchUpInside];
        [menuBox addSubview:okBtn];
        
        menuBox.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [menuOverlay addSubview:menuBox];
        [keyWindow addSubview:menuOverlay];
        
        // ئەنیمەیشنی هاتنە سەر شاشەی مینیوەکە
        [UIView animateWithDuration:0.45
                              delay:0.0
             usingSpringWithDamping:0.65
              initialSpringVelocity:0.8
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            menuOverlay.alpha = 1.0;
            menuBox.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

%ctor {
    showBloodThemedMenu();
}
