#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

// لێدانی دەنگ بە فەنکشنی سیستەمی بێ کێشەی لینکر
void playWelcomeAudio() {
    NSBundle *tweakBundle = [NSBundle bundleWithPath:@"/Library/MobileSubstrate/DynamicLibraries/MamaHala.bundle"];
    NSString *soundPath = [tweakBundle pathForResource:@"MamaHala" ofType:@"mp3"];
    
    if (!soundPath) {
        soundPath = @"/Library/MobileSubstrate/DynamicLibraries/MamaHala.bundle/MamaHala.mp3";
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
        SystemSoundID soundID;
        OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
        if (status == kAudioServicesNoError) {
            AudioServicesPlaySystemSound(soundID);
        }
    }
}

// دروستکردنی لۆگۆی جوڵاوی MAMAHALA
void showMamaHalaLogo() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) return;
        
        UIView *logoContainer = [[UIView alloc] initWithFrame:CGRectMake(keyWindow.bounds.size.width / 2 - 125, 40, 250, 50)];
        logoContainer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        logoContainer.layer.cornerRadius = 12;
        logoContainer.layer.borderWidth = 1.5;
        logoContainer.layer.borderColor = [UIColor cyanColor].CGColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:logoContainer.bounds];
        titleLabel.text = @"MAMAHALA";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        [logoContainer addSubview:titleLabel];
        [keyWindow addSubview:logoContainer];
        
        logoContainer.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            logoContainer.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        playWelcomeAudio();
        showMamaHalaLogo();
    });
}
