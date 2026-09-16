#import <UIKit/UIKit.h>

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // پشکنینی ماوەی بەسەرچوون (٣٠ ڕۆژ)
        NSDate *installDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SHAZA_InstallDate"];
        if (!installDate) {
            installDate = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:installDate forKey:@"SHAZA_InstallDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:installDate];
        int daysPassed = secondsBetween / (3600 * 24);
        
        if (daysPassed > 30) {
            // ئەگەر یەک مانگ بەسەرچوو، مۆدەکە کار ناکات
            return;
        }
        
        // دروستکردنی پەنجەرەی سەرەکی
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake((window.frame.size.width - 200) / 2, 50, 200, 40)];
        badgeView.backgroundColor = [UIColor colorWithRed:0.1 green:0.05 blue:0.15 alpha:0.9];
        badgeView.layer.cornerRadius = 10;
        badgeView.layer.borderWidth = 1.5;
        badgeView.layer.borderColor = [UIColor purpleColor].CGColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:badgeView.bounds];
        titleLabel.text = @"⚡️ SHAZA ⚡️\nVIP MODULE • 2026";
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        
        [badgeView addSubview:titleLabel];
        [window addSubview:badgeView];
    });
}
