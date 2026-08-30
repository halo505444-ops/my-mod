#import <UIKit/UIKit.h>

// پێناسەکردنی گۆڕاوەکان بۆ دوگمەکانی مێنۆ
bool espMaster = false;
bool espLine = false;
bool espBox = false;
bool espHealth = false;
bool espName = false;
bool espDistance = false;
bool espBone = false;
bool espTeamID = false;
bool espWeapon = false;
bool espHideBot = false;
float espDistValue = 500.0;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        // دوگمەی سەر شاشە (Floating Menu Button)
        UIButton *floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingBtn.frame = CGRectMake(50, 100, 55, 55);
        floatingBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.9];
        [floatingBtn setTitle:@"ADMIN" forState:UIControlStateNormal];
        [floatingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        floatingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        floatingBtn.layer.cornerRadius = 27.5;
        floatingBtn.layer.borderWidth = 2.0;
        floatingBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        // دروستکردنی پەنجەرەی مێنۆکە (Menu Container View)
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(50, 170, 360, 220)];
        menuView.backgroundColor = [UIColor colorWithRed:0.08 green:0.09 blue:0.12 alpha:0.95];
        menuView.layer.cornerRadius = 15;
        menuView.layer.borderWidth = 1.5;
        menuView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.6 blue:1.0 alpha:1.0].CGColor;
        menuView.hidden = YES; // سەرەتا شاردراوەیە تاوەکو دوگمەکە دەکرێتەوە
        
        // تایتڵی مێنۆ
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 330, 25)];
        titleLabel.text = @"⚡ ADMIN IOS - مۆد مێنۆی کوردی ⚡";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [menuView addSubview:titleLabel];
        
        // بەشەکانی مێنۆ (HOME, ESP, AIM, ITEMS, SKIN) - لێرەدا نموونەی بەشی ئیسپ (ESP) دادەنێین کە هەموو بژاردەکانی تێدایە بە کوردی:
        NSArray *espOptions = @[
            @"[✓] گشتی ESP",
            @"[✓] هێڵی دەرکەوتن (Line)",
            @"[ ] لاکێشە (Box)",
            @"[✓] تەندروستی (Health)",
            @"[✓] ناوی یاریزان (Name)",
            @"[✓] دووری (Distance)",
            @"[✓] ئێسقان (Bone)",
            @"[✓] ژمارەی تیم (Team ID)",
            @"[✓] چەک (Weapon)",
            @"[ ] شارندنەوەی بۆت (Hide Bot)"
        ];
        
        int yOffset = 45;
        for (int i = 0; i < espOptions.count; i++) {
            UILabel *optLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, yOffset, 200, 20)];
            optLabel.text = espOptions[i];
            optLabel.textColor = [UIColor whiteColor];
            optLabel.font = [UIFont systemFontOfSize:11];
            [menuView addSubview:optLabel];
            yOffset += 16;
        }
        
        // بەستنەوەی چالاکی دوگمەی سەرەکی بۆ کردنەوە و داخستنی مێنۆ
        [floatingBtn addTarget:^({
            menuView.hidden = !menuView.hidden;
        }, forControlEvents:UIControlEventTouchUpInside];
        
        [window addSubview:menuView];
        [window addSubview:floatingBtn];
    });
}
