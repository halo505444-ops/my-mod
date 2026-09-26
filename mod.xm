#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// 1. دووگمەی مەلەوانی (Floating Menu Button) بە ⚙️
@interface ObsidianFloatingButton : UIButton
@end

@implementation ObsidianFloatingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(50, 100, 50, 50)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.15 alpha:0.9];
        self.layer.cornerRadius = 25;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        
        [self setTitle:@"⚙️" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:22];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

@end


// 2. کۆدی سلایدەری بازنەیی (Circular Slider) بۆ FOV، AimDis و iPadView
@interface CircularSlider : UIControl
@property (nonatomic, assign) float value;
@property (nonatomic, assign) float minimumValue;
@property (nonatomic, assign) float maximumValue;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CircularSlider

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title min:(float)min max:(float)max val:(float)val {
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumValue = min;
        self.maximumValue = max;
        self.value = val;
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -18, frame.size.width, 20)];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.height/2) - 10, frame.size.width, 20)];
        self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)self.value];
        self.valueLabel.textColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0];
        self.valueLabel.font = [UIFont boldSystemFontOfSize:13];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.valueLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:0.9].CGColor);
    CGContextSetLineWidth(context, 4.0);
    CGRect circleRect = CGRectInset(self.bounds, 8, 8);
    CGContextAddEllipseInRect(context, circleRect);
    CGContextStrokePath(context);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self updateValueWithTouch:touch];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self updateValueWithTouch:touch];
    return YES;
}

- (void)updateValueWithTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    CGFloat angle = atan2(dy, dx) + M_PI_2;
    if (angle < 0) angle += 2 * M_PI;
    
    CGFloat percentage = angle / (2 * M_PI);
    self.value = self.minimumValue + percentage * (self.maximumValue - self.minimumValue);
    self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)self.value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end


// 3. بەشی Home Tab
@interface ObsidianHomeTab : UIView
@end

@implementation ObsidianHomeTab

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *langBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        langBtn.frame = CGRectMake(20, 15, 100, 30);
        [langBtn setTitle:@"KURDISH ◀" forState:UIControlStateNormal];
        [langBtn setTitleColor:[UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0] forState:UIControlStateNormal];
        langBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        langBtn.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1.0];
        langBtn.layer.cornerRadius = 6;
        langBtn.layer.borderWidth = 1.0;
        langBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:langBtn];
        
        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resetBtn.frame = CGRectMake(180, 15, 110, 32];
        [resetBtn setTitle:@"Reset guest" forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        resetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        resetBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.24 alpha:1.0];
        resetBtn.layer.cornerRadius = 16;
        resetBtn.layer.borderWidth = 1.0;
        resetBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:resetBtn];
        
        UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hideBtn.frame = CGRectMake(310, 15, 110, 32];
        [hideBtn setTitle:@"Hide Hack" forState:UIControlStateNormal];
        [hideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        hideBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        hideBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.24 alpha:1.0];
        hideBtn.layer.cornerRadius = 16;
        hideBtn.layer.borderWidth = 1.0;
        hideBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:hideBtn];
        
        UIButton *handcamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        handcamBtn.frame = CGRectMake(240, 58, 110, 32];
        [handcamBtn setTitle:@"Handcam" forState:UIControlStateNormal];
        [handcamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        handcamBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        handcamBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.24 alpha:1.0];
        handcamBtn.layer.cornerRadius = 16;
        handcamBtn.layer.borderWidth = 1.0;
        handcamBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:handcamBtn];
        
        UIButton *chkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chkBtn.frame = CGRectMake(20, 60, 110, 25];
        [chkBtn setTitle:@"  iPadView" forState:UIControlStateNormal];
        [chkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        chkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        chkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 16, 16)];
        box.layer.borderWidth = 1.0;
        box.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        box.layer.cornerRadius = 3;
        box.backgroundColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0];
        [chkBtn addSubview:box];
        [self addSubview:chkBtn];
        
        CircularSlider *ipadSlider = [[CircularSlider alloc] initWithFrame:CGRectMake(35, 95, 75, 75) title:@"iPadView" min:70 max:120 val:90];
        [self addSubview:ipadSlider];
        
        UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 110, 120, 25)];
        verLabel.text = @"VERSION 1.0";
        verLabel.textColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0];
        verLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:verLabel];
    }
    return self;
}

@end


// 4. بەشی ESP Tab
@interface ObsidianESPTab : UIView
@end

