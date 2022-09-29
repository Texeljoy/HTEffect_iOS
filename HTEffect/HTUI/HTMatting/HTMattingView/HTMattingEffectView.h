//
//  HTMattingEffectView.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMattingEffectView : UIView

typedef NS_ENUM(NSInteger, EffectType) {
    HT_AISegmentation = 0, // AI抠图
    HT_Greenscreen = 1,// 绿幕抠图
};

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, copy) void (^onClickEffectBlock)(NSInteger index, EffectType type);

@end

NS_ASSUME_NONNULL_END
