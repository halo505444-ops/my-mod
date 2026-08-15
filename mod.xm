#import <UIKit/UIKit.h>

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        if (window) {
            // دروستکردنی نیشانەکە لە ناوەڕاستی شاشە
            UILabel *watermarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
            watermarkLabel.center = CGPointMake(window.bounds.size.width / 2, window.bounds.size.height / 2 + 60);
            watermarkLabel.text = @"محمد VIP";
            watermarkLabel.textColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0];
            watermarkLabel.textAlignment = NSTextAlignmentCenter;
            watermarkLabel.font = [UIFont boldSystemFontOfSize:18];
            
            // کاریگەری درەوشانەوە
            watermarkLabel.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0].CGColor;
            watermarkLabel.layer.shadowOffset = CGSizeMake(0, 0);
            watermarkLabel.layer.shadowRadius = 6.0;
            watermarkLabel.layer.shadowOpacity = 0.9;
            
            [window addSubview:watermarkLabel];
            
            // جووڵاندنی ئەملا و ئەولا (Animation)
            [UIView animateWithDuration:2.0 
                                  delay:0.0 
                                options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut 
                             animations:^{
                // گۆڕینی شوێنەکەی بۆ لای ڕاست بە بڕی 50 پیکسڵ و دواتر گەڕانەوەی خۆکار
                watermarkLabel.transform = CGAffineTransformMakeTranslation(50, 0);
            } completion:nil];
        }
    });
}
