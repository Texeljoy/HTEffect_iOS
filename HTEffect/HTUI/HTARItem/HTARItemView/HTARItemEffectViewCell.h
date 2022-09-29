//
//  HTARItemEffectViewCell.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTARItemEffectViewCell : UICollectionViewCell

- (void)setHtImage:(UIImage *)image isCancelEffect:(BOOL)isCancelEffect;
- (void)startAnimation;
- (void)endAnimation;
- (void)setSelectedBorderHidden:(BOOL)hidden borderColor:(UIColor *)color;
- (void)hiddenDownloaded:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
