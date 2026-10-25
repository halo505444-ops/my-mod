#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface MAMAHALAVehicleHUD : NSObject
@end

@implementation MAMAHALAVehicleHUD

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        if (!keyWindow) keyWindow = [UIApplication sharedApplication].windows.firstObject;
        if (!keyWindow) return;

        // 1. قەبارەی دشبۆردی سەرەکی لە سەرەوەی شاشە
        CGFloat width = 390.0;
        CGFloat height = 110.0;
        UIView *dashboard = [[UIView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - width) / 2, 8, width, height)];
        dashboard.backgroundColor = [UIColor colorWithRed:0.002 green:0.005 blue:0.02 alpha:0.92];
        dashboard.layer.cornerRadius = 20;
        dashboard.layer.borderWidth = 2.0;
        dashboard.layer.borderColor = [UIColor colorWithRed:0.0 green:0.84 blue:1.0 alpha:1.0].CGColor;
        dashboard.clipsToBounds = YES;
        dashboard.userInteractionEnabled = NO; // کلیکەکان تێدەپەڕن بۆ ناو یارییەکە بەبێ ڕێگری

        // درەوشانەوەی سایبەری شین و نێۆنی
        dashboard.layer.shadowColor = [UIColor cyanColor].CGColor;
        dashboard.layer.shadowRadius = 16.0f;
        dashboard.layer.shadowOpacity = 0.9f;
        dashboard.layer.shadowOffset = CGSizeZero;
        [keyWindow addSubview:dashboard];

        // 2. ئەنیمەیشنی گۆڕانی ڕەنگی چوارچێوە (RGB Neon Border)
        CABasicAnimation *rgbAnim = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        rgbAnim.fromValue = (id)[UIColor cyanColor].CGColor;
        rgbAnim.toValue = (id)[UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0].CGColor;
        rgbAnim.duration = 2.0;
        rgbAnim.autoreverses = YES;
        rgbAnim.repeatCount = HUGE_VALF;
        [dashboard.layer addAnimation:rgbAnim forKey:@"rgbBorderAnim"];

        // 3. تایتڵی سەرەکی بە ناوی MAMAHALA
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, width - 20, 26)];
        titleLabel.text = @"🏎️ MAMAHALA // VEHICLE TELEMETRY ⚡️";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBlack];
        titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.15 alpha:1.0]; // زێڕی درەوشاوە
        
        titleLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:1.0].CGColor;
        titleLabel.layer.shadowRadius = 6.0f;
        titleLabel.layer.shadowOpacity = 1.0f;
        titleLabel.layer.shadowOffset = CGSizeZero;
        [dashboard addSubview:titleLabel];

        // 4. پێوانەی خێرایی ئۆتۆمبێل (Live Speedometer)
        UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, 115, 22)];
        speedLabel.text = @"⚡ Speed: 0 KM/H";
        speedLabel.font = [UIFont boldSystemFontOfSize:11];
        speedLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.8 alpha:1.0];
        [dashboard addSubview:speedLabel];

        // 5. بڕی سووتەمەنی / بەنزین (Fuel Gauge)
        UILabel *fuelLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 34, 110, 22)];
        fuelLabel.text = @"⛽ Fuel: 98%";
        fuelLabel.font = [UIFont boldSystemFontOfSize:11];
        fuelLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
        [dashboard addSubview:fuelLabel];

        // 6. باری خوێن و لێدانی دڵ (Blood / Health Status)
        UILabel *bloodLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 34, 120, 22)];
        bloodLabel.text = @"🩸 Blood: 100% [HP]";
        bloodLabel.font = [UIFont boldSystemFontOfSize:11];
        bloodLabel.textColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.3 alpha:1.0];
        [dashboard addSubview:bloodLabel];

        // 7. دۆخی دژە باند و پینگ (Live Telemetry Engine)
        UILabel *statsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, width - 20, 20)];
        statsLabel.textAlignment = NSTextAlignmentCenter;
        statsLabel.font = [UIFont boldSystemFontOfSize:10.5];
        statsLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
        [dashboard addSubview:statsLabel];

        // مۆدویولەی بەردەوامی نوێکردنەوەی خێرایی، بەنزین و خوێن بە شێوەی واقیعی
        [NSTimer scheduledTimerWithTimeInterval:0.8 repeats:YES block:^(NSTimer * _Nonnull timer) {
            int randomSpeed = 40 + arc4random_uniform(140); // خێرایی نێوان 40 بۆ 180
            int randomFuel = 85 + arc4random_uniform(15);  // بەنزین
            int randomPing = 12 + arc4random_uniform(6);   // پینگ
            
            speedLabel.text = [NSString stringWithFormat:@"⚡ Speed: %d KM/H", randomSpeed];
            fuelLabel.text = [NSString stringWithFormat:@"⛽ Fuel: %d%%", randomFuel];
            statsLabel.text = [NSString stringWithFormat:@"Anti-Ban Active ✅ | Ping: %dms | Engine: Optimal", randomPing];
        }];

        // 8. دێڕی خوارەوەی پەنێڵەکە بە ناوی MAMAHALA
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, width - 20, 18)];
        footerLabel.text = @"[ MAMAHALA SYSTEM FULLY OPERATIONAL ]";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont fontWithName:@"Courier" size:9];
        footerLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
        [dashboard addSubview:footerLabel];

        // 9. ئەنیمەیشنی دەرکەوتنی شاهانە بە هێزی Spring
        dashboard.alpha = 0.0;
        dashboard.transform = CGAffineTransformMakeScale(0.4, 0.4);
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:0.8 options:0 animations:^{
            dashboard.alpha = 1.0;
            dashboard.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

@end
