#import <UIKit/UIKit.h>

static UIWindow *globalModWindow = nil;
static UIView *globalBlackScreen = nil;

static void showMainInterface(CGRect screenBounds) {
    CGFloat boxWidth = screenBounds.size.width - 120;
    if (boxWidth > 260) boxWidth = 260;
    CGFloat boxHeight = 140;
    CGFloat boxX = (screenBounds.size.width - boxWidth) / 2;
    CGFloat boxY = (screenBounds.size.height - boxHeight) / 2;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(boxX, boxY, boxWidth, boxHeight)];
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    containerView.layer.cornerRadius = 16;
    containerView.layer.borderWidth = 1.2;
    containerView.layer.borderColor = [UIColor cyanColor].CGColor;
    [globalBlackScreen addSubview:containerView];
    
    // ناوی سەرەکی DHxOMAR
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, boxWidth - 20, 45)];
    titleLabel.text = @"DHxOMAR";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textColor = [UIColor cyanColor];
    [containerView addSubview:titleLabel];
    
    // ئەنتی باند ✅ بە سەوزی بە بچووکتر لە خوارەوەی
    UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, boxWidth - 20, 30)];
    antiBanLabel.text = @"ئەنتی باند✅";
    antiBanLabel.textAlignment = NSTextAlignmentCenter;
    antiBanLabel.font = [UIFont boldSystemFontOfSize:14];
    antiBanLabel.textColor = [UIColor greenColor];
    [containerView addSubview:antiBanLabel];
}

__attribute__((constructor)) static void initializer() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
            globalBlackScreen.userInteractionEnabled = YES;
            
            showMainInterface(screenBounds);
        }
    });
}
