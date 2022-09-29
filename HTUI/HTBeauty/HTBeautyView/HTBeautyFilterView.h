//
//  HTBeautyFilterView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTBeautyFilterView : UIView

@property (nonatomic, copy) void (^onUpdateSliderHiddenBlock)(HTModel *model, NSString *key);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@end

NS_ASSUME_NONNULL_END
