//
//  HTGestureEffectView.h
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/4/17.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTGestureEffectView : UIView

@property (nonatomic, copy) void(^didSelectedModelBlock)(HTModel *model,NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

/**
 * 外部点击menu选项后刷新CollectionView
 *
 * @param dic 数据
 */
- (void)updateGestureDataWithDict:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
