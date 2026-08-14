#import <UIKit/UIKit.h>

@interface ModMenuController : UIViewController
@property (strong, nonatomic) UIButton *floatingButton;
@property (strong, nonatomic) UIView *menuView;
@end

@implementation ModMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFloatingButton];
    [self setupMenuUI];
}

// دروستکردنی دوگمەی مەلەوان (فڵۆتینگ بۆتن) بۆ کردنەوە و داخستنی مینۆکە
- (void)setupFloatingButton {
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(20, 100, 60, 60);
    self.floatingButton.backgroundColor = [UIColor systemIndigoColor];
    [self.floatingButton setTitle:@"مۆد" forState:UIControlStateNormal];
    [self.floatingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.floatingButton.layer.cornerRadius = 30;
    self.floatingButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.floatingButton.layer.shadowOpacity = 0.5f;
    self.floatingButton.layer.shadowRadius = 5.0f;
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    // جووڵاندنی دوگمەکە بە پەنجە لەسەر شاشە
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragButton:)];
    [self.floatingButton addGestureRecognizer:pan];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.floatingButton];
}

- (void)dragButton:(UIPanGestureRecognizer *)pan {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint translation = [pan translationInView:window];
    CGPoint center = self.floatingButton.center;
    self.floatingButton.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [pan setTranslation:CGPointZero inView:window];
}

// دروستکردنی ناوەوەی مینۆکە بە زمانی کوردی و بژاردە داواکراوەکان
- (void)setupMenuUI {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(50, 180, 280, 260)];
    self.menuView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    self.menuView.layer.cornerRadius = 16;
    self.menuView.layer.borderWidth = 1.5f;
    self.menuView.layer.borderColor = [[UIColor systemCyanColor] CGColor];
    self.menuView.hidden = YES; // سەرەتای کار داخراوە
    
    // ناونیشانی مینۆ
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 260, 30)];
    titleLabel.text = @"مینۆی مۆد - کوردی";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.menuView addSubview:titleLabel];
    
    // دوگمەی یەکەم: جۆینی چەناڵ
    UIButton *channelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    channelButton.frame = CGRectMake(20, 65, 240, 45);
    channelButton.backgroundColor = [UIColor systemBlueColor];
    [channelButton setTitle:@"جۆینی چەناڵ" forState:UIControlStateNormal];
    [channelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    channelButton.layer.cornerRadius = 10;
    channelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [channelButton addTarget:self action:@selector(joinChannelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:channelButton];
    
    // دوگمەی دووەم: سەرۆکی چەناڵ
    UIButton *ownerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    ownerButton.frame = CGRectMake(20, 125, 240, 45);
    ownerButton.backgroundColor = [UIColor systemGreenColor];
    [ownerButton setTitle:@"سەرۆکی چەناڵ" forState:UIControlStateNormal];
    [ownerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ownerButton.layer.cornerRadius = 10;
    ownerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [ownerButton addTarget:self action:@selector(channelOwnerTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:ownerButton];

    // ناوی دروستکەر بە بچووکی لە خوارەوە
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 260, 20)];
    footerLabel.text = @"دروستکەری مۆدمینۆ: MamaHala";
    footerLabel.textColor = [UIColor lightGrayColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:10];
    [self.menuView addSubview:footerLabel];
    
    [window addSubview:self.menuView];
}

// کردنەوە و داخستنی مینۆکە لە ڕێگەی دوگمەی مەلەوانەوە
- (void)toggleMenu {
    self.menuView.hidden = !self.menuView.hidden;
}

// کردنەوەی لینکی جۆینی چەناڵ
- (void)joinChannelTapped {
    NSURL *url = [NSURL URLWithString:@"https://t.me/HACK_IOS2"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

// کردنەوەی لینکی سەرۆکی چەناڵ
- (void)channelOwnerTapped {
    NSURL *url = [NSURL URLWithString:@"https://t.me/ARKAN_IOS"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
