//
//  HTMakeupCollectionViewCell.h
//  HTEffectDemo
//
//  Created by Eddie on 2023/9/11.
//

#import <UIKit/UIKit.h>
@class HTModel;
NS_ASSUME_NONNULL_BEGIN
/**
 *
 *  美妆Cell
 *
 */

@interface HTMakeupCollectionViewCell : UICollectionViewCell

- (void)setModel:(HTModel *)model type:(NSInteger)type isThemeWhite:(BOOL)isWhite;

- (void)setNoneImage:(BOOL)selected isThemeWhite:(BOOL)isWhite;

@end

NS_ASSUME_NONNULL_END
