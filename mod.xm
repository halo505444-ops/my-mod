#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

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

// وێنە لەسەرەوە، پیتەکان یەک بە دوای یەک و دەنگی پێشوازی (بێ نوسینی خوارەوە)
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // کارپێکردنی دەنگی پێشوازیی پیاوانەی پاراو
        AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Welcome to MamaHala server"];
        utterance.rate = 0.48;
        utterance.pitchMultiplier = 0.8;
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
            
            // کۆنتێنەری سەرەکی کە وێنە و پیتەکانی تێدایە
            UIView *mainContainer = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - 320) / 2, 15, 320, 140)];
            mainContainer.userInteractionEnabled = NO;
            mainContainer.alpha = 0.0;
            
            // ١. هێنانی وێنەکە لە گیتهەب و دانانی لە سەرەوە
            UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - 240) / 2, 0, 240, 75)];
            logoImageView.contentMode = UIViewContentModeScaleAspectFit;
            logoImageView.layer.allowsEdgeAntialiasing = YES;
            logoImageView.layer.cornerRadius = 10;
            logoImageView.clipsToBounds = YES;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *imageURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala.jpg"];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *customImage = [UIImage imageWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (customImage) {
                        logoImageView.image = customImage;
                    }
                });
            });
            [mainContainer addSubview:logoImageView];
            
            // ٢. پیتەکانی MAMA HALA بە نۆرە و یەک بە دوای یەک
            NSArray *letters = @[@"M", @"A", @"M", @"A", @" ", @"H", @"A", @"L", @"A"];
            CGFloat startX = 5;
            CGFloat letterWidth = 33;
            NSMutableArray *labelArray = [NSMutableArray array];
            
            for (int i = 0; i < letters.count; i++) {
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(startX + (i * letterWidth), 80, letterWidth, 40)];
                lbl.text = letters[i];
                lbl.textColor = [UIColor colorWithRed:1.0 green:0.15 blue:0.35 alpha:1.0];
                lbl.font = [UIFont boldSystemFontOfSize:28];
                lbl.textAlignment = NSTextAlignmentCenter;
                
                // تیشکدانەوەی پیتەکان (Glow)
                lbl.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.15 blue:0.35 alpha:1.0].CGColor;
                lbl.layer.shadowRadius = 8.0;
                lbl.layer.shadowOpacity = 0.9;
                lbl.layer.shadowOffset = CGSizeZero;
                
                lbl.alpha = 0.0;
                lbl.transform = CGAffineTransformMakeScale(0.1, 0.1);
                
                [mainContainer addSubview:lbl];
                [labelArray addObject:lbl];
            }
            
            [window addSubview:mainContainer];
            [window bringSubviewToFront:mainContainer];
            
            // ئەنیمەیشنی دەرکەوتنی گشتی کۆنتێنەر
            [UIView animateWithDuration:0.5 animations:^{
                mainContainer.alpha = 1.0;
            }];
            
            // جووڵەی پیتەکان یەک بە دوای یەک (Staggered Animation)
            for (int i = 0; i < labelArray.count; i++) {
                UILabel *lbl = labelArray[i];
                double delayInSeconds = 0.08 * i;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER
