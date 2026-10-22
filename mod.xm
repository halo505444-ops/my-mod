#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface ShazaVIPGodModeHUD : NSObject
@end

@implementation ShazaVIPGodModeHUD

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

        // 1. بۆکسی سەرەکی Ultra VIP (لە سەرەوەی شاشە - بێ ڕێگری لە کلیکەکان)
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - 260) / 2, 12, 260, 80)];
        containerView.backgroundColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.03 alpha:0.85];
        containerView.layer.cornerRadius = 16;
        containerView.layer.borderWidth = 1.5;
        containerView.layer.borderColor = [UIColor cyanColor].CGColor;
        containerView.clipsToBounds = YES;
        containerView.userInteractionEnabled = NO; // تێپەڕبوونی کلیکەکان بۆ ناو یارییەکە
        
        // درەوشانەوەی نێۆنی گەورە بۆ پەنێڵەکە
        containerView.layer.shadowColor = [UIColor magentaColor].CGColor;
        containerView.layer.shadowRadius = 14.0f;
        containerView.layer.shadowOpacity = 0.95f;
        containerView.layer.shadowOffset = CGSizeZero;
        [keyWindow addSubview:containerView];

        // ئەنیمەیشنی گۆڕانی ڕەنگی چوارچێوە (RGB Border Animation)
        CABasicAnimation *borderColorAnim = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        borderColorAnim.fromValue = (id)[UIColor cyanColor].CGColor;
        borderColorAnim.toValue = (id)[UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0].CGColor;
        borderColorAnim.duration = 3.0;
        borderColorAnim.autoreverses = YES;
        borderColorAnim.repeatCount = HUGE_VALF;
        [containerView.layer addAnimation:borderColorAnim forKey:@"rgbBorder"];

        // 2. دەقی هاکینگی سەرەتایی (Terminal Effect)
        UILabel *hackerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 244, 64)];
        hackerLabel.textColor = [UIColor greenColor];
        hackerLabel.font = [UIFont fontWithName:@"Courier-Bold" size:10];
        hackerLabel.numberOfLines = 3;
        hackerLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:hackerLabel];

        // 3. ناوی سەرەکی SHAZAVIP (بۆ قۆناغی ئاگرین)
        UILabel *shazaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 260, 42)];
        shazaLabel.text = @"⚡️ SHAZAVIP ⚡️";
        shazaLabel.textAlignment = NSTextAlignmentCenter;
        shazaLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBlack];
        shazaLabel.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.2 alpha:1.0]; // زێڕی درەوشاوە
        shazaLabel.alpha = 0.0;
        
        shazaLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:1.0].CGColor;
        shazaLabel.layer.shadowRadius = 12.0f;
        shazaLabel.layer.shadowOpacity = 1.0f;
        shazaLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:shazaLabel];

        // 4. زانیارییە پێشکەوتووەکان (Anti-Ban Active + Live Status)
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 260, 22)];
        infoLabel.text = @"Anti-Ban Active ✅ | Ping: 14ms | 60 FPS";
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.font = [UIFont boldSystemFontOfSize:9.5];
        infoLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0]; // سەوزی نێۆن
        infoLabel.alpha = 0.0;
        
        infoLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        infoLabel.layer.shadowRadius = 3.0f;
        infoLabel.layer.shadowOpacity = 1.0f;
        infoLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:infoLabel];

        // 5. زنجیرەی ئەنیمەیشنی هاکینگ و پاشان گڕگرتنی $4\text{K}$
        NSArray *hackSequence = @[
            @"> INITIALIZING GOD-MODE KERNEL...",
            @"> BYPASSING SECURE ENCRYPTION...",
            @"> SHAZAVIP ULTRA SECURED 🚀"
        ];
        __block int index = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.4 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (index < hackSequence.count) {
                hackerLabel.text = hackSequence[index];
                index++;
            } else {
                [timer invalidate];

                // لابردنی دەقی هاکینگ و گۆڕینی باگراوند بۆ شوشەی پاک
                [UIView animateWithDuration:0.5 animations:^{
                    hackerLabel.alpha = 0.0;
                    containerView.backgroundColor = [UIColor colorWithRed:0.0 green:0.02 blue:0.05 alpha:0.25];
                } completion:^(BOOL finished) {
                    [hackerLabel removeFromSuperview];

                    // دەرکەوتنی ناوی شازە و زانیارییەکان
                    shazaLabel.alpha = 1.0;
                    infoLabel.alpha = 1.0;

                    // سیستەمی ئاگری ڕاستەقینەی $4\text{K}$ (CAEmitterLayer) بە دوو قات ئاگر و پڕشنگ
                    CAEmitterLayer *fireEmitter = [CAEmitterLayer layer];
                    fireEmitter.emitterPosition = CGPointMake(containerView.bounds.size.width / 2, 45);
                    fireEmitter.emitterSize = CGSizeMake(200, 10);
                    fireEmitter.emitterShape = kCAEmitterLayerLine;

                    // گەردیلەی ئاگری گەرمی ناوەندی (سپی و زەرد)
                    CAEmitterCell *coreFire = [CAEmitterCell emitterCell];
                    coreFire.birthRate = 150;
                    coreFire.lifetime = 0.4;
                    coreFire.velocity = 35;
                    coreFire.velocityRange = 12;
                    coreFire.emissionLongitude = M_PI + M_PI_2;
                    coreFire.emissionRange = M_PI_4 / 2.0;
                    coreFire.scaleSpeed = -0.35;
                    coreFire.color = [UIColor colorWithRed:1.0 green:1.0 blue:0.6 alpha:0.95].CGColor;

                    // گەردیلەی ئاگری دەرەکی (پرتەقاڵی و سوور - واقیعی)
                    CAEmitterCell *flameFire = [CAEmitterCell emitterCell];
                    flameFire.birthRate = 260;
                    flameFire.lifetime = 0.65;
                    flameFire.velocity = 55;
                    flameFire.velocityRange = 20;
                    flameFire.emissionLongitude = M_PI + M_PI_2;
                    flameFire.emissionRange = M_PI_4;
                    flameFire.scaleSpeed = -0.2;
                    flameFire.color = [UIColor colorWithRed:1.0 green:0.35 blue:0.0 alpha:0.85].CGColor;

                    // پڕشنگی خێرای ئاگر (Sparks)
                    CAEmitterCell *sparks = [CAEmitterCell emitterCell];
                    sparks.birthRate = 35;
                    sparks.lifetime = 1.3;
                    sparks.velocity = 80;
                    sparks.velocityRange = 30;
                    sparks.emissionLongitude = M_PI + M_PI_2;
                    sparks.emissionRange = (M_PI / 3.0);
                    sparks.scale = 0.05;
                    sparks.scaleSpeed = -0.02;
                    sparks.color = [UIColor colorWithRed:1.0 green:0.7 blue:0.1 alpha:1.0].CGColor;

                    fireEmitter.emitterCells = @[flameFire, coreFire, sparks];
                    [containerView.layer insertSublayer:fireEmitter below:shazaLabel.layer];
                }];
            }
        }];
    });
}

@end
