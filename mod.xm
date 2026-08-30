#import <UIKit/UIKit.h>

@interface DraggableButton : UIButton
@end

@implementation DraggableButton {
    CGPoint touchLocation;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.superview];
    
    CGFloat deltaX = currentLocation.x - touchLocation.x;
    CGFloat deltaY = currentLocation.y - touchLocation.y;
    
    CGPoint newCenter = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);
    
    CGFloat x = MAX(self.frame.size.width/2, MIN(newCenter.x, self.superview.bounds.size.width - self.frame.size.width/2));
    CGFloat y = MAX(self.frame.size.height/2, MIN(newCenter.y, self.superview.bounds.size.height - self.frame.size.height/2));
    
    self.center = CGPointMake(x, y);
    touchLocation = currentLocation;
}
@end

@interface MenuManager : NSObject
+ (void)toggleMenu:(UIButton *)sender;
@end

static UIView *mainMenuView = nil;

@implementation MenuManager
+ (void)toggleMenu:(UIButton *)sender {
    if (mainMenuView) {
        mainMenuView.hidden = !mainMenuView.hidden;
    }
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        // دوگمەی سەر شاشە (کەلسەر و ئاگر + ناوی MaMahaLa)
        DraggableButton *floatBtn = [DraggableButton buttonWithType:UIButtonTypeCustom];
        floatBtn.frame = CGRectMake(40, 100, 80, 80);
        floatBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.05 blue:0.05 alpha:0.95];
        floatBtn.layer.cornerRadius = 40;
        floatBtn.layer.borderWidth = 3.0;
        floatBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        [floatBtn setTitle:@"🔥💀\nMaMahaLa" forState:UIControlStateNormal];
        floatBtn.titleLabel.numberOfLines = 2;
        floatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [floatBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        floatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        
        // مێنۆی سەرەکی بە هەموو بەشەکانیەوە
        mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(30, 150, 420, 310)];
        mainMenuView.backgroundColor = [UIColor colorWithRed:0.12 green:0.06 blue:0.22 alpha:0.97];
        mainMenuView.layer.cornerRadius = 16;
        mainMenuView.layer.borderWidth = 2.0;
        mainMenuView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0].CGColor;
        mainMenuView.hidden = YES;
        
        // تایتڵ و بەرهەمهێنەر
        UILabel *creatorLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 390, 22)];
        creatorLbl.text = @"🔥 بەرهەم هێنەری مۆدمینۆ: MaMahaLa 🔥";
        creatorLbl.textColor = [UIColor orangeColor];
        creatorLbl.font = [UIFont boldSystemFontOfSize:13];
        creatorLbl.textAlignment = NSTextAlignmentCenter;
        [mainMenuView addSubview:creatorLbl];
        
        // بەشەکانی مێنۆ بە زمانی کوردی
        NSArray *sections = @[
            @"بەشی ESP: یاریزان، تەندروستی، هێڵ، کوب",
            @"بەشی ئایمبۆت: ئایمبۆت، سەر، فۆڤ 188",
            @"بەشی بیرگە: بەفراوی، باراناوی، قەبارەی کەسایەتی",
            @"بەشی جلوبەرگ: پێستەکان، سندوقی مردن",
            @"ڕێکخستنەکان: 60 فرەیم، زمانی کوردی"
        ];
        
        int startY = 38;
        for (int i = 0; i < sections.count; i++) {
            UILabel *secLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, startY + (i * 50), 390, 42)];
            secLabel.text = [NSString stringWithFormat:@"🔹 %@", sections[i]];
            secLabel.textColor = [UIColor cyanColor];
            secLabel.font = [UIFont boldSystemFontOfSize:11];
            secLabel.numberOfLines = 2;
            [mainMenuView addSubview:secLabel];
        }
        
        // بەستنەوەی کردنەوە و داخستنی مێنۆ بە دوگمەکە
        [floatBtn addTarget:[MenuManager class] action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        [window addSubview:mainMenuView];
        [window addSubview:floatBtn];
    });
}
