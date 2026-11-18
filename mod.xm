#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMedia/CoreMedia.h>
#import <objc/message.h>
#import <dlfcn.h>

static id introPlayer = nil;
static CALayer *introPlayerLayer = nil;
static UIView *videoContainer = nil;
static UIView *menuOverlay = nil;

// لابردنی پاشبنەمای ڕەشی وێنەی MAMA.JPG بۆ لۆگۆکەی سەرەوە
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

static UIWindow* getActiveWindow() {
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
    return keyWindow;
}

// دانانی لۆگۆی MAMA.JPG یەکسەر لە ناوەڕاستی سەرەوەی شاشە بەبێ باکگراوندی ڕەش
static void setupTopLogo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURL *imageURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MAMA.JPG"];
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error) {
                UIImage *downloadedImage = [UIImage imageWithData:data];
                UIImage *transparentLogo = removeBlackBackground(downloadedImage);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIWindow *keyWindow = getActiveWindow();
                    if (keyWindow && transparentLogo) {
                        CGFloat logoWidth = 110.0;
                        CGFloat logoHeight = 110.0;
                        CGFloat screenWidth = keyWindow.bounds.size.width;
                        CGFloat centerX = (screenWidth - logoWidth) / 2.0;
                        CGFloat topY = 15.0;
                        
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

@interface BloodMenuHandler : NSObject
+ (instancetype)shared;
- (void)skipTapped;
- (void)okTapped;
@end

static void playFullScreenVideo(UIWindow *keyWindow) {
    if (!keyWindow) return;
    
    dlopen("/System/Library/Frameworks/AVFoundation.framework/AVFoundation", RTLD_LAZY);
    
    Class AVPlayerItemClass = NSClassFromString(@"AVPlayerItem");
    Class AVPlayerClass = NSClassFromString(@"AVPlayer");
    Class AVPlayerLayerClass = NSClassFromString(@"AVPlayerLayer");
    
    if (!AVPlayerItemClass || !AVPlayerClass || !AVPlayerLayerClass) return;
    
    NSURL *videoURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/Mama.MP4"];
    
    videoContainer = [[UIView alloc] initWithFrame:keyWindow.bounds];
    videoContainer.backgroundColor = [UIColor blackColor];
    videoContainer.userInteractionEnabled = NO;
    videoContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    id playerItem = ((id (*)(Class, SEL, NSURL *))objc_msgSend)(AVPlayerItemClass, sel_registerName("playerItemWithURL:"), videoURL);
    introPlayer = ((id (*)(Class, SEL, id))objc_msgSend)(AVPlayerClass, sel_registerName("playerWithPlayerItem:"), playerItem);
    
    ((void (*)(id, SEL, BOOL))objc_msgSend)(introPlayer, sel_registerName("setMuted:"), NO);
    
    introPlayerLayer = ((CALayer * (*)(Class, SEL, id))objc_msgSend)(AVPlayerLayerClass, sel_registerName("playerLayerWithPlayer:"), introPlayer);
    introPlayerLayer.frame = videoContainer.bounds;
    [introPlayerLayer setValue:@"AVLayerVideoGravityResize" forKey:@"videoGravity"];
    
    [videoContainer.layer addSublayer:introPlayerLayer];
    [keyWindow addSubview:videoContainer];
    
    ((void (*)(id, SEL))objc_msgSend)(introPlayer, sel_registerName("play"));
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"AVPlayerItemDidPlayToEndTimeNotification"
                                                      object:playerItem
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
        [UIView animateWithDuration:0.5 animations:^{
            videoContainer.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (introPlayer) {
                ((void (*)(id, SEL))objc_msgSend)(introPlayer, sel_registerName("pause"));
            }
            [introPlayerLayer removeFromSuperlayer];
            [videoContainer removeFromSuperview];
            introPlayer = nil;
            introPlayerLayer = nil;
            videoContainer = nil;
        }];
    }];
}

@implementation BloodMenuHandler

+ (instancetype)shared {
    static BloodMenuHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BloodMenuHandler alloc] init];
    });
    return instance;
}

- (void)skipTapped {
    if (!menuOverlay) return;
    [UIView animateWithDuration:0.3 animations:^{
        menuOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [menuOverlay removeFromSuperview];
        menuOverlay = nil;
    }];
}

- (void)okTapped {
    if (!menuOverlay) return;
    UIWindow *parentWindow = menuOverlay.window;
    [UIView animateWithDuration:0.3 animations:^{
        menuOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [menuOverlay removeFromSuperview];
        menuOverlay = nil;
        playFullScreenVideo(parentWindow);
    }];
}

@end

