#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <objc/message.h>
#import <dlfcn.h>

static id introPlayer = nil;
static CALayer *introPlayerLayer = nil;
static UIView *videoContainer = nil;

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

static void playImmediateFullScreenVideo() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = getActiveWindow();
        if (!keyWindow) return;
        
        dlopen("/System/Library/Frameworks/AVFoundation.framework/AVFoundation", RTLD_LAZY);
        
        Class AVPlayerItemClass = NSClassFromString(@"AVPlayerItem");
        Class AVPlayerClass = NSClassFromString(@"AVPlayer");
        Class AVPlayerLayerClass = NSClassFromString(@"AVPlayerLayer");
        
        if (!AVPlayerItemClass || !AVPlayerClass || !AVPlayerLayerClass) return;
        
        NSURL *videoURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/halo505444-ops/my-mod/main/MamaHala%20.MP4"];
        
        videoContainer = [[UIView alloc] initWithFrame:keyWindow.bounds];
        videoContainer.backgroundColor = [UIColor blackColor];
        videoContainer.userInteractionEnabled = NO;
        videoContainer.layer.zPosition = 10000;
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
    });
}

%ctor {
    playImmediateFullScreenVideo();
}
