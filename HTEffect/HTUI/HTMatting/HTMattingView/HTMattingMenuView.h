//
//  HTMattingMenuView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMattingMenuView : UIView

@property (nonatomic, copy) void (^onClickBlock)(NSArray *array,NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, strong) NSArray *listArr;

@end

NS_ASSUME_NONNULL_END
