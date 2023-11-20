//
//  HTBeautyView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2023/03/30.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"
#import "HTSliderRelatedView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    美颜Base视图
 
 */
@interface HTBeautyView : UIView

// 滑动条相关View
@property (nonatomic, strong) HTSliderRelatedView *sliderRelatedView;

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
