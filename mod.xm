#import <UIKit/UIKit.h>

static UIWindow *globalModWindow = nil;
static UIView *globalBlackScreen = nil;

// پشکنینی توندی ٧ ڕۆژ لەمڕۆوە
static BOOL isModStillValid() {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *expiryKey = @"DHxOMAR_Exact_7Days_Expiry";
    
    NSDate *now = [NSDate date];
    NSDate *startDate = [defaults objectForKey:expiryKey];
    
    if (!startDate) {
        [defaults setObject:now forKey:expiryKey];
        [defaults synchronize];
        startDate = now;
    }
    
    NSTimeInterval sevenDaysSeconds = 7.0 * 24.0 * 60.0 * 60.0;
    NSTimeInterval elapsed = [now timeIntervalSinceDate:startDate];
    
    if (elapsed < 0 || elapsed > sevenDaysSeconds) {
        return NO;
    }
    
    return YES;
}

static void showMainInterface(CGRect screenBounds) {
    // قەبارەی بۆکسەکە بچووک و ڕێکوپێک
    CGFloat boxWidth = 150;
    CGFloat boxHeight = 50;
    CGFloat boxX = 15; // گۆشەی سەرەوەی چەپ
    CGFloat boxY = 45; // لە نزیک تایتڵ بار
    
    // بۆکسێکی ڕەش بە کەمێک شەفافیەتەوە
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(boxX, boxY, boxWidth, boxHeight)];
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    containerView.layer.cornerRadius = 10;
    containerView.layer.borderWidth = 1.0;
    containerView.layer.borderColor = [UIColor cyanColor].CGColor;
    
    // گرنگ: دەبێت بۆکسەکە خۆی تاچی هەبێت بۆ ئەگەر پێویست بوو کلیکی لەسەر بکەیت
    containerView.userInteractionEnabled = YES; 
    
    [globalBlackScreen addSubview:containerView];
    
    // ناوی سەرەکی DHxOMAR
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, boxWidth, 24)];
    titleLabel.text = @"DHxOMAR";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor cyanColor];
    [containerView addSubview:titleLabel];
    
    // ئەنتی باند ✅ بە سەوزی
    UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, boxWidth, 18)];
    antiBanLabel.text = @"ئەنتی باند✅";
    antiBanLabel.textAlignment = NSTextAlignmentCenter;
    antiBanLabel.font = [UIFont boldSystemFontOfSize:10];
    antiBanLabel.textColor = [UIColor greenColor];
    [containerView addSubview:antiBanLabel];
}

__attribute__((constructor)) static void initializer() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!isModStillValid()) {
            return;
        }
        
        UIWindowScene *activeScene = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                activeScene = (UIWindowScene *)scene;
                break;
            }
        }
        
        if (activeScene) {
            CGRect screenBounds = activeScene.windows.firstObject ? activeScene.windows.firstObject.bounds : CGRectMake(0, 0, 414, 896);
            if (screenBounds.size.width == 0) {
                screenBounds = CGRectMake(0, 0, 414, 896);
            }
            
            globalModWindow = [[UIWindow alloc] initWithWindowScene:activeScene];
            globalModWindow.frame = screenBounds;
            globalModWindow.windowLevel = UIWindowLevelAlert + 100;
            globalModWindow.backgroundColor = [UIColor clearColor];
            
            UIViewController *rootVC = [[UIViewController alloc] init];
            rootVC.view.backgroundColor = [UIColor clearColor];
            globalModWindow.rootViewController = rootVC;
            
            [globalModWindow makeKeyAndVisible];
            
            globalBlackScreen = rootVC.view;
            
            // شاشەی گشتی پشتەوە هیچ تاچێک ناگرێت، بۆ ئەوەی یاریەکە و دوگمەی OK بە ئازادی کار بکەن
            globalBlackScreen.userInteractionEnabled = NO; 
            
            showMainInterface(screenBounds);
        }
    });
}
