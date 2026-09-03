#import <UIKit/UIKit.h>

@interface CloseIPAManager : NSObject
+ (void)showFloatingHeaderInWindow:(UIWindow *)window;
@end

@implementation CloseIPAManager
+ (void)showFloatingHeaderInWindow:(UIWindow *)window {
    UIView *floatingHeader = [[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width - 280) / 2, 20, 280, 50)];
    floatingHeader.backgroundColor = [UIColor colorWithRed:0.0 green:0.05 blue:0.0 alpha:0.95];
    floatingHeader.layer.cornerRadius = 16.0;
    floatingHeader.layer.borderWidth = 2.0;
    floatingHeader.layer.borderColor = [UIColor greenColor].CGColor;
    floatingHeader.layer.shadowColor = [UIColor greenColor].CGColor;
    floatingHeader.layer.shadowOpacity = 0.6;
    floatingHeader.layer.shadowRadius = 12.0;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:floatingHeader.bounds];
    headerLabel.text = @"CLOSE_IPA";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont fontWithName:@"Courier-Bold" size:22.0];
    headerLabel.textColor = [UIColor greenColor];
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
        customVC.view.backgroundColor = [UIColor colorWithRed:0.02 green:0.05 blue:0.02 alpha:0.92];

        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 290)];
        container.center = customVC.view.center;
        container.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.01 alpha:0.98];
        container.layer.cornerRadius = 24.0;
        container.layer.borderWidth = 2.0;
        container.layer.borderColor = [UIColor greenColor].CGColor;
        [customVC.view addSubview:container];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        titleLabel.text = @"CLOSE_IPA";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:28.0];
        titleLabel.textColor = [UIColor greenColor];
        [container addSubview:titleLabel];

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 45)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = [UIColor greenColor];
        textField.backgroundColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.0 alpha:1.0]; // ڕاستکردنەوەی هەڵەکە لێرەدا
        textField.layer.cornerRadius = 10.0;
        textField.layer.borderWidth = 1.0;
        textField.layer.borderColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0].CGColor;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont fontWithName:@"Courier" size:15.0];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER ACCESS CODE" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0]}];
        [container addSubview:textField];

        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        submitBtn.frame = CGRectMake(20, 145, 280, 45);
        [submitBtn setTitle:@"ACCESS" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor = [UIColor greenColor];
        submitBtn.layer.cornerRadius = 10.0;
        submitBtn.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16.0];

        [submitBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            [container endEditing:YES];
            
            if ([textField.text isEqualToString:@"CLOSE_IPA"]) {
                [customVC dismissViewControllerAnimated:YES completion:^{
                    [CloseIPAManager showFloatingHeaderInWindow:keyWindow];
                }];
            } else {
                textField.text = @"";
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ACCESS DENIED!" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            }
        }] forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:submitBtn];

        UILabel *tgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 300, 20)];
        tgLabel.text = @"https://t.me/close_hack";
        tgLabel.textAlignment = NSTextAlignmentCenter;
        tgLabel.font = [UIFont fontWithName:@"Courier" size:12.0];
        tgLabel.textColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.5 alpha:1.0];
        [container addSubview:tgLabel];

        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 245, 300, 15)];
        footerLabel.text = @"mamahala";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont fontWithName:@"Courier" size:10.0];
        footerLabel.textColor = [UIColor darkGrayColor];
        [container addSubview:footerLabel];

        UIViewController *rootVC = keyWindow.rootViewController;
        if (rootVC) {
            [rootVC presentViewController:customVC animated:YES completion:nil];
        }
    });
}
