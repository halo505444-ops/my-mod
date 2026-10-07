#import <UIKit/UIKit.h>
#import <dlfcn.h>

// فەنکشنێک بۆ دۆزینەوە و هێنانی وێنەکە ڕاستەوخۆ لە شوێنی فایلی مۆدەکە
static UIImage *getMamaHalaImage() {
    Dl_info info;
    if (dladdr((void *)&getMamaHalaImage, &info) == 0) return nil;
    NSString *dylibPath = [NSString stringWithUTF8String:info.dli_fname];
    NSString *dylibDir = [dylibPath stringByDeletingLastPathComponent];
    
    // 1. پشکنینی ناو بەیاندڵی MamaHala.bundle ئەگەر هەبێت
    NSString *bundlePath = [dylibDir stringByAppendingPathComponent:@"MamaHala.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *imagePath = [bundle pathForResource:@"MamaHala" ofType:@"jpg"];
    if (imagePath) {
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        if (img) return img;
    }
    
    // 2. پشکنینی ڕاستەوخۆی فایلی MamaHala.jpg لە تەنیشت دایلبەکە
    NSString *directPath = [dylibDir stringByAppendingPathComponent:@"MamaHala.jpg"];
    UIImage *directImg = [UIImage imageWithContentsOfFile:directPath];
    if (directImg) return directImg;
    
    return nil;
}

// پشکنینی کاتی بەسەرچوون (٣٠ ڕۆژ)
__attribute__((constructor)) static void checkExpiration() {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = 2026;
    comps.month = 10;
    comps.day = 7;
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

// نیشاندانی وێنەی لۆگۆ لە ناوەڕاستی سەرەوەی شاشە
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
            CGFloat logoWidth = 150;
            CGFloat logoHeight = 70;
            CGFloat logoX = (screenWidth - logoWidth) / 2;
            CGFloat logoY = 40;
            
            UIImage *customImage = getMamaHalaImage();
            
            if (customImage) {
                UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoWidth, logoHeight)];
                logoImageView.image = customImage;
                logoImageView.contentMode = UIViewContentModeScaleAspectFit;
                logoImageView.userInteractionEnabled = NO;
                
                [window addSubview:logoImageView];
                [window bringSubviewToFront:logoImageView];
            }
        }
    });
}
