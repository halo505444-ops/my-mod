#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <objc/message.h>
#import <dlfcn.h>

static id introPlayer = nil;
static CALayer *introPlayerLayer = nil;
static UIView *videoContainer = nil;

static void showAnimatedWelcomeText(UIWindow *keyWindow) {
    if (!keyWindow) return;
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, keyWindow.bounds.size.width - 40, 150)];
    welcomeLabel.center = CGPointMake(keyWindow.bounds.size.width / 2.0, keyWindow.bounds.size.height / 2.0);
    welcomeLabel.text = @"WELCOME TO\nSERVER MAMAHALA";
    welcomeLabel.numberOfLines = 2;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    
    welcomeLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:36.0] ?: [UIFont boldSystemFontOfSize:36.0];
    
    // ڕەنگی ئاڵتوونی درەوشاوە
    welcomeLabel.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:0.15 alpha:1.0];
    welcomeLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.0 alpha:1.0].CGColor;
    welcomeLabel.layer.shadowOffset = CGSizeMake(0, 0);
    welcomeLabel.layer.shadowRadius = 15.0;
    welcomeLabel.layer.shadowOpacity = 1.0;
    welcomeLabel.layer.masksToBounds = NO;
    
    welcomeLabel.alpha = 0.0;
    welcomeLabel.transform = CGAffineTransformMakeScale(0.3, 0.3);
    welcomeLabel.userInteractionEnabled = NO;
    welcomeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [keyWindow addSubview:welcomeLabel];
    
    [UIView animateWithDuration:0.9
                          delay:0.0
         usingSpringWithDamping:0.55
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        welcomeLabel.alpha = 1.0;
        welcomeLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0
                              delay:4.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            welcomeLabel.alpha = 0.0;
            welcomeLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [welcomeLabel removeFromSuperview];
        }];
    }];
}

static void finishVideoAndShowText(UIWindow *keyWindow) {
    if (!videoContainer) return;
    
    [UIView animateWithDuration:0.6 animations:^{
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
        
        showAnimatedWelcomeText(keyWindow);
    }];
}

static void setupFullScreenIntro() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // کردنەوەی AVFoundation بە شێوەی داینامیکی بەبێ پێویستبوون بە Makefile
        dlopen("/System/Library/Frameworks/AVFoundation.framework/AVFoundation", RTLD_LAZY);
        
        Class AVPlayerItemClass = NSClassFromString(@"AVPlayerItem");
        Class AVPlayerClass = NSClassFromString(@"AVPlayer");
        Class AVPlayerLayerClass = NSClassFromString(@"AVPlayerLayer");
        
        if (!AVPlayerItemClass || !AVPlayerClass || !AVPlayerLayerClass) return;
        
        NSURL *videoURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/Hala.MP4"];
        
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
        
        if (keyWindow) {
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
            
            // دەستپێکردنی لێدانی ڤیدیۆکە
            ((void (*)(id, SEL))objc_msgSend)(introPlayer, sel_registerName("play"));
            
            // کاتێک ڤیدیۆکە تەواو بوو
            [[NSNotificationCenter defaultCenter] addObserverForName:@"AVPlayerItemDidPlayToEndTimeNotification"
                                                              object:playerItem
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:^(NSNotification *note) {
                finishVideoAndShowText(keyWindow);
            }];
            
            // یان دوای ٢٣ چرکە بە تەواوی
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(23.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                finishVideoAndShowText(keyWindow);
            });
        }
    });
}

%ctor {
    setupFullScreenIntro();
}
