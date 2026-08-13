#import <substrate.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

bool isESPEnabled = false;

// فەنکشنێک بۆ دروستکردنی Gradientی ئاڵای کوردستان
CAGradientLayer *kurdistanFlagGradient(CGRect frame) {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    
    // ڕەنگەکان بەپێی ڕێز بەندی ئاڵا (سەوز لە سەرەوە، سپی، سوور لە خوارەوە)
    // وەزیفی ستاندارد: سەرەوە سەوز، ناوەڕاست سپی، خوارەوە سوور
    UIColor *colorTop = [UIColor colorWithRed:0.0 green:0.6 blue:0.3 alpha:1.0]; // سەوزی تۆخ
    UIColor *colorMid = [UIColor whiteColor]; // سپی
    UIColor *colorBot = [UIColor colorWithRed:0.8 green:0.1 blue:0.2 alpha:1.0]; // سووری تۆخ
    
    layer.colors = @[(__bridge id)colorTop.CGColor, (__bridge id)colorMid.CGColor, (__bridge id)colorBot.CGColor];
    
    // دیاریکردنی ڕێژەی هەر ڕەنگێک (33% بۆ هەر یەکێک)
    layer.locations = @[@0.0, @0.33, @0.66, @1.0]; // زیادکردنی خاڵێک بۆ ڕێکخستنی باشتر
    
    // ڕێکخستنی ئاراستەی gradient (ستونی)
    layer.startPoint = CGPointMake(0.5, 0.0);
    layer.endPoint = CGPointMake(0.5, 1.0);
    
    return layer;
}

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

    // گەورەکردنی دوگمەکە بۆ قەبارەی گەورە (بۆ نموونە: 200x70)
    // وە گواستنەوەی بۆ شوێنێکی زۆر دیار (ناوەڕاستی سەرەوە)
    CGRect buttonFrame = CGRectMake(100, 50, 200, 70);
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = buttonFrame;
    
    // دانانی نووسینەکان
    [menuButton setTitle:@"ESP: OFF" forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // نووسینی سەرەکی سپی
    [menuButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]]; // فۆنتی گەورە
    
    // دانانی Gradientی ئاڵای کوردستان لە پشتەوەی دوگمەکە
    CAGradientLayer *flagLayer = kurdistanFlagGradient(menuButton.bounds);
    flagLayer.cornerRadius = 10; // گۆشە خڕکردنەوە
    [menuButton.layer insertSublayer:flagLayer atIndex:0];
    
    // زیادکردنی سنوورێک (Border) بۆ جوانی
    menuButton.layer.borderColor = [UIColor blackColor].CGColor;
    menuButton.layer.borderWidth = 1.0;
    menuButton.layer.cornerRadius = 10;
    menuButton.clipsToBounds = YES;

    // زیادکردنی وێنەی خۆرەکە لە ناوەڕاستی دوگمەکە (وەک ئایکۆنێکی ناوەکی)
    // لێرەدا تەنها نووسینێک زیاد دەکەین چونکە دانانی وێنە لە کۆدی سادەدا ئاڵۆزە
    // دەتوانیت دواتر وێنەی خۆرەکە وەک وێنەیەک دابنێیت لەسەر دوگمەکە

    [menuButton addTarget:[NSClassFromString(@"MenuController") class] action:@selector(toggleESP:) forControlEvents:UIControlEventTouchUpInside];

    [window addSubview:menuButton];
}

@interface MenuController : NSObject
+ (void)toggleESP:(UIButton *)sender;
@end

@implementation MenuController
+ (void)toggleESP:(UIButton *)sender {
    isESPEnabled = !isESPEnabled;
    
    // دۆزینەوەی Gradient layerەکە بۆ گۆڕینی ڕەنگەکان لە کاتی ON/OFF
    // (لە کۆدی سادەدا تەنها ڕەنگی نووسینەکە دەگۆڕین)
    if (isESPEnabled) {
        [sender setTitle:@"ESP: ON" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal]; // گۆڕینی ڕەنگی نووسین بۆ زەرد لە کاتی ON
    } else {
        [sender setTitle:@"ESP: OFF" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // گەڕانەوە بۆ سپی لە کاتی OFF
    }
}
@end

static void (*old_applicationDidFinishLaunching)(id, SEL, id, id);
static void replacement_applicationDidFinishLaunching(id self, SEL _cmd, id application, id launchOptions) {
    old_applicationDidFinishLaunching(self, _cmd, application, launchOptions);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShowMenu();
    });
}

__attribute__((constructor)) static void init() {
    MSHookMessage(objc_getClass("UIApplication"), @selector(application:didFinishLaunchingWithOptions:), (IMP)replacement_applicationDidFinishLaunching, (IMP *)&old_applicationDidFinishLaunching);
}
