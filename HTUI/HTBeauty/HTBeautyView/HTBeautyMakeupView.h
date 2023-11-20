//
//  HTBeautyMakeupView.h
//  HTEffectDemo
//
//  Created by Eddie on 2023/9/11.
//

#import <UIKit/UIKit.h>
@class HTModel;

NS_ASSUME_NONNULL_BEGIN

/**
 *
 *  美妆视图
 *
 */

@interface HTBeautyMakeupView : UIView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;

/**
 * 通知外部弹出提示框
 */
@property (nonatomic, copy) void(^makeupShowAlertBlock)(void);

/**
 * 通知外部弹出拉条并设置效果特效
 */
@property (nonatomic, copy) void(^makeupDidSelectedBlock)(BOOL showTitle, NSString *_Nullable title, BOOL showSlider, HTModel *_Nullable model);

/**
 * 恢复按钮是否可以点击
 */
- (void)checkRestoreButton;

/**
 * 重置按钮导致的的恢复默认值
 */
- (void)restore;

/**
 *  恢复效果，用于外界妆容推荐取消后的效果恢复，UI不动
 */
- (void)restoreEffect;

@end

NS_ASSUME_NONNULL_END