@implementation ObsidianESPTab

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *leftColumn = @[@"ESP", @"Line", @"Health", @"Name", @"Distance", @"Weapon"];
        NSArray *rightColumn = @[@"Bone", @"HideBot", @"Alert360"];
        
        for (int i = 0; i < leftColumn.count; i++) {
            CGFloat yPos = 15 + (i * 35);
            UIButton *swBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            swBtn.frame = CGRectMake(15, yPos, 70, 26];
            [swBtn setTitle:@"ON ⚡️" forState:UIControlStateNormal];
            [swBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            swBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            swBtn.backgroundColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0];
            swBtn.layer.cornerRadius = 13;
            [self addSubview:swBtn];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(95, yPos + 3, 100, 20)];
            lbl.text = leftColumn[i];
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont boldSystemFontOfSize:12];
            [self addSubview:lbl];
        }
        
        for (int i = 0; i < rightColumn.count; i++) {
            CGFloat yPos = 15 + (i * 35);
            UIButton *swBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            swBtn.frame = CGRectMake(210, yPos, 70, 26];
            [swBtn setTitle:(i == 0 ? @"ON ⚡️" : @"OFF") forState:UIControlStateNormal];
            [swBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            swBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            swBtn.backgroundColor = (i == 0) ? [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0] : [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
            swBtn.layer.cornerRadius = 13;
            [self addSubview:swBtn];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(290, yPos + 3, 100, 20)];
            lbl.text = rightColumn[i];
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont boldSystemFontOfSize:12];
            [self.superview addSubview:lbl]; // Fixing superview context warning safely
        }
        
        UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsBtn.frame = CGRectMake(210, 125, 140, 32];
        [settingsBtn setTitle:@"ESP Settings" forState:UIControlStateNormal];
        [settingsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        settingsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        settingsBtn.backgroundColor = [UIColor colorWithRed:0.35 green:0.25 blue:0.15 alpha:1.0];
        settingsBtn.layer.cornerRadius = 6;
        settingsBtn.layer.borderWidth = 1.0;
        settingsBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:settingsBtn];
    }
    return self;
}

@end


// 5. بەشی AIM Tab
@interface ObsidianAIMTab : UIView
@end

@implementation ObsidianAIMTab

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CircularSlider *fovSlider = [[CircularSlider alloc] initWithFrame:CGRectMake(80, 10, 75, 75) title:@"FOV" min:0 max:360 val:144];
        [self addSubview:fovSlider];
        
        CircularSlider *aimDisSlider = [[CircularSlider alloc] initWithFrame:CGRectMake(220, 10, 75, 75) title:@"AimDis" min:50 max:500 val:105];
        [self addSubview:aimDisSlider];
        
        NSArray *checkboxOptions = @[@"AimBot", @"Skip Bot", @"Skip Knock", @"Slient aim", @"Show Fov"];
        NSArray *frames = @[
            [NSValue valueWithCGRect:CGRectMake(50, 100, 110, 25)],
            [NSValue valueWithCGRect:CGRectMake(170, 100, 110, 25)],
            [NSValue valueWithCGRect:CGRectMake(290, 100, 110, 25)],
            [NSValue valueWithCGRect:CGRectMake(110, 128, 110, 25)],
            [NSValue valueWithCGRect:CGRectMake(230, 128, 110, 25)]
        ];
        
        for (int i = 0; i < checkboxOptions.count; i++) {
            CGRect btnRect = [frames[i] CGRectValue];
            UIButton *chkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            chkBtn.frame = btnRect;
            [chkBtn setTitle:[NSString stringWithFormat:@"  %@", checkboxOptions[i]] forState:UIControlStateNormal];
            [chkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            chkBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            chkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 16, 16)];
            box.layer.borderWidth = 1.0;
            box.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
            box.layer.cornerRadius = 3;
            box.tag = 99;
            [chkBtn addSubview:box];
            
            [chkBtn addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:chkBtn];
        }
        
        NSArray *titles = @[@"Mode", @"Target", @"AIM Mode"];
        NSArray *options1 = @[@"Fire", @"Scope", @"Both"];
        NSArray *options2 = @[@"Head", @"Body"];
        NSArray *options3 = @[@"Risk", @"Mid", @"Safe"];
        NSArray *allOpts = @[options1, options2, options3];
        
        for (int i = 0; i < titles.count; i++) {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 160 + (i * 32), 70, 25)];
            lbl.text = titles[i];
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont boldSystemFontOfSize:11];
            [self addSubview:lbl];
            
            NSArray *opts = allOpts[i];
            for (int j = 0; j < opts.count; j++) {
                UIButton *optBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                optBtn.frame = CGRectMake(95 + (j * 95), 160 + (i * 32), 85, 25);
                [optBtn setTitle:opts[j] forState:UIControlStateNormal];
                [optBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                optBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                optBtn.backgroundColor = (j == 0) ? [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0] : [UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1.0];
                if(j == 0) [optBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                optBtn.layer.cornerRadius = 6;
                [self addSubview:optBtn];
            }
        }
    }
    return self;
}

- (void)checkboxTapped:(UIButton *)sender {
    UIView *box = [sender viewWithTag:99];
    if (box.backgroundColor == [UIColor clearColor]) {
        box.backgroundColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0];
        box.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        box.backgroundColor = [UIColor clearColor];
        box.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
    }
}

@end


// 6. فەنکشنی دەنگی خۆکار (Voice Greeting) لە کاتی پەیڕەوکردنی هاکەکە لە ناو پۆبجی
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"بەخێر بێی بۆ مۆد مێنۆی مامە هەڵە، بەهیوای یارییەکی خۆش"];
        utterance.rate = 0.48f; // خێرایی خوێندنەوەی دەنگەکە بە شێوازێکی سروشتی و ڕوون
        utterance.pitchMultiplier = 1.0f;
        
        // هەوڵدان بۆ دۆزینەوەی دەنگی کوردی یان عەرەبی نزیک لە کوردی
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ku-IQ"];
        if (!voice) {
            voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ar-IQ"];
        }
        if (voice) {
            utterance.voice = voice;
        }
        
        [synth speakUtterance:utterance];
    });
}
