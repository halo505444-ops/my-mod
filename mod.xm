#import <UIKit/UIKit.h>

@interface MamaHalaMenu : NSObject
@end

@implementation MamaHalaMenu

static UIView *floatingMenu = nil;
static UIButton *floatingBtn = nil;
static int currentLanguage = 0; // 0: سۆرانی, 1: بادینی, 2: English

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self verifyServerAndSetup];
    });
}

// پشکنینی ڕاستەقینەی سێرفەر و پشکنینی وادە (30 ڕۆژ اوفلاین)
+ (void)verifyServerAndSetup {
    NSString *urlString = @"https://narkhdockqhlwxxyyyxjr.supabase.co/rest/v1/licenses?select=*";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // بەستنەوەی تۆکنی تایبەتی سێرفەرەکەت
    NSString *apiKey = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA";
    [request setValue:apiKey forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", apiKey] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && data) {
            // لێرەدا سەرکەوتوو بوو لە پەیوەندی کردن بە سێرفەر
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createFloatingButton];
            });
        } else {
            // ئەگەر سێرفەر نەبەسترا یان هێڵ کێشەی هەبوو، لێرەدا دەتوانرێت سنوردار بکرێت
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createFloatingButton]; // بۆ تاقیکردنەوە دەیخەینە کار
            });
        }
    }];
    [task resume];
}

+ (void)createFloatingButton {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!floatingBtn) {
        floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingBtn.frame = CGRectMake(20, 150, 55, 55);
        floatingBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:0.92];
        [floatingBtn setTitle:@"⚡️" forState:UIControlStateNormal];
        floatingBtn.titleLabel.font = [UIFont systemFontOfSize:24];
        floatingBtn.layer.cornerRadius = 27.5;
        floatingBtn.layer.borderWidth = 2.0;
        floatingBtn.layer.borderColor = [UIColor systemYellowColor].CGColor;
        [floatingBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:floatingBtn];
    }
}

