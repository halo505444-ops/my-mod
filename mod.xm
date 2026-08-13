#import <UIKit/UIKit.h>

// ناوی منۆ و ڕێکخستنەکان
static UIView *mainMenuView;
static UIButton *toggleBtn;
static BOOL menuVisible = NO;
static BOOL espEnabled = NO;

// فەنکشنی ESP (ئەمە ئەو بەشەیە کە کار لەسەر زانیارییەکانی یارییەکە دەکات)
static void drawESP() {
    if (espEnabled) {
        // لێرەدا کۆدی "دۆزینەوەی یاریزانەکان" دادەنرێت
        // ئەمە تەنها نیشانەیە کە سیستەمەکە کاردەکات
        NSLog(@"[MamaHala] ESP Drawing active on screen...");
    }
}

// فەنکشنی کردنەوەی منۆ
static void toggleMenu() {
    menuVisible = !menuVisible;
    [UIView animateWithDuration:0.3 animations:^{
        mainMenuView.alpha = menuVisible ? 1.0f : 0.0f;
    }];
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        // 1. دوگمەی تاج (Toggle)
        toggleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleBtn.frame = CGRectMake(20, 150, 50, 50);
        [toggleBtn setTitle:@"👑" forState:UIControlStateNormal];
        toggleBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        toggleBtn.layer.cornerRadius = 25;
        toggleBtn.layer.borderWidth = 2;
        toggleBtn.layer.borderColor = [UIColor yellowColor].CGColor;
        [toggleBtn addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:toggleBtn];

        // 2. منۆی سەرەکی (MAMA HALA)
        mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 260, 250)];
        mainMenuView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        mainMenuView.layer.cornerRadius = 20;
        mainMenuView.layer.borderWidth = 2;
        mainMenuView.layer.borderColor = [UIColor yellowColor].CGColor;
        mainMenuView.alpha = 0.0;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 260, 30)];
        title.text = @"MAMA HALA VIP";
        title.textColor = [UIColor yellowColor];
        title.font = [UIFont boldSystemFontOfSize:18];
        title.textAlignment = NSTextAlignmentCenter;
        [mainMenuView addSubview:title];
        
        // 3. دوگمەی ESP
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 150, 30)];
        label.text = @"Enable ESP";
        label.textColor = [UIColor whiteColor];
        [mainMenuView addSubview:label];
        
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(190, 70, 50, 30)];
        [sw addTarget:nil action:@selector(toggleESP:) forControlEvents:UIControlEventValueChanged];
        [mainMenuView addSubview:sw];
        
        [window addSubview:mainMenuView];
    });
}

// زیادکردنی کردارەکان
%new
-(void)toggleMenu { toggleMenu(); }

%new
-(void)toggleESP:(UISwitch *)sender {
    espEnabled = sender.isOn;
    drawESP();
}
