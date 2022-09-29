//
//  HTGestureView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTGestureView : UIView

@property (nonatomic, copy) void (^onClickCameraBlock)(void);

@end

NS_ASSUME_NONNULL_END
