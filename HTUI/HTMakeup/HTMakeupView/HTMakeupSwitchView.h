//
//  HTMakeupSwitchView.h
//  HTEffectDemo
//
//  Created by Eddie on 2024/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 
    美妆的颜色选择视图
 
 */

@interface HTMakeupSwitchView : UIView

/**
 *  更新UI
 */
- (void)updateWithIndex:(NSInteger)index;

@property (nonatomic, assign) BOOL isThemeWhite;

@end


@interface HTMakeupSwitchViewCell : UICollectionViewCell

-(void)setColor:(UIColor *)color sel:(BOOL)sel borderColor:(UIColor *)borderColor;

@end


NS_ASSUME_NONNULL_END
