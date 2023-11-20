//
//  HTARItemEffectView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 
    AR道具功能视图
 
 */
@interface HTARItemEffectView : UIView


- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, copy) void (^arDownladCompleteBlock)(NSInteger index);


/**
 * 清除特效
 */
-(void)clean;

/**
 * 外部点击menu选项后刷新CollectionView
 *
 * @param dic 数据
 */
- (void)updateDataWithDict:(NSDictionary *)dic;

@end



NS_ASSUME_NONNULL_END
