#import <UIKit/UIKit.h>

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootVC = keyWindow.rootViewController;
        
        if (!rootVC) return;

        // دروستکردنی پەنجەرەی سەرەکی کە هەموو شاشەکە بە ڕەنگی ڕەش و سپی مۆدێرن داپۆشێت
        UIViewController *customVC = [[UIViewController alloc] init];
        customVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        customVC.view.backgroundColor = [UIColor blackColor];

        // بۆکسێکی سەرنجڕاکێش بە دیزاینی ڕەش و لێواری سپی (Border)
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 310)];
        container.center = customVC.view.center;
        container.backgroundColor = [UIColor blackColor];
        container.layer.cornerRadius = 24.0;
        container.layer.borderWidth = 2.0;
        container.layer.borderColor = [UIColor whiteColor].CGColor;
        container.layer.shadowColor = [UIColor whiteColor].CGColor;
        container.layer.shadowOpacity = 0.2;
        container.layer.shadowRadius = 15.0;
        [customVC.view addSubview:container];

        // نوسینی CLOSE_IPA بە فۆنتێکی زۆر ڕاقی و سەرنجڕاکێش (لێرەدا جێگەی ئەو ناوە دەگرێتەوە)
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 290, 45)];
        titleLabel.text = @"CLOSE_IPA";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0];
        titleLabel.textColor = [UIColor whiteColor];
        [container addSubview:titleLabel];

        // هێڵێکی جوانی ڕوخسار بۆ جیاکردنەوەی ناونیشانەکە
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40, 78, 250, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [container addSubview:lineView];

        // خانەی نووسینی کۆد بە دیزاینی ڕەش و لێواری سپی
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25, 95, 280, 45)];
        textField.placeholder = @"کۆد لێرە بنووسە";
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = [UIColor whiteColor];
        textField.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1.0];
        textField.layer.cornerRadius = 12.0;
        textField.layer.borderWidth = 1.0;
        textField.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:15.0];
        
        // ڕەنگی پڵەسهۆڵدەری (Placeholder) سپی کاڵ
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"کۆد لێرە بنووسە" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        [container addSubview:textField];

        // دوگمەی پشکنین بە ڕەنگی سپی و نوسینی ڕەش بۆ دیمەنێکی شاهانە
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        submitBtn.frame = CGRectMake(25, 155, 280, 45);
        [submitBtn setTitle:@"پشکنین" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor = [UIColor whiteColor];
        submitBtn.layer.cornerRadius = 12.0;
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];

        [submitBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            [container endEditing:YES];
            
            if ([textField.text isEqualToString:@"CLOSE_IPA"]) {
                [customVC dismissViewControllerAnimated:YES completion:nil];
            } else {
                textField.text = @"";
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"کۆدەکە هەڵەیە! دیسان هەوڵ بدە" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
            }
        }] forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:submitBtn];

        // لینکی تیلیگرام لە خوارەوە بە ڕەنگی شینی کاڵی سەرنجڕاکێش
        UILabel *tgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 220, 300, 20)];
        tgLabel.text = @"جۆینی تیلیگرام https://t.me/close_hack";
        tgLabel.textAlignment = NSTextAlignmentCenter;
        tgLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
        tgLabel.textColor = [UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:1.0];
        [container addSubview:tgLabel];

        // نوسینی mamahala بە بچووکی لە خوارترین بەشی چوارچێوەکە
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 260, 300, 15)];
        footerLabel.text = @"mamahala";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont systemFontOfSize:11.0];
        footerLabel.textColor = [UIColor darkGrayColor];
        [container addSubview:footerLabel];

        [rootVC presentViewController:customVC animated:YES completion:nil];
    });
}
