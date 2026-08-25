#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <dlfcn.h>
#import <sys/sysctl.h>

// پاراستنی دژە-دەبەس (Anti-Debug)
typedef int (*ptrace_ptr)(int _request, pid_t _pid, caddr_t _addr, int _data);
void antiDebug() {
    ptrace_ptr ptrace_s = (ptrace_ptr)dlsym(RTLD_DEFAULT, "ptrace");
    if (ptrace_s) {
        ptrace_s(31, 0, 0, 0);
    }
}

// دروستکردنی لۆگۆ یان نیشانەی سەر ڕوونما بێ پەنجەرە و کلیل
__attribute__((constructor)) void initMod() {
    antiDebug();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *w in scene.windows) {
                    if (w.isKeyWindow) {
                        window = w;
                        break;
                    }
                }
            }
        }
        if (!window) window = [[UIApplication sharedApplication].windows firstObject];
        
        if (window) {
            // قەبارەی بۆکسی لۆگۆ
            UIView *modView = [[UIView alloc] initWithFrame:CGRectMake((window.frame.size.width - 200) / 2, 40, 200, 42)];
            modView.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.08 alpha:0.85];
            modView.layer.cornerRadius = 10;
            modView.layer.borderWidth = 1.0;
            modView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            // ئەفێکتی بریقەدار (Glow Effect)
            modView.layer.shadowColor = [UIColor whiteColor].CGColor;
            modView.layer.shadowRadius = 6.0f;
            modView.layer.shadowOpacity = 0.8f;
            modView.layer.shadowOffset = CGSizeZero;
            
            // 1. 𝐂𝐋𝐎𝐒𝐄~𝐇𝐀𝐂𝐊 بە ڕەنگی سپی لە سەرەوە
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 200, 20)];
            titleLabel.text = @"𝐂𝐋𝐎𝐒𝐄~𝐇𝐀𝐂𝐊";
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:13];
            titleLabel.textColor = [UIColor whiteColor];
            [modView addSubview:titleLabel];
            
            // 2. MamaHala بە زۆر بچووکی لە ژێرەوەی
            UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 200, 15)];
            subLabel.text = @"MamaHala";
            subLabel.textAlignment = NSTextAlignmentCenter;
            subLabel.font = [UIFont systemFontOfSize:9];
            subLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1.0];
            [modView addSubview:subLabel];
            
            [window addSubview:modView];
            
            // لادانی خۆکاری لۆگۆکە دوای 6 چرکە بۆ ئەوەی بێزارکەر نەبێت لە یارییدا
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    modView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [modView removeFromSuperview];
                }];
            });
        }
    });
}
