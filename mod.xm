#import <UIKit/UIKit.h>

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    
    if (![self viewWithTag:9999]) {
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat boxWidth = 190.0;
        CGFloat boxHeight = 35.0;
        
        // دانانی لە ناوەڕاستی سەرەوە
        UILabel *watermarkLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - boxWidth) / 2, 40, boxWidth, boxHeight)];
        
        watermarkLabel.text = @"TG📱SaraExpert";
        
        // ڕەنگی زەردی تۆخ (ئاڵتونی)
        UIColor *darkYellowColor = [UIColor colorWithRed:0.90 green:0.75 blue:0.0 alpha:1.0];
        watermarkLabel.textColor = darkYellowColor;
        
        watermarkLabel.font = [UIFont boldSystemFontOfSize:16.0]; 
        watermarkLabel.textAlignment = NSTextAlignmentCenter;
        
        // باکگراوندی ڕەش
        watermarkLabel.backgroundColor = [UIColor blackColor];
        
        // چوارچێوەی زەردی تۆخ
        watermarkLabel.layer.borderWidth = 1.5;
        watermarkLabel.layer.borderColor = [darkYellowColor CGColor];
        watermarkLabel.layer.cornerRadius = 8.0;
        watermarkLabel.clipsToBounds = YES;
        
        watermarkLabel.tag = 9999;
        
        // ڕێگەدان بە پەنجەدان لە شاشەی ژێرەوە
        watermarkLabel.userInteractionEnabled = NO; 

        [self addSubview:watermarkLabel];
    }
}

%end
