#import <UIKit/UIKit.h>

@interface HafristManager : NSObject
+ (void)showFloatingHeaderInWindow:(UIWindow *)window;
@end

@implementation HafristManager
+ (void)showFloatingHeaderInWindow:(UIWindow *)window {
    UIView *floatingHeader = [[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width - 320) / 2, 20, 320, 50)];
    floatingHeader.backgroundColor = [UIColor colorWithRed:0.1 green:0.02 blue:0.15 alpha:0.95];
    floatingHeader.layer.cornerRadius = 16.0;
    floatingHeader.layer.borderWidth = 2.0;
    
    // ڕەنگاوڕەنگ وەک پەلکەزێڕینە (Rainbow Border & Shadow)
    CALayer *borderLayer = [CALayer layer];
    borderLayer.frame = floatingHeader.bounds;
    borderLayer.cornerRadius = 16.0;
    borderLayer.borderWidth = 2.0;
    borderLayer.borderColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.7 alpha:1.0].CGColor;
    [floatingHeader.layeraddSublayer:borderLayer];
    
    floatingHeader.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.8 alpha:1.0].CGColor;
    floatingHeader.layer.shadowOpacity = 0.8;
    floatingHeader.layer.shadowRadius = 12.0;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:floatingHeader.bounds];
    headerLabel.text = @"🔞🔞هافرێست بەس پیاو نی😂🔞";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont fontWithName:@"Courier-Bold" size:14.0];
    headerLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.9 alpha:1.0];
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
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                for (UIWindow *window in scene.windows) {
                    keyWindow = window;
                    break;
                }
                if (keyWindow) break;
            }
        }
        
        if (!keyWindow) return;

        UIViewController *customVC = [[UIViewController alloc] init];
        customVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        customVC.view.backgroundColor = [UIColor colorWithRed:0.08 green:0.02 blue:0.12 alpha:0.92];

        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 290)];
        container.center = customVC.view.center;
        container.backgroundColor = [UIColor colorWithRed:0.05 green:0.01 blue:0.08 alpha:0.98];
        container.layer.cornerRadius = 24.0;
        container.layer.borderWidth = 2.0;
        container.layer.borderColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.8 alpha:1.0].CGColor;
        [customVC.view addSubview:container];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 320, 40)];
        titleLabel.text = @"🔞🔞هافرێست بەس پیاو نی😂🔞";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:15.0];
        titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.9 alpha:1.0];
        [container addSubview:titleLabel];

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 300, 45)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.95 alpha:1.0];
        textField.backgroundColor = [UIColor colorWithRed:0.15 green:0.03 blue:0.2 alpha:1.0];
        textField.layer.cornerRadius = 10.0;
        textField.layer.borderWidth = 1.0;
        textField.layer.borderColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.7 alpha:1.0].CGColor;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont fontWithName:@"Courier" size:13.0];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"🔞🔞هافرێست بەس پیاو نی😂🔞" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.7 green:0.4 blue:0.7 alpha:1.0]}];
        [container addSubview:textField];

        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        submitBtn.frame = CGRectMake(20, 145, 300, 45);
        [submitBtn setTitle:@"🔞🔞هافرێست بەس پیاو نی😂🔞" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor = [UIColor colorWithRed:0.85 green:0.25 blue:0.75 alpha:1.0];
        submitBtn.layer.cornerRadius = 10.0;
        submitBtn.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:13.0];

        [submitBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            [container endEditing:YES];
            [customVC dismissViewControllerAnimated:YES completion:^{
                [HafristManager showFloatingHeaderInWindow:keyWindow];
            }];
        }] forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:submitBtn];

        UILabel *tgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 320, 20)];
        tgLabel.text = @"🔞🔞هافرێست بەس پیاو نی😂🔞";
        tgLabel.textAlignment = NSTextAlignmentCenter;
        tgLabel.font = [UIFont fontWithName:@"Courier" size:11.0];
        tgLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.85 alpha:1.0];
        [container addSubview:tgLabel];

        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 245, 320, 15)];
        footerLabel.text = @"🔞🔞هافرێست بەس پیاو نی😂🔞";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont fontWithName:@"Courier" size:10.0];
        footerLabel.textColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.9 alpha:1.0];
        [container addSubview:footerLabel];

        UIViewController *rootVC = keyWindow.rootViewController;
        if (rootVC) {
            [rootVC presentViewController:customVC animated:YES completion:nil];
        }
    });
}
