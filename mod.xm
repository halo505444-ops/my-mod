#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <sys/stat.h>
#import <dlfcn.h>
#include <array>

#include "Project/ImGui/imgui.h"
#include "Project/Extra/Bone.hpp"
#include "Project/Extra/utf.hpp"
#include "Project/Extra/Obfuscate.h"
#include "Project/Offset/Offset.hpp"
#include "Project/Main/ESP.hpp"

// Global Variables for Features
BOOL IsLine = NO, IsBox = NO, IsDistance = NO, IsHealth = NO, IsBone = NO, IsName = NO, IsAlert360 = NO, IsWeapon = NO;
BOOL IsAimbot = NO, IsAutoShoot = NO, IsFov = NO, IsRecoil = NO, IsSilentAim = NO, IsPrediction = NO, IsHeadshotOnly = NO;
BOOL IsFly = NO, IsHighJump = NO, IsSpeed = NO, IsWallHack = NO, IsFastReload = NO, IsInstantHit = NO, IsMagicBullet = NO;
BOOL IsWeaponSkins = NO, IsCharacterSkins = NO, IsVehicleSkins = NO, IsMythicEffect = NO, IsCustomEmote = NO;
BOOL IsBulletTrack = NO, IsIgnoreKnock = NO;

// Core Engine Variables
static long GWorld, UName, Engine, PersistentLevel, PlayerController, Character, PlayerCameraManager, ControlRotation, MyHUD;
static MinimalViewInfo POV;
float IsRadius = 160.0f;
float IsSpeedVal = 1.0f;
float IsThicknessLine = 1.0f;
float IsThicknessBone = 1.0f;
int IsStyle = 0;
bool drawOutline = true;
float IsFontDraw = 12.0f;
int IsEnglish = 0;

typedef NS_ENUM(NSInteger, AppLanguage) {
    LangSorani = 0,
    LangBadini,
    LangEnglish
};

typedef NS_ENUM(NSInteger, MenuSection) {
    SectionESP = 0,
    SectionAimbot,
    SectionMemory,
    SectionSkins,
    SectionSettings
};

@interface ModMenuManager : NSObject
@property (nonatomic, assign) BOOL isAuthorized;
@property (nonatomic, assign) AppLanguage currentLang;
@property (nonatomic, assign) MenuSection currentSection;

@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIStackView *tabStackView;
@property (nonatomic, strong) UIStackView *contentStackView;
@end

@implementation ModMenuManager

+ (instancetype)sharedInstance {
    static ModMenuManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ModMenuManager alloc] init];
        shared.currentLang = LangSorani;
        shared.currentSection = SectionESP;
        shared.isAuthorized = NO;
    });
    return shared;
}

- (UIWindow *)getMainWindow {
    UIWindow *foundWindow = nil;
    for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    foundWindow = window;
                    break;
                }
            }
        }
    }
    if (!foundWindow) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        foundWindow = [UIApplication sharedApplication].windows.firstObject;
#pragma clang diagnostic pop
    }
    return foundWindow;
}

