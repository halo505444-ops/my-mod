#import <UIKit/UIKit.h>

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
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}

%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window) {
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat logoWidth = 150;
            CGFloat logoHeight = 70;
            CGFloat logoX = (screenWidth - logoWidth) / 2;
            CGFloat logoY = 40;
            
            NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/MobileSubstrate/DynamicLibraries/MamaHala.bundle"];
            UIImage *customImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"MamaHala" ofType:@"jpg"]];
            
            UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoWidth, logoHeight)];
            logoImageView.image = customImage;
            logoImageView.contentMode = UIViewContentModeScaleAspectFit;
            logoImageView.userInteractionEnabled = NO;
            
            [window addSubview:logoImageView];
        }
    });
}
