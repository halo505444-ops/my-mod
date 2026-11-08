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
    // قەبارەی بچووکتر و شوێنی سەرەوەی شاشە
    CGFloat boxWidth = 180;
    CGFloat boxHeight = 65;
    CGFloat boxX = (screenBounds.size.width - boxWidth) / 2;
    CGFloat boxY = 45; // گواستنەوە بۆ سەرەوەی شاشە
    
    // بێ هیچ بۆکسێکی ڕەش (تەنها لێرەدا کۆنتەینەرەکەمان کرد بە بێ ڕەنگ و بێ بڵاوکراوە)
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(boxX, boxY, boxWidth, boxHeight)];
    containerView.backgroundColor = [UIColor clearColor];
    [globalBlackScreen addSubview:containerView];
    
    // ناوی سەرەکی DHxOMAR (بچووکتر و ڕێکوپێک لە سەرەوە)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, boxWidth, 35)];
    titleLabel.text = @"DHxOMAR";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor cyanColor];
    [containerView addSubview:titleLabel];
    
    // ئەنتی باند ✅ بە سەوزی لە خوار ناوی سەرەکییەوە
    UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, boxWidth, 25)];
    antiBanLabel.text = @"ئەنتی باند✅";
    antiBanLabel.textAlignment = NSTextAlignmentCenter;
    antiBanLabel.font = [UIFont boldSystemFontOfSize:12];
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
            globalBlackScreen.userInteractionEnabled = NO; // بۆ ئەوەی ڕێگری لە یارییەکە نەكات
            
            showMainInterface(screenBounds);
        }
    });
}
