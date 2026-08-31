#import <UIKit/UIKit.h>

@interface DraggableManager : UIView {
    CGPoint touchLocation;
}
@end

@implementation DraggableManager
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

@interface DraggableButton : UIButton {
    CGPoint touchLocation;
}
@end

@implementation DraggableButton
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

@interface DraggableMenuView : DraggableManager
@end
@implementation DraggableMenuView
@end

static DraggableMenuView *mainMenuView = nil;
static UIView *contentAreaView = nil;

static void switchTab(int index) {
    if (!contentAreaView) return;
    for (UIView *sub in contentAreaView.subviews) {
        [sub removeFromSuperview];
    }
    
    if (index == 0) {
        NSArray *switches = @[@"Line", @"Nation", @"Enemy", @"Box"];
        for (int i = 0; i < switches.count; i++) {
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20, 20 + (i * 40))];
            [sw setOnTintColor:[UIColor colorWithRed:0.55 green:0.25 blue:0.65 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 20 + (i * 40), 200, 30)];
            lbl.text = switches[i];
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:14];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 1) {
        NSArray *switches = @[@"Aimbot", @"Silent Aim", @"Aim Line", @"Ignore Bots"];
        for (int i = 0; i < switches.count; i++) {
            int row = i / 2;
            int col = i % 2;
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (col * 170), 15 + (row * 40))];
            [sw setOnTintColor:[UIColor colorWithRed:0.55 green:0.25 blue:0.65 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85 + (col * 170), 15 + (row * 40), 90, 30)];
            lbl.text = switches[i];
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:12];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 2) {
        NSArray *items = @[@"Snowy", @"Rainy", @"Character Size", @"HitX", @"Crosshair"];
        for (int i = 0; i < items.count; i++) {
            int row = i / 2;
            int col = i % 2;
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (col * 170), 20 + (row * 50))];
            [sw setOnTintColor:[UIColor colorWithRed:0.55 green:0.25 blue:0.65 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85 + (col * 170), 22 + (row * 50), 100, 25)];
            lbl.text = items[i];
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:12];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 3) {
        NSArray *items = @[@"Enable Skin", @"Bag Gun", @"Dead Box", @"Lobby Skin"];
        for (int i = 0; i < items.count; i++) {
            int row = i / 2;
            int col = i % 2;
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (col * 170), 20 + (row * 50))];
            [sw setOnTintColor:[UIColor colorWithRed:0.55 green:0.25 blue:0.65 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85 + (col * 170), 22 + (row * 50), 100, 25)];
            lbl.text = items[i];
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:12];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 4) {
        NSArray *fpsList = @[@"30FPS", @"60FPS", @"90FPS", @"120FPS"];
        for (int i = 0; i < fpsList.count; i++) {
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (i * 82), 20)];
            [sw setOnTintColor:[UIColor colorWithRed:0.55 green:0.25 blue:0.65 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15 + (i * 82), 58, 80, 20)];
            lbl.text = fpsList[i];
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:11];
            lbl.textAlignment = NSTextAlignmentCenter;
            [contentAreaView addSubview:lbl];
        }
    }
}

@interface TabButtonHandler : NSObject
+ (void)tabClicked:(UIButton *)sender;
@end
@implementation TabButtonHandler
+ (void)tabClicked:(UIButton *)sender {
    switchTab((int)sender.tag);
}
@end

static void toggleMenuAction() {
    if (mainMenuView) {
        mainMenuView.hidden = !mainMenuView.hidden;
        if (!mainMenuView.hidden) {
            [mainMenuView.superview bringSubviewToFront:mainMenuView];
        }
    }
}

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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[ButtonGestureHelper class] action:@selector(handleTap:)];
        [floatBtn addGestureRecognizer:tapGesture];
        
        mainMenuView = [[DraggableMenuView alloc] initWithFrame:CGRectMake(40, 165, 520, 310)];
        mainMenuView.backgroundColor = [UIColor colorWithRed:0.18 green:0.08 blue:0.28 alpha:0.98];
        mainMenuView.layer.cornerRadius = 16;
        mainMenuView.layer.borderWidth = 2.0;
        mainMenuView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0].CGColor;
        mainMenuView.hidden = YES;
        
        UIView *sidebarView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 130, 280)];
        sidebarView.backgroundColor = [UIColor colorWithRed:0.12 green:0.05 blue:0.20 alpha:1.0];
        sidebarView.layer.cornerRadius = 10;
        [mainMenuView addSubview:sidebarView];
        
        NSArray *tabs = @[@"ESP", @"AIMBOT", @"MEMORY", @"MODSKIN", @"SETTINGS"];
        for (int i = 0; i < tabs.count; i++) {
            UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tabBtn.frame = CGRectMake(10, 15 + (i * 50), 110, 40];
            [tabBtn setTitle:tabs[i] forState:UIControlStateNormal];
            [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tabBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            tabBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.12 blue:0.38 alpha:1.0];
            tabBtn.layer.cornerRadius = 8;
            tabBtn.tag = i;
            [tabBtn addTarget:[TabButtonHandler class] action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
            [sidebarView addSubview:tabBtn];
        }
        
        contentAreaView = [[UIView alloc] initWithFrame:CGRectMake(150, 15, 360, 280)];
        contentAreaView.backgroundColor = [UIColor colorWithRed:0.94 green:0.90 blue:0.98 alpha:1.0];
        contentAreaView.layer.cornerRadius = 10;
        [mainMenuView addSubview:contentAreaView];
        
        switchTab(0);
        
        [window addSubview:mainMenuView];
        [window addSubview:floatBtn];
        [window bringSubviewToFront:floatBtn];
    });
}
