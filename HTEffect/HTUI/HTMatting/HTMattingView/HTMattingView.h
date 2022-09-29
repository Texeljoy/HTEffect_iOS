//
//  HTMattingView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMattingView : UIView

@property (nonatomic, copy) void (^onClickCameraBlock)(void);

@end

NS_ASSUME_NONNULL_END
