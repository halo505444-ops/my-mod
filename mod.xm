#import <UIKit/UIKit.h>

// دروستکردنی هاوکارێک بۆ دوگمەکان
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

// فەنکشنی پشکنینی کلیل لە سۆپابەیس
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

// دروستکردنی مێنوی سەرەکی و لۆژیکی هاکەکە
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        // ڕوکاری سەرەکی مێنوی MamaHala VIP
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 260, 220)];
        menuView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
        menuView.layer.cornerRadius = 12;
        menuView.layer.borderWidth = 1.5;
        menuView.layer.borderColor = [UIColor redColor].CGColor;
        
        // ناونیشانی مێنۆ
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
        titleLabel.text = @"🔥 MamaHala VIP Menu 🔥";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [menuView addSubview:titleLabel];
        
        // خانەی نوسینی کلیل (TextField)
        UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, 220, 35)];
        keyField.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        keyField.textColor = [UIColor whiteColor];
        keyField.placeholder = @"MamaHala-VIP";
        keyField.borderStyle = UITextBorderStyleRoundedRect;
        keyField.textAlignment = NSTextAlignmentCenter;
        [menuView addSubview:keyField];
        
        // نیشانەی دۆخی کلیل (سەوز یان سور)
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 220, 25)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont boldSystemFontOfSize:12];
        [menuView addSubview:statusLabel];
        
        // دوگمەی پشکنیینی کلیل (Check Key)
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkButton.frame = CGRectMake(20, 135, 220, 40);
        checkButton.backgroundColor = [UIColor systemBlueColor];
        [checkButton setTitle:@"پشکنینی کلیل (Check Key)" forState:UIControlStateNormal];
        [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkButton.layer.cornerRadius = 8;
        
        // بەستنەوەی کرداری دوگمەکە
        MamaHalaTarget *target = [[MamaHalaTarget alloc] init];
        target.block = ^{
            NSString *enteredKey = keyField.text;
            if (checkSupabaseKey(enteredKey)) {
                statusLabel.text = @"✓ کلیلەکە ڕاستە و کارایە!";
                statusLabel.textColor = [UIColor greenColor];
            } else {
                statusLabel.text = @"✗ کلیلەکە هەڵەیە یان بوونی نییە!";
                statusLabel.textColor = [UIColor redColor];
            }
        };
        
        [checkButton addTarget:target action:@selector(_actionTapped:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:checkButton];
        
        [window addSubview:menuView];
    });
}
