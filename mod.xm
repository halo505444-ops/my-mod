#import <UIKit/UIKit.h>

@interface SpeedHackManager : NSObject
+ (void)startFloatingAnimationInWindow:(UIWindow *)window;
@end

@implementation SpeedHackManager
+ (void)startFloatingAnimationInWindow:(UIWindow *)window {
    UIView *floatingHeader = [[UIView alloc] initWithFrame:CGRectMake(-260, 20, 260, 52)];
    floatingHeader.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:0.9];
    floatingHeader.layer.cornerRadius = 16.0;
    floatingHeader.layer.borderWidth = 1.8;
    floatingHeader.layer.borderColor = [UIColor whiteColor].CGColor;
    
    floatingHeader.layer.shadowColor = [UIColor whiteColor].CGColor;
    floatingHeader.layer.shadowOpacity = 0.8;
    floatingHeader.layer.shadowRadius = 12.0;
    floatingHeader.layer.shadowOffset = CGSizeMake(0, 0);
    floatingHeader.layer.masksToBounds = NO;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 240, 22)];
    headerLabel.text = @"⚡ SPEED_HACK ⚡";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16.0];
    headerLabel.textColor = [UIColor whiteColor];
    [floatingHeader addSubview:headerLabel];
    
    UILabel *subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 240, 18)];
    subHeaderLabel.text = @"VIP MODULE • 2026";
    subHeaderLabel.textAlignment = NSTextAlignmentCenter;
    subHeaderLabel.font = [UIFont fontWithName:@"Courier" size:11.0];
    subHeaderLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [floatingHeader addSubview:subHeaderLabel];
    
    [window addSubview:floatingHeader];
    
    [UIView animateWithDuration:7.0 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut animations:^{
        floatingHeader.frame = CGRectMake(window.bounds.size.width + 10, 20, 260, 52);
    } completion:nil];
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
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
        if (!keyWindow) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                for (UIWindow *window in scene.windows) {
                    keyWindow = window;
                    break;
                }
                if (keyWindow) break;
            }
        }
        
        if (keyWindow) {
            [SpeedHackManager startFloatingAnimationInWindow:keyWindow];
        }
    });
}
