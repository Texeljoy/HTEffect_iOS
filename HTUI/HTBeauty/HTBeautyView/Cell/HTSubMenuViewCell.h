//
//  HTSubMenuViewCell.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSubMenuViewCell : UICollectionViewCell

- (void)setTitle:(NSString *)title selected:(BOOL)selected textColor:(UIColor *)color;
- (void)setLineHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
