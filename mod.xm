#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShazaVIPHologramHUD : NSObject
@end

@implementation ShazaVIPHologramHUD

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

        // بۆکسێکی سەرەکی بۆ ڕاداری سایبەری
        UIView *radarContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 160, 190)];
        radarContainer.backgroundColor = [UIColor colorWithRed:0.0 green:0.05 blue:0.1 alpha:0.5];
        radarContainer.layer.cornerRadius = 15;
        radarContainer.layer.borderWidth = 1.2;
        radarContainer.layer.borderColor = [UIColor cyanColor].CGColor;
        radarContainer.clipsToBounds = YES;

        // زیادکردنی بریقەی نێۆنی (Glow Effect)
        radarContainer.layer.shadowColor = [UIColor cyanColor].CGColor;
        radarContainer.layer.shadowRadius = 8.0f;
        radarContainer.layer.shadowOpacity = 0.8f;
        radarContainer.layer.shadowOffset = CGSizeZero;

        // 1. بازنەی ڕادار لە سەرەوەی پەنێڵەکە
        UIView *radarCircle = [[UIView alloc] initWithFrame:CGRectMake(30, 10, 100, 100)];
        radarCircle.layer.cornerRadius = 50;
        radarCircle.layer.borderWidth = 1.0;
        radarCircle.layer.borderColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.8 alpha:0.8].CGColor;
        radarCircle.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.5 alpha:0.15];
        radarCircle.clipsToBounds = YES;
        [radarContainer addSubview:radarCircle];

        // هێڵی خولاوەی ڕادار (Radar Sweep Line)
        UIView *sweepLine = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 2, 50)];
        sweepLine.backgroundColor = [UIColor cyanColor];
        sweepLine.layer.anchorPoint = CGPointMake(0.5, 1.0);
        sweepLine.center = CGPointMake(50, 50);
        [radarCircle addSubview:sweepLine];

        // ئەنیمەیشنی سووڕانەوەی هێڵەکە بە بێ پچڕان
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(M_PI * 2.0);
        rotationAnimation.duration = 2.0;
        rotationAnimation.repeatCount = HUGE_VALF;
        [sweepLine.layer addAnimation:rotationAnimation forKey:@"radarRotation"];

        // 2. ناوی سەرەکی SHAZAVIP لە ناوەڕاستی ڕادارەکەدا
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 20)];
        titleLabel.text = @"SHAZAVIP";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]; // ڕەنگی زێڕی
        [radarCircle addSubview:titleLabel];

        // 3. نیشانەی خێرایی و پینگ (Live Ping / FPS)
        UILabel *pingBadge = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 140, 20)];
        pingBadge.text = @"⚡️ Ping: 20ms | FPS: 60";
        pingBadge.textAlignment = NSTextAlignmentCenter;
        pingBadge.font = [UIFont boldSystemFontOfSize:10];
        pingBadge.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.4 alpha:1.0]; // ڕەنگی سەوز
        [radarContainer addSubview:pingBadge];

        // 4. سکوێنەری پەیامەکان (Dynamic Status Logs) کە خۆکار دەگۆڕێن
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, 150, 40)];
        statusLabel.numberOfLines = 2;
        statusLabel.text = @"[Securing Memory...]\nSHAZAVIP Active ✅";
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
        statusLabel.textColor = [UIColor whiteColor];
        [radarContainer addSubview:statusLabel];

        // سووڕی گۆڕینی پەیامەکان بە شێوازێکی هێمن
        __block NSArray *statusMessages = @[
            @"[Securing Memory...]\nSHAZAVIP Active ✅",
            @"[Bypass: Secured 🛡️]\nAnti-Ban: ON",
            @"[Server Connected]\nReady to Play 🚀"
        ];
        __block int msgIndex = 0;
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            msgIndex = (msgIndex + 1) % statusMessages.count;
            statusLabel.text = statusMessages[msgIndex];
        }];

        // زیادکردن بۆ سەر شاشە بە ئەنیمەیشنی گەورەبوون و دەرکەوتنی سیحراوی
        radarContainer.alpha = 0.0;
        radarContainer.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [keyWindow addSubview:radarContainer];

        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            radarContainer.alpha = 1.0;
            radarContainer.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

@end
