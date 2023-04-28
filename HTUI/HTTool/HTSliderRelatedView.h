//
//  HTSliderRelatedView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import "HTSliderView.h"

@interface HTSliderRelatedView : UIView

// 自定义Slider
@property (nonatomic, strong) HTSliderView *sliderView;

- (void)setSliderHidden:(BOOL)hidden;

@property (nonatomic, assign) BOOL isThemeWhite;

@end
