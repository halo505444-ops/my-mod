#import <UIKit/UIKit.h>

// دروستکردنی فەنکشنێک بۆ پیشاندانی تابلۆکە یان کردنەوەی تلیگرام کاتێک کلیک دەکرێت
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // دروستکردنی ڕووکاری سەرەکی (Floating View / Button)
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        UIButton *shazaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shazaButton.frame = CGRectMake(100, 50, 200, 40);
        shazaButton.backgroundColor = [UIColor blackColor];
        [shazaButton setTitle:@"⚡️ SHAZA ⚡️\nViP MODULE • 2026" forState:UIControlStateNormal];
        shazaButton.titleLabel.numberOfLines = 2;
        shazaButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [shazaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // جوانکاری چوارچێوەکە (پەپووکەی وەنەوشەیی/نێون)
        shazaButton.layer.cornerRadius = 10;
        shazaButton.layer.borderWidth = 1.5;
        shazaButton.layer.borderColor = [UIColor purpleColor].CGColor;
        
        // چالاککردنی دوگمەکە بۆ ئەوەی ڕاستەوخۆت بباتە ناو تلیگرام
        [shazaButton addTarget:[[self class] alloc] action:@selector(openShazaTelegram) forControlEvents:UIControlEventTouchUpInside];
        
        [keyWindow addSubview:shazaButton];
    });
}

// فەنکشنی کردنەوەی لینکی تلیگرام
%hookf(void, openShazaTelegram) {
    NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/shazavip"];
    if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
    }
}