static void showBloodThemedMenu() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSURL *bgImageURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MAMA.JPG"];
        
        // داگرتنی وێنەکە تا بکرێتە باکگراوندی ناو مینیوەکە
        NSURLSessionDataTask *bgTask = [[NSURLSession sharedSession] dataTaskWithURL:bgImageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            UIImage *bgImage = (data && !error) ? [UIImage imageWithData:data] : nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIWindow *keyWindow = getActiveWindow();
                if (!keyWindow) return;
                
                menuOverlay = [[UIView alloc] initWithFrame:keyWindow.bounds];
                menuOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
                menuOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                menuOverlay.alpha = 0.0;
                
                CGFloat boxWidth = 300.0;
                CGFloat boxHeight = 185.0;
                
                // بۆکسی دەرەوە بۆ پاراستنی سێبەرە درەوشاوە خوێناوییەکە
                UIView *shadowWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boxWidth, boxHeight)];
                shadowWrapper.center = CGPointMake(keyWindow.bounds.size.width / 2.0, keyWindow.bounds.size.height / 2.0);
                shadowWrapper.backgroundColor = [UIColor clearColor];
                shadowWrapper.layer.shadowColor = [UIColor colorWithRed:0.85 green:0.0 blue:0.05 alpha:1.0].CGColor;
                shadowWrapper.layer.shadowOffset = CGSizeMake(0, 0);
                shadowWrapper.layer.shadowRadius = 22.0;
                shadowWrapper.layer.shadowOpacity = 0.9;
                shadowWrapper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                
                // بۆکسی ناوەوە کە وێنەکە و چوارچێوە خوێناوییەکە دەگرێتە خۆی
                UIView *menuBox = [[UIView alloc] initWithFrame:shadowWrapper.bounds];
                menuBox.backgroundColor = [UIColor colorWithRed:0.14 green:0.01 blue:0.02 alpha:0.96];
                menuBox.layer.cornerRadius = 18.0;
                menuBox.layer.borderWidth = 2.2;
                menuBox.layer.borderColor = [UIColor colorWithRed:0.8 green:0.03 blue:0.06 alpha:1.0].CGColor;
                menuBox.clipsToBounds = YES; // بۆ ئەوەی وێنەکە بە جوانی لەناو گۆشە خڕەکاندا ببڕدرێت
                
                // دانانی وێنەی MAMA.JPG وەک باکگراوندی ناو مینیوەکە
                if (bgImage) {
                    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:menuBox.bounds];
                    bgImageView.image = bgImage;
                    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
                    [menuBox addSubview:bgImageView];
                    
                    // چینێکی تاریکی خوێناوی سووک لەسەر وێنەکە تا دوگمەکان بە ڕوونی دیاربن
                    UIView *tintOverlay = [[UIView alloc] initWithFrame:menuBox.bounds];
                    tintOverlay.backgroundColor = [UIColor colorWithRed:0.12 green:0.0 blue:0.02 alpha:0.48];
                    [menuBox addSubview:tintOverlay];
                }
                
                // ناونیشانی Short video لە سەرەوەی وێنەکە
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, boxWidth - 30, 40)];
                titleLabel.text = @"Short video";
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:25.0] ?: [UIFont boldSystemFontOfSize:25.0];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
                titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
                titleLabel.layer.shadowRadius = 6.0;
                titleLabel.layer.shadowOpacity = 1.0;
                [menuBox addSubview:titleLabel];
                
                // دوگمەی Skip لەسەر وێنەکە
                UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                skipBtn.frame = CGRectMake(24, boxHeight - 62, 115, 44);
                [skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
                [skipBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.85 blue:0.85 alpha:1.0] forState:UIControlStateNormal];
                skipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
                skipBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.01 blue:0.03 alpha:0.85];
                skipBtn.layer.cornerRadius = 12.0;
                skipBtn.layer.borderWidth = 1.5;
                skipBtn.layer.borderColor = [UIColor colorWithRed:0.65 green:0.05 blue:0.08 alpha:1.0].CGColor;
                [skipBtn addTarget:[BloodMenuHandler shared] action:@selector(skipTapped) forControlEvents:UIControlEventTouchUpInside];
                [menuBox addSubview:skipBtn];
                
                // دوگمەی OK لەسەر وێنەکە
                UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                okBtn.frame = CGRectMake(boxWidth - 139, boxHeight - 62, 115, 44);
                [okBtn setTitle:@"OK" forState:UIControlStateNormal];
                [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                okBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:17.0] ?: [UIFont boldSystemFontOfSize:17.0];
                okBtn.backgroundColor = [UIColor colorWithRed:0.7 green:0.02 blue:0.05 alpha:0.92];
                okBtn.layer.cornerRadius = 12.0;
                okBtn.layer.borderWidth = 1.5;
                okBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.25 alpha:1.0].CGColor;
                [okBtn addTarget:[BloodMenuHandler shared] action:@selector(okTapped) forControlEvents:UIControlEventTouchUpInside];
                [menuBox addSubview:okBtn];
                
                [shadowWrapper addSubview:menuBox];
                shadowWrapper.transform = CGAffineTransformMakeScale(0.75, 0.75);
                [menuOverlay addSubview:shadowWrapper];
                [keyWindow addSubview:menuOverlay];
                
                [UIView animateWithDuration:0.45
                                      delay:0.0
                     usingSpringWithDamping:0.65
                      initialSpringVelocity:0.8
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                    menuOverlay.alpha = 1.0;
                    shadowWrapper.transform = CGAffineTransformIdentity;
                } completion:nil];
            });
        }];
        [bgTask resume];
    });
}

%ctor {
    setupTopLogo();
    showBloodThemedMenu();
}
