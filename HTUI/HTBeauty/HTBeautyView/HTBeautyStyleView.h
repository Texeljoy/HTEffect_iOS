//
//  HTBeautyStyleView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    风格 功能视图
 
 */
@interface HTBeautyStyleView : UIView

@property (nonatomic, copy) void (^onClickBlock)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@end

NS_ASSUME_NONNULL_END
