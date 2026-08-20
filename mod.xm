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

// بەشی پەنجەرەی کلیل و ڕووکاری سەرەکی (Login Page)
@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *keyTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.12 alpha:1.0];
    
    // لابردنی کیبۆرد کاتێک کلیک لە دەرەوە دەکرێت
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    // 1. دروست کەری مۆدمینۆ بە ڕەنگی سوری بریقەدار لە سەرەوە
    UILabel *creatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, self.view.frame.size.width - 40, 30)];
    creatorLabel.text = @"دروست کەری مۆدمینۆ";
    creatorLabel.textAlignment = NSTextAlignmentCenter;
    creatorLabel.font = [UIFont boldSystemFontOfSize:15];
    creatorLabel.textColor = [UIColor redColor]; // ڕەنگی سور
    
    creatorLabel.layer.shadowColor = [UIColor redColor].CGColor;
    creatorLabel.layer.shadowRadius = 6.0f;
    creatorLabel.layer.shadowOpacity = 1.0f;
    creatorLabel.layer.shadowOffset = CGSizeZero;
    [self.view addSubview:creatorLabel];
    
    // 2. MAMAHALA بە ڕەنگی شینی بریقەدار لە ژێرەوەی
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 78, self.view.frame.size.width - 40, 45)];
    titleLabel.text = @"MAMAHALA";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:26];
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.68 blue:1.0 alpha:1.0]; // ڕەنگی شین
    
    titleLabel.layer.shadowColor = [UIColor cyanColor].CGColor;
    titleLabel.layer.shadowRadius = 8.0f;
    titleLabel.layer.shadowOpacity = 1.0f;
    titleLabel.layer.shadowOffset = CGSizeZero;
    [self.view addSubview:titleLabel];
    
    // دەقی داوای کلیل
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, self.view.frame.size.width - 40, 25)];
    subtitleLabel.text = @"تکایە کڵی چالاککردن بنووسە:";
    subtitleLabel.textColor = [UIColor lightGrayColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:subtitleLabel];
    
    // خانەی نووسینی کلیل
    self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 170, self.view.frame.size.width - 80, 45)];
    self.keyTextField.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.22 alpha:1.0];
    self.keyTextField.textColor = [UIColor whiteColor];
    self.keyTextField.textAlignment = NSTextAlignmentCenter;
    self.keyTextField.placeholder = @"لێرە کۆد بنووسە...";
    self.keyTextField.layer.cornerRadius = 8.0;
    self.keyTextField.layer.borderWidth = 1.0;
    self.keyTextField.layer.borderColor = [UIColor cyanColor].CGColor;
    self.keyTextField.delegate = self;
    [self.view addSubview:self.keyTextField];
    
    // دوگمەی پشکنین و کردنەوە
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(40, 230, self.view.frame.size.width - 80, 45);
    [loginButton setTitle:@"پشکنین و کردنەوە" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.58 blue:1.0 alpha:1.0];
    loginButton.layer.cornerRadius = 8.0;
    [loginButton addTarget:self action:@selector(verifyKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // 3. تێبینی و ئاگاداری باند لە خوارەوە
    UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, self.view.frame.size.width - 40, 60)];
    warningLabel.text = @"تێبینی: ئەگەر بەجوانی یاری پێبکەن باند نابن وە ئێمە هیچ بەرپرس نین لە باند بوون ⚠️🚫";
    warningLabel.textColor = [UIColor orangeColor];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.font = [UIFont systemFontOfSize:11];
    warningLabel.numberOfLines = 0;
    [self.view addSubview:warningLabel];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)verifyKey {
    [self.view endEditing:YES];
    NSString *enteredKey = self.keyTextField.text;
    
    // پشکنینی کلیلەکە
    if ([enteredKey isEqualToString:@"MamaHala"]) {
        // کردنەوەی کەناڵی تلیگرام
        NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/MARAyHACK"];
        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"هەڵە" message:@"کلیلەکە هەڵەیە، تکایە دڵنیابەرەوە." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

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
