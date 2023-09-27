//
//  HTBeautyEffectViewCell.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import <UIKit/UIKit.h>
#import "HTButton.h"
@class HTModel;
NS_ASSUME_NONNULL_BEGIN

@interface HTBeautyEffectViewCell : UICollectionViewCell

@property (nonatomic, strong) HTButton *item;
@property (nonatomic, strong) UIView *pointView;

//@property (nonatomic, strong) HTModel *bodyModel;//美体
- (void)setBodyModel:(HTModel *)model themeWhite:(BOOL)white;

@end

NS_ASSUME_NONNULL_END
