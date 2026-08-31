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

static UIView *mainMenuView = nil;

// فەرمانی کردنەوە و داخستنی مێنۆ بە شێوازی سەلامەت
static void toggleMenuAction() {
    if (mainMenuView) {
        mainMenuView.hidden = !mainMenuView.hidden;
        if (!mainMenuView.hidden) {
            [mainMenuView.superview bringSubviewToFront:mainMenuView];
        }
    }
}

// کلاسێکی هاوکار بۆ گرتنی پەنجە لەسەر دوگمەکە
@interface ButtonGestureHelper : NSObject
+ (void)handleTap:(UITapGestureRecognizer *)gesture;
@end

@implementation ButtonGestureHelper
+ (void)handleTap:(UITapGestureRecognizer *)gesture {
    toggleMenuAction();
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) return;
        
        // دوگمەی سەر شاشە (تاج، چەک و ناوی MaMahaLa)
        DraggableButton *floatBtn = [DraggableButton buttonWithType:UIButtonTypeCustom];
        floatBtn.frame = CGRectMake(30, 90, 110, 65);
        floatBtn.backgroundColor = [UIColor colorWithRed:0.1 green:0.05 blue:0.02 alpha:0.95];
        floatBtn.layer.cornerRadius = 12;
        floatBtn.layer.borderWidth = 2.0;
        floatBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0].CGColor;
        
        [floatBtn setTitle:@"👑 ⚔️\nMaMahaLa" forState:UIControlStateNormal];
        floatBtn.titleLabel.numberOfLines = 2;
        floatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [floatBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.9 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
        floatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        
        // بەستنەوەی تاپی پەنجە بە دوگمەکەوە بە بێ کێشەی target
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[ButtonGestureHelper class] action:@selector(handleTap:)];
        [floatBtn addGestureRecognizer:tapGesture];
        
        // مێنۆی سەرەکی
        mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(30, 165, 420, 310)];
        mainMenuView.backgroundColor = [UIColor colorWithRed:0.12 green:0.06 blue:0.22 alpha:0.97];
        mainMenuView.layer.cornerRadius = 16;
        mainMenuView.layer.borderWidth = 2.0;
        mainMenuView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0].CGColor;
        mainMenuView.hidden = YES;
        
        // تایتڵ و بەرهەمهێنەر
        UILabel *creatorLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 390, 22)];
        creatorLbl.text = @"👑 بەرهەم هێنەری مۆدمینۆ: MaMahaLa 👑";
        creatorLbl.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
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
        
        [window addSubview:mainMenuView];
        [window addSubview:floatBtn];
        [window bringSubviewToFront:floatBtn];
    });
}
