#import <UIKit/UIKit.h>

__attribute__((constructor)) static void initCustomMod() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [[UIApplication sharedApplication].windows firstObject];
        }
        
        if (window) {
            UILabel *modLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 315, 45)];
            modLabel.text = @"✨ [ SNAKE_IOS01 ] • VIP MOD ✨";
            modLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.8 alpha:1.0];
            modLabel.font = [UIFont boldSystemFontOfSize:15.0];
            modLabel.textAlignment = NSTextAlignmentCenter;
            modLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
            modLabel.layer.cornerRadius = 10.0;
            modLabel.layer.masksToBounds = YES;
            modLabel.layer.borderWidth = 1.2;
            modLabel.layer.borderColor = [[UIColor colorWithRed:0.0 green:1.0 blue:0.8 alpha:0.8] CGColor];
            
            [window addSubview:modLabel];
            
            modLabel.alpha = 0.0;
            [UIView animateWithDuration:0.8 animations:^{
                modLabel.alpha = 1.0;
            }];
        }
    });
}
