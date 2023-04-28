//
//  HTUIColor+ColorChange.h -- 16进制转RGB
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>

@interface UIColor(ColorChange)

// 颜色转换:iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(float)alpha;

@end
