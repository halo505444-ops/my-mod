#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

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
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    }
    return self;
}
- (void)handlePan:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:self.superview];
    self.center = CGPointMake(self.center.x + t.x, self.center.y + t.y);
    [g setTranslation:CGPointZero inView:self.superview];
}
@end

@interface CircularSlider : UIControl
@property (nonatomic, assign) float value, minimumValue, maximumValue;
@property (nonatomic, strong) UILabel *valueLabel, *titleLabel;
@end

@implementation CircularSlider
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title min:(float)min max:(float)max val:(float)val {
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumValue = min; self.maximumValue = max; self.value = val;
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
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(c, [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:0.9].CGColor);
    CGContextSetLineWidth(c, 4.0);
    CGContextAddEllipseInRect(c, CGRectInset(self.bounds, 8, 8));
    CGContextStrokePath(c);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { [self updateVal:touch]; return YES; }
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { [self updateVal:touch]; return YES; }

- (void)updateVal:(UITouch *)touch {
    CGPoint p = [touch locationInView:self];
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat angle = atan2(p.y - center.y, p.x - center.x) + M_PI_2;
    if (angle < 0) angle += 2 * M_PI;
    self.value = self.minimumValue + (angle / (2 * M_PI)) * (self.maximumValue - self.minimumValue);
    self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)self.value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end

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
        resetBtn.frame = CGRectMake(180, 15, 110, 32);
        [resetBtn setTitle:@"Reset guest" forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        resetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        resetBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.24 alpha:1.0];
        resetBtn.layer.cornerRadius = 16;
        resetBtn.layer.borderWidth = 1.0;
        resetBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:resetBtn];
        
        UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hideBtn.frame = CGRectMake(310, 15, 110, 32);
        [hideBtn setTitle:@"Hide Hack" forState:UIControlStateNormal];
        [hideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        hideBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        hideBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.24 alpha:1.0];
        hideBtn.layer.cornerRadius = 16;
        hideBtn.layer.borderWidth = 1.0;
        hideBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:hideBtn];
        
        UIButton *handcamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        handcamBtn.frame = CGRectMake(240, 58, 110, 32);
        [handcamBtn setTitle:@"Handcam" forState:UIControlStateNormal];
        [handcamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        handcamBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        handcamBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.24 alpha:1.0];
        handcamBtn.layer.cornerRadius = 16;
        handcamBtn.layer.borderWidth = 1.0;
        handcamBtn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0].CGColor;
        [self addSubview:handcamBtn];
        
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

@interface ObsidianESPTab : UIView
@end

@implementation ObsidianESPTab
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *leftColumn = @[@"ESP", @"Line", @"Health", @"Name", @"Distance", @"Weapon"];
        for (int i = 0; i < leftColumn.count; i++) {
            UIButton *swBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            swBtn.frame = CGRectMake(15, 15 + (i * 35), 70, 26);
            [swBtn setTitle:@"ON ⚡️" forState:UIControlStateNormal];
            [swBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            swBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            swBtn.backgroundColor = [UIColor colorWithRed:0.95 green:0.8 blue:0.15 alpha:1.0];
            swBtn.layer.cornerRadius = 13;
            [self addSubview:swBtn];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(95, 15 + (i * 35) + 3, 100, 20)];
            lbl.text = leftColumn[i];
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont boldSystemFontOfSize:12];
            [self addSubview:lbl];
        }
    }
    return self;
}
@end

@interface ObsidianAIMTab : UIView
@end

@implementation ObsidianAIMTab
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CircularSlider *fov = [[CircularSlider alloc] initWithFrame:CGRectMake(80, 10, 75, 75) title:@"FOV" min:0 max:360 val:144];
        [self addSubview:fov];
        
        CircularSlider *aimDis = [[CircularSlider alloc] initWithFrame:CGRectMake(220, 10, 75, 75) title:@"AimDis" min:50 max:500 val:105];
        [self addSubview:aimDis];
    }
    return self;
}
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utt = [[AVSpeechUtterance alloc] initWithString:@"بەخێر بێی بۆ مۆد مێنۆی مامە هەڵە، بەهیوای یارییەکی خۆش"];
        utt.rate = 0.48f;
        AVSpeechSynthesisVoice *v = [AVSpeechSynthesisVoice voiceWithLanguage:@"ku-IQ"];
        if (!v) v = [AVSpeechSynthesisVoice voiceWithLanguage:@"ar-IQ"];
        if (v) utt.voice = v;
        [synth speakUtterance:utt];
    });
}
