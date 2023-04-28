//
//  HTFilterMenuView.h
//  HTEffectDemo
//
//  Created by Eddie on 2023/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTFilterMenuView : UIView

@property (nonatomic, copy) void (^filterItemMenuOnClickBlock)(NSArray *array,NSInteger index);

@property (nonatomic, strong) NSArray *listArr;

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
