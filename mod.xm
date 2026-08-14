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

- (void)setupFloatingButton {
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(20, 100, 60, 60);
    self.floatingButton.backgroundColor = [UIColor purpleColor];
    [self.floatingButton setTitle:@"مۆد" forState:UIControlStateNormal];
    [self.floatingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.floatingButton.layer.cornerRadius = 30;
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)setupMenuUI {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(50, 180, 280, 260)];
    self.menuView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    self.menuView.layer.cornerRadius = 16;
    self.menuView.layer.borderWidth = 1.5f;
    self.menuView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.menuView.hidden = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 260, 30)];
    titleLabel.text = @"مینۆی مۆد - کوردی";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.menuView addSubview:titleLabel];
    
    UIButton *channelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    channelButton.frame = CGRectMake(20, 65, 240, 45);
    channelButton.backgroundColor = [UIColor systemBlueColor];
    [channelButton setTitle:@"جۆینی چەناڵ" forState:UIControlStateNormal];
    [channelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    channelButton.layer.cornerRadius = 10;
    [channelButton addTarget:self action:@selector(joinChannelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:channelButton];
    
    UIButton *ownerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    ownerButton.frame = CGRectMake(20, 125, 240, 45);
    ownerButton.backgroundColor = [UIColor systemGreenColor];
    [ownerButton setTitle:@"سەرۆکی چەناڵ" forState:UIControlStateNormal];
    [ownerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ownerButton.layer.cornerRadius = 10;
    [ownerButton addTarget:self action:@selector(channelOwnerTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:ownerButton];

    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 260, 20)];
    footerLabel.text = @"دروستکەری مۆدمینۆ: MamaHala";
    footerLabel.textColor = [UIColor lightGrayColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:10];
    [self.menuView addSubview:footerLabel];
    
    [window addSubview:self.menuView];
}

- (void)toggleMenu {
    self.menuView.hidden = !self.menuView.hidden;
}

- (void)joinChannelTapped {
    NSURL *url = [NSURL URLWithString:@"https://t.me/HACK_IOS2"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)channelOwnerTapped {
    NSURL *url = [NSURL URLWithString:@"https://t.me/ARKAN_IOS"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
