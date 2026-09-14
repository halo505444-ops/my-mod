#import <UIKit/UIKit.h>

@interface ModMenuManager : NSObject
+ (instancetype)sharedInstance;
- (void)showMenu;
@end

@implementation ModMenuManager {
    UIWindow *menuWindow;
    UIView *mainView;
}

+ (instancetype)sharedInstance {
    static ModMenuManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ModMenuManager alloc] init];
    });
    return sharedInstance;
}

- (void)showMenu {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (menuWindow) return;
        
        // دروستکردنی پەنجەرەی مۆد مینیو
        menuWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        menuWindow.windowLevel = UIWindowLevelAlert + 1;
        menuWindow.backgroundColor = [UIColor clearColor];
        
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor clearColor];
        menuWindow.rootViewController = vc;
        
        // ڕووکاری سەرەکی مۆد مینیو (Background)
        mainView = [[UIView alloc] initWithFrame:CGRectMake(50, 80, 300, 380)];
        mainView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
        mainView.layer.cornerRadius = 15;
        mainView.layer.borderWidth = 1.5;
        mainView.layer.borderColor = [UIColor systemBlueColor].CGColor;
        [vc.view addSubview:mainView];
        
        // تایتڵی مۆد مینیو (بە ناوی MamaHala)
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 260, 30)];
        titleLabel.text = @"MamaHala Mod Menu";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:titleLabel];
        
        // دووگمەی داخستنەوە (Close Button - X)
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        closeButton.frame = CGRectMake(255, 12, 35, 35);
        [closeButton setTitle:@"✕" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [closeButton addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:closeButton];
        
        // ۱. دووگمەی پشکنینی داتا / لایسنس
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkButton.frame = CGRectMake(20, 70, 260, 45);
        [checkButton setTitle:@"پشکنینی داتا / لایسنس" forState:UIControlStateNormal];
        [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkButton.backgroundColor = [UIColor systemBlueColor];
        checkButton.layer.cornerRadius = 8;
        [checkButton addTarget:self action:@selector(verifyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:checkButton];
        
        // ۲. دووگمەی خەڵت
        UIButton *khalatButton = [UIButton buttonWithType:UIButtonTypeSystem];
        khalatButton.frame = CGRectMake(20, 130, 260, 45);
        [khalatButton setTitle:@"دووگمەی خەڵت" forState:UIControlStateNormal];
        [khalatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        khalatButton.backgroundColor = [UIColor systemRedColor];
        khalatButton.layer.cornerRadius = 8;
        [khalatButton addTarget:self action:@selector(khalatButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:khalatButton];
        
        [menuWindow makeKeyAndVisible];
    });
}

- (void)verifyButtonTapped:(UIButton *)sender {
    sender.enabled = NO;
    [sender setTitle:@"چاوەڕوان بە..." forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
        [sender setTitle:@"پشکنینی داتا / لایسنس" forState:UIControlStateNormal];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ئەنجامی پشکنین" 
                                                                       message:@"سەد لەسەد کاردەکا و داتا بە سەرکەوتوویی وەرگیرا!" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDefault handler:nil]];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

- (void)khalatButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ئاگاداری" 
                                                                   message:@"کلیل خەڵتە شێرە برا" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDefault handler:nil]];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)closeMenu {
    menuWindow.hidden = YES;
    menuWindow = nil;
}

@end

// بانگکردنەوە و نیشاندانی مینیوەکە دوای کرانەوەی یارییەکە
static void (*old_applicationDidFinishLaunching)(id, SEL, id, id);
void new_applicationDidFinishLaunching(id self, SEL _cmd, id application, id launchOptions) {
    old_applicationDidFinishLaunching(self, _cmd, application, launchOptions);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ModMenuManager sharedInstance] showMenu];
    });
}

%ctor {
    %init();
}