- (NSString *)localizedStringForKey:(NSString *)key {
    NSDictionary *translations = @{
        @"ESP": @{ @(LangSorani): @"بینینی نەیار (ESP)", @(LangBadini): @"دیتنا نەیاران", @(LangEnglish): @"ESP" },
        @"Aim": @{ @(LangSorani): @"ئایمبۆت", @(LangBadini): @"ئایمبۆت", @(LangEnglish): @"Aim" },
        @"Fly": @{ @(LangSorani): @"هێز و خێرایی", @(LangBadini): @"فڕین و لەزاتی", @(LangEnglish): @"Powers" },
        @"Skins": @{ @(LangSorani): @"سکینەکان", @(LangBadini): @"سکین", @(LangEnglish): @"Skins" },
        @"Lang": @{ @(LangSorani): @"زمان", @(LangBadini): @"زمان", @(LangEnglish): @"Lang" },
        
        @"Line": @{ @(LangSorani): @"هێڵی نەیار (Line)", @(LangBadini): @"هێلا نەیاری", @(LangEnglish): @"Line" },
        @"Box": @{ @(LangSorani): @"چوارگۆشەی نەیار (Box)", @(LangBadini): @"چوارگوشکە", @(LangEnglish): @"Box" },
        @"Distance": @{ @(LangSorani): @"دووری نەیار (Distance)", @(LangBadini): @"دووری", @(LangEnglish): @"Distance" },
        @"Health": @{ @(LangSorani): @"تەندروستی نەیار (Health)", @(LangBadini): @"تەندروستی", @(LangEnglish): @"Health" },
        @"Skeleton": @{ @(LangSorani): @"ئێسکی لەش (Skeleton)", @(LangBadini): @"ئێسکی لەش", @(LangEnglish): @"Skeleton" },
        @"Name": @{ @(LangSorani): @"ناوی نەیار (Name)", @(LangBadini): @"ناڤێ نەیاری", @(LangEnglish): @"Name ESP" },
        @"Alert": @{ @(LangSorani): @"ئاگاداری بینین (Danger Alert)", @(LangBadini): @"ئاگاداری دیتنێ", @(LangEnglish): @"Danger Alert" },
        @"Loot": @{ @(LangSorani): @"دۆزینەوەی لوت و چەک (Loot)", @(LangBadini): @"لوت و چەک", @(LangEnglish): @"Item Loot ESP" },
        
        @"Aimbot": @{ @(LangSorani): @"ئایمبۆتی ئۆتۆماتیک", @(LangBadini): @"ئایمبۆتا خۆکار", @(LangEnglish): @"Aimbot" },
        @"Auto Shoot": @{ @(LangSorani): @"تەقەکردنی خۆکار (Auto Shoot)", @(LangBadini): @"تەقەکرنا خۆکار", @(LangEnglish): @"Auto Shoot" },
        @"FOV": @{ @(LangSorani): @"بازنەی ئایم (FOV Circle)", @(LangBadini): @"بازنەیا ئایم", @(LangEnglish): @"FOV Circle" },
        @"Recoil": @{ @(LangSorani): @"بێ پاشگەزبوونەوە (No Recoil)", @(LangBadini): @"بێ پاشگەزبوون", @(LangEnglish): @"No Recoil" },
        @"Silent": @{ @(LangSorani): @"سایلێنت ئایم (Silent Aim)", @(LangBadini): @"سایلێنت ئایم", @(LangEnglish): @"Silent Aim" },
        @"Prediction": @{ @(LangSorani): @"پێشبینی جووڵە (Prediction)", @(LangBadini): @"پێشبینا جووڵەی", @(LangEnglish): @"Prediction" },
        @"Headshot": @{ @(LangSorani): @"تەنها سەرسەر (Headshot Only)", @(LangBadini): @"تەنها سەر", @(LangEnglish): @"Headshot Only" },
        
        @"Fly Hack": @{ @(LangSorani): @"فڕین لە ئاسمان (Fly)", @(LangBadini): @"فڕین ل ئاسمانێ", @(LangEnglish): @"Fly Hack" },
        @"High Jump": @{ @(LangSorani): @"بازدانی بەرز (High Jump)", @(LangBadini): @"بازدانا بلند", @(LangEnglish): @"High Jump" },
        @"Speed Hack": @{ @(LangSorani): @"خێرایی یاریزان (Speed)", @(LangBadini): @"لەزاتی", @(LangEnglish): @"Speed Hack" },
        @"WallHack": @{ @(LangSorani): @"بینین لەپشت دیوار (WallHack)", @(LangBadini): @"دیتن ژ پاش دیواران", @(LangEnglish): @"WallHack" },
        @"Fast Reload": @{ @(LangSorani): @"پڕکردنەوەی خێرای چەک (Fast Reload)", @(LangBadini): @"ڕێلۆدا خێرا", @(LangEnglish): @"Fast Reload" },
        @"Instant Hit": @{ @(LangSorani): @"پێکانی خێرا (Instant Hit)", @(LangBadini): @"پێکانا خێرا", @(LangEnglish): @"Instant Hit" },
        @"Magic Bullet": @{ @(LangSorani): @"گولەی سیحراوی (Magic Bullet)", @(LangBadini): @"گولەیا سیحراوی", @(LangEnglish): @"Magic Bullet" },
        
        @"Weapon Skins": @{ @(LangSorani): @"سکینی گشت چەکەکان", @(LangBadini): @"سکینێن چەکان", @(LangEnglish): @"Weapon Skins" },
        @"Character Skins": @{ @(LangSorani): @"سکینی جلوبەرگ و کەسایەتی", @(LangBadini): @"سکینێن کەسایەتی", @(LangEnglish): @"Character Skins" },
        @"Vehicle Skins": @{ @(LangSorani): @"سکینی ئۆتۆمبێل و کەشتی", @(LangBadini): @"سکینێن ترۆمبێلان", @(LangEnglish): @"Vehicle Skins" },
        @"Mythic Effect": @{ @(LangSorani): @"تایبەتمەندی مایتیک و پلەبەرز", @(LangBadini): @"مایتیک ئێفێکت", @(LangEnglish): @"Mythic Effects" },
        @"Emotes": @{ @(LangSorani): @"سەمای کراوە و ئەیمۆت", @(LangBadini): @"سەما و ئەیمۆت", @(LangEnglish): @"Unlock Emotes" }
    };
    
    NSDictionary *langDict = translations[key];
    if (langDict && langDict[@(self.currentLang)]) {
        return langDict[@(self.currentLang)];
    }
    return key;
}

