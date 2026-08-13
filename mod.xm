#import <UIKit/UIKit.h>

static UIButton *logoBtn;

static void openTelegramChannel() {
    NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/SNAKE_IOS01"]; 
    if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
    }
}

@interface LogoButtonHandler : NSObject
+ (void)onLogoClicked:(UIButton *)sender;
@end

@implementation LogoButtonHandler
+ (void)onLogoClicked:(UIButton *)sender {
    openTelegramChannel();
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    if (windowScene.windows.count > 0) {
                        window = windowScene.windows.firstObject;
                        break;
                    }
                }
            }
        }
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }
        if (!window) return;
        
        logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // قەبارەی گونجاو وەک لۆگۆکەی ناو وێنەکە (پانی ١٣٠، بەرزی ٣٢)
        CGFloat w = 130.0f;
        CGFloat h = 32.0f;
        logoBtn.frame = CGRectMake((window.bounds.size.width - w) / 2.0f, 65.0f, w, h);
        
        // پاشبنەمایەکی شینی تاریکی تەنک (تایبەت بە ستایلی شین)
        logoBtn.backgroundColor = [UIColor colorWithRed:0.02f green:0.08f blue:0.18f alpha:0.85f];
        
        // نووسینی ناوی تۆ
        [logoBtn setTitle:@"MamaHala" forState:UIControlStateNormal];
        
        // ڕەنگی دەقەکە بە شینی کاڵی درەوشاوە
        [logoBtn setTitleColor:[UIColor colorWithRed:0.4f green:0.8f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        logoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        // چوارچێوەیەکی شینی سەرنجڕاکێش وەک تابلۆکە
        logoBtn.layer.cornerRadius = 6.0f;
        logoBtn.layer.borderWidth = 1.5f;
        logoBtn.layer.borderColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f].CGColor;
        
        [logoBtn addTarget:[LogoButtonHandler class] action:@selector(onLogoClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [window addSubview:logoBtn];
    });
}
