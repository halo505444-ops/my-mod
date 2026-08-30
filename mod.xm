// ==========================================
// MaMaHaLa VIP Gaming Mod Menu - iOS (Theos)
// Target: PUBG Mobile - ESP, Aimbot, Skin Hack
// ==========================================

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

// Global UI Elements
static UIButton *maMaHaLaFloatBtn = nil;
static UIView *menuContainer = nil;
static BOOL isMenuVisible = NO;

// Feature States
static BOOL espBox = NO;
static BOOL espLine = NO;
static BOOL espDistance = NO;
static BOOL espHealth = NO;
static BOOL espName = NO;

static BOOL aimbotEnabled = NO;
static int aimbotFOV = 100;
static int aimbotSmooth = 5;

static BOOL skinM416 = NO;
static BOOL skinAWM = NO;
static BOOL skinOutfit = NO;

// Forward Declarations
void createMenuUI();
void toggleMenu();

// Handler Interface Declaration
@interface MaMaHaLaHandler : NSObject
+ (void)handleDrag:(UIPanGestureRecognizer *)gesture;
+ (void)toggleMenuAction;
@end

// Helper for Modern Window Retrieval
UIWindow *getModernKeyWindow() {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    }
    if (!keyWindow) {
        // Fallback to older window array retrieval safely
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
        #pragma clang diagnostic pop
    }
    return keyWindow;
}

// ==========================================
// FLOATING BUTTON (MaMaHaLa)
// ==========================================
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = getModernKeyWindow();
        if (!keyWindow) return;

        // Create Floating Button
        maMaHaLaFloatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maMaHaLaFloatBtn.frame = CGRectMake(20, 120, 75, 75);
        maMaHaLaFloatBtn.layer.cornerRadius = 37.5;
        
        // Gorgeous Gaming Gradient Background
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = maMaHaLaFloatBtn.bounds;
        gradient.cornerRadius = 37.5;
        gradient.colors = @[(id)[UIColor colorWithRed:0.05 green:0.85 blue:0.95 alpha:0.95].CGColor,
                            (id)[UIColor colorWithRed:0.55 green:0.05 blue:0.95 alpha:0.95].CGColor];
        [maMaHaLaFloatBtn.layer insertSublayer:gradient atIndex:0];

        // Button Title styling
        [maMaHaLaFloatBtn setTitle:@"MaMaHaLa" forState:UIControlStateNormal];
        maMaHaLaFloatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [maMaHaLaFloatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // Shadow & Glow
        maMaHaLaFloatBtn.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:0.9].CGColor;
        maMaHaLaFloatBtn.layer.shadowOffset = CGSizeMake(0, 0);
        maMaHaLaFloatBtn.layer.shadowRadius = 10.0;
        maMaHaLaFloatBtn.layer.shadowOpacity = 1.0;

        // Pan Gesture for dragging the button anywhere
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:[MaMaHaLaHandler class] action:@selector(handleDrag:)];
        [maMaHaLaFloatBtn addGestureRecognizer:pan];

        // Tap action to show/hide menu
        [maMaHaLaFloatBtn addTarget:[MaMaHaLaHandler class] action:@selector(toggleMenuAction) forControlEvents:UIControlEventTouchUpInside];

        [keyWindow addSubview:maMaHaLaFloatBtn];
        createMenuUI();
    });
}

@implementation MaMaHaLaHandler
+ (void)handleDrag:(UIPanGestureRecognizer *)gesture {
    UIWindow *window = getModernKeyWindow();
    CGPoint translation = [gesture translationInView:window];
    CGPoint center = gesture.view.center;
    gesture.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:window];
}

+ (void)toggleMenuAction {
    isMenuVisible = !isMenuVisible;
    menuContainer.hidden = !isMenuVisible;
}
@end

// ==========================================
// MODERN GAMING MENU UI CONSTRUCTION
// ==========================================
void createMenuUI() {
    UIWindow *window = getModernKeyWindow();
    if (!window) return;

    // Main Menu Container (Glassmorphism & Gaming Neon Border)
    menuContainer = [[UIView alloc] initWithFrame:CGRectMake(120, 80, 450, 340)];
    menuContainer.backgroundColor = [UIColor colorWithRed:0.06 green:0.07 blue:0.10 alpha:0.96];
    menuContainer.layer.cornerRadius = 18.0;
    menuContainer.layer.borderWidth = 2.0;
    menuContainer.layer.borderColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.95 alpha:0.9].CGColor;
    menuContainer.hidden = YES; // Hidden by default

    // Header Bar
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:0.10 green:0.12 blue:0.18 alpha:1.0];
    headerView.layer.cornerRadius = 18.0;
    headerView.clipsToBounds = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 350, 50)];
    titleLabel.text = @"⚡ MaMaHaLa VIP GAMING MENU ⚡";
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [headerView addSubview:titleLabel];

    // Close Button inside Menu
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(400, 10, 30, 30);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [closeBtn addTarget:[MaMaHaLaHandler class] action:@selector(toggleMenuAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeBtn];

    [menuContainer addSubview:headerView];
    [window addSubview:menuContainer];
}
