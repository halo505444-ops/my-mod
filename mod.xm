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
        
        // دروستکردنی دوگمەی هێلکەیی (Capsule) وەک وێنەکە
        UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat w = 150.0f;
        CGFloat h = 42.0f;
        logoBtn.frame = CGRectMake((window.bounds.size.width - w) / 2.0f, 40.0f, w, h);
        
        // پاشبنەمای تاریکی شەفاف و شێوە خڕ (Capsule)
        logoBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7f];
        logoBtn.layer.cornerRadius = h / 2.0f;
        logoBtn.layer.borderWidth = 1.0f;
        logoBtn.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.25f].CGColor;
        logoBtn.clipsToBounds = YES;
        
        // ڕێکخستنی دوو دێڕ نووسین (ناوی سەرەوە و مێژووی ژێرەوە)
        NSString *mainText = @"MamaHala";
        NSString *subText = @"08/13/26";
        NSString *fullString = [NSString stringWithFormat:@"%@\n%@", mainText, subText];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullString];
        
        // فۆنت و ڕەنگی ناوی سەرەوە
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:[fullString rangeOfString:mainText]];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[fullString rangeOfString:mainText]];
        
        // فۆنت و ڕەنگی مێژووی خوارەوە
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:[fullString rangeOfString:subText]];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.75f alpha:1.0f] range:[fullString rangeOfString:subText]];
        
        [logoBtn setAttributedTitle:attrString forState:UIControlStateNormal];
        logoBtn.titleLabel.numberOfLines = 2;
        logoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [logoBtn addTarget:[LogoButtonHandler class] action:@selector(onLogoClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [window addSubview:logoBtn];
    });
}
