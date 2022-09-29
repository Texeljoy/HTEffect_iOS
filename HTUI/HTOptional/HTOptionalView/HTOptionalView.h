//
//  HTOptionalView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTOptionalView : UIView

@property (nonatomic, copy) void (^onClickBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
