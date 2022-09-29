//
//  HTButton.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTButton : UIButton

- (void)setImage:(UIImage *)image imageWidth:(CGFloat)width title:(NSString *)title;
- (void)setTextColor:(UIColor *)color;
- (void)setTextFont:(UIFont *)font;
- (void)setImageCornerRadius:(CGFloat)radius;
- (void)setTextBackgroundColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
