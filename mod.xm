#import <UIKit/UIKit.h>

@interface ShazaVIPTypewriterManager : NSObject
+ (void)startAnimation;
@end

@implementation ShazaVIPTypewriterManager

+ (void)startAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) return;

        // دروستکردنی لایەری سەرەکی
        UIView *bannerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, keyWindow.bounds.size.width, 160)];
        bannerContainer.center = CGPointMake(keyWindow.bounds.size.width / 2, keyWindow.bounds.size.height / 3);
        bannerContainer.userInteractionEnabled = NO;

        // نووسینی سەرەکی (⚡️SHAZAVIP⚡️)
        UILabel *mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bannerContainer.bounds.size.width, 70)];
        mainTitle.textText = @""; // سەرەتا بەتاڵە بۆ ئەوەی پیت بە پیت بێت
        mainTitle.textAlignment = NSTextAlignmentCenter;
        mainTitle.font = [UIFont boldSystemFontOfSize:38];
        mainTitle.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]; // زێڕی
        
        // بریقە (Glow)
        mainTitle.layer.shadowColor = [UIColor cyanColor].CGColor;
        mainTitle.layer.shadowRadius = 12.0f;
        mainTitle.layer.shadowOpacity = 0.9f;
        mainTitle.layer.shadowOffset = CGSizeZero;

        // نووسینی خوارەوە (💥WELCOME TO SERVER MAMAHALA💥)
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, bannerContainer.bounds.size.width, 40)];
        subTitle.text = @"";
        subTitle.textAlignment = NSTextAlignmentCenter;
        subTitle.font = [UIFont boldSystemFontOfSize:15];
        subTitle.textColor = [UIColor colorWithRed:1.0 green:0.27 blue:0.0 alpha:1.0]; // پڕتەقالی
        
        subTitle.layer.shadowColor = [UIColor magentaColor].CGColor;
        subTitle.layer.shadowRadius = 8.0f;
        subTitle.layer.shadowOpacity = 0.8f;
        subTitle.layer.shadowOffset = CGSizeZero;

        [bannerContainer addSubview:mainTitle];
        [bannerContainer addSubview:subTitle];
        [keyWindow addSubview:bannerContainer];

        // دەقی تەواو
        NSString *fullMainText = @"⚡️SHAZAVIP⚡️";
        NSString *fullSubText = @"💥WELCOME TO SERVER MAMAHALA💥";

        // فەنکشنی پیت بە پیت هاتن (Typing) بۆ سەرەکی
        __block int mainIndex = 0;
        NSTimer *typeTimer = [NSTimer scheduledTimerWithTimeInterval:0.12 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (mainIndex <= fullMainText.length) {
                mainTitle.text = [fullMainText substringToIndex:mainIndex];
                mainIndex++;
            } else {
                [timer invalidate];
                
                // کاتێک سەرەکی تەواو بوو، دەستی بە دووەم بکە
                __block int subIndex = 0;
                NSTimer *subTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 repeats:YES block:^(NSTimer * _Nonnull subTimerRef) {
                    if (subIndex <= fullSubText.length) {
                        subTitle.text = [fullSubText substringToIndex:subIndex];
                        subIndex++;
                    } else {
                        [subTimerRef invalidate];
                        
                        // پاش چەند چرکەیەک، پیت بە پیت بسڕەوە (رۆیشتن)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            // سڕینەوەی پیت بە پیت بۆ نووسینی خوارەوە
                            __block int subRemoveIndex = fullSubText.length;
                            NSTimer *subDelTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 repeats:YES block:^(NSTimer * _Nonnull delTimerRef) {
                                if (subRemoveIndex >= 0) {
                                    subTitle.text = [fullSubText substringToIndex:subRemoveIndex];
                                    subRemoveIndex--;
                                } else {
                                    [delTimerRef invalidate];
                                    
                                    // سڕینەوەی پیت بە پیت بۆ نووسینی سەرەکی
                                    __block int mainRemoveIndex = fullMainText.length;
                                    NSTimer *mainDelTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 repeats:YES block:^(NSTimer * _Nonnull mainDelRef) {
                                        if (mainRemoveIndex >= 0) {
                                            mainTitle.text = [fullMainText substringToIndex:mainRemoveIndex];
                                            mainRemoveIndex--;
                                        } else {
                                            [mainDelRef invalidate];
                                            [bannerContainer removeFromSuperview];
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
}

@end

// یەکسەر کە یارییەکە دەستپێدەکات و دەیاتە سەر کار
%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShazaVIPTypewriterManager startAnimation];
    });
}
