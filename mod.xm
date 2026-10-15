#import <UIKit/UIKit.h>

// دروستکردنی ڕوکارێکی سەرنجڕاکێش و ئەنیمی (UI)
@interface ShazaVIPManager : NSObject
+ (void)showWelcomeBanner;
@end

@implementation ShazaVIPManager

+ (void)showWelcomeBanner {
    // دڵنیابوونەوە لەوەی لەسەر مینی مەین ویندۆوە
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) return;

        // دروستکردنی لایەری سەرەکی (Container View)
        UIView *bannerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, keyWindow.bounds.size.width, 150)];
        bannerContainer.center = CGPointMake(keyWindow.bounds.size.width / 2, keyWindow.bounds.size.height / 3);
        bannerContainer.userInteractionEnabled = NO;
        
        // نووسینی سەرەکی: ⚡️SHAZAVIP⚡️
        UILabel *mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bannerContainer.bounds.size.width, 70)];
        mainTitle.text = @"⚡️SHAZAVIP⚡️";
        mainTitle.textAlignment = NSTextAlignmentCenter;
        mainTitle.font = [UIFont boldSystemFontOfSize:38];
        mainTitle.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]; // زێڕی
        
        // زیادکردنی بریقە (Glow Effect) بۆ نووسینی سەرەکی
        mainTitle.layer.shadowColor = [UIColor cyanColor].CGColor;
        mainTitle.layer.shadowRadius = 10.0f;
        mainTitle.layer.shadowOpacity = 0.9f;
        mainTitle.layer.shadowOffset = CGSizeZero;
        
        // نووسینی دووەم: 💥WELCOME TO SERVER MAMAHALA💥
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, bannerContainer.bounds.size.width, 40)];
        subTitle.text = @"💥WELCOME TO SERVER MAMAHALA💥";
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.font = [UIFont boldSystemFontOfSize:16];
        subTitle.textColor = [UIColor colorWithRed:1.0 green:0.27 blue:0.0 alpha:1.0]; // پڕتەقالی / سور
        
        subTitle.layer.shadowColor = [UIColor magentaColor].CGColor;
        subTitle.layer.shadowRadius = 8.0f;
        subTitle.layer.shadowOpacity = 0.8f;
        subTitle.layer.shadowOffset = CGSizeZero;

        // کۆکردنەوەی لایەرەکان
        [bannerContainer addSubview:mainTitle];
        [bannerContainer addSubview:subTitle];
        [keyWindow addSubview:bannerContainer];

        // ئەنیمەیشنی دەرکەوتن و جووڵە (Fade In & Scale)
        bannerContainer.transform = CGAffineTransformMakeScale(0.1, 0.1);
        bannerContainer.alpha = 0.0;
        
        [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            bannerContainer.transform = CGAffineTransformIdentity;
            bannerContainer.alpha = 1.0;
        } completion:^(BOOL finished) {
            // لابردنی پاش ٢٠ چرکە یان دوای تەواوبوون
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    bannerContainer.alpha = 0.0;
                } completion:^(BOOL finished2) {
                    [bannerContainer removeFromSuperview];
                }];
            });
        }];
    });
}

@end

// بەکارهێنانی Logos Hook بۆ کاتی چوونە ژوورەوە بۆ یارییەکە یان کارپێکردنی تابلۆکە
%ctor {
    // چاوەڕێکردنی ٢٠ چرکە دوای ئەوەی یارییەکە دەستپێدەکات
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ShazaVIPManager showWelcomeBanner];
    });
}
