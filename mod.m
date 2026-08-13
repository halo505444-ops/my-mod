#import <UIKit/UIKit.h>

@interface MamaHalaMenu : UIView
@end

@implementation MamaHalaMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = [UIColor magentaColor].CGColor;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        title.text = @"🔥 MamaHala 🔥";
        title.textColor = [UIColor magentaColor];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        
        UIButton *espBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        espBtn.frame = CGRectMake(15, 50, frame.size.width - 30, 35];
        [espBtn setTitle:@"ESP: OFF" forState:UIControlStateNormal];
        [espBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        espBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        espBtn.layer.cornerRadius = 6;
        [espBtn addTarget:self action:@selector(toggleESP:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:espBtn];
        
        UIButton *aimBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aimBtn.frame = CGRectMake(15, 95, frame.size.width - 30, 35);

        [aimBtn setTitle:@"Aimbot: OFF" forState:UIControlStateNormal];
        [aimBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        aimBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        aimBtn.layer.cornerRadius = 6;
        [aimBtn addTarget:self action:@selector(toggleAimbot:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aimBtn];
    }
    return self;
}

- (void)toggleESP:(UIButton *)sender {
    if ([sender.titleLabel.text containsString:@"OFF"]) {
        [sender setTitle:@"ESP: ON" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"ESP: OFF" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)toggleAimbot:(UIButton *)sender {
    if ([sender.titleLabel.text containsString:@"OFF"]) {
        [sender setTitle:@"Aimbot: ON" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Aimbot: OFF" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}
@end

__attribute__((constructor))
void MamaHalaInit() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) window = [[UIApplication sharedApplication].windows firstObject];
        if (window) {
            MamaHalaMenu *menu = [[MamaHalaMenu alloc] initWithFrame:CGRectMake(40, 80, 220, 145)];
            [window addSubview:menu];
            [window bringSubviewToFront:menu];
        }
    });
}
