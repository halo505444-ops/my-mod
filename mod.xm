#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <dlfcn.h>
#import <sys/sysctl.h>

// پاراستنی دژە-دەبەس (Anti-Debug) بۆ ئەوەی کەس نەتوانێ بە ئاسانی دەستکاری بکات
typedef int (*ptrace_ptr)(int _request, pid_t _pid, caddr_t _addr, int _data);
void antiDebug() {
    ptrace_ptr ptrace_s = (ptrace_ptr)dlsym(RTLD_DEFAULT, "ptrace");
    if (ptrace_s) {
        ptrace_s(31, 0, 0, 0); // PT_DENY_ATTACH
    }
}

// بەشی نیشاندانی ناوی MamaHALA بە سوڕانەوەی ٣٦٠ پلە لە ناو یارییەکەدا
@interface DashboardViewController : UIViewController
@property (nonatomic, strong) UILabel *animatedLabel;
@end

@implementation DashboardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    // دروستکردنی تێکست بۆ سوڕانەوە
    self.animatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    self.animatedLabel.text = @"MamaHALA";
    self.animatedLabel.font = [UIFont boldSystemFontOfSize:24];
    self.animatedLabel.textColor = [UIColor systemYellowColor];
    self.animatedLabel.textAlignment = NSTextAlignmentCenter; // ڕاستکراوەیە بۆ NSTextAlignmentCenter
    [self.view addSubview:self.animatedLabel];
    
    // جووڵەی سوڕانەوەی ٣٦٠ پلە بە دەوری خۆیدا
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithDouble:M_PI * 2.0];
    rotationAnimation.duration = 4.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.animatedLabel.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
@end

// بەشی تایتڵ و کلیل (Login Page)
@interface LoginViewController : UIViewController
@property (nonatomic, strong) UITextField *keyTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.12 alpha:1.0];
    
    // ناوی Mama Hala بە ڕەنگەکانی ئاڵای کوردستان
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 50)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:28];
    
    NSMutableAttributedString *coloredTitle = [[NSMutableAttributedString alloc] initWithString:@"Mama Hala"];
    [coloredTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];     // Mama
    [coloredTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(4, 1)];   // بۆشایی
    [coloredTitle addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5, 4)];   // Hala
    titleLabel.attributedText = coloredTitle;
    [self.view addSubview:titleLabel];
    
    // دەقی داوای کلیل
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width - 40, 30)];
    subtitleLabel.text = @"تکایە کڵی چالاککردن بنووسە:";
    subtitleLabel.textColor = [UIColor lightGrayColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:subtitleLabel];
    
    // خانەی نووسینی کلیل
    self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 190, self.view.frame.size.width - 80, 45)];
    self.keyTextField.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.22 alpha:1.0];
    self.keyTextField.textColor = [UIColor whiteColor];
    self.keyTextField.textAlignment = NSTextAlignmentCenter;
    self.keyTextField.placeholder = @"لێرە کۆد بنووسە...";
    self.keyTextField.layer.cornerRadius = 8.0;
    self.keyTextField.layer.borderWidth = 1.0;
    self.keyTextField.layer.borderColor = [UIColor cyanColor].CGColor;
    [self.view addSubview:self.keyTextField];
    
    // دوگمەی پشکنین و کردنەوە
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(40, 255, self.view.frame.size.width - 80, 45);
    [loginButton setTitle:@"پشکنین و کردنەوە" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.58 blue:1.0 alpha:1.0];
    loginButton.layer.cornerRadius = 8.0;
    [loginButton addTarget:self action:@selector(verifyKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)verifyKey {
    NSString *enteredKey = self.keyTextField.text;
    
    // پشکنینی کلیلەکە
    if ([enteredKey isEqualToString:@"MamaHala"]) {
        // کردنەوەی لینکی تلیگرام
        NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/MARAyHACK"];
        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
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
            
            DashboardViewController *dashboardVC = [[DashboardViewController alloc] init];
            [window.rootViewController addChildViewController:dashboardVC];
            [window.rootViewController.view addSubview:dashboardVC.view];
            [dashboardVC didMoveToParentViewController:window.rootViewController];
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"هەڵە" message:@"کلیلەکە هەڵەیە، تکایە دڵنیابەرەوە." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

// سەرەتای کارپێکردنی تویکەکە
%ctor {
    antiDebug();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    });
}
