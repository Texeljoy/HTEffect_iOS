//
//  HTFilterStyleViewCell.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "HTButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTFilterStyleViewCell : UICollectionViewCell

@property (nonatomic, strong) HTButton *item;

- (void)setMaskViewColor:(UIColor *)color selected:(BOOL)selected;

- (void)setItemCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
