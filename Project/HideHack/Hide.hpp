#pragma once
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface HeeeNoScreenShotView : UIView
@end
NS_ASSUME_NONNULL_END

@interface HeeeNoScreenShotView ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *clearView;
@end

@implementation HeeeNoScreenShotView

- (instancetype)init {
    self = [super init];
    if (self) { [self setupUI]; }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { [self setupUI]; }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = self.bounds;
    self.clearView.frame = self.bounds;
}

- (void)setupUI {
    [self addSubview:self.textField];
    self.textField.subviews.firstObject.userInteractionEnabled = YES;
    [self.textField.subviews.firstObject addSubview:self.clearView];
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    if (self.textField != view) {
        [self.clearView addSubview:view];
    }
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.secureTextEntry = YES;
    }
    return _textField;
}

- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [[UIView alloc] init];
    }
    return _clearView;
}

@end

inline void InitializeHideHack() {
    // دەستپێکردنی سیستەمی شاردنەوەی ڕوکار
    NSLog(@"[MamaHala] HideHack Initialized with SecureView.");
}
