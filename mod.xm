#کان_مای_نێت // یان کتێبخانە پێویستەکان بۆ UIWindow و UIKit
#import <UIKit/UIKit.h>

// دروستکردنی گۆڕاوێک بۆ پشکنینی ئەوەی ئایا کۆدەکە دروستە یان نا
static BOOL isAuthorized = NO;

// دروستکردنی UIWindow و UIViewController بۆ نیشاندانی پەنجەرەی login
@interface ShazaLoginController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIView *menuBox;
@property (nonatomic, strong) UITextField *keyTextField;
@end

@implementation ShazaLoginController

- (void)viewDidLoad {
    [superviewDidLoad];
    
    // پاشبنەمایەکی ڕوونکەرەوە بۆ ئەوەی بزانین دەست لە دەرەوە دراوە یان نا
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // کاتێک دەست لە دەرەوەی سندوقی نوسین یان مۆدیووکە درا، مۆدیووکە لابدە (ئەگەر کۆد نەنووسرابوو)
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOutsideTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    // چوارچێوەی سەرەکی مۆد مینیۆکە
    self.menuBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    self.menuBox.center = self.view.center;
    self.menuBox.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.0];
    self.menuBox.layer.cornerRadius = 16.0;
    self.menuBox.layer.borderWidth = 1.5;
    self.menuBox.layer.borderColor = [UIColor colorWithRed:0.1 green:0.9 blue:0.3 alpha:1.0].CGColor; // ڕەنگی سەوزی تریفە
    
    // سێبەری سەوز بۆ چوارچێوەکە
    self.menuBox.layer.shadowColor = [UIColor colorWithRed:0.1 green:0.9 blue:0.3 alpha:0.8].CGColor;
    self.menuBox.layer.shadowOffset = CGSizeMake(0, 0);
    self.menuBox.layer.shadowRadius = 12.0;
    self.menuBox.layer.shadowOpacity = 1.0;
    [self.view addSubview:self.menuBox];
    
    // ناوی SHAZA ⚡️VIP بە فۆنت و ڕەنگی جوانی سەرەوە
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 35)];
    titleLabel.text = @"SHAZA ⚡️ VIP";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    [self.menuBox addSubview:titleLabel];
    
    // سندوقی نوسینی کۆد (TextField)
    self.keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 260, 45];
    self.keyTextField.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
    self.keyTextField.textColor = [UIColor whiteColor];
    self.keyTextField.textAlignment = NSTextAlignmentCenter;
    self.keyTextField.layer.cornerRadius = 8.0;
    self.keyTextField.layer.borderWidth = 1.0;
    self.keyTextField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor;
    self.keyTextField.delegate = self;
    
    // دەستکاری ڕەنگ و شێوازی Placeholder
    self.keyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"کۆد لێرە بنووسە..." attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    [self.menuBox addSubview:self.keyTextField];
    
    // نوسینی MamaHala بە زۆر بچووکی لە خوارەوە
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 280, 20)];
    footerLabel.text = @"MamaHala";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:10];
    footerLabel.textColor = [UIColor grayColor];
    [self.menuBox addSubview:footerLabel];
}

// کارکردن لە کاتی نوسین بۆ پشکنینی ڕاستەخۆی کۆدەکە
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // ئەگەر کۆدەکە یەکسان بوو بە SHAZAViP ئەوا مۆدیووکە دادەخرێت و یاری کردن دەکرێتەوە
    if ([currentText isEqualToString:@"SHAZAViP"]) {
        isAuthorized = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return YES;
}

// ئەگەر دەست لە دەرەوەی کیبۆرد یان مۆدیووکە بدرێت
- (void)handleOutsideTap:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    // ئەگەر دەستەکە دەرەوەی چوارچێوەی سەرەکی بوو و کۆدەکەش نەنووسراببوو، ڕێگری بکە لە یاری کردن
    if (!CGRectContainsPoint(self.menuBox.frame, location)) {
        if (!isAuthorized) {
            // دەتوانیت لێرە هیچ نەکەیت یان نامەیەک نیشان بدەیت بۆ ئەوەی یاری نەکات
            [self.keyTextField resignFirstResponder];
        }
    }
}

@end

// بانگکردنی پەنجەرەکە لە کاتی کرانەوەی یارییەکەدا
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_page(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window && !isAuthorized) {
            ShazaLoginController *loginVC = [[ShazaLoginController alloc] init];
            loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [window.rootViewController presentViewController:loginVC animated:YES completion:nil];
        }
    });
}
