//
//  UIButton+HTImagePosition.h
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HTImagePosition) {
    HTImagePositionLeft = 0,              //图片在左，文字在右，默认
    HTImagePositionRight = 1,             //图片在右，文字在左
    HTImagePositionTop = 2,               //图片在上，文字在下
    HTImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (HTImagePosition)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
//- (void)setImagePosition:(HTImagePosition)postion spacing:(CGFloat)spacing;


//新方法
- (void)layoutButtonWithEdgeInsetsStyle:(HTImagePosition)style imageTitleSpace:(CGFloat)space;


/////创建水平渐变色的按钮 isLevel: YES=水平 NO=垂直
//+ (UIButton *)defaultMutableColorButtonWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *_Nullable)font isLevel:(BOOL)isLevel;
//
///// 创建一个按钮
//+ (UIButton *)initWithButton:(CGRect)rect text:(NSString *_Nullable)title font:(CGFloat)fontSize textColor:(UIColor *_Nullable)color normalImg:(NSString *_Nullable)nImg highImg:(NSString *_Nullable)hImg selectedImg:(NSString *_Nullable)sImg;

@end

NS_ASSUME_NONNULL_END
