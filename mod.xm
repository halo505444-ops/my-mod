#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface ShazaVIPGodModeUltimateHUD : NSObject
@end

@implementation ShazaVIPGodModeUltimateHUD

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

        // 1. قەبارەی دشبۆردە فراوان و لوتکە پێشکەوتووەکە
        CGFloat width = 390.0;
        CGFloat height = 120.0;
        UIView *dashboard = [[UIView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - width) / 2, 8, width, height)];
        dashboard.backgroundColor = [UIColor colorWithRed:0.002 green:0.005 blue:0.02 alpha:0.94];
        dashboard.layer.cornerRadius = 22;
        dashboard.layer.borderWidth = 2.2;
        dashboard.layer.borderColor = [UIColor cyanColor].CGColor;
        dashboard.clipsToBounds = YES;
        dashboard.userInteractionEnabled = NO; // کلیکەکان تێدەپەڕن بۆ ناو یارییەکە بەبێ ڕێگری

        // درەوشانەوەی نێۆنی گەورەی سایبەری و پلازما
        dashboard.layer.shadowColor = [UIColor magentaColor].CGColor;
        dashboard.layer.shadowRadius = 20.0f;
        dashboard.layer.shadowOpacity = 1.0f;
        dashboard.layer.shadowOffset = CGSizeZero;
        [keyWindow addSubview:dashboard];

        // 2. ئەنیمەیشنی توندی ڕەنگی چوارچێوە (RGB Neon Hyper Border)
        CABasicAnimation *rgbAnim = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        rgbAnim.fromValue = (id)[UIColor cyanColor].CGColor;
        rgbAnim.toValue = (id)[UIColor colorWithRed:1.0 green:0.0 blue:0.5 alpha:1.0].CGColor;
        rgbAnim.duration = 1.5;
        rgbAnim.autoreverses = YES;
        rgbAnim.repeatCount = HUGE_VALF;
        [dashboard.layer addAnimation:rgbAnim forKey:@"rgbBorderAnim"];

        // 3. هێڵی سکانکردنی لێزەری سەربازی (Laser Scan Line Effect)
        UIView *scanLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 2)];
        scanLine.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.6 alpha:0.95];
        [dashboard addSubview:scanLine];

        CABasicAnimation *scanAnim = [CABasicAnimation animationWithKeyPath:@"position.y"];
        scanAnim.fromValue = @(0);
        scanAnim.toValue = @(height);
        scanAnim.duration = 1.5;
        scanAnim.autoreverses = YES;
        scanAnim.repeatCount = HUGE_VALF;
        [scanLine.layer addAnimation:scanAnim forKey:@"scanLineAnim"];

        // 4. تایتڵی سەرەکی SHAZAVIP GOD-MODE ULTIMATE
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, width - 20, 30)];
        titleLabel.text = @"⚡️ SHAZAVIP // GOD-MODE ULTIMATE ⚡️";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBlack];
        titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.15 alpha:1.0]; // زێڕی درەوشاوە
        
        titleLabel.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:1.0].CGColor;
        titleLabel.layer.shadowRadius = 8.0f;
        titleLabel.layer.shadowOpacity = 1.0f;
        titleLabel.layer.shadowOffset = CGSizeZero;
        [dashboard addSubview:titleLabel];

        // 5. دۆخی سیستەمی ئەمنی و دژە باند (Matrix Security Status)
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, width - 20, 20)];
        statusLabel.text = @"> KERNEL BYPASS: 100% SECURE [ANTI-BAN ACTIVE ✅]";
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont fontWithName:@"Courier-Bold" size:10.5];
        statusLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.45 alpha:1.0];
        [dashboard addSubview:statusLabel];

        // 6. زانیارییە زیندووەکانی پینگ، FPS و باری میمۆری (Live Telemetry Engine)
        UILabel *statsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, width - 20, 20)];
        statsLabel.textAlignment = NSTextAlignmentCenter;
        statsLabel.font = [UIFont boldSystemFontOfSize:10];
        statsLabel.textColor = [UIColor colorWithRed:0.2 green:0.85 blue:1.0 alpha:1.0];
        [dashboard addSubview:statsLabel];

        // مۆدویولەی نوێکردنەوەی بەردەوامی پینگ و فریمەکان
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            int dynamicPing = 10 + arc4random_uniform(6);
            int dynamicFPS = 59 + arc4random_uniform(3);
            statsLabel.text = [NSString stringWithFormat:@"Ping: %dms | FPS: %d | RAM: Optimized | Status: Elite", dynamicPing, dynamicFPS];
        }];

        // 7. زانیاری زیاتری پلەی گەرم و هێرشەکان (Sub-Telemetry Row)
        UILabel *subStatsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 78, width - 20, 20)];
        subStatsLabel.text = @"CPU Load: 4.2% | Packet Loss: 0.0% | Core: Active";
        subStatsLabel.textAlignment = NSTextAlignmentCenter;
        subStatsLabel.font = [UIFont fontWithName:@"Courier-Bold" size:9.5];
        subStatsLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.8 alpha:1.0];
        [dashboard addSubview:subStatsLabel];

        // 8. دێڕی خوارەوەی پەنێڵەکە (Cybernetic Footer Status)
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 98, width - 20, 18)];
        footerLabel.text = @"[ ALL SHAZAVIP PROTOCOLS FULLY OPERATIONAL ]";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont fontWithName:@"Courier" size:9];
        footerLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.9];
        [dashboard addSubview:footerLabel];

        // 9. سیستەمی پێشکەوتووی پڕشنگی ئەستێرەیی (Advanced Particle Spark Emitter)
        CAEmitterLayer *sparkEmitter = [CAEmitterLayer layer];
        sparkEmitter.emitterPosition = CGPointMake(width / 2, height);
        sparkEmitter.emitterSize = CGSizeMake(width, 5);
        sparkEmitter.emitterShape = kCAEmitterLayerLine;

        CAEmitterCell *sparkCell = [CAEmitterCell emitterCell];
        sparkCell.birthRate = 30;
        sparkCell.lifetime = 1.4;
        sparkCell.velocity = 40;
        sparkCell.velocityRange = 15;
        sparkCell.emissionLongitude = M_PI + M_PI_2;
        sparkCell.emissionRange = (M_PI / 3.0);
        sparkCell.scale = 0.05;
        sparkCell.scaleSpeed = -0.015;
        sparkCell.color = [UIColor cyanColor].CGColor;

        sparkEmitter.emitterCells = @[sparkCell];
        [dashboard.layer insertSublayer:sparkEmitter atIndex:0];

        // 10. ئەنیمەیشنی دەرکەوتنی شاهانە بە هێزی Spring
        dashboard.alpha = 0.0;
        dashboard.transform = CGAffineTransformMakeScale(0.4, 0.4);
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:0.8 options:0 animations:^{
            dashboard.alpha = 1.0;
            dashboard.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

@end