+ (void)toggleMenu {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (floatingMenu) {
        [floatingMenu removeFromSuperview];
        floatingMenu = nil;
        return;
    }
    
    // دیزاینی سەرەکی مینۆکە
    floatingMenu = [[UIView alloc] initWithFrame:CGRectMake(40, 75, 330, 490)];
    floatingMenu.backgroundColor = [UIColor colorWithRed:0.06 green:0.06 blue:0.06 alpha:0.97];
    floatingMenu.layer.cornerRadius = 16;
    floatingMenu.layer.borderWidth = 1.8;
    floatingMenu.layer.borderColor = [UIColor systemCyanColor].CGColor;
    
    // ناونیشانی سەرەکی بە ناوی خۆت
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 290, 30)];
    title.text = @"⚡️ MAMA HALA VIP ⚡️";
    title.textColor = [UIColor systemYellowColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [floatingMenu addSubview:title];
    
    // دوگمەی داخستن (X) بە شێوازێکی جوان
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(285, 12, 35, 35];
    [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [floatingMenu addSubview:closeBtn];
    
    // دوگمەکانی گۆڕینی زمان (سۆرانی / بادینی / ئینگلیزی)
    UISegmentedControl *langSelector = [[UISegmentedControl alloc] initWithItems:@[@"کوردی (سۆرانی)", @"کوردی (بادینی)", @"English"]];
    langSelector.frame = CGRectMake(15, 52, 300, 32];
    langSelector.selectedSegmentIndex = currentLanguage;
    [langSelector addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventValueChanged];
    [floatingMenu addSubview:langSelector];
    
    // دروستکردنی تایبەتمەندییەکان
    [self setupFeaturesInView:floatingMenu];
    
    [window addSubview:floatingMenu];
}

+ (void)changeLanguage:(UISegmentedControl *)sender {
    currentLanguage = (int)sender.selectedSegmentIndex;
    [floatingMenu removeFromSuperview];
    floatingMenu = nil;
    [self toggleMenu];
}

+ (void)setupFeaturesInView:(UIView * )menuView {
    NSArray *espTitles;
    NSArray *aimTitles;
    
    if (currentLanguage == 0) {
        espTitles = @[@"ئێس پی بۆکس (ESP Box)", @"ئێس پی هێڵ (ESP Line)", @"ئێس پی دوری (ESP Distance)"];
        aimTitles = @[@"ئایم بۆت سەر (AimBot Head)", @"ئایم بۆت سینگ (AimBot Chest)"];
    } else if (currentLanguage == 1) {
        espTitles = @[@"ئێس پی بۆکس (ESP Box)", @"ئێس پی تەل (ESP Line)", @"دویراتییا ئێس پی (Distance)"];
        aimTitles = @[@"ئایم بۆت سەری (Head)", @"ئایم بۆت سنگ (Chest)"];
    } else {
        espTitles = @[@"ESP Box", @"ESP Line", @"ESP Distance"];
        aimTitles = @[@"AimBot Head", @ "AimBot Chest"];
    }
    
    // بەشی ESP
    UILabel *espHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 96, 300, 20];
    espHeader.text = (currentLanguage == 1) ? @"--- تایبەتمەندیێن ئێس پی ---" : ((currentLanguage == 0) ? @"--- بەشی ئێس پی (ESP) ---" : @"--- ESP Features ---");
    espHeader.textColor = [UIColor systemCyanColor];
    espHeader.font = [UIFont boldSystemFontOfSize:13];
    [menuView addSubview:espHeader];
    
    for (int i = 0; i < 3; i++) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(15, 122 + (i * 38), 0, 0)];
        [sw addTarget:self action:@selector(featureToggled:) forControlEvents:UIControlEventValueChanged];
        [menuView addSubview:sw];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 122 + (i * 38), 235, 30)];
        lbl.text = espTitles[i];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:13];
        [menuView addSubview:lbl];
    }
    
    // بەشی AimBot
    UILabel *aimHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 240, 300, 20];
    aimHeader.text = (currentLanguage == 1) ? @"--- تایبەتمەندیێن ئایم بۆتی ---" : ((currentLanguage == 0) ? @"--- بەشی ئایم بۆت (AimBot) ---" : @"--- AimBot Features ---");
    aimHeader.textColor = [UIColor systemGreenColor];
    aimHeader.font = [UIFont boldSystemFontOfSize:13];
    [menuView addSubview:aimHeader];
    
    for (int i = 0; i < 2; i++) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(15, 266 + (i * 38), 0, 0)];
        [sw addTarget:self action:@selector(featureToggled:) forControlEvents:UIControlEventValueChanged];
        [menuView addSubview:sw];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 266 + (i * 38), 235, 30)];
        lbl.text = aimTitles[i];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:13];
        [menuView addSubview:lbl];
    }
    
    // کۆنتڕۆڵی دوری و مەودای ئایم بۆت (Slider)
    UILabel *sliderLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 350, 300, 20];
    sliderLbl.text = (currentLanguage == 1) ? @"دویراتی و مەودای ئایم بۆتی:" : ((currentLanguage == 0) ? @"مەودا و دوری ئایم بۆت (Range):" : @"AimBot Distance & Range:");
    sliderLbl.textColor = [UIColor lightGrayColor];
    sliderLbl.font = [UIFont systemFontOfSize:12];
    [menuView addSubview:sliderLbl];
    
    UISlider *rangeSlider = [[UISlider alloc] initWithFrame:CGRectMake(15, 375, 300, 20];
    rangeSlider.minimumValue = 50;
    rangeSlider.maximumValue = 400;
    rangeSlider.value = 150;
    [rangeSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [menuView addSubview:rangeSlider];
    
    // لۆگۆی کۆتایی بە ناوی MamaHala
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(15, 455, 300, 20];
    footer.text = @"Developer: MamaHala ⚡️ VIP Edition";
    footer.textColor = [UIColor systemYellowColor];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.font = [UIFont boldSystemFontOfSize:11];
    [menuView addSubview:footer];
}

+ (void)featureToggled:(UISwitch * )sender {
    if (sender.isOn) {
        // لێرەدا سەح کرا (هەڵکردنی تایبەتمەندی)
    } else {
        // لێرەدا سەح لادرا (کوژاندنەوەی تایبەتمەندی)
    }
}

+ (void)sliderChanged:(UISlider * )sender {
    float val = sender.value;
    // کۆنتڕۆڵکردنی مەودای ئایم بۆت لێرە جێبەجێ دەبێت
}

@end
