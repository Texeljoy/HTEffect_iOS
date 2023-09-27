//
//  HTFilterStyleViewCell.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>
@class HTModel;
NS_ASSUME_NONNULL_BEGIN

@interface HTFilterStyleViewCell : UICollectionViewCell

/**
 *  赋值
 */
- (void)setModel:(HTModel *)model isWhite:(BOOL)isWhite;

/**
 *  美妆空cell赋值
 */
- (void)setNoneImage:(BOOL)selected isThemeWhite:(BOOL)isWhite;

@end

NS_ASSUME_NONNULL_END
