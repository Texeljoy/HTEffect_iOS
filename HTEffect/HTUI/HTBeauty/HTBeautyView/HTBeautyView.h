//
//  HTBeautyView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"
#import "HTSliderRelatedView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTBeautyView : UIView

// 滑动条相关View
@property (nonatomic, strong) HTSliderRelatedView *sliderRelatedView;
@property (nonatomic, copy) void(^onClickBackBlock)(void);
@property (nonatomic, copy) void(^onClickCameraBlock)(void);

@end

NS_ASSUME_NONNULL_END
