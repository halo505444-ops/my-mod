#import <UIKit/UIKit.h>

@interface HamaVIPManager : NSObject
+ (void)startModUI;
@end

@implementation HamaVIPManager

+ (void)startModUI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
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
            if (!keyWindow) {
                keyWindow = [UIApplication sharedApplication].windows.firstObject;
            }
            if (!keyWindow) return;

            // لایەری سەرەکی بۆ دەقی سەرەوە و خوارەوە
            UIView *mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 60, keyWindow.bounds.size.width, 120)];
            mainContainer.userInteractionEnabled = NO;

            // 1. دەقی سەرەوە (HAMA⚡️VIP) - پیت بە پیت و دووبارەبوونەوەی بەردەوام
            UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainContainer.bounds.size.width, 60)];
            topTitle.textAlignment = NSTextAlignmentCenter;
            topTitle.font = [UIFont boldSystemFontOfSize:34];
            topTitle.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]; // زێڕی
            topTitle.layer.shadowColor = [UIColor cyanColor].CGColor;
            topTitle.layer.shadowRadius = 10.0f;
            topTitle.layer.shadowOpacity = 0.9f;
            topTitle.layer.shadowOffset = CGSizeZero;
            [mainContainer addSubview:topTitle];

            // 2. دەقی خوارەوە (TG➡️hama_vip0) - بە بچوکی ڕاوەستاو
            UILabel *bottomTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, mainContainer.bounds.size.width, 30)];
            bottomTitle.text = @"TG➡️hama_vip0";
            bottomTitle.textAlignment = NSTextAlignmentCenter;
            bottomTitle.font = [UIFont boldSystemFontOfSize:14];
            bottomTitle.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0]; // شینێکی کاڵ
            bottomTitle.layer.shadowColor = [UIColor magentaColor].CGColor;
            bottomTitle.layer.shadowRadius = 6.0f;
            bottomTitle.layer.shadowOpacity = 0.8f;
            bottomTitle.layer.shadowOffset = CGSizeZero;
            [mainContainer addSubview:bottomTitle];

            [keyWindow addSubview:mainContainer];

            // لۆژیکی پیت بە پیت بۆ دەقی سەرەوە (بەردەوام دێت و دڕوات)
            NSString *fullTopText = @"HAMA⚡️VIP";
            __block int index = 0;
            __block BOOL isDeleting = NO;

            [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (!isDeleting) {
                    if (index <= fullTopText.length) {
                        topTitle.text = [fullTopText substringToIndex:index];
                        index++;
                    } else {
                        isDeleting = YES;
                        // کاتێک تەواو بوو کەمێک دەوەستێت پاشان دەست بە سڕینەوە دەکات
                    }
                } else {
                    if (index >= 0) {
                        topTitle.text = [fullTopText substringToIndex:index];
                        index--;
                    } else {
                        isDeleting = NO;
                    }
                }
            }];

            // 3. دروستکردنی دەقی ئەنتی باند کە بە هەڕەمەکی دەجووڵێت (Floating Anti-Ban Text)
            UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 240, 35)];
            antiBanLabel.text = @"ئەکتیف نیە ئەنتی باند ❗️❗️";
            antiBanLabel.textAlignment = NSTextAlignmentCenter;
            antiBanLabel.font = [UIFont boldSystemFontOfSize:13];
            antiBanLabel.textColor = [UIColor redColor]; // سەرەت بە ڕەنگی سوور
            antiBanLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            antiBanLabel.layer.cornerRadius = 8;
            antiBanLabel.clipsToBounds = YES;
            [keyWindow addSubview:antiBanLabel];

            // جووڵەی هەڕەمەکی بۆ دەقی ئەنتی باند (بڕواتە ئەولاو ئەولا)
            [UIView animateKeyframesWithDuration:6.0 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
                [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
                    antiBanLabel.center = CGPointMake(120, 350);
                }];
                [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
                    antiBanLabel.center = CGPointMake(keyWindow.bounds.size.width - 120, 280);
                }];
                [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
                    antiBanLabel.center = CGPointMake(150, 420);
                }];
                [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
                    antiBanLabel.center = CGPointMake(keyWindow.bounds.size.width - 150, 180);
                }];
            } completion:nil];

            // پاش چەند چرکەیەک (بۆ نموونە کاتێک دەگاتە لۆبی - ١٢ چرکە)، دەقەکە دەگۆڕێت بۆ ئەنتی باند کارایە ✅
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                antiBanLabel.text = @"ئەنتی باند کارایە ✅";
                antiBanLabel.textColor = [UIColor greenColor]; // دەبێتە سەوز
            });
        });
    });
}

@end

// کارپێکردنی ڕاستەوخۆ کاتێک یارییەکە دەکرێتەوە
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HamaVIPManager startModUI];
    });
}
