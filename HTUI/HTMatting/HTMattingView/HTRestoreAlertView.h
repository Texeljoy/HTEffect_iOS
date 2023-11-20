//
//  HTRestoreAlertView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2023/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
    恢复默认值的弹框视图
 
 */
@protocol HTRestoreAlertViewDelegate <NSObject>

@optional
-(void)alertViewDidSelectedStatus:(BOOL)status;//NO=取消，YES=确认

@end

@interface HTRestoreAlertView : UIView

/**
 * 类方法初始化
 *
 * @param delegate 设置代理
 */
+ (void)showWithTitle:(NSString *)title delegate:(id<HTRestoreAlertViewDelegate>)delegate;

/**
 * 隐藏，实际是从父类移除
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
