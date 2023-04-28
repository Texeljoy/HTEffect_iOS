//
//  HTAdapter.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIkit/UIkit.h>

// 获取屏幕宽高
#define HTScreenWidth  [UIScreen mainScreen].bounds.size.width
#define HTScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface HTAdapter : NSObject

+ (HTAdapter *)shareInstance;
/**
 * 适配left
 * @param left UI元素适配前left位置值
 */
- (CGFloat)getAfterAdaptionLeft:(CGFloat)left;
/**
 * 适配top
 * @param top UI元素适配前top位置值
 */
- (CGFloat)getAfterAdaptionTop:(CGFloat)top;
/**
 * 适配width
 * @param width UI元素适配前width值
 */
- (CGFloat)getAfterAdaptionWidth:(CGFloat)width;
/**
 * 适配height
 * @param height UI元素适配前height值
 */
- (CGFloat)getAfterAdaptionHeight:(CGFloat)height;
/**
 * 适配statusBarHeight
 * @return 返回适配后状态栏高度
 */
- (CGFloat)getStatusBarHeight;
/**
 * 适配saftAreaHeight
 * @return 返回安全距离高度
 */
- (CGFloat)getSaftAreaHeight;

@end
