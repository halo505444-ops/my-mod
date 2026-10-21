#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface ShazaVIPHackerFireShow : NSObject
@end

@implementation ShazaVIPHackerFireShow

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

        // 1. بۆکسی سەرەکی
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - 280) / 2, 40, 280, 90)];
        containerView.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.05 alpha:0.85];
        containerView.layer.cornerRadius = 15;
        containerView.layer.borderWidth = 1.2;
        containerView.layer.borderColor = [UIColor greenColor].CGColor;
        containerView.clipsToBounds = YES;
        [keyWindow addSubview:containerView];

        // 2. دەقی هاکینگ لە سەرەتاوە
        UILabel *hackerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 260, 60)];
        hackerLabel.textColor = [UIColor greenColor];
        hackerLabel.font = [UIFont fontWithName:@"Courier-Bold" size:12];
        hackerLabel.numberOfLines = 3;
        hackerLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:hackerLabel];

        // 3. ناوی SHAZAVIP (لە سەرەتادا نادیارە تا کاتی ئاگرگرتن)
        UILabel *shazaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 45)];
        shazaLabel.text = @"SHAZAVIP";
        shazaLabel.textAlignment = NSTextAlignmentCenter;
        shazaLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBlack];
        shazaLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.3 alpha:1.0]; // زێڕی گەش
        shazaLabel.alpha = 0.0;
        
        // درەوشانەوەی ئاگرین بۆ پشت ناوەکە
        shazaLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:1.0].CGColor;
        shazaLabel.layer.shadowRadius = 10.0f;
        shazaLabel.layer.shadowOpacity = 1.0f;
        shazaLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:shazaLabel];

        // 4. دەقی خوارەوە: Anti-Ban Active ✅ (بە ڕەنگی سەوزی فسفۆڕی جیاواز لە ئاگرەکە)
        UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 280, 20)];
        antiBanLabel.text = @"Anti-Ban Active ✅";
        antiBanLabel.textAlignment = NSTextAlignmentCenter;
        antiBanLabel.font = [UIFont boldSystemFontOfSize:11];
        antiBanLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
        antiBanLabel.alpha = 0.0;
        
        antiBanLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        antiBanLabel.layer.shadowRadius = 3.0f;
        antiBanLabel.layer.shadowOpacity = 1.0f;
        antiBanLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:antiBanLabel];

        // 5. زنجیرەی ئەنیمەیشنی هاکینگ و پاشان تەقینەوەی ئاگرەکە
        NSArray *hackMessages = @[
            @"> INITIALIZING KERNEL INJECTION...",
            @"> BYPASSING ANTI-BAN PROTOCOLS...",
            @"> SHAZAVIP SECURED 100% 🚀"
        ];
        __block int step = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (step < hackMessages.count) {
                hackerLabel.text = hackMessages[step];
                step++;
            } else {
                [timer invalidate];

                // لابرنی دەقی هاکینگ و گۆڕینی باگراوند بۆ شوشەیی پاک
                [UIView animateWithDuration:0.6 animations:^{
                    hackerLabel.alpha = 0.0;
                    containerView.backgroundColor = [UIColor clearColor];
                    containerView.layer.borderColor = [UIColor clearColor].CGColor;
                } completion:^(BOOL finished) {
                    [hackerLabel removeFromSuperview];

                    // نیشاندانی ناوی شازە، دژە باند و دەستپێکی ئاگرەکە
                    shazaLabel.alpha = 1.0;
                    antiBanLabel.alpha = 1.0;

                    // سیستەمی ئاگری ڕاستەقینە (Real Fire Emitter) لەسەر ناوەکە
                    CAEmitterLayer *fireEmitter = [CAEmitterLayer layer];
                    fireEmitter.emitterPosition = CGPointMake(containerView.bounds.size.width / 2, 45);
                    fireEmitter.emitterSize = CGSizeMake(200, 10);
                    fireEmitter.emitterShape = kCAEmitterLayerLine;

                    // گەردیلەی ئاگری ناوەندی (سپی/زەرد)
                    CAEmitterCell *coreFire = [CAEmitterCell emitterCell];
                    coreFire.birthRate = 120;
                    coreFire.lifetime = 0.5;
                    coreFire.velocity = 35;
                    coreFire.velocityRange = 15;
                    coreFire.emissionLongitude = M_PI + M_PI_2;
                    coreFire.emissionRange = M_PI_4 / 2.0;
                    coreFire.scaleSpeed = -0.4;
                    coreFire.color = [UIColor colorWithRed:1.0 green:1.0 blue:0.7 alpha:0.9].CGColor;

                    // گەردیلەی ئاگری دەرەکی (پرتەقاڵی و سوور)
                    CAEmitterCell *flameFire = [CAEmitterCell emitterCell];
                    flameFire.birthRate = 220;
                    flameFire.lifetime = 0.8;
                    flameFire.velocity = 55;
                    flameFire.velocityRange = 25;
                    flameFire.emissionLongitude = M_PI + M_PI_2;
                    flameFire.emissionRange = M_PI_4;
                    flameFire.scaleSpeed = -0.2;
                    flameFire.color = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:0.75].CGColor;

                    // پڕشنگی ئاگر (Sparks)
                    CAEmitterCell *sparks = [CAEmitterCell emitterCell];
                    sparks.birthRate = 25;
                    sparks.lifetime = 1.5;
                    sparks.velocity = 80;
                    sparks.velocityRange = 40;
                    sparks.emissionLongitude = M_PI + M_PI_2;
                    sparks.emissionRange = (M_PI / 3.0);
                    sparks.scale = 0.05;
                    sparks.scaleSpeed = -0.02;
                    sparks.color = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0].CGColor;

                    fireEmitter.emitterCells = @[flameFire, coreFire, sparks];
                    [containerView.layer insertSublayer:fireEmitter below:shazaLabel.layer];
                }];
            }
        }];
    });
}

@end
