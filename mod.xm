#import <UIKit/UIKit.h>

%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window) {
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat logoWidth = 150;
            CGFloat logoHeight = 70;
            CGFloat logoX = (screenWidth - logoWidth) / 2;
            CGFloat logoY = 40;
            
            // خوێندنەوەی وێنەکە ڕاستەوخۆ لەناو بەیاندڵی مۆدەکەوە
            NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/MobileSubstrate/DynamicLibraries/my-mod.bundle"];
            UIImage *customImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"JPEG" ofType:@"jpg"]];
            
            UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, logoY, logoWidth, logoHeight)];
            logoImageView.image = customImage;
            logoImageView.contentMode = UIViewContentModeScaleAspectFit;
            logoImageView.userInteractionEnabled = NO;
            
            [window addSubview:logoImageView];
        }
    });
}
