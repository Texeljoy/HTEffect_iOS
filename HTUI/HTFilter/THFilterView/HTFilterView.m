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
// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;

@property (nonatomic, assign) NSInteger menuIndex;
@property (nonatomic, strong) HTModel *currentModel;
  
@end


@implementation HTFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
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
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(82));
        }];
        
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-HTHeight(40));
        }];
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
            @"name":[HTTool isCurrentLanguageChinese] ? @"风格滤镜" : @"Style",
            @"classify":[HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_style_filter_config.json"] withKey:@"ht_style_filter"]
        },
        @{
            @"name":[HTTool isCurrentLanguageChinese] ? @"特效滤镜" : @"Special",
            @"classify":[HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_effect_filter_config.json"] withKey:@"ht_effect_filter"]
        },
        @{
            @"name":[HTTool isCurrentLanguageChinese] ? @"哈哈镜" : @"Distorting",
            @"classify":[HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_haha_filter_config.json"] withKey:@"ht_haha_filter"]
        }
      ];
    return _listArr;
}

# pragma mark - 懒加载
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
        }];
        
        // 弹框
        _effectView.filterTipBlock = ^{
            if (weakSelf.confirmLabel.hidden) {
                weakSelf.confirmLabel.hidden = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.confirmLabel.hidden = YES;
                });
            }
        };
 
    }
    return _effectView;
}

- (UILabel *)confirmLabel{
    if (!_confirmLabel) {
        _confirmLabel = [[UILabel alloc] init];
        _confirmLabel.text = [HTTool isCurrentLanguageChinese] ? @"请先关闭妆容推荐" : @"Please turn off MakeupStyle first";
        _confirmLabel.font = HTFontMedium(15);
        _confirmLabel.textColor = UIColor.whiteColor;
        _confirmLabel.textAlignment = NSTextAlignmentCenter;
        [_confirmLabel setHidden:YES];
    }
    return _confirmLabel;
}


@end
