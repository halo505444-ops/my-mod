#import <substrate.h>
#import <UIKit/UIKit.h>

// گۆڕاوی سەرەکی بۆ هەڵگیرسان و کوژاندنەوەی ESP
bool isESPEnabled = false;

// فەنکشنی سەرەکی بۆ کێشانەوەی ESP
void DrawESP() {
    if (!isESPEnabled) return;
    // لێرەدا لۆجیکی پیشاندانی کەسەکان جێبەجێ دەبێت
}

// دروستکردنی مێنوی ڕووکار بە شێوازی نوێ (iOS 13+)
void ShowMenu() {
    UIWindow *window = nil;
    for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *w in windowScene.windows) {
                if (w.isKeyWindow) {
                    window = w;
                    break;
                }
            }
        }
    }
    if (!window) return;

    // دروستکردنی دوگمەیەک بۆ مۆنۆکە
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuButton.frame = CGRectMake(50, 50, 120, 40);
    [menuButton setTitle:@"ESP Menu: OFF" forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    menuButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];

    [menuButton addTarget:[NSClassFromString(@"MenuController") class] action:@selector(toggleESP:) forControlEvents:UIControlEventTouchUpInside];

    [window addSubview:menuButton];
}

@interface MenuController : NSObject
+ (void)toggleESP:(UIButton *)sender;
@end

@implementation MenuController
+ (void)toggleESP:(UIButton *)sender {
    isESPEnabled = !isESPEnabled;
    if (isESPEnabled) {
        [sender setTitle:@"ESP Menu: ON" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"ESP Menu: OFF" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}
@end

static void (*old_applicationDidFinishLaunching)(id, SEL, id, id);
static void replacement_applicationDidFinishLaunching(id self, SEL _cmd, id application, id launchOptions) {
    old_applicationDidFinishLaunching(self, _cmd, application, launchOptions);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShowMenu();
    });
}

__attribute__((constructor)) static void init() {
    MSHookMessage(objc_getClass("UIApplication"), @selector(application:didFinishLaunchingWithOptions:), (IMP)replacement_applicationDidFinishLaunching, (IMP *)&old_applicationDidFinishLaunching);
}
