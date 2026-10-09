#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// فەنکشنی لێدانی دەنگەکە بە دەنگی پیاوانەی قوڵ
void playWelcomeSound() {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Welcome to MamaHala server"];
    
    AVSpeechSynthesisVoice *maleVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.voice = maleVoice;
    
    // ڕێکخستنی خێرایی و بەرزی دەنگ بۆ ئەوەی پیاوانە و گڕ بێت
    utterance.rate = 0.42f;
    utterance.pitchMultiplier = 0.8f;
    
    [synthesizer speakUtterance:utterance];
}

// دروستکردنی لۆگۆی جوڵاوی MAMAHALA کە لەسەر شاشە دەمێنێتەوە و لانەچێت
void showMamaHalaLogo() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) return;
        
        // دروستکردنی ڤیووی لۆگۆکە لە سەرەوەی شاشە
        UIView *logoContainer = [[UIView alloc] initWithFrame:CGRectMake(keyWindow.bounds.size.width / 2 - 125, 40, 250, 50)];
        logoContainer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        logoContainer.layer.cornerRadius = 12;
        logoContainer.layer.borderWidth = 1.5;
        logoContainer.layer.borderColor = [UIColor cyanColor].CGColor;
        
        // نیشاندانی تەنها ناوی MAMAHALA
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:logoContainer.bounds];
        titleLabel.text = @"MAMAHALA";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        [logoContainer addSubview:titleLabel];
        [keyWindow addSubview:logoContainer];
        
        // ئەنیمەیشنی سەرەتایی دەرکەوتن بێ ئەوەی بسڕێتەوە
        logoContainer.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            logoContainer.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

// هۆکی سەرەکی بۆ کاتی چوونە ناو یارییەکە
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // لێدانی دەنگەکە
        playWelcomeSound();
        // نیشاندانی لۆگۆی جوڵاو کە بەردەوام دەمێنێتەوە
        showMamaHalaLogo();
    });
}
