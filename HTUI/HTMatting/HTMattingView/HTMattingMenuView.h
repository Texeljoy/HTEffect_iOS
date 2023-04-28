//
//  HTMattingMenuView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
    人像分割顶部视图
 
 */
@interface HTMattingMenuView : UIView

@property (nonatomic, copy) void (^mattingOnClickBlock)(NSArray *array,NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, strong) NSArray *listArr;

@end

NS_ASSUME_NONNULL_END
