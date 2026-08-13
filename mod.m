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

        CGFloat w = 140.0f;
        CGFloat h = 32.0f;
        logoBtn.frame = CGRectMake((window.bounds.size.width - w) / 2.0f, 45.0f, w, h);

        logoBtn.backgroundColor = [UIColor colorWithRed:0.05f green:0.02f blue:0.1f alpha:0.85f];
        [logoBtn setTitle:@"MamaHala" forState:UIControlStateNormal];
        [logoBtn setTitleColor:[UIColor colorWithRed:0.9f green:0.6f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        logoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];

        logoBtn.layer.cornerRadius = 8.0f;
        logoBtn.layer.borderWidth = 1.5f;
        logoBtn.layer.borderColor = [UIColor colorWithRed:0.7f green:0.3f blue:1.0f alpha:1.0f].CGColor;

        [logoBtn addTarget:[LogoButtonHandler class] action:@selector(onLogoClicked:) forControlEvents:UIControlEventTouchUpInside];

        [window addSubview:logoBtn];
    });
}
