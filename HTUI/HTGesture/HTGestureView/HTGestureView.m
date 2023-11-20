//
//  HTGestureView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/9/13.
//

#import "HTGestureView.h"
#import "HTGestureEffectView.h"
#import "HTGestureMenuView.h"
#import "HTTool.h"


@interface HTGestureView ()

@property (nonatomic, strong) NSArray *listArr;// 手势部分全部数据
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HTGestureMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) HTGestureEffectView *effectView;
//@property (nonatomic, strong) UIButton *backButton;

@end

NSString *gesturePath = @"";
static NSString *const HTGestureViewCellId = @"HTGestureViewCellId";

@implementation HTGestureView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(HTHeight(258));
        }];
        [self.containerView addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(45));
        }];
        [self.containerView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.containerView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(0));
            make.left.right.bottom.equalTo(self.containerView);
        }];
//
//        [self.containerView addSubview:self.backButton];
//        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.containerView).offset(HTWidth(20));
//            make.bottom.equalTo(self.containerView).offset(-HTHeight(11)-[[HTAdapter shareInstance] getSaftAreaHeight]);
//            make.width.mas_equalTo(HTWidth(15));
//            make.height.mas_equalTo(HTHeight(8));
//        }];
    }
    return self;
    
}

//#pragma mark - 返回按钮点击
//- (void)backButtonClick {
//    if (_gestureBackBlock) {
//        _gestureBackBlock();
//    }
//}

#pragma mark - 懒加载
- (NSArray *)listArr{
    _listArr = @[
        @{
            @"name":@"手势特效",
            @"classify":[HTTool jsonModeForPath:[[[HTEffect shareInstance] getGestureEffectPath] stringByAppendingFormat:@"ht_gesture_effect_config.json"] withKey:@"ht_gesture_effect"]
        }
      ];
    return _listArr;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HTColors(0, 0.7);
    }
    return _containerView;
}

- (HTGestureMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTGestureMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf;
        _menuView.gestureMenuBlock = ^(NSArray * _Nonnull array, NSInteger index) {
            NSDictionary *dic = @{@"data":array,@"type":@(index)};
//            weakSelf.menuIndex = index;
            //刷新effect数据
            [weakSelf.effectView updateGestureDataWithDict:dic];
        };
    }
    return _menuView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HTColors(255, 0.3);
    }
    return _lineView;
}

- (HTGestureEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[HTGestureEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
//        WeakSelf;
        _effectView.didSelectedModelBlock = ^(HTModel * _Nonnull model, NSInteger index) {
            
//            weakSelf.currentModel = model;
        };
 
    }
    return _effectView;
}

//- (UIButton *)backButton{
//    if (!_backButton) {
//        _backButton = [[UIButton alloc] init];
//        [_backButton setImage:[UIImage imageNamed:@"ht_back.png"] forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backButton;
//}

@end

