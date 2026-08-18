#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ئەم فەنکشنە بۆ پشکنینی ئۆنلاینی کۆدەکەیە
void checkOnlineActivation(NSString *inputCode) {
    NSString *jsonURL = @"https://gist.githubusercontent.com/halo505444-ops/415c10497b8a92c97640ac07cf844c92/raw/keys.json";
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonURL]];
    if (!data) {
        NSLog(@"==> Error: Could not connect to server!");
        return;
    }
    
    NSDictionary *keys = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *codeData = keys[inputCode];
    
    if (codeData) {
        NSString *expiryString = codeData[@"expiry_date"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *expiryDate = [df dateFromString:expiryString];
        
        // بەراوردکردنی بەرواری ئەمڕۆ لەگەڵ بەرواری بەسەرچوون
        if (expiryDate && [expiryDate compare:[NSDate date]] == NSOrderedDescending) {
            // کۆدەکە کارایە -> کردنەوەی کەناڵی تێلیگرام
            NSString *telegramURL = @"https://t.me/YourChannelName"; // لینکی کەناڵەکەت لێرە دابنە
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telegramURL] options:@{} completionHandler:nil];
        } else {
            NSLog(@"==> Code Expired!");
        }
    } else {
        NSLog(@"==> Invalid Code!");
    }
}
