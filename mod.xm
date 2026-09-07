#import <UIKit/UIKit.h>

@interface MamaHalaTarget : NSObject
@property (nonatomic, copy) void (^block)(void);
- (void)_actionTapped:(id)sender;
@end

@implementation MamaHalaTarget
- (void)_actionTapped:(id)sender {
    if (self.block) {
        self.block();
    }
}
@end

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

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        UIView *menuView = [[UIView alloc] initWithFrame:window.bounds];
        menuView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
        
        CGFloat boxWidth = 300;
        CGFloat boxHeight = 290; // کەمێک درێژتر کرا بۆ جێگیرکردنی دوگمەی تلیگرام
        CGFloat boxX = (window.bounds.size.width - boxWidth) / 2;
        CGFloat boxY = (window.bounds.size.height - boxHeight) / 2;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(boxX, boxY, boxWidth, boxHeight)];
        containerView.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:0.98];
        containerView.layer.cornerRadius = 16;
        containerView.layer.borderWidth = 1.5;
        containerView.layer.borderColor = [UIColor redColor].CGColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, boxWidth - 40, 30)];
        titleLabel.text = @"🔥 MamaHala VIP Menu 🔥";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [containerView addSubview:titleLabel];
        
        UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectMake(25, 65, boxWidth - 50, 40)];
        keyField.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        keyField.textColor = [UIColor whiteColor];
        keyField.placeholder = @"کلیل لێرە بنووسە...";
        keyField.borderStyle = UITextBorderStyleRoundedRect;
        keyField.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:keyField];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 115, boxWidth - 50, 25)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        [containerView addSubview:statusLabel];
        
        // دوگمەی پشکنینی کلیل
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkButton.frame = CGRectMake(25, 150, boxWidth - 50, 42);
        checkButton.backgroundColor = [UIColor systemBlueColor];
        [checkButton setTitle:@"پشکنینی کلیل (Check Key)" forState:UIControlStateNormal];
        [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkButton.layer.cornerRadius = 10;
        
        MamaHalaTarget *checkTarget = [[MamaHalaTarget alloc] init];
        checkTarget.block = ^{
            [keyField resignFirstResponder];
            NSString *enteredKey = keyField.text;
            if (checkSupabaseKey(enteredKey)) {
                statusLabel.text = @"✓ کلیلەکە ڕاستە و کارایە!";
                statusLabel.textColor = [UIColor greenColor];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [menuView removeFromSuperview];
                });
            } else {
                statusLabel.text = @"✗ کلیلەکە هەڵەیە یان بوونی نییە!";
                statusLabel.textColor = [UIColor redColor];
            }
        };
        [checkButton addTarget:checkTarget action:@selector(_actionTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:checkButton];
        
        // دروستکردنی دوگمەی Kyeeee بۆ پەیوەندیکردن بە تلیگرام
        UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tgButton.frame = CGRectMake(25, 202, boxWidth - 50, 42);
        tgButton.backgroundColor = [UIColor colorWithRed:0.11 green:0.65 blue:0.89 alpha:1.0]; // ڕەنگی تایبەتی تلیگرام
        [tgButton setTitle:@"Kyeeee" forState:UIControlStateNormal];
        [tgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tgButton.layer.cornerRadius = 10;
        tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        MamaHalaTarget *tgTarget = [[MamaHalaTarget alloc] init];
        tgTarget.block = ^{
            NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/Mama_Hala0"];
            if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
                [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
            }
        };
        [tgButton addTarget:tgTarget action:@selector(_actionTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:tgButton];
        
        [menuView addSubview:containerView];
        [window addSubview:menuView];
    });
}
