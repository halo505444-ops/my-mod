#import <UIKit/UIKit.h>

@interface ShazaVIPTypewriterManager : NSObject
+ (void)startAnimation;
@end

@implementation ShazaVIPTypewriterManager

+ (void)startAnimation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // دۆزینەوەی پەنجەرەی کارای یارییەکە
            UIWindow *keyWindow = nil;
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
            if (!keyWindow) {
                keyWindow = [UIApplication sharedApplication].windows.firstObject;
            }
            if (!keyWindow) return;

            // دروستکردنی باگراوندی دەقەکان لە شاشەدا
            UIView *bannerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, keyWindow.bounds.size.width, 160)];
            bannerContainer.center = CGPointMake(keyWindow.bounds.size.width / 2, keyWindow.bounds.size.height / 3);
            bannerContainer.userInteractionEnabled = NO;

            // نووسینی سەرەکی: ⚡️SHAZAVIP⚡️
            UILabel *mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bannerContainer.bounds.size.width, 70)];
            mainTitle.text = @"";
            mainTitle.textAlignment = NSTextAlignmentCenter;
            mainTitle.font = [UIFont boldSystemFontOfSize:38];
            mainTitle.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]; // ڕەنگی زێڕی
            
            // زیادکردنی بریقە (Glow) بۆ نووسینی سەرەکی
            mainTitle.layer.shadowColor = [UIColor cyanColor].CGColor;
            mainTitle.layer.shadowRadius = 12.0f;
            mainTitle.layer.shadowOpacity = 0.9f;
            mainTitle.layer.shadowOffset = CGSizeZero;

            // نووسینی خوارەوە: 💥WELCOME TO SERVER MAMAHALA💥
            UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, bannerContainer.bounds.size.width, 40)];
            subTitle.text = @"";
            subTitle.textAlignment = NSTextAlignmentCenter;
            subTitle.font = [UIFont boldSystemFontOfSize:15];
            subTitle.textColor = [UIColor colorWithRed:1.0 green:0.27 blue:0.0 alpha:1.0]; // ڕەنگی پڕتەقالی
            
            // زیادکردنی بریقە بۆ نووسینی خوارەوە
            subTitle.layer.shadowColor = [UIColor magentaColor].CGColor;
            subTitle.layer.shadowRadius = 8.0f;
            subTitle.layer.shadowOpacity = 0.8f;
            subTitle.layer.shadowOffset = CGSizeZero;

            [bannerContainer addSubview:mainTitle];
            [bannerContainer addSubview:subTitle];
            [keyWindow addSubview:bannerContainer];

            // دەقە ڕاستەقینەکان کە پیت بە پیت دەردەکەون
            NSString *fullMainText = @"⚡️SHAZAVIP⚡️";
            NSString *fullSubText = @"💥WELCOME TO SERVER MAMAHALA💥";

            // هێنانی پیت بە پیت بۆ نووسینی سەرەکی
            __block int mainIndex = 0;
            [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (mainIndex <= fullMainText.length) {
                    mainTitle.text = [fullMainText substringToIndex:mainIndex];
                    mainIndex++;
                } else {
                    [timer invalidate];
                    
                    // کاتێک سەرەکی تەواو بوو، دەست بە نووسینی خوارەوە دەکات پیت بە پیت
                    __block int subIndex = 0;
                    [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull subTimerRef) {
                        if (subIndex <= fullSubText.length) {
                            subTitle.text = [fullSubText substringToIndex:subIndex];
                            subIndex++;
                        } else {
                            [subTimerRef invalidate];
                            
                            // ماوەی مانەوەی بۆ ٣ چرکە، پاشان پیت بە پیت دەسڕێتەوە و دەڕوات
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                __block int subRemoveIndex = fullSubText.length;
                                [NSTimer scheduledTimerWithTimeInterval:0.03 repeats:YES block:^(NSTimer * _Nonnull delTimerRef) {
                                    if (subRemoveIndex >= 0) {
                                        subTitle.text = [fullSubText substringToIndex:subRemoveIndex];
                                        subRemoveIndex--;
                                    } else {
                                        [delTimerRef invalidate];
                                        
                                        __block int mainRemoveIndex = fullMainText.length;
                                        [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull mainDelRef) {
                                            if (mainRemoveIndex >= 0) {
                                                mainTitle.text = [fullMainText substringToIndex:mainRemoveIndex];
                                                mainRemoveIndex--;
                                            } else {
                                                [mainDelRef invalidate];
                                                [bannerContainer removeFromSuperview]; // لادانی تەواوی شاشەکە
                                            }
                                        }];
                                    }
                                }];
                            });
                        }
                    }];
                }
            }];
        });
    });
}

@end

// کارپێکردنی ڕاستەوخۆ کاتێک یارییەکە دەکرێتەوە
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ShazaVIPTypewriterManager startAnimation];
    });
}
