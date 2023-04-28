//
//  HTMattingEffectView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
    人像分割 功能视图
 
 */
@interface HTMattingEffectView : UIView

//typedef NS_ENUM(NSInteger, EffectType) {
//    HT_AISegmentation = 0, // 人像分割
//    HT_Greenscreen = 1,// 绿幕抠图
//};

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, copy) void (^mattingDownladCompleteBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
