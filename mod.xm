#import <UIKit/UIKit.h>

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    
    if (![self viewWithTag:9999]) {
        // دیاریکردنی قەبارە (بچووکتر کراوەتەوە بۆ ئەوەی ڕێگر نەبێت لە یاری)
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat boxWidth = 190.0; // پانتایی چوارچێوەکە
        CGFloat boxHeight = 35.0; // بەرزی چوارچێوەکە
        
        // دانانی لە ناوەڕاستی سەرەوەی شاشەکە
        UILabel *watermarkLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - boxWidth) / 2, 40, boxWidth, boxHeight)];
        
        watermarkLabel.text = @"TG📱SaraExpert";
        
        // ڕەنگی نوسین: زەردێکی تۆخ (ئاڵتونی)
        UIColor *darkYellowColor = [UIColor colorWithRed:0.90 green:0.75 blue:0.0 alpha:1.0];
        watermarkLabel.textColor = darkYellowColor;
        
        // فۆنتەکە زەقە بەڵام قەبارەکەی بچووکترە (16) بۆ ئەوەی لە چوارچێوەکە جێی ببێتەوە
        watermarkLabel.font = [UIFont boldSystemFontOfSize:16.0]; 
        watermarkLabel.textAlignment = NSTextAlignmentCenter;
        
        // باکگراوند: چوارچێوەیەکی ڕەش
        watermarkLabel.backgroundColor = [UIColor blackColor];
        
        // ڕۆخی چوارچێوەکە (بۆردەر): بە هەمان ڕەنگی زەردی تۆخ
        watermarkLabel.layer.borderWidth = 1.5; // ئەستووری هێڵی چوارچێوەکە
        watermarkLabel.layer.borderColor = [darkYellowColor CGColor];
        
        // چەمانەوەی گۆشەکانی چوارچێوەکە بۆ ئەوەی جوانتر دەرکەوێت
        watermarkLabel.layer.cornerRadius = 8.0;
        watermarkLabel.clipsToBounds = YES; // پێویستە بۆ ئەوەی ڕەنگە ڕەشەکە لە چوارچێوەکە دەرنەچێت
        
        watermarkLabel.tag = 9999;
        
        // ڕێگەدان بە پەنجەدان لە شاشەی ژێرەوەی بێ ئەوەی تێکستەکە ڕێگر بێت
        watermarkLabel.userInteractionEnabled = NO; 

        [self addSubview:watermarkLabel];
    }
}

%end
