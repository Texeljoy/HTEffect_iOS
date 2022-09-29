//
//  HTARItemView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTARItemView : UIView

@property (nonatomic, copy) void (^onClickCameraBlock)(void);

@end

NS_ASSUME_NONNULL_END
