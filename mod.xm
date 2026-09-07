#import <UIKit/UIKit.h>

@interface MamaHalaHelper : NSObject
@property (nonatomic, copy) void (^actionBlock)(void);
- (void)triggerAction:(id)sender;
@end

@implementation MamaHalaHelper
- (void)triggerAction:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}
@end

void checkSupabaseKeyAsync(NSString *enteredKey, void (^completion)(bool success)) {
    NSString *supabaseUrl = @"https://narkhdockqhlwxxyyxjr.supabase.co";
    NSString *supabaseKey = @"Sb_publishable_ZSYNiCI8U1zVImnMUKqTsA_6RBjMIVs";
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/keys?key_text=eq.%@&select=is_active", supabaseUrl, [enteredKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:supabaseKey forHTTPHeaderField:@"apikey"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", supabaseKey] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        bool isValid = false;
        if (!error && data) {
            NSError *jsonError = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if ([jsonArray count] > 0) {
                NSDictionary *dict = [jsonArray objectAtIndex:0];
                id isActive = [dict objectForKey:@"is_active"];
                if ([isActive isKindOfClass:[NSNumber class]] && [isActive boolValue] == YES) {
                    isValid = true;
                } else if ([isActive isKindOfClass:[NSString class]] && [(NSString *)isActive caseInsensitiveCompare:@"true"] == NSOrderedSame) {
                    isValid = true;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(isValid);
        });
    }];
    [task resume];
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in scene.windows) {
                    if (w.isKeyWindow) {
                        window = w;
                        break;
                    }
                }
            }
            if (window) break;
        }
        if (!window) window = [[UIApplication sharedApplication] keyWindow];
        if (!window) return;
        
        UIView *menuView = [[UIView alloc] initWithFrame:window.bounds];
        menuView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
        
        CGFloat boxWidth = 310;
        CGFloat boxHeight = 265;
        CGFloat boxX = (window.bounds.size.width - boxWidth) / 2;
        CGFloat boxY = (window.bounds.size.height - boxHeight) / 2;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(boxX, boxY, boxWidth, boxHeight)];
        containerView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:0.98];
        containerView.layer.cornerRadius = 18;
        containerView.layer.borderWidth = 2.0;
        
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
        [containerView addSubview:keyField];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 118, boxWidth - 50, 25)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont boldSystemFontOfSize:14];
        [containerView addSubview:statusLabel];
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkButton.frame = CGRectMake(25, 153, boxWidth - 50, 44);
        checkButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.55 blue:1.0 alpha:1.0];
        [checkButton setTitle:@"پشکنینی کلیل (Check Key)" forState:UIControlStateNormal];
        [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkButton.layer.cornerRadius = 10;
        checkButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        MamaHalaHelper *checkHelper = [[MamaHalaHelper alloc] init];
        __weak UITextField *weakKeyField = keyField;
        __weak UILabel *weakStatusLabel = statusLabel;
        __weak UIView *weakMenuView = menuView;
        
        checkHelper.actionBlock = ^{
            [weakKeyField resignFirstResponder];
            NSString *enteredKey = weakKeyField.text;
            if (!enteredKey || [enteredKey length] == 0) {
                weakStatusLabel.text = @"کلیل بنووسە!";
                weakStatusLabel.textColor = [UIColor redColor];
                return;
            }
            weakStatusLabel.text = @"پشکنین...";
            weakStatusLabel.textColor = [UIColor yellowColor];
            
            checkSupabaseKeyAsync(enteredKey, ^(bool success) {
                if (success) {
                    weakStatusLabel.text = @"کرا";
                    weakStatusLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.35 alpha:1.0];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakMenuView removeFromSuperview];
                    });
                } else {
                    weakStatusLabel.text = @"نەکارا";
                    weakStatusLabel.textColor = [UIColor redColor];
                }
            });
        };
        [checkButton addTarget:checkHelper action:@selector(triggerAction:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:checkButton];
        
        UIButton *tgButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tgButton.frame = CGRectMake(25, 207, boxWidth - 50, 44);
        tgButton.backgroundColor = [UIColor colorWithRed:0.11 green:0.65 blue:0.89 alpha:1.0];
        [tgButton setTitle:@"بۆ دەستکەوتنی کلیل دەست لێرە دە" forState:UIControlStateNormal];
        [tgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tgButton.layer.cornerRadius = 10;
        tgButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        
        MamaHalaHelper *tgHelper = [[MamaHalaHelper alloc] init];
        tgHelper.actionBlock = ^{
            [weakKeyField resignFirstResponder];
            NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/Mama_Hala0"];
            if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
                [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
            }
        };
        [tgButton addTarget:tgHelper action:@selector(triggerAction:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:tgButton];
        
        [menuView addSubview:containerView];
        
        // لابردنی کیبۆرد بە کلیککردن لە دەرەوە بە شێوازێکی بێ کێشە
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] init];
        MamaHalaHelper *dismissHelper = [[MamaHalaHelper alloc] init];
        dismissHelper.actionBlock = ^{
            [weakKeyField resignFirstResponder];
        };
        [dismissTap addTarget:dismissHelper action:@selector(triggerAction:)];
        dismissTap.cancelsTouchesInView = NO;
        [menuView addGestureRecognizer:dismissTap];
        
        [window addSubview:menuView];
    });
}
