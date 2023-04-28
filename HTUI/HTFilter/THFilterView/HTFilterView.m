//
//  HTFilterView.m
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/3/30.
//

#import "HTFilterView.h"
#import "HTFilterMenuView.h"
#import "HTFilterEffectView.h"
#import "HTUIConfig.h"
#import "HTTool.h"

@interface HTFilterView ()

   

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;

//@property (nonatomic, strong ,readwrite) HTSliderRelatedView *sliderRelatedView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HTFilterMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) HTFilterEffectView *effectView;
//@property (nonatomic, strong) UIButton *backButton;
//@property (strong, nonatomic) UIButton *cameraBtn;

@property (nonatomic, assign) NSInteger menuIndex;
@property (nonatomic, strong) HTModel *currentModel;
  
@end


@implementation HTFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
     
//        [self addSubview:self.sliderRelatedView];
//        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self);
//            make.height.mas_equalTo(HTHeight(53));
//        }];
        
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
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(82));
        }];
 
//        [self.containerView addSubview:self.cameraBtn];
//        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.containerView).offset(-HTHeight(11)-[[HTAdapter shareInstance] getSaftAreaHeight]);
//            make.centerX.equalTo(self.containerView);
//            make.width.height.mas_equalTo(HTWidth(43));
//        }];
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

#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
    self.effectView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : HTColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : HTColors(255, 0.3);
}

//- (void)onBackClick:(UIButton *)button{
//    if (_filterBackBlock) {
//        _filterBackBlock();
//    }
//}

- (void)updateEffect:(int)value{
    // 设置美颜参数
    [[HTEffect shareInstance] setFilter:(int)self.menuIndex name:self.currentModel.name];
    
}
 

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 懒加载
- (NSArray *)listArr{
    _listArr = @[
        @{
            @"name":@"风格滤镜",
            @"classify":[HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_style_filter_config.json"] withKey:@"ht_style_filter"]
        },
        @{
            @"name":@"特效滤镜",
            @"classify":[HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_effect_filter_config.json"] withKey:@"ht_effect_filter"]
        },
        @{
            @"name":@"哈哈镜",
            @"classify":[HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_haha_filter_config.json"] withKey:@"ht_haha_filter"]
        }
      ];
    return _listArr;
}

# pragma mark - 懒加载
//- (HTSliderRelatedView *)sliderRelatedView{
//    if (!_sliderRelatedView) {
//        _sliderRelatedView = [[HTSliderRelatedView alloc] initWithFrame:CGRectZero];
//        [_sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:[HTTool getFloatValueForKey:HT_STYLE_FILTER_SLIDER]];
//        WeakSelf;
//        // 更新效果
//        [_sliderRelatedView.sliderView setRefreshValueBlock:^(CGFloat value) {
//            [weakSelf updateEffect:value];
//        }];
//        // 写入缓存
//        [_sliderRelatedView.sliderView setEndDragBlock:^(CGFloat value) {
////            [weakSelf saveParameters:value];
//
//            switch (weakSelf.menuIndex) {
//                case 0://风格
//                    [HTTool setFloatValue:value forKey:HT_STYLE_FILTER_SLIDER];
//                    break;
//                case 1://特效
//                    [HTTool setFloatValue:value forKey:HT_EFFECT_FILTER_SLIDER];
//                    break;
//                case 2://哈哈镜
//                    [HTTool setFloatValue:value forKey:HT_HAHA_FILTER_SLIDER];
//                    break;
//                default:
//                    break;
//            }
//
//        }];
//        [_sliderRelatedView setHidden:YES];
//    }
//    return _sliderRelatedView;
//}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HTColors(0, 0.7);
    }
    return _containerView;
}

- (HTFilterMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTFilterMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf;
        [_menuView setFilterItemMenuOnClickBlock:^(NSArray * _Nonnull array, NSInteger index) {
            NSDictionary *dic = @{@"data":array,@"type":@(index)};
            weakSelf.menuIndex = index;
            //刷新effect数据
            [weakSelf.effectView updateFilterListData:dic];
        }];
//        [_menuView setArItemMenuOnClickBlock:^(NSArray * _Nonnull array, NSInteger index, NSInteger selectedIndex) {
//            NSDictionary *dic = @{@"data":array,@"type":@(index),@"selected":@(selectedIndex)};
//            //刷新effect数据
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTARItemEffectView_UpDateListArray" object:dic];
//        }];
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

- (HTFilterEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[HTFilterEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_effectView setOnUpdateSliderHiddenBlock:^(HTModel * _Nonnull model,NSInteger index) {
            
            weakSelf.currentModel = model;
//            if(index == 0||self.menuIndex == 1||self.menuIndex == 2){
//                [weakSelf.sliderRelatedView setHidden:YES];
//            }else{
//                [weakSelf.sliderRelatedView setHidden:NO];
//            }
        }];
 
    }
    return _effectView;
}

//- (UIButton *)backButton{
//    if (!_backButton) {
//        _backButton = [[UIButton alloc] init];
//        [_backButton setImage:[UIImage imageNamed:@"ht_back.png"] forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(onBackClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backButton;
//}
 
 

 
//- (UIButton *)cameraBtn{
//    if (!_cameraBtn) {
//        _cameraBtn = [[UIButton alloc] init];
//        [_cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
//        [_cameraBtn addTarget:self action:@selector(onCameraClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _cameraBtn;
//}


@end
