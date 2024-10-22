//
//  HTMakeupMenuView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "HTMakeupSwitchView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 
    美颜顶部菜单视图
 
 */
@interface HTMakeupMenuView : UIView

@property (nonatomic, assign) bool disabled;
@property (nonatomic, copy) void (^onClickBlock)(NSArray *array);
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) UILabel *makeupTitleLabel;// 美妆标题用
@property (nonatomic, strong) HTMakeupSwitchView *switchView;//颜色切换视图

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr;

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
