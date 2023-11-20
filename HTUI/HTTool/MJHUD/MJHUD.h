//
//  MJHUD.h
//  MJHUD
//
//  Created by mingjin on 18/10/15.
//  Copyright © 2018年 mingjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJHUD : UIView
/**
 *  显示指示器
 *  如果不希望有文字，message填入nil或者@""
 *
 *  @param message 信息文本
 */
+ (void)showLoading:(NSString *)message;

/**
 *  显示成功指示器
 *  如果不希望有文字，message填入nil或者@""
 *
 *  @param message 信息文本
 */
+ (void)showSuccess:(NSString *)message;

/**
 *  显示错误指示器
 *  如果不希望有文字，message填入nil或者@""
 *
 *  @param message 信息文本
 */
+ (void)showFaild:(NSString *)message;

/**
 *  显示INFO指示器
 *  如果不希望有文字，message填入nil或者@""
 *
 *  @param message 信息文本
 */
+ (void)showInfo:(NSString *)message;

/**
 *  显示指示器 自定义图片
 *  如果不希望有文字，message填入nil或者@""
 *
 *  @param message 信息文本
 */
+ (void)showInfo:(NSString *)message image:(UIImage *)image;

/**
 *  显示文字指示器
 *  如果不希望有文字，message填入nil或者@""
 *
 *  @param message 信息文本
 */
+ (void)showMessage:(NSString *)message;
/**
 *  撤去指示器
 */
+ (void)dismiss;

+ (void)configMessageColor:(UIColor *)color;

@end
