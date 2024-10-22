//
//  HTMakeupStyleView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    妆容推荐(风格) 功能视图
 
 */
@interface HTMakeupStyleView : UIView

/**
 *  风格推荐选中的通知
 */
@property (nonatomic, copy) void (^styleDidSelectedBlock)(BOOL showSlider, HTModel * _Nullable model);

/**
 *  风格推荐选中取消的通知
 */
@property (nonatomic, copy) void (^styleClosedBlock)(void);


// 外部menu点击后刷新
- (void)updateStyleListData;

/**
 *  拉条实现特效
 */
- (void)updateEffectWithValue:(int)value;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
