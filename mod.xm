#import <UIKit/UIKit.h>

@interface SecurityManager : NSObject
+ (void)checkKey;
@end

@implementation SecurityManager

+ (void)checkKey {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        if (window) {
            __block UIView *overlayView = [[UIView alloc] initWithFrame:window.bounds];
            overlayView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.08 alpha:0.98];
            
            // زیادکردنی فەرمان بۆ لادانی کیبۆرد کاتێک لە دەرەوە دەدرێت
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:overlayView action:@selector(endEditing:)];
            tapGesture.cancelsTouchesInView = NO;
            [overlayView addGestureRecognizer:tapGesture];
            
            // نوسینی ناوی محمدVIP بە قەبارەیەکی گەورە و درەوشاوە
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, window.bounds.size.width - 40, 60)];
            titleLabel.text = @"محمدVIP";
            titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:36];
            
            // کاریگەری درەوشانەوە (Glow)
            titleLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0].CGColor;
            titleLabel.layer.shadowOffset = CGSizeMake(0, 0);
            titleLabel.layer.shadowRadius = 8.0;
            titleLabel.layer.shadowOpacity = 0.9;
            
            [overlayView addSubview:titleLabel];
            
            // جووڵاندنی ناونیشانەکە ئەملا و ئەولا (Animation)
            [UIView animateWithDuration:1.5 
                                  delay:0.0 
                                options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut 
                             animations:^{
                titleLabel.transform = CGAffineTransformMakeTranslation(30, 0);
            } completion:nil];
            
            // نوسینی ڕێنمایی بە عەرەبی
            UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, window.bounds.size.width - 40, 30)];
            subLabel.text = @"الرجاء إدخال كود التفعيل:";
            subLabel.textColor = [UIColor lightGrayColor];
            subLabel.textAlignment = NSTextAlignmentCenter;
            subLabel.font = [UIFont systemFontOfSize:14];
            [overlayView addSubview:subLabel];
            
            // خانەی نووسینی کۆد
            UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectMake(50, 220, window.bounds.size.width - 100, 45)];
            keyField.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1.0];
            keyField.textColor = [UIColor whiteColor];
            keyField.placeholder = @" أدخل الكود هنا...";
            keyField.textAlignment = NSTextAlignmentCenter;
            keyField.layer.cornerRadius = 8;
            keyField.layer.borderWidth = 1.0;
            keyField.layer.borderColor = [UIColor cyanColor].CGColor;
            keyField.secureTextEntry = YES;
            [overlayView addSubview:keyField];
            
            // دوگمەی پشکنینی کۆد بە عەرەبی
            UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            submitBtn.frame = CGRectMake(50, 280, window.bounds.size.width - 100, 45);
            submitBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:1.0 alpha:1.0];
            [submitBtn setTitle:@"تحقق وفتح" forState:UIControlStateNormal];
            [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            submitBtn.layer.cornerRadius = 8;
            
            [submitBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                NSString *enteredCode = keyField.text;
                
                // پشکنینی کۆد
                if ([enteredCode isEqualToString:@"محمدVIP"]) {
                    // ١. لادانی شاشەی قفڵ و کردنەوەی یارییەکە
                    [overlayView removeFromSuperview];
                    
                    // ٢. کردنەوەی ڕاستەوخۆی کەناڵی تلیگرام
                    NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/s18k1"];
                    if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
                        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
                    }
                } else {
                    // ئەگەر کۆدەکە هەڵە بوو، دەورەی خانەکە سوور دەبێتەوە
                    keyField.layer.borderColor = [UIColor redColor].CGColor;
                }
            }] forControlEvents:UIControlEventTouchUpInside];
            
            [overlayView addSubview:submitBtn];
            [window addSubview:overlayView];
        }
    });
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SecurityManager checkKey];
    });
}
