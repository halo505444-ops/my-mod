#import <UIKit/UIKit.h>

bool checkSupabaseKey(NSString *enteredKey) {
    NSString *supabaseUrl = @"https://narkhdockqhlwxxyyxjr.supabase.co";
    NSString *supabaseKey = @"Sb_publishable_ZSYNiCI8U1zVImnMUKqTsA_6RBjMIVs";
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/keys?key_text=eq.%@&select=is_active", supabaseUrl, [enteredKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:supabaseKey forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", supabaseKey] forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data) {
        NSError *jsonError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if ([jsonArray count] > 0) {
            NSDictionary *dict = [jsonArray objectAtIndex:0];
            id isActive = [dict objectForKey:@"is_active"];
            if ([isActive isKindOfClass:[NSNumber class]] && [isActive boolValue] == YES) {
                return true;
            } else if ([isActive isKindOfClass:[NSString class]] && [(NSString *)isActive caseInsensitiveCompare:@"true"] == NSOrderedSame) {
                return true;
            }
        }
    }
    return false;
}

// کلاسێکی تایبەت بۆ بەڕێوەبردنی تاچ و لابردنی کیبۆرد بێ کێشە
@interface MamaHalaTouchView : UIView
@property (nonatomic, strong) UITextField *targetTextField;
@end

@implementation MamaHalaTouchView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.targetTextField) {
        [self.targetTextField resignFirstResponder];
    }
}
@end

@interface MamaHalaButtonHelper : NSObject
@property (nonatomic, copy) void (^actionBlock)(void);
- (void)buttonTapped:(id)sender;
@end

@implementation MamaHalaButtonHelper
- (void)buttonTapped:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        MamaHalaTouchView *menuView = [[MamaHalaTouchView alloc] initWithFrame:window.bounds];
        menuView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.80];
        
        CGFloat boxWidth = 310;
        CGFloat boxHeight = 295;
        CGFloat boxX = (window.bounds.size.width - boxWidth) / 2;
        CGFloat boxY = (window.bounds.size.height - boxHeight) / 2;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(boxX, boxY, boxWidth, boxHeight)];
        containerView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:0.98];
        containerView.layer.cornerRadius = 18;
        containerView.layer.borderWidth = 2.0;
        
        // ڕەنگی سەوزی درەوشاوەی نایابی هاکینگ (Neon Hacker Green)
        containerView.layer.borderColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.35 alpha:1.0].CGColor;
        containerView.layer.shadowColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.35 alpha:0.9].CGColor;
        containerView.layer.shadowRadius = 14.0;
        containerView.layer.shadowOpacity = 1.0;
        containerView.layer.shadowOffset = CGSizeZero;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, boxWidth - 40, 30)];
        titleLabel.text = @"🔥 MamaHala VIP Menu 🔥";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [containerView addSubview:titleLabel];
        
        UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectMake(25, 68, boxWidth - 50, 42)];
        keyField.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
        keyField.textColor = [UIColor whiteColor];
        keyField.placeholder = @"کلیل لێرە بنووسە...";
        keyField.borderStyle = UITextBorderStyleRoundedRect;
        keyField.textAlignment = NSTextAlignmentCenter;
        keyField.returnKeyType = UIReturnKeyDone;
        [containerView addSubview:keyField];
        
        menuView.targetTextField = keyField;
        
        // لابردنی کیبۆرد کاتێک دوگمەی Done لەسەر کیبۆرد دەدرێت
        MamaHalaButtonHelper *returnHelper = [[MamaHalaButtonHelper alloc] init];
        returnHelper.actionBlock = ^{
            [keyField resignFirstResponder];
        };
        [keyField addTarget:returnHelper action:@selector(buttonTapped:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 118, boxWidth - 50, 25)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont boldSystemFontOfSize:14];
        [containerView addSubview:statusLabel];
        
        // دوگمەی پشکنینی کلیل
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkButton.frame = CGRectMake(25, 153, boxWidth - 50, 44);
        checkButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.55 blue:1.0 alpha:1.0];
        [checkButton setTitle:@"پشکنینی کلیل (Check Key)" forState:UIControlStateNormal];
        [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkButton.layer.cornerRadius = 10;
        checkButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        MamaHalaButtonHelper *checkHelper = [[MamaHalaButtonHelper alloc] init];
        checkHelper.actionBlock = ^{
            [keyField resignFirstResponder];
            NSString *enteredKey = keyField.text;
            if (checkSupabaseKey(enteredKey)) {
                statusLabel.text = @"کرا";
                statusLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.35 alpha:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [menuView removeFromSuperview];
                });
            } else {
                statusLabel.text = @"نەکارا";
                statusLabel.textColor = [UIColor redColor];
            }
        };
        [checkButton addTarget:checkHelper action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:checkButton];
        
        // دوگمەی تلیگرام
        UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tgButton.frame = CGRectMake(25, 207, boxWidth - 50, 44);
        tgButton.backgroundColor = [UIColor colorWithRed:0.11 green:0.65 blue:0.89 alpha:1.0];
        [tgButton setTitle:@"بۆ دەستکەوتنی کلیل دەست لێرە دە" forState:UIControlStateNormal];
        [tgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tgButton.layer.cornerRadius = 10;
        tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        
        MamaHalaButtonHelper *tgHelper = [[MamaHalaButtonHelper alloc] init];
        tgHelper.actionBlock = ^{
            [keyField resignFirstResponder];
            NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/Mama_Hala0"];
            if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
                [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
            }
        };
        [tgButton addTarget:tgHelper action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:tgButton];
        
        [menuView addSubview:containerView];
        [window addSubview:menuView];
    });
}
