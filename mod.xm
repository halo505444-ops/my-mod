#import <UIKit/UIKit.h>

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

// هێنانی تاجەکە، لابردنی ڕەشی پشتەوە و بەرزکردنەوە بۆ سەرەوەتر
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
            
            CGFloat logoWidth = 210;
            CGFloat logoHeight = 100;
            CGFloat logoX = (screenWidth - logoWidth) / 2;
            CGFloat logoY = 10; // لێرە بەرزترمان کردەوە بۆ سەرەوە (پێشتر 30 بوو)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *imageURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala2.JPG"];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *customImage = [UIImage imageWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (customImage) {
                        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoWidth, logoHeight)];
                        logoImageView.image = customImage;
                        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
                        
                        logoImageView.layer.allowsEdgeAntialiasing = YES;
                        logoImageView.layer.compositingFilter = @"screenBlendMode";
                        
                        logoImageView.userInteractionEnabled = NO;
                        
                        [window addSubview:logoImageView];
                        [window bringSubviewToFront:logoImageView];
                    }
                });
            });
        }
    });
}
