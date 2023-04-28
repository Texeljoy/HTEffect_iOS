//
//  HTFilterHahaViewCell.h
//  HTEffectDemo
//
//  Created by Eddie on 2023/4/6.
//

#import <UIKit/UIKit.h>
#import "HTButton.h"
#import "HTModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTFilterHahaViewCell : UICollectionViewCell

@property (nonatomic, strong) HTButton *item;
//@property (nonatomic, strong) HTModel *model;
@property (nonatomic, assign) BOOL sel;

// 赋值
-(void)setModel:(HTModel *)model theme:(BOOL)white;

@end

NS_ASSUME_NONNULL_END
