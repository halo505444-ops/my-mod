#import <UIKit/UIKit.h>

// پشکنینی کاتی بەسەرچوون (٣٠ ڕۆژ)
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

// دروستکردنی بۆکسێکی شوشەیی تەڵق (Glassmorphism) کە پاشبنەری یارییەی پێەوە دیارە
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
            
            CGFloat containerWidth = 210;
            CGFloat containerHeight = 100;
            CGFloat containerX = (screenWidth - containerWidth) / 2;
            CGFloat containerY = 30;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *imageURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala2.JPG"];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *customImage = [UIImage imageWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (customImage) {
                        // دروستکردنی شوشەی تەڵقی سیستەم (Blur Effect)
                        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                        UIVisualEffectView *glassView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                        glassView.frame = CGRectMake(containerX, containerY, containerWidth, containerHeight);
                        glassView.layer.cornerRadius = 16;
                        glassView.layer.borderWidth = 0.6;
                        glassView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor; // لێوارێکی زۆر کاڵ و شیک
                        glassView.clipsToBounds = YES;
                        
                        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerWidth, containerHeight)];
                        logoImageView.image = customImage;
                        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
                        logoImageView.userInteractionEnabled = NO;
                        
                        [glassView.contentView addSubview:logoImageView];
                        [window addSubview:glassView];
                        [window bringSubviewToFront:glassView];
                    }
                });
            });
        }
    });
}
