//
//  HTSliderView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/22.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTSliderType) {
    HTSliderTypeI = 1,// 1~100
    HTSliderTypeII = 2// -50~50
};

@interface HTSliderView : UISlider

@property (nonatomic, copy) void (^refreshValueBlock)(CGFloat value);
@property (nonatomic, copy) void (^valueBlock)(CGFloat value);
@property (nonatomic, copy) void (^endDragBlock)(CGFloat value);

// 滑动对应进度的文字
@property (nonatomic, strong) UILabel *sliderLabel;
// 覆盖底层的上方滑动条
@property (nonatomic, strong) UIView *slideBar;
// 标记分割的点（用于第二种滑动条类型)
@property (nonatomic, strong) UIView *splitPoint;
// 调整标记view大小
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
// 设置滑动条类型&参数
- (void)setSliderType:(HTSliderType)sliderType WithValue:(float)value;

@end
