//
//  HTBeautyEffectView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/19.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTBeautyEffectView : UIView

@property (nonatomic,copy) void (^onClickResetBlock)(void);
@property (nonatomic,copy) void (^onUpdateSliderHiddenBlock)(HTModel *model);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;
- (void)updateResetButtonState:(UIControlState)state;
- (void)clickResetSuccess;

@end

NS_ASSUME_NONNULL_END
