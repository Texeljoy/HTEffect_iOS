//
//  HTARItemMenuView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTARItemMenuView : UIView

@property (nonatomic, copy) void (^onClickBlock)(NSArray *array,NSInteger index,NSInteger selectedIndex);

@property (nonatomic, strong) NSArray *listArr;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@end

NS_ASSUME_NONNULL_END
