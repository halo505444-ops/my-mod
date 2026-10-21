#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ShazaVIPRealFireHUD : NSObject
@end

@implementation ShazaVIPRealFireHUD

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

        // 1. بۆکسی سەرەکی (بێ چوارچێوەی قورس)
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - 280) / 2, 40, 280, 80)];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.userInteractionEnabled = NO;

        // 2. ناوی سەرەکی لە سەرەوە: SHAZAVIP
        UILabel *shazaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 280, 45)];
        shazaLabel.text = @"SHAZAVIP";
        shazaLabel.textAlignment = NSTextAlignmentCenter;
        shazaLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBlack];
        shazaLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.3 alpha:1.0]; // زێڕی زۆر گەش
        
        // درەوشانەوەی نێۆنی گەرم بۆ پشت ناوەکە
        shazaLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:1.0].CGColor;
        shazaLabel.layer.shadowRadius = 12.0f;
        shazaLabel.layer.shadowOpacity = 1.0f;
        shazaLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:shazaLabel];

        // 3. سیستەمی ئاگری ڕاستەقینە (Real Fire & Sparks Emitter)
        CAEmitterLayer *fireEmitter = [CAEmitterLayer layer];
        fireEmitter.emitterPosition = CGPointMake(containerView.bounds.size.width / 2, 38);
        fireEmitter.emitterSize = CGSizeMake(200, 10);
        fireEmitter.emitterShape = kCAEmitterLayerLine;

        // گەردیلەی ئاگری ناوەندی (ڕەنگی سپی/زەرد - زۆر گەرم)
        CAEmitterCell *coreFire = [CAEmitterCell emitterCell];
        coreFire.birthRate = 120;
        coreFire.lifetime = 0.5;
        coreFire.velocity = 35;
        coreFire.velocityRange = 15;
        coreFire.emissionLongitude = M_PI + M_PI_2;
        coreFire.emissionRange = M_PI_4 / 2;
        coreFire.scaleSpeed = -0.4;
        coreFire.color = [UIColor colorWithRed:1.0 green:1.0 blue:0.7 alpha:0.9].CGColor;

        // گەردیلەی ئاگری دەرەکی (ڕەنگی پرتەقاڵی و سوور - ڕاستەقینە)
        CAEmitterCell *flameFire = [CAEmitterCell emitterCell];
        flameFire.birthRate = 220;
        flameFire.lifetime = 0.8;
        flameFire.velocity = 55;
        flameFire.velocityRange = 25;
        flameFire.emissionLongitude = M_PI + M_PI_2;
        flameFire.emissionRange = M_PI_4;
        flameFire.scaleSpeed = -0.2;
        flameFire.color = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:0.75].CGColor;

        // پڕشنگی ئاگر (Sparks کە بەرەو هەوا دەفڕن)
        CAEmitterCell *sparks = [CAEmitterCell emitterCell];
        sparks.birthRate = 25;
        sparks.lifetime = 1.5;
        sparks.velocity = 80;
        sparks.velocityRange = 40;
        sparks.emissionLongitude = M_PI + M_PI_2;
        sparks.emissionRange = M_PI_3;
        sparks.scale = 0.05;
        sparks.scaleSpeed = -0.02;
        sparks.color = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0].CGColor;

        fireEmitter.emitterCells = @[flameFire, coreFire, sparks];
        [containerView.layer insertSublayer:fireEmitter below:shazaLabel.layer];

        // 4. دەقی خوارەوە: Anti-Ban Active ✅ (بچووک بە ڕەنگی سەوزی فسفۆڕی جیاواز)
        UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 280, 20)];
        antiBanLabel.text = @"Anti-Ban Active ✅";
        antiBanLabel.textAlignment = NSTextAlignmentCenter;
        antiBanLabel.font = [UIFont boldSystemFontOfSize:12];
        antiBanLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0]; // سەوزی نێۆن (بە تەواوی جیاواز لە ئاگرەکە)
        
        // سیبەر بۆ باشتڕ خوێندنەوە لەسەر شوێنی ئاگرەکە
        antiBanLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        antiBanLabel.layer.shadowRadius = 4.0f;
        antiBanLabel.layer.shadowOpacity = 1.0f;
        antiBanLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:antiBanLabel];

        // 5. دەرکەوتنی نەرم لەسەر شاشەی یارییەکە
        containerView.alpha = 0.0;
        [keyWindow addSubview:containerView];

        [UIView animateWithDuration:1.0 animations:^{
            containerView.alpha = 1.0;
        }];
    });
}

@end
