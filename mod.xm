#import <UIKit/UIKit.h>

@interface ShazaHelper : NSObject
+ (void)openTelegram;
@end

@implementation ShazaHelper
+ (void)openTelegram {
    NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/shazavip"];
    if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
    }
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // دۆزینەوەی پەنجەرەی چالاک بە شێوازی مۆدێرن و بێ کێشە
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

        if (keyWindow) {
            UIButton *shazaButton = [UIButton buttonWithType:UIButtonTypeCustom];
            shazaButton.frame = CGRectMake(100, 50, 200, 40);
            shazaButton.backgroundColor = [UIColor blackColor];
            [shazaButton setTitle:@"⚡️ SHAZA ⚡️\nVIP MODULE • 2026" forState:UIControlStateNormal];
            shazaButton.titleLabel.numberOfLines = 2;
            shazaButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [shazaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            // جوانکاری چوارچێوەکە
            shazaButton.layer.cornerRadius = 10;
            shazaButton.layer.borderWidth = 1.5;
            shazaButton.layer.borderColor = [UIColor purpleColor].CGColor;
            
            // بەستنەوەی دوگمەکە بە فەنکشنی کردنەوەی تلیگرام
            [shazaButton addTarget:[ShazaHelper class] action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
            
            [keyWindow addSubview:shazaButton];
        }
    });
}