- (void)validateKey:(NSString *)key completion:(void(^)(BOOL isValid))completion {
    NSString *urlString = [NSString stringWithFormat:@"https://narkhdockqhlwxxyyxjr.supabase.co/rest/v1/keys?key_text=eq.%@", key];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"apikey"];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) {
            completion(NO);
            return;
        }
        
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError && [jsonArray isKindOfClass:[NSArray class]] && jsonArray.count > 0) {
            NSDictionary *keyData = jsonArray[0];
            if ([keyData[@"is_active"] boolValue] == YES) {
                completion(YES);
                return;
            }
        }
        completion(NO);
    }];
    [task resume];
}

- (void)syncWithServerFeature:(NSString *)featureName status:(BOOL)status {
    NSString *urlString = @"https://narkhdockqhlwxxyyxjr.supabase.co/rest/v1/mod_logs";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"apikey"];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hcmtoZG9ja3FobHd4eHl5eGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg3MjM3MTMsImV4cCI6MjEwNDI5OTcxM30.F_1g9fcQgSFoMGiqp6hjfanOU6gAxZkTJ35qBa0wuUA" forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *jsonBody = @{@"feature": featureName, @"status": status ? @(YES) : @(NO)};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:nil];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];
    [task resume];
}

- (void)setupMenu {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self getMainWindow];
        if (!window) return;

        self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.floatingButton.frame = CGRectMake(50, 100, 50, 50);
        self.floatingButton.backgroundColor = [UIColor clearColor];
        [self.floatingButton setTitle:@"⚙️" forState:UIControlStateNormal];
        self.floatingButton.titleLabel.font = [UIFont systemFontOfSize:32];
        self.floatingButton.layer.zPosition = 99999;
        [self.floatingButton addTarget:self action:@selector(handleFloatingButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *panBtn = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanButton:)];
        [self.floatingButton addGestureRecognizer:panBtn];
        [window addSubview:self.floatingButton];

        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 320, 440)];
        self.menuView.backgroundColor = [UIColor colorWithRed:0.95 green:0.93 blue:0.98 alpha:0.98];
        self.menuView.hidden = YES;
        self.menuView.layer.zPosition = 99998;
        self.menuView.layer.cornerRadius = 14;
        self.menuView.layer.borderWidth = 2.5;
        self.menuView.layer.borderColor = [UIColor purpleColor].CGColor;
        self.menuView.clipsToBounds = YES;

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 30)];
        self.titleLabel.text = @"👑 M ᴀ ᴍ ᴀ 𝐇 ᴀ ʟ ᴀ 👑";
        self.titleLabel.textColor = [UIColor purpleColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.menuView addSubview:self.titleLabel];

        self.tabStackView = [[UIStackView alloc] initWithFrame:CGRectMake(10, 48, 300, 34)];
        self.tabStackView.axis = UILayoutConstraintAxisHorizontal;
        self.tabStackView.distribution = UIStackViewDistributionFillEqually;
        self.tabStackView.spacing = 3;
        [self.menuView addSubview:self.tabStackView];

        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 90, 300, 335)];
        self.contentScrollView.showsVerticalScrollIndicator = YES;
        [self.menuView addSubview:self.contentScrollView];

        self.contentStackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 300, 520)];
        self.contentStackView.axis = UILayoutConstraintAxisVertical;
        self.contentStackView.distribution = UIStackViewDistributionFillEqually;
        self.contentStackView.spacing = 6;
        [self.contentScrollView addSubview:self.contentStackView];

        UIPanGestureRecognizer *panMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanMenu:)];
        [self.menuView addGestureRecognizer:panMenu];

        [window addSubview:self.menuView];
        [self reloadTabs];
        [self reloadMenuButtons];
    });
}

