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
        NSArray *switches = @[@"هێڵی دیتن", @"نەتەوەکان", @"دوژمن", @"قەفەس (سندوق)"];
        for (int i = 0; i < switches.count; i++) {
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20, 20 + (i * 45), 50, 30)];
            [sw setOnTintColor:[UIColor colorWithRed:0.85 green:0.25 blue:0.45 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85, 20 + (i * 45), 230, 30)];
            lbl.text = switches[i];
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:14];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 1) {
        NSArray *switches = @[@"نیشانەگرتنی ئۆتۆماتیک", @"لێدانی شاراوە", @"هێڵی ئامانج", @"پشتگوێخستنی بۆت"];
        for (int i = 0; i < switches.count; i++) {
            int row = i / 2;
            int col = i % 2;
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (col * 170), 15 + (row * 50), 50, 30)];
            [sw setOnTintColor:[UIColor colorWithRed:0.85 green:0.25 blue:0.45 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85 + (col * 170), 15 + (row * 50), 90, 40)];
            lbl.text = switches[i];
            lbl.numberOfLines = 2;
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:11];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 2) {
        NSArray *items = @[@"بەفراوی", @"باراناوی", @"قەبارەی کەسایەتی", @"پێکانی خێرا", @"نیشانەی ئامانج"];
        for (int i = 0; i < items.count; i++) {
            int row = i / 2;
            int col = i % 2;
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (col * 170), 20 + (row * 48), 50, 30)];
            [sw setOnTintColor:[UIColor colorWithRed:0.85 green:0.25 blue:0.45 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85 + (col * 170), 20 + (row * 48), 100, 35)];
            lbl.text = items[i];
            lbl.numberOfLines = 2;
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:11];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 3) {
        NSArray *items = @[@"چالاککردنی ڕووکەش", @"چەکی جانتا", @"سندوقی مردن", @"ڕووکەشی لۆبی"];
        for (int i = 0; i < items.count; i++) {
            int row = i / 2;
            int col = i % 2;
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (col * 170), 20 + (row * 50), 50, 30)];
            [sw setOnTintColor:[UIColor colorWithRed:0.85 green:0.25 blue:0.45 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(85 + (col * 170), 20 + (row * 50), 100, 30)];
            lbl.text = items[i];
            lbl.textColor = [UIColor colorWithRed:0.25 green:0.15 blue:0.35 alpha:1.0];
            lbl.font = [UIFont boldSystemFontOfSize:12];
            [contentAreaView addSubview:lbl];
        }
    } else if (index == 4) {
        NSArray *fpsList = @[@"٣٠ فریم", @"٦٠ فریم", @"٩٠ فریم", @"١٢٠ فریم"];
        for (int i = 0; i < fpsList.count; i++) {
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(20 + (i * 82), 25, 50, 30)];
            [sw setOnTintColor:[UIColor colorWithRed:0.85 green:0.25 blue:0.45 alpha:1.0]];
            [contentAreaView addSubview:sw];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15 + (i * 82), 65, 80, 20)];
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
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *win in scene.windows) {
                        if (win.isKeyWindow) {
                            window = win;
                            break;
                        }
                    }
                }
            }
        }
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }
        if (!window) return;
        
        DraggableButton *floatBtn = [DraggableButton buttonWithType:UIButtonTypeCustom];
        floatBtn.frame = CGRectMake(30, 90, 120, 70);
        floatBtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.04 blue:0.22 alpha:0.98];
        floatBtn.layer.cornerRadius = 16;
        floatBtn.layer.borderWidth = 2.5;
        floatBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0].CGColor;
        [floatBtn setTitle:@"👑 MaMaHaLa 👑\n⚔️ لێبدە بۆ کردنەوە ⚔️" forState:UIControlStateNormal];
        floatBtn.titleLabel.numberOfLines = 2;
        floatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [floatBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.9 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        floatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[ButtonGestureHelper class] action:@selector(handleTap:)];
        [floatBtn addGestureRecognizer:tapGesture];
        
        mainMenuView = [[DraggableMenuView alloc] initWithFrame:CGRectMake(40, 150, 540, 330)];
        mainMenuView.backgroundColor = [UIColor colorWithRed:0.16 green:0.06 blue:0.26 alpha:0.98];
        mainMenuView.layer.cornerRadius = 18;
        mainMenuView.layer.borderWidth = 3.0;
        mainMenuView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0].CGColor;
        mainMenuView.hidden = YES;
        
        // ناونیشانی بەرهەمهێنەر و لۆگۆ لە سەرەوەی مێنۆ
        UILabel *brandLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 510, 22)];
        brandLbl.text = @"⚡ MaMaHaLa VIP Menu - All Rights Reserved ⚡";
        brandLbl.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.2 alpha:1.0];
        brandLbl.font = [UIFont boldSystemFontOfSize:12];
        brandLbl.textAlignment = NSTextAlignmentCenter;
        [mainMenuView addSubview:brandLbl];
        
        UIView *sidebarView = [[UIView alloc] initWithFrame:CGRectMake(12, 35, 130, 280)];
        sidebarView.backgroundColor = [UIColor colorWithRed:0.10 green:0.03 blue:0.18 alpha:1.0];
        sidebarView.layer.cornerRadius = 12;
        sidebarView.layer.borderWidth = 1.0;
        sidebarView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.25 blue:0.45 alpha:0.5].CGColor;
        [mainMenuView addSubview:sidebarView];
        
        NSArray *tabs = @[@"دیاریکردن (ESP)", @"نیشانەگر (AIM)", @"یادگە (MEMORY)", @"ڕووکەش (SKIN)", @"ڕێکخستن (SET)"];
        for (int i = 0; i < tabs.count; i++) {
            UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tabBtn.frame = CGRectMake(10, 12 + (i * 52), 110, 42];
            [tabBtn setTitle:tabs[i] forState:UIControlStateNormal];
            [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tabBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            tabBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.10 blue:0.38 alpha:1.0];
            tabBtn.layer.cornerRadius = 8;
            tabBtn.tag = i;
            [tabBtn addTarget:[TabButtonHandler class] action:@selector(tabClicked:) forControlEvents:UIControlEventTouchUpInside];
            [sidebarView addSubview:tabBtn];
        }
        
        contentAreaView = [[UIView alloc] initWithFrame:CGRectMake(152, 35, 376, 280)];
        contentAreaView.backgroundColor = [UIColor colorWithRed:0.95 green:0.92 blue:0.98 alpha:1.0];
        contentAreaView.layer.cornerRadius = 12;
        contentAreaView.layer.borderWidth = 1.5;
        contentAreaView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.25 blue:0.45 alpha:0.6].CGColor;
        [mainMenuView addSubview:contentAreaView];
        
        switchTab(0);
        
        [window addSubview:mainMenuView];
        [window addSubview:floatBtn];
        [window bringSubviewToFront:floatBtn];
    });
}
