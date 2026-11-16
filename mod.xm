#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

static AVPlayer *introPlayer = nil;
static AVPlayerLayer *introPlayerLayer = nil;
static UIView *videoContainer = nil;

static void showAnimatedWelcomeText(UIWindow *keyWindow) {
    if (!keyWindow) return;
    
    // دروستکردنی لێبڵی نووسینەکە لە ناوەڕاستی شاشە
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, keyWindow.bounds.size.width - 40, 150)];
    welcomeLabel.center = CGPointMake(keyWindow.bounds.size.width / 2.0, keyWindow.bounds.size.height / 2.0);
    welcomeLabel.text = @"WELCOME TO\nSERVER MAMAHALA";
    welcomeLabel.numberOfLines = 2;
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    
    // فۆنتی گەورە و ئەستوور
    welcomeLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:36.0] ?: [UIFont boldSystemFontOfSize:36.0];
    
    // ڕەنگێکی ئاڵتوونی جوان لەگەڵ سێبەری درەوشاوە (Glow)
    welcomeLabel.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:0.15 alpha:1.0];
    welcomeLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.0 alpha:1.0].CGColor;
    welcomeLabel.layer.shadowOffset = CGSizeMake(0, 0);
    welcomeLabel.layer.shadowRadius = 15.0;
    welcomeLabel.layer.shadowOpacity = 1.0;
    welcomeLabel.layer.masksToBounds = NO;
    
    // ئامادەکردن بۆ ئەنیمەیشن (سەرەتا بچووک و نادیار)
    welcomeLabel.alpha = 0.0;
    welcomeLabel.transform = CGAffineTransformMakeScale(0.3, 0.3);
    welcomeLabel.userInteractionEnabled = NO;
    welcomeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [keyWindow addSubview:welcomeLabel];
    
    // ئەنیمەیشنی هاتنە ناوەوە بە شێوەی سپرینگ (Spring)
    [UIView animateWithDuration:0.9
                          delay:0.0
         usingSpringWithDamping:0.55
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        welcomeLabel.alpha = 1.0;
        welcomeLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // مانەوەی نووسینەکە بۆ ماوەی ٤ چرکە و پاشان ونبوونی بە هێواشی
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
        [introPlayer pause];
        [introPlayerLayer removeFromSuperlayer];
        [videoContainer removeFromSuperview];
        introPlayer = nil;
        introPlayerLayer = nil;
        videoContainer = nil;
        
        // پیشاندانی نووسینە ئەنیمەیشنەکە
        showAnimatedWelcomeText(keyWindow);
    }];
}

static void setupFullScreenIntro() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // بەستەری ڕاستەوخۆی (Raw) ڤیدیۆکەت لە گیتهەب
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
            // داپۆشینی تەواوی شاشەکە
            videoContainer = [[UIView alloc] initWithFrame:keyWindow.bounds];
            videoContainer.backgroundColor = [UIColor blackColor];
            videoContainer.userInteractionEnabled = NO; // بۆ ئەوەی دەستلێدان نەوەستێت
            videoContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoURL];
            introPlayer = [AVPlayer playerWithPlayerItem:playerItem];
            introPlayer.muted = NO; // دەنگی ڤیدیۆکە کار دەکات (ئەگەر دەتەوێت بێ دەنگ بێت بیکە بە YES)
            
            introPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:introPlayer];
            introPlayerLayer.frame = videoContainer.bounds;
            introPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // پڕکردنەوەی تەواوی شاشەکە
            
            [videoContainer.layer addSublayer:introPlayerLayer];
            [keyWindow addSubview:videoContainer];
            
            [introPlayer play];
            
            // کاتێک ڤیدیۆکە تەواو بوو یان دوای ٢٣ چرکە، ڤیدیۆکە لادەچێت و نووسینەکە دێت
            [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                              object:playerItem
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:^(NSNotification *note) {
                finishVideoAndShowText(keyWindow);
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(23.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                finishVideoAndShowText(keyWindow);
            });
        }
    });
}

%ctor {
    setupFullScreenIntro();
}
