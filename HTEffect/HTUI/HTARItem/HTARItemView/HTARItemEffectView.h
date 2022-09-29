//
//  HTARItemEffectView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTARItemEffectView : UIView

typedef NS_ENUM(NSInteger, EffectType) {
    HT_Sticker = 0, // 贴纸
    HT_WaterMark = 1,// 水印
};

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, copy) void (^onClickEffectBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
