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

        // 1. بۆکسی سەرەکی (بچووک و لە سەرەوە - بەبێ ڕێگریکردن لە کلیکەکانی یارییەکە)
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - 200) / 2, 15, 200, 65)];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.userInteractionEnabled = NO; // <--- ئەمە وا دەکات کلیکەکان تێپەڕبن بۆ ناو یارییەکە
        [keyWindow addSubview:containerView];

        // 2. دەقی هاکینگ لە سەرەتاوە
        UILabel *hackerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 190, 55)];
        hackerLabel.textColor = [UIColor greenColor];
        hackerLabel.font = [UIFont fontWithName:@"Courier-Bold" size:10];
        hackerLabel.numberOfLines = 3;
        hackerLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:hackerLabel];

        // 3. ناوی SHAZAVIP (لە سەرەوە بە قەبارەی گونجاو)
        UILabel *shazaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 200, 35)];
        shazaLabel.text = @"SHAZAVIP";
        shazaLabel.textAlignment = NSTextAlignmentCenter;
        shazaLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBlack];
        shazaLabel.textColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.3 alpha:1.0]; // زێڕی گەش
        shazaLabel.alpha = 0.0;
        
        shazaLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:1.0].CGColor;
        shazaLabel.layer.shadowRadius = 8.0f;
        shazaLabel.layer.shadowOpacity = 1.0f;
        shazaLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:shazaLabel];

        // 4. دەقی خوارەوە: Anti-Ban Active ✅
        UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 200, 18)];
        antiBanLabel.text = @"Anti-Ban Active ✅";
        antiBanLabel.textAlignment = NSTextAlignmentCenter;
        antiBanLabel.font = [UIFont boldSystemFontOfSize:9.5];
        antiBanLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
        antiBanLabel.alpha = 0.0;
        
        antiBanLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        antiBanLabel.layer.shadowRadius = 2.0f;
        antiBanLabel.layer.shadowOpacity = 1.0f;
        antiBanLabel.layer.shadowOffset = CGSizeZero;
        [containerView addSubview:antiBanLabel];

        // 5. زنجیرەی ئەنیمەیشنی هاکینگ و پاشان ئاگرگرتن
        NSArray *hackMessages = @[
            @"> KERNEL INJECTION...",
            @"> BYPASSING ANTI-BAN...",
            @"> SHAZAVIP SECURED 🚀"
        ];
        __block int step = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.4 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (step < hackMessages.count) {
                hackerLabel.text = hackMessages[step];
                step++;
            } else {
                [timer invalidate];

                [UIView animateWithDuration:0.5 animations:^{
                    hackerLabel.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [hackerLabel removeFromSuperview];

                    shazaLabel.alpha = 1.0;
                    antiBanLabel.alpha = 1.0;

                    // سیستەمی ئاگری ڕاستەقینە لەسەر ناوەکە
                    CAEmitterLayer *fireEmitter = [CAEmitterLayer layer];
                    fireEmitter.emitterPosition = CGPointMake(containerView.bounds.size.width / 2, 35);
                    fireEmitter.emitterSize = CGSizeMake(140, 5);
                    fireEmitter.emitterShape = kCAEmitterLayerLine;

                    CAEmitterCell *coreFire = [CAEmitterCell emitterCell];
                    coreFire.birthRate = 90;
                    coreFire.lifetime = 0.4;
                    coreFire.velocity = 25;
                    coreFire.velocityRange = 10;
                    coreFire.emissionLongitude = M_PI + M_PI_2;
                    coreFire.emissionRange = M_PI_4 / 2.0;
                    coreFire.scaleSpeed = -0.3;
                    coreFire.color = [UIColor colorWithRed:1.0 green:1.0 blue:0.7 alpha:0.9].CGColor;

                    CAEmitterCell *flameFire = [CAEmitterCell emitterCell];
                    flameFire.birthRate = 150;
                    flameFire.lifetime = 0.6;
                    flameFire.velocity = 40;
                    flameFire.velocityRange = 15;
                    flameFire.emissionLongitude = M_PI + M_PI_2;
                    flameFire.emissionRange = M_PI_4;
                    flameFire.scaleSpeed = -0.2;
                    flameFire.color = [UIColor colorWithRed:1.0 green:0.3 blue:0.0 alpha:0.75].CGColor;

                    CAEmitterCell *sparks = [CAEmitterCell emitterCell];
                    sparks.birthRate = 15;
                    sparks.lifetime = 1.2;
                    sparks.velocity = 60;
                    sparks.velocityRange = 25;
                    sparks.emissionLongitude = M_PI + M_PI_2;
                    sparks.emissionRange = (M_PI / 3.0);
                    sparks.scale = 0.04;
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