- (void)reloadTabs {
    for (UIView *subview in self.tabStackView.arrangedSubviews) {
        [subview removeFromSuperview];
    }
    
    NSArray *tabsKeys = @[@"ESP", @"Aim", @"Fly", @"Skins", @"Lang"];
    for (int i = 0; i < tabsKeys.count; i++) {
        UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tabBtn setTitle:[self localizedStringForKey:tabsKeys[i]] forState:UIControlStateNormal];
        tabBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tabBtn.backgroundColor = (self.currentSection == i) ? [UIColor systemBlueColor] : [UIColor darkGrayColor];
        tabBtn.layer.cornerRadius = 6;
        tabBtn.tag = i;
        [tabBtn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabStackView addArrangedSubview:tabBtn];
    }
}

- (void)handleFloatingButtonTapped {
    if (!self.isAuthorized) {
        [self showKeyPrompt];
    } else {
        self.menuView.hidden = !self.menuView.hidden;
    }
}

- (void)handlePanButton:(UIPanGestureRecognizer *)recognizer {
    UIWindow *window = [self getMainWindow];
    CGPoint translation = [recognizer translationInView:window];
    CGPoint center = recognizer.view.center;
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:window];
}

- (void)handlePanMenu:(UIPanGestureRecognizer *)recognizer {
    UIWindow *window = [self getMainWindow];
    CGPoint translation = [recognizer translationInView:window];
    CGPoint center = recognizer.view.center;
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:window];
}

- (void)switchTab:(UIButton *)sender {
    self.currentSection = (MenuSection)sender.tag;
    [self reloadTabs];
    [self reloadMenuButtons];
}

