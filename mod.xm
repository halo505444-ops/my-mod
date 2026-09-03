#import <UIKit/UIKit.h>

@interface CloseIPAManager : NSObject
+ (void)showFloatingHeaderInWindow:(UIWindow *)window;
@end

@implementation CloseIPAManager
+ (void)showFloatingHeaderInWindow:(UIWindow *)window {
    // چوارچێوەی بچووکی سەرەوە لە شوێنی RTVIP بۆ داپۆشینی بە شێوازێکی مۆدێرن
    UIView *floatingHeader = [[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width - 240) / 2, 45, 240, 40)];
    floatingHeader.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    floatingHeader.layer.cornerRadius = 12.0;
    floatingHeader.layer.borderWidth = 1.5;
    floatingHeader.layer.borderColor = [UIColor whiteColor].CGColor;
    floatingHeader.layer.shadowColor = [UIColor whiteColor].CGColor;
    floatingHeader.layer.shadowOpacity = 0.3;
    floatingHeader.layer.shadowRadius = 8.0;
    
    // نوسینی CLOSE_IPA بە فۆنتێکی زەق و ڕاق لە ناو چوارچێوەکەدا
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:floatingHeader.bounds];
    headerLabel.text = @"CLOSE_IPA";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
    headerLabel.textColor = [UIColor whiteColor];
    [floatingHeader addSubview:headerLabel];
    
    [window addSubview:floatingHeader];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        
        if (!keyWindow) return;

        // مینیووی پڕی شاشە بۆ داواکردنی کلیل
        UIViewController *customVC = [[UIViewController alloc] init];
        customVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        customVC.view.backgroundColor = [UIColor blackColor];

        // بۆکسەی ناوەڕاست بۆ خانەی نووسین
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 290)];
        container.center = customVC.view.center;
        container.backgroundColor = [UIColor blackColor];
        container.layer.cornerRadius = 24.0;
        container.layer.borderWidth = 2.0;
        container.layer.borderColor = [UIColor whiteColor].CGColor;
        [customVC.view addSubview:container];

        // ناونیشانی سەرەکی لە مینیووی داخستندا
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        titleLabel.text = @"CLOSE_IPA";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0];
        titleLabel.textColor = [UIColor whiteColor];
        [container addSubview:titleLabel];

        // خانەی نووسینی کۆد
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 45)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = [UIColor whiteColor];
        textField.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
        textField.layer.cornerRadius = 10.0;
        textField.layer.borderWidth = 1.0;
        textField.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1.0].CGColor;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:15.0];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"کۆد لێرە بنووسە" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        [container addSubview:textField];

        // دوگمەی پشکنین
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        submitBtn.frame = CGRectMake(20, 145, 280, 45);
        [submitBtn setTitle:@"پشکنین" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor = [UIColor whiteColor];
        submitBtn.layer.cornerRadius = 10.0;
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];

        [submitBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            [container endEditing:YES];
            
            if ([textField.text isEqualToString:@"CLOSE_IPA"]) {
                [customVC dismissViewControllerAnimated:YES completion:^{
                    // کاتێک کلیلەکە ڕاست بوو، پەنجەرەکە لادەچێت و چوارچێوە مۆدێرنەکەی سەرەوە لە شوێنی RTVIP دەردەکەوێت
                    [CloseIPAManager showFloatingHeaderInWindow:keyWindow];
                }];
            } else {
                textField.text = @"";
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"کۆدەکە هەڵەیە!" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            }
        }] forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:submitBtn];

        // لینکی تیلیگرام
        UILabel *tgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 300, 20)];
        tgLabel.text = @"https://t.me/close_hack";
        tgLabel.textAlignment = NSTextAlignmentCenter;
        tgLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
        tgLabel.textColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
        [container addSubview:tgLabel];

        // واژووی mamahala
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 245, 300, 15)];
        footerLabel.text = @"mamahala";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont systemFontOfSize:10.0];
        footerLabel.textColor = [UIColor darkGrayColor];
        [container addSubview:footerLabel];

        UIViewController *rootVC = keyWindow.rootViewController;
        if (rootVC) {
            [rootVC presentViewController:customVC animated:YES completion:nil];
        }
    });
}
