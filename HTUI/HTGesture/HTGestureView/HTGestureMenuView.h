//
//  HTGestureMenuView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2023/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
    手势特效菜单视图
 
 */
@interface HTGestureMenuView : UIView

/**
 * 点击时通知外部
 */
@property (nonatomic, copy) void (^gestureMenuBlock)(NSArray *array,NSInteger index);

@property (nonatomic, strong) NSArray *listArr;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@end

NS_ASSUME_NONNULL_END