- (void)reloadMenuButtons {
    for (UIView *subview in self.contentStackView.arrangedSubviews) {
        [subview removeFromSuperview];
    }
    
    if (self.currentSection == SectionESP) {
        self.contentStackView.frame = CGRectMake(0, 0, 300, 360);
        self.contentScrollView.contentSize = CGSizeMake(300, 360);
        
        [self addSwitchRowToStack:@"Line" status:IsLine action:@selector(toggleLine:)];
        [self addSwitchRowToStack:@"Box" status:IsBox action:@selector(toggleBox:)];
        [self addSwitchRowToStack:@"Distance" status:IsDistance action:@selector(toggleDistance:)];
        [self addSwitchRowToStack:@"Health" status:IsHealth action:@selector(toggleHealth:)];
        [self addSwitchRowToStack:@"Skeleton" status:IsBone action:@selector(toggleSkeleton:)];
        [self addSwitchRowToStack:@"Name" status:IsName action:@selector(toggleName:)];
        [self addSwitchRowToStack:@"Alert" status:IsAlert360 action:@selector(toggleAlert:)];
        [self addSwitchRowToStack:@"Loot" status:IsWeapon action:@selector(toggleLoot:)];
    } 
    else if (self.currentSection == SectionAimbot) {
        self.contentStackView.frame = CGRectMake(0, 0, 300, 320);
        self.contentScrollView.contentSize = CGSizeMake(300, 320);
        
        [self addSwitchRowToStack:@"Aimbot" status:IsAimbot action:@selector(toggleAimbot:)];
        [self addSwitchRowToStack:@"Auto Shoot" status:IsAutoShoot action:@selector(toggleAutoShoot:)];
        [self addSwitchRowToStack:@"FOV" status:IsFov action:@selector(toggleFov:)];
        [self addSwitchRowToStack:@"Recoil" status:IsRecoil action:@selector(toggleRecoil:)];
        [self addSwitchRowToStack:@"Silent" status:IsSilentAim action:@selector(toggleSilent:)];
        [self addSwitchRowToStack:@"Prediction" status:IsPrediction action:@selector(togglePrediction:)];
        [self addSwitchRowToStack:@"Headshot" status:IsHeadshotOnly action:@selector(toggleHeadshot:)];
    } 
    else if (self.currentSection == SectionMemory) {
        self.contentStackView.frame = CGRectMake(0, 0, 300, 320);
        self.contentScrollView.contentSize = CGSizeMake(300, 320);
        
        [self addSwitchRowToStack:@"Fly Hack" status:IsFly action:@selector(toggleFly:)];
        [self addSwitchRowToStack:@"High Jump" status:IsHighJump action:@selector(toggleHighJump:)];
        [self addSwitchRowToStack:@"Speed Hack" status:IsSpeed action:@selector(toggleSpeed:)];
        [self addSwitchRowToStack:@"WallHack" status:IsWallHack action:@selector(toggleWallHack:)];
        [self addSwitchRowToStack:@"Fast Reload" status:IsFastReload action:@selector(toggleFastReload:)];
        [self addSwitchRowToStack:@"Instant Hit" status:IsInstantHit action:@selector(toggleInstantHit:)];
        [self addSwitchRowToStack:@"Magic Bullet" status:IsMagicBullet action:@selector(toggleMagicBullet:)];
    } 
    else if (self.currentSection == SectionSkins) {
        self.contentStackView.frame = CGRectMake(0, 0, 300, 230);
        self.contentScrollView.contentSize = CGSizeMake(300, 230);
        
        [self addSwitchRowToStack:@"Weapon Skins" status:IsWeaponSkins action:@selector(toggleWeaponSkins:)];
        [self addSwitchRowToStack:@"Character Skins" status:IsCharacterSkins action:@selector(toggleCharacterSkins:)];
        [self addSwitchRowToStack:@"Vehicle Skins" status:IsVehicleSkins action:@selector(toggleVehicleSkins:)];
        [self addSwitchRowToStack:@"Mythic Effect" status:IsMythicEffect action:@selector(toggleMythicEffect:)];
        [self addSwitchRowToStack:@"Emotes" status:IsCustomEmote action:@selector(toggleEmotes:)];
    } 
    else if (self.currentSection == SectionSettings) {
        self.contentStackView.frame = CGRectMake(0, 0, 300, 140);
        self.contentScrollView.contentSize = CGSizeMake(300, 140);
        
        [self addLangButtonToStack:@"کوردی (سۆرانى)" langIndex:LangSorani];
        [self addLangButtonToStack:@"کوردی (بادینی)" langIndex:LangBadini];
        [self addLangButtonToStack:@"English" langIndex:LangEnglish];
    }
}

