#import <UIKit/UIKit.h>

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootVC = keyWindow.rootViewController;
        
        if (!rootVC) return;

        // دروستکردنی پەنجەرەی سپی و نوسینی ڕەش
        UIViewController *customVC = [[UIViewController alloc] init];
        customVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        customVC.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

        // قەبارەی بۆکسەکە
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)];
        container.center = customVC.view.center;
        container.backgroundColor = [UIColor whiteColor];
        container.layer.cornerRadius = 16.0;
        container.layer.shadowColor = [UIColor blackColor].CGColor;
        container.layer.shadowOpacity = 0.3;
        container.layer.shadowRadius = 10.0;
        [customVC.view addSubview:container];

        // نوسینی CLOSE_IPA بە فۆنتێکی گەورە و قەڵەوی جوان
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 40)];
        titleLabel.text = @"CLOSE_IPA";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
        titleLabel.textColor = [UIColor blackColor];
        [container addSubview:titleLabel];

        // خانەی نووسینی کۆد
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 65, 280, 40)];
        textField.placeholder = @"کۆد لێرە بنووسە";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textColor = [UIColor blackColor];
        textField.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
        textField.font = [UIFont systemFontOfSize:15.0];
        [container addSubview:textField];

        // دوگمەی پشکنین
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        submitBtn.frame = CGRectMake(20, 115, 280, 40);
        [submitBtn setTitle:@"پشکنین" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor = [UIColor blackColor];
        submitBtn.layer.cornerRadius = 8.0;
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];

        [submitBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            if ([textField.text isEqualToString:@"CLOSE_IPA"]) {
                [customVC dismissViewControllerAnimated:YES completion:nil];
            } else {
                textField.text = @"";
                textField.placeholder = @"کۆدەکە هەڵەیە! دیسان هەوڵ بدە";
            }
        }] forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:submitBtn];

        // نوسینی تیلیگرام لە خوارەوە
        UILabel *tgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, 300, 25)];
        tgLabel.text = @"جۆینی تیلیگرام https://t.me/close_hack";
        tgLabel.textAlignment = NSTextAlignmentCenter;
        tgLabel.font = [UIFont systemFontOfSize:12.0];
        tgLabel.textColor = [UIColor systemBlueColor];
        [container addSubview:tgLabel];

        // نوسینی mamahala بە بچووکی لە خوارترین بەشی پەنجەرەکە
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 215, 300, 20)];
        footerLabel.text = @"mamahala";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont systemFontOfSize:11.0];
        footerLabel.textColor = [UIColor darkGrayColor];
        [container addSubview:footerLabel];

        [rootVC presentViewController:customVC animated:YES completion:nil];
    });
}
