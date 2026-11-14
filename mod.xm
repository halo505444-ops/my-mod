#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

// فەنکشنێک بۆ لابردنی ڕەنگی ڕەشی پاشبنەمای وێنەی JPG بە شێوەی ئۆتۆماتیکی
UIImage* removeBlackBackground(UIImage *image) {
    if (!image) return nil;
    CGImageRef rawImageRef = image.CGImage;
    // دیاریکردنی مەودای ڕەنگی ڕەش (لە 0 تا 35) بۆ ئەوەی بکرێتە شەفاف
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
        
        // بەستەری ڕاستەوخۆی (Raw) وێنەکەت لە گیتهەب
        NSURL *imageURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala2.JPG"];
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error) {
                UIImage *downloadedImage = [UIImage imageWithData:data];
                // لابردنی باکگراوندە ڕەشەکە
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
                        // قەبارە و شوێنی لۆگۆکە لەسەر شاشە (دەتوانیت X و Y بگۆڕیت)
                        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 110, 110)];
                        logoView.image = transparentLogo;
                        logoView.contentMode = UIViewContentModeScaleAspectFit;
                        logoView.backgroundColor = [UIColor clearColor];
                        logoView.userInteractionEnabled = NO; // بۆ ئەوەی ڕێگری لە دەستلێدانی یارییەکە نەکات
                        
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