- (void)addSwitchRowToStack:(NSString *)key status:(BOOL)status action:(SEL)action {
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    rowView.backgroundColor = [UIColor whiteColor];
    rowView.layer.cornerRadius = 8;
    rowView.layer.borderWidth = 1.2;
    rowView.layer.borderColor = [UIColor purpleColor].CGColor;
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(12, 5, 50, 30)];
    sw.on = status;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [rowView addSubview:sw];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 215, 30)];
    lbl.text = [self localizedStringForKey:key];
    lbl.font = [UIFont boldSystemFontOfSize:12];
    lbl.textColor = [UIColor darkTextColor];
    [rowView addSubview:lbl];
    
    [self.contentStackView addArrangedSubview:rowView];
}

- (void)addLangButtonToStack:(NSString *)title langIndex:(AppLanguage)lang {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    BOOL isSelected = (self.currentLang == lang);
    [btn setTitle:[NSString stringWithFormat:@"%@%@", title, isSelected ? @" ✔" : @""] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = isSelected ? [UIColor systemBlueColor] : [UIColor darkGrayColor];
    btn.layer.cornerRadius = 8;
    btn.tag = lang;
    [btn addTarget:self action:@selector(selectLanguage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentStackView addArrangedSubview:btn];
}

- (void)selectLanguage:(id)sender {
    self.currentLang = (AppLanguage)((UIView *)sender).tag;
    IsEnglish = (self.currentLang == LangEnglish) ? 1 : 0;
    [self reloadTabs];
    [self reloadMenuButtons];
}

// Toggles for ESP
- (void)toggleLine:(UISwitch *)sender { IsLine = sender.isOn; [self syncWithServerFeature:@"Line" status:sender.isOn]; }
- (void)toggleBox:(UISwitch *)sender { IsBox = sender.isOn; [self syncWithServerFeature:@"Box" status:sender.isOn]; }
- (void)toggleDistance:(UISwitch *)sender { IsDistance = sender.isOn; [self syncWithServerFeature:@"Distance" status:sender.isOn]; }
- (void)toggleHealth:(UISwitch *)sender { IsHealth = sender.isOn; [self syncWithServerFeature:@"Health" status:sender.isOn]; }
- (void)toggleSkeleton:(UISwitch *)sender { IsBone = sender.isOn; [self syncWithServerFeature:@"Skeleton" status:sender.isOn]; }
- (void)toggleName:(UISwitch *)sender { IsName = sender.isOn; [self syncWithServerFeature:@"Name" status:sender.isOn]; }
- (void)toggleAlert:(UISwitch *)sender { IsAlert360 = sender.isOn; [self syncWithServerFeature:@"Alert" status:sender.isOn]; }
- (void)toggleLoot:(UISwitch *)sender { IsWeapon = sender.isOn; [self syncWithServerFeature:@"Loot" status:sender.isOn]; }

// Toggles for Aimbot
- (void)toggleAimbot:(UISwitch *)sender { IsAimbot = sender.isOn; [self syncWithServerFeature:@"Aimbot" status:sender.isOn]; }
- (void)toggleAutoShoot:(UISwitch *)sender { IsAutoShoot = sender.isOn; [self syncWithServerFeature:@"AutoShoot" status:sender.isOn]; }
- (void)toggleFov:(UISwitch *)sender { IsFov = sender.isOn; [self syncWithServerFeature:@"FOV" status:sender.isOn]; }
- (void)toggleRecoil:(UISwitch *)sender { IsRecoil = sender.isOn; [self syncWithServerFeature:@"NoRecoil" status:sender.isOn]; }
- (void)toggleSilent:(UISwitch *)sender { IsSilentAim = sender.isOn; [self syncWithServerFeature:@"SilentAim" status:sender.isOn]; }
- (void)togglePrediction:(UISwitch *)sender { IsPrediction = sender.isOn; [self syncWithServerFeature:@"Prediction" status:sender.isOn]; }
- (void)toggleHeadshot:(UISwitch *)sender { IsHeadshotOnly = sender.isOn; [self syncWithServerFeature:@"HeadshotOnly" status:sender.isOn]; }

// Toggles for Memory / Powers
- (void)toggleFly:(UISwitch *)sender { IsFly = sender.isOn; [self syncWithServerFeature:@"Fly" status:sender.isOn]; }
- (void)toggleHighJump:(UISwitch *)sender { IsHighJump = sender.isOn; [self syncWithServerFeature:@"HighJump" status:sender.isOn]; }
- (void)toggleSpeed:(UISwitch *)sender { IsSpeed = sender.isOn; [self syncWithServerFeature:@"Speed" status:sender.isOn]; }
- (void)toggleWallHack:(UISwitch *)sender { IsWallHack = sender.isOn; [self syncWithServerFeature:@"WallHack" status:sender.isOn]; }
- (void)toggleFastReload:(UISwitch *)sender { IsFastReload = sender.isOn; [self syncWithServerFeature:@"FastReload" status:sender.isOn]; }
- (void)toggleInstantHit:(UISwitch *)sender { IsInstantHit = sender.isOn; [self syncWithServerFeature:@"InstantHit" status:sender.isOn]; }
- (void)toggleMagicBullet:(UISwitch *)sender { IsMagicBullet = sender.isOn; [self syncWithServerFeature:@"MagicBullet" status:sender.isOn]; }

// Toggles for Skins
- (void)toggleWeaponSkins:(UISwitch *)sender { IsWeaponSkins = sender.isOn; [self syncWithServerFeature:@"WeaponSkins" status:sender.isOn]; }
- (void)toggleCharacterSkins:(UISwitch *)sender { IsCharacterSkins = sender.isOn; [self syncWithServerFeature:@"CharacterSkins" status:sender.isOn]; }
- (void)toggleVehicleSkins:(UISwitch *)sender { IsVehicleSkins = sender.isOn; [self syncWithServerFeature:@"VehicleSkins" status:sender.isOn]; }
- (void)toggleMythicEffect:(UISwitch *)sender { IsMythicEffect = sender.isOn; [self syncWithServerFeature:@"MythicEffect" status:sender.isOn]; }
- (void)toggleEmotes:(UISwitch *)sender { IsCustomEmote = sender.isOn; [self syncWithServerFeature:@"Emotes" status:sender.isOn]; }

- (void)showKeyPrompt {
    UIWindow *window = [self getMainWindow];
    UIViewController *rootVC = window.rootViewController;
    
    UIAlertController *keyAlert = [UIAlertController alertControllerWithTitle:@"🔑 MamaHala Key System" 
        message:@"تکایە کلیلی چالاککردن بنووسە:" 
        preferredStyle:UIAlertControllerStyleAlert];
        
    [keyAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"کلیل لێرە بنووسە...";
    }];
    
    UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"💬 بۆ دەست کەوتنی کلیل دەست لێرە بدە" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *telegramURL = [NSURL URLWithString:@"https://t.me/MAMA_HALA0"];
        if ([[UIApplication sharedApplication] canOpenURL:telegramURL]) {
            [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showKeyPrompt];
        });
    }];
    [keyAlert addAction:telegramAction];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"پشکنین" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *enteredKey = keyAlert.textFields.firstObject.text;
        [self validateKey:enteredKey completion:^(BOOL isValid) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isValid) {
                    self.isAuthorized = YES;
                    self.menuView.hidden = NO;
                } else {
                    UIAlertController *errAlert = [UIAlertController alertControllerWithTitle:@"هەڵە" message:@"کلیلەکە هەڵەیە یان ناچالاکە!" preferredStyle:UIAlertControllerStyleAlert];
                    [errAlert addAction:[UIAlertAction actionWithTitle:@"باشە" style:UIAlertActionStyleDestructive handler:nil]];
                    [rootVC presentViewController:errAlert animated:YES completion:nil];
                }
            });
        }];
    }];
    
    [keyAlert addAction:submitAction];
    [keyAlert addAction:[UIAlertAction actionWithTitle:@"داخستن" style:UIAlertActionStyleCancel handler:nil]];
    [rootVC presentViewController:keyAlert animated:YES completion:nil];
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ModMenuManager sharedInstance] setupMenu];
    });
}
