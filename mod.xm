#import <UIKit/UIKit.h>

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
        
        // دروستکردنی ستایلی گەیمینگ و بریقەدار (Neon Badge)
        UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat w = 170.0f;
        CGFloat h = 42.0f;
        logoBtn.frame = CGRectMake((window.bounds.size.width - w) / 2.0f, 45.0f, w, h);
        
        // پاشبنەمای تاریکی گەیمینگ
        logoBtn.backgroundColor = [UIColor colorWithRed:0.06f green:0.02f blue:0.12f alpha:0.9f];
        logoBtn.layer.cornerRadius = 10.0f;
        
        // چوارچێوەی نایاب و ڕووناک (Neon Border)
        logoBtn.layer.borderWidth = 1.5f;
        logoBtn.layer.borderColor = [UIColor colorWithRed:0.8f green:0.2f blue:1.0f alpha:1.0f].CGColor;
        
        // دروستکردنی سێبەری درەوشاوە (Glow Effect)
        logoBtn.layer.shadowColor = [UIColor colorWithRed:0.8f green:0.2f blue:1.0f alpha:1.0f].CGColor;
        logoBtn.layer.shadowOffset = CGSizeMake(0, 0);
        logoBtn.layer.shadowRadius = 6.0f;
        logoBtn.layer.shadowOpacity = 0.8f;
        
        // ڕێکخستنی نووسینەکان بە ستایلی VIP
        NSString *mainText = @"⚡ MamaHala ⚡";
        NSString *subText = @"VIP MODULE • 2026";
        NSString *fullString = [NSString stringWithFormat:@"%@\n%@", mainText, subText];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullString];
        
        // فۆنت و ڕەنگی ناوی سەرەوە
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:[fullString rangeOfString:mainText]];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0f green:0.8f blue:1.0f alpha:1.0f] range:[fullString rangeOfString:mainText]];
        
        // فۆنت و ڕەنگی دەقی خوارەوە
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:[fullString rangeOfString:subText]];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.6f green:0.6f blue:0.8f alpha:1.0f] range:[fullString rangeOfString:subText]];
        
        [logoBtn setAttributedTitle:attrString forState:UIControlStateNormal];
        logoBtn.titleLabel.numberOfLines = 2;
        logoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [logoBtn addTarget:[LogoButtonHandler class] action:@selector(onLogoClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [window addSubview:logoBtn];
    });
}
