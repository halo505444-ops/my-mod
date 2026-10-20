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

            // لایەری سەرەکی (بچووکتر و نزیکتر لە سەرەوە)
            UIView *mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 35, keyWindow.bounds.size.width, 90)];
            mainContainer.userInteractionEnabled = NO;

            // 1. دەقی سەرەوە (HAMA⚡️VIP) - قەبارە بچووکتر و توندتر
            UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainContainer.bounds.size.width, 45)];
            topTitle.textAlignment = NSTextAlignmentCenter;
            topTitle.font = [UIFont boldSystemFontOfSize:24];
            topTitle.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
            topTitle.layer.shadowColor = [UIColor cyanColor].CGColor;
            topTitle.layer.shadowRadius = 8.0f;
            topTitle.layer.shadowOpacity = 0.9f;
            topTitle.layer.shadowOffset = CGSizeZero;
            [mainContainer addSubview:topTitle];

            // 2. دەقی خوارەوە (TG➡️hama_vip0) - زۆر بچووک و نزیک
            UILabel *bottomTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, mainContainer.bounds.size.width, 25)];
            bottomTitle.text = @"TG➡️hama_vip0";
            bottomTitle.textAlignment = NSTextAlignmentCenter;
            bottomTitle.font = [UIFont boldSystemFontOfSize:12];
            bottomTitle.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
            bottomTitle.layer.shadowColor = [UIColor magentaColor].CGColor;
            bottomTitle.layer.shadowRadius = 5.0f;
            bottomTitle.layer.shadowOpacity = 0.8f;
            bottomTitle.layer.shadowOffset = CGSizeZero;
            [mainContainer addSubview:bottomTitle];

            [keyWindow addSubview:mainContainer];

            // پیت بە پیت و بێ پچڕان (HAMA⚡️VIP)
            NSString *fullTopText = @"HAMA⚡️VIP";
            __block int index = 0;
            __block BOOL isDeleting = NO;

            [NSTimer scheduledTimerWithTimeInterval:0.12 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (!isDeleting) {
                    if (index <= fullTopText.length) {
                        topTitle.text = [fullTopText substringToIndex:index];
                        index++;
                    } else {
                        isDeleting = YES;
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

            // 3. ئەنتی باند بێ هیچ چوارچێوەیەک و جووڵەی هەڕەمەکی
            UILabel *antiBanLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 180, 220, 30)];
            antiBanLabel.text = @"ئەنتی باند ❌";
            antiBanLabel.textAlignment = NSTextAlignmentCenter;
            antiBanLabel.font = [UIFont boldSystemFontOfSize:14];
            antiBanLabel.textColor = [UIColor redColor];
            antiBanLabel.backgroundColor = [UIColor clearColor]; // لادانی تەواوی چوارچێوە و باگراوند
            antiBanLabel.layer.shadowColor = [UIColor blackColor].CGColor;
            antiBanLabel.layer.shadowRadius = 4.0f;
            antiBanLabel.layer.shadowOpacity = 0.9f;
            antiBanLabel.layer.shadowOffset = CGSizeZero;
            [keyWindow addSubview:antiBanLabel];

            // جووڵەی هەڕەمەکی بە دەوردا بێوەستان
            [UIView animateKeyframesWithDuration:7.0 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
                [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
                    antiBanLabel.center = CGPointMake(100, 300);
                }];
                [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3 animations:^{
                    antiBanLabel.center = CGPointMake(keyWindow.bounds.size.width - 100, 220);
                }];
                [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.4 animations:^{
                    antiBanLabel.center = CGPointMake(160, 380);
                }];
            } completion:nil];

            // گۆڕینی دۆخەکە بۆ ئەنتی باند ✅ پاش ١٢ چرکە
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                antiBanLabel.text = @"ئەنتی باند ✅";
                antiBanLabel.textColor = [UIColor greenColor];
            });
        });
    });
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HamaVIPManager startModUI];
    });
}
