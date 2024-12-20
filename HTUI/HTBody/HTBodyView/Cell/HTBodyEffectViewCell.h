//
//  HTBodyEffectViewCell.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import <UIKit/UIKit.h>
#import "HTButton.h"
@class HTModel;
NS_ASSUME_NONNULL_BEGIN

@interface HTBodyEffectViewCell : UICollectionViewCell

@property (nonatomic, strong) HTButton *item;
@property (nonatomic, strong) UIView *pointView;

// 美颜美型赋值
- (void)setSkinShapeModel:(HTModel *)model themeWhite:(BOOL)white;

// 美体赋值
- (void)setBodyModel:(HTModel *)model themeWhite:(BOOL)white;

@end

NS_ASSUME_NONNULL_END
