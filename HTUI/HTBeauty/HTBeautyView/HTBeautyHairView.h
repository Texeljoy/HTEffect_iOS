//
//  HTBeautyHairView.h
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/3/31.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    美发视图
 
 */
@interface HTBeautyHairView : UIView

@property (nonatomic, copy) void (^beautyHairBlock)(HTModel *model, NSString *key);

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
