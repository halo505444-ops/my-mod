#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (nonatomic, strong) UITextField *keyTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // پاشبنەمای تاریک
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
    
    // دوگمەی پشکنین
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
    
    // پشکنینی کلیلەکە کە دەبێت MamaHala بێت
    if ([enteredKey isEqualToString:@"MamaHala"]) {
        // کردنەوەی کەناڵی تلیگرام
        NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/Mama_Hala0"];
        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"هەڵە" message:@"کلیلەکە هەڵەیە، تکایە دڵنیابەرەوە." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

// نیشاندانی پەنجەرەی کلیل لە کاتی کردنەوەی یارییەکەدا
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    });
}
