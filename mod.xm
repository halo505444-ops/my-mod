#import <UIKit/UIKit.h>

@interface MamaHalaView : NSObject
+ (void)showBanner;
@end

@implementation MamaHalaView

+ (void)showBanner {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) return;

        // دروستکردنی باوەڕی سەرەکی لۆگۆکە
        UIView *banner = [[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width - 220) / 2, 40, 220, 45)];
        banner.backgroundColor = [UIColor colorWithRed:0.08 green:0.05 blue:0.15 alpha:0.92];
        banner.layer.cornerRadius = 12;
        banner.layer.borderWidth = 1.5;
        banner.layer.borderColor = [UIColor colorWithRed:0.65 green:0.15 blue:0.95 alpha:1.0].CGColor;
        
        // بریقەدانەوەی لێوارەکان (Glow Effect)
        banner.layer.shadowColor = [UIColor colorWithRed:0.75 green:0.2 blue:1.0 alpha:1.0].CGColor;
        banner.layer.shadowOffset = CGSizeMake(0, 0);
        banner.layer.shadowRadius = 8.0;
        banner.layer.shadowOpacity = 0.8;

        // تێکستی یەکەم: ⚡ MamaHala ⚡
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 220, 20)];
        titleLabel.text = @"⚡ MamaHala ⚡";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [banner addSubview:titleLabel];

        // تێکستی دووەم: VIP MODULE • 2026
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 220, 16)];
        subLabel.text = @"VIP MODULE • 2026";
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.textColor = [UIColor colorWithRed:0.85 green:0.7 blue:1.0 alpha:1.0];
        subLabel.font = [UIFont systemFontOfSize:10];
        [banner addSubview:subLabel];

        [window addSubview:banner];
    });
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MamaHalaView showBanner];
    });
}
