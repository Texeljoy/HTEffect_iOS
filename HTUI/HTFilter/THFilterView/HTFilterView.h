//
//  HTFilterView.h
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/3/30.
//

#import <UIKit/UIKit.h>
#import "HTSliderRelatedView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    滤镜视图
 
 */
@interface HTFilterView : UIView

// 滑动条相关View
@property (nonatomic, strong ,readonly) HTSliderRelatedView *sliderRelatedView;
//@property (nonatomic, copy) void(^filterBackBlock)(void);

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
