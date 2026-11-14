#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

UIImage* removeBlackBackground(UIImage *image) {
    if (!image) return nil;
    CGImageRef rawImageRef = image.CGImage;
    const CGFloat colorMasking[6] = {0, 35, 0, 35, 0, 35};
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (maskedImageRef) CGImageRelease(maskedImageRef);
    
    return result ? result : image;
}

static void setupFloatingLogo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSURL *imageURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala2.JPG"];
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error) {
                UIImage *downloadedImage = [UIImage imageWithData:data];
                UIImage *transparentLogo = removeBlackBackground(downloadedImage);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIWindow *keyWindow = nil;
                    if (@available(iOS 13.0, *)) {
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
                    }
                    if (!keyWindow) {
                        keyWindow = [UIApplication sharedApplication].keyWindow;
                    }
                    
                    if (keyWindow && transparentLogo) {
                        // قەبارەی لۆگۆکە
                        CGFloat logoWidth = 110.0;
                        CGFloat logoHeight = 110.0;
                        
                        // هەژمارکردنی ڕێک ناوەڕاستی شاشەکە
                        CGFloat screenWidth = keyWindow.bounds.size.width;
                        CGFloat centerX = (screenWidth - logoWidth) / 2.0;
                        CGFloat topY = 15.0; // دووری لە لێواری سەرەوە (دەتوانیت بیگۆڕیت)
                        
                        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX, topY, logoWidth, logoHeight)];
                        logoView.image = transparentLogo;
                        logoView.contentMode = UIViewContentModeScaleAspectFit;
                        logoView.backgroundColor = [UIColor clearColor];
                        logoView.userInteractionEnabled = NO;
                        logoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                        
                        [keyWindow addSubview:logoView];
                    }
                });
            }
        }];
        [downloadTask resume];
    });
}

%ctor {
    setupFloatingLogo();
}
