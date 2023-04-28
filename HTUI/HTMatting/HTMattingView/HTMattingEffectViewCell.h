//
//  HTMattingEffectViewCell.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMattingEffectViewCell : UICollectionViewCell

@property (nonatomic, strong,readonly) UIImageView *htImageView;
- (void)setHtImage:(UIImage *_Nullable)image isCancelEffect:(BOOL)isCancelEffect;
- (void)startAnimation;
- (void)endAnimation;
- (void)setSelectedBorderHidden:(BOOL)hidden borderColor:(UIColor *)color;
- (void)hiddenDownloaded:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
