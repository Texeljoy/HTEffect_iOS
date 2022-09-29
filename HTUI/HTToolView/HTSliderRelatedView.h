//
//  HTSliderRelatedView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import "HTSliderView.h"

@interface HTSliderRelatedView : UIView

// 自定义Slider
@property (nonatomic, strong) HTSliderView *sliderView;
// 美颜对比开关
@property (nonatomic, strong) UIButton *htContrastBtn;

- (void)setSliderHidden:(BOOL)hidden;

@end
