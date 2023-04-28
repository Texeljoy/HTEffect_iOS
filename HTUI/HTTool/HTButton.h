//
//  HTButton.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTButton : UIButton

- (void)setImage:(UIImage *)image imageWidth:(CGFloat)width title:(NSString *)title;
- (void)setTextColor:(UIColor *)color;
- (void)setTextFont:(UIFont *)font;
- (void)setImageCornerRadius:(CGFloat)radius;
- (void)setTextBackgroundColor:(UIColor *)color;

- (NSString *)getTitle;

@end

NS_ASSUME_NONNULL_END
