#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// پشکنینی کاتی بەسەرچوون (٣٠ ڕۆژ لە بەرواری دەستپێک: 2026-10-08)
__attribute__((constructor)) static void checkExpiration() {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = 2026;
    comps.month = 10;
    comps.day = 8;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [calendar dateFromComponents:comps];
    
    NSDateComponents *thirtyDays = [[NSDateComponents alloc] init];
    thirtyDays.day = 30;
    NSDate *expirationDate = [calendar dateByAddingComponents:thirtyDays toDate:startDate options:0];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:expirationDate] == NSOrderedDescending) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MamaHala"
                                                                         message:@"کاتی ئەم مۆدە تەواو بوو، کلیل خەڵتە شێرە برا"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"داخستن" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                exit(0);
            }]];
            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}

// جووڵەی پیتەکان و لێدانی دەنگی پێشوازیی پیاوانە بە ئینگلیزی
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // کارپێکردنی دەنگی پێشوازی (Text-to-Speech) بە دەنگی پیاوانەی پاراو
        AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Welcome to MamaHala server"];
        utterance.rate = 0.48; // خێراییەکی گونجاو و پاراو
        utterance.pitchMultiplier = 0.8; // دابەزاندنی تۆنی دەنگ بۆ ئەوەی پیاوانە و ئەستوور دەرکە우ێت
        utterance.volume = 1.0;
        [synthesizer speakUtterance:utterance];
        
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in scene.windows) {
                    if (w.isKeyWindow) {
                        window = w;
                        break;
                    }
                }
            }
        }
        if (!window) {
            window = [[[UIApplication sharedApplication] windows] firstObject];
        }
        
        if (window) {
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 340) / 2, 35, 340, 90)];
            containerView.userInteractionEnabled = NO;
            
            NSArray *letters = @[@"M", @"A", @"M", @"A", @" ", @"H", @"A", @"L", @"A"];
            CGFloat startX = 10;
            CGFloat letterWidth = 33;
            
            NSMutableArray *labelArray = [NSMutableArray array];
            
            for (int i = 0; i < letters.count; i++) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(startX + (i * letterWidth), 5, letterWidth, 50)];
                lbl.text = letters[i];
                lbl.textColor = [UIColor colorWithRed:1.0 green:0.15 blue:0.35 alpha:1.0];
                lbl.font = [UIFont boldSystemFontOfSize:32];
                lbl.textAlignment = NSTextAlignmentCenter;
                
                lbl.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.15 blue:0.35 alpha:1.0].CGColor;
                lbl.layer.shadowRadius = 8.0;
                lbl.layer.shadowOpacity = 0.9;
                lbl.layer.shadowOffset = CGSizeZero;
                
                lbl.alpha = 0.0;
                lbl.transform = CGAffineTransformMakeScale(0.1, 0.1);
                
                [containerView addSubview:lbl];
                [labelArray addObject:lbl];
            }
            
            UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 340, 25)];
            subLabel.text = @"TG: @MamaHala";
            subLabel.textColor = [UIColor whiteColor];
            subLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
            subLabel.textAlignment = NSTextAlignmentCenter;
            subLabel.alpha = 0.0;
            [containerView addSubview:subLabel];
            
            [window addSubview:containerView];
            [window bringSubviewToFront:containerView];
            
            for (int i = 0; i < labelArray.count; i++) {
                UILabel *lbl = labelArray[i];
                double delayInSeconds = 0.1 * i;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.4 animations:^{
                        lbl.alpha = 1.0;
                        lbl.transform = CGAffineTransformIdentity;
                    }];
                });
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.6 animations:^{
                    subLabel.alpha = 1.0;
                }];
            });
        }
    });
}
