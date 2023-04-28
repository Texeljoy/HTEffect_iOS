//
//  HTARItemMenuView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 
  AR道具标题视图
 
 */

@interface HTARItemMenuView : UIView

@property (nonatomic, copy) void (^arItemMenuOnClickBlock)(NSArray *array, NSInteger index);

@property (nonatomic, strong) NSArray *listArr;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@end

NS_ASSUME_NONNULL_END
