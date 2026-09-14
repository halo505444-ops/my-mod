#import <UIKit/UIKit.h>

static BOOL isAuthorized = NO;
static UIWindow *shazaWindow = nil;

@interface ShazaLoginController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIView *menuBox;
@property (nonatomic, strong) UITextField *keyTextField;
@end

@implementation ShazaLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *installDate = [defaults objectForKey:@"ShazaInstallDate"];
    
    if (!installDate) {
        installDate = [NSDate date];
        [defaults setObject:installDate forKey:@"ShazaInstallDate"];
        [defaults synchronize];
    }
    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:installDate];
    double daysBetween = secondsBetween / 86400;
    
    if (daysBetween >= 30 || daysBetween < 0) {
        exit(0);
    }

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOutsideTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.menuBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    self.menuBox.center = self.view.center;
    self.menuBox.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.0];
    self.menuBox.layer.cornerRadius = 16.0;
    self.menuBox.layer.borderWidth = 1.5;
    self.menuBox.layer.borderColor = [UIColor colorWithRed:0.1 green:0.9 blue:0.3 alpha:1.0].CGColor;
    
    self.menuBox.layer.shadowColor = [UIColor colorWithRed:0.1 green:0.9 blue:0.3 alpha:0.8].CGColor;
    self.menuBox.layer.shadowOffset = CGSizeMake(0, 0);
    self.menuBox.layer.shadowRadius = 12.0;
    self.menuBox.layer.shadowOpacity = 1.0;
    [self.view addSubview:self.menuBox];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 35)];
    titleLabel.text = @"SHAZA ⚡️ VIP";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    [self.menuBox addSubview:titleLabel];
    
    self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 260, 45)];
    self.keyTextField.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
    self.keyTextField.textColor = [UIColor whiteColor];
    self.keyTextField.textAlignment = NSTextAlignmentCenter;
    self.keyTextField.layer.cornerRadius = 8.0;
    self.keyTextField.layer.borderWidth = 1.0;
    self.keyTextField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor;
    self.keyTextField.delegate = self;
    self.keyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"کۆد لێرە بنووسە..." attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    [self.menuBox addSubview:self.keyTextField];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 280, 20)];
    footerLabel.text = @"MamaHala";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:10];
    footerLabel.textColor = [UIColor grayColor];
    [self.menuBox addSubview:footerLabel];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([currentText isEqualToString:@"SHAZAViP"]) {
        isAuthorized = YES;
        shazaWindow.hidden = YES;
        shazaWindow = nil;
    }
    return YES;
}

- (void)handleOutsideTap:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    if (!CGRectContainsPoint(self.menuBox.frame, location)) {
        if (!isAuthorized) {
            [self.keyTextField resignFirstResponder];
        }
    }
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_page(), ^{
        if (!isAuthorized) {
            UIWindowScene *activeScene = nil;
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
                    activeScene = (UIWindowScene *)scene;
                    break;
                }
            }
            
            if (activeScene) {
                shazaWindow = [[UIWindow alloc] initWithWindowScene:activeScene];
                shazaWindow.rootViewController = [[ShazaLoginController alloc] init];
                shazaWindow.windowLevel = UIWindowLevelAlert + 1;
                [shazaWindow makeKeyAndVisible];
            }
        }
    });
}
