//
//  HTHairView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTHairView.h"
#import "HTTool.h"
#import "HTHairMenuView.h"
#import "HTUIConfig.h"
#import "HTUIManager.h"
#import "HTBtHairView.h"
#import "HTRestoreAlertView.h"


@interface HTHairView ()<HTRestoreAlertViewDelegate>

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;
// 当前选中的model
@property (nonatomic, strong) HTModel *currentModel;
@property (nonatomic, assign) HTDataCategoryType currentType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HTHairMenuView *menuView;
@property (nonatomic, assign) BOOL menuViewDisabled;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTBtHairView *hairView;

//@property (nonatomic, strong) HTModel *makeupModel;
// 重置按钮的状态
//@property (nonatomic, assign) BOOL needResetBeauty;
//@property (nonatomic, assign) BOOL needResetShape;
//@property (nonatomic, assign) BOOL needResetMakeup;

// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *hairArray; // 美发

@end

@implementation HTHairView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.hairArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTHair" ofType:@"json"] withKey:@"ht_hair"];
    if (self) {
        // 获取文件路径
//        stylePath = [[NSBundle mainBundle] pathForResource:@"HTStyleBeauty" ofType:@"json"];
        self.currentType = HT_HAIR_SLIDER;
        [self addSubview:self.sliderRelatedView];
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.currentModel.key]];
        [self.sliderRelatedView setHidden:YES];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(HTHeight(53));
        }];
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
        
        [self.containerView addSubview:self.hairView];
        [self.hairView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(77));
        }];
        
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-HTHeight(40));
        }];
        
        
    }
    return self;
    
}

//- (void)onBackClick:(UIButton *)button{
//    if (self.onClickBackBlock) {
//        self.onClickBackBlock();
//    }
//}


#pragma mark - 菜单点击
- (void)setOnClickMenu:(NSArray *)array{
    
    NSDictionary *dic = array[0];
    NSString *name = dic[@"name"];
    
    if ([name isEqualToString:[HTTool isCurrentLanguageChinese] ? @"美发" : @"Hair"]) {
        self.menuView.disabled = NO;
        [self.hairView setHidden:YES];
        
        //获取选中的位置
        int index = [HTTool getFloatValueForKey:HT_HAIR_SELECTED_POSITION];
        if (index == 0) {
            [self.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:100];
            [self.sliderRelatedView setHidden:YES];
        }else{
            HTModel *model = [[HTModel alloc] initWithDic:self.hairArray[index]];
            self.currentModel = model;
//                NSLog(@"======= %.2f ===== %@", [HTTool getFloatValueForKey:model.key], model.key);
            [self.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:[HTTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
        }
        self.currentType = HT_HAIR_SLIDER;
        [self.menuView.menuCollectionView reloadData];
        [self.hairView setHidden:NO];
        
    }
    
    
}

- (void)updateEffect:(int)value{
  /**  if (self.currentType == HT_MAKEUP_SLIDER) {
        // 设置美妆特效
        // TODO: 更换美妆新接口
//        [[HTEffect shareInstance] setMakeup:self.currentModel.idCard name:self.currentModel.name value:value];
        [[HTEffect shareInstance] setMakeup:self.currentModel.idCard property:@"name" value:self.currentModel.name];
        [[HTEffect shareInstance] setMakeup:self.currentModel.idCard property:@"value" value:[NSString stringWithFormat:@"%d", value]];
        
    }else if (self.currentType == HT_BODY_SLIDER) {
        // 设置美体特效
        [[HTEffect shareInstance] setBodyBeauty:self.currentModel.idCard value:value];
        
    }else {
        // 设置美颜 美发参数
        [HTTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
    } */
    if (self.currentType == HT_HAIR_SLIDER) {
        [HTTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
    }
}

- (void)saveParameters:(int)value{
    NSString *key = self.currentModel.key;
    [HTTool setFloatValue:value forKey:key];
    
    // 储存滑动条参数
//    NSLog(@"aaaaaaaaaaaa %d == %@", value, key);
//    [HTTool setFloatValue:value forKey:key];
}

#pragma mark - 弹框代理方法 HTRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        
        
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.currentModel.key]];
//        [self.sliderRelatedView setHidden:NO];
    }
}



#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
    self.hairView.isThemeWhite = isThemeWhite;
    self.sliderRelatedView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : HTColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : HTColors(255, 0.3);
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[
            
            @{
                @"name":[HTTool isCurrentLanguageChinese] ? @"美发" : @"Hair",
                @"classify":@[
                    @{
                        @"name":[HTTool isCurrentLanguageChinese] ? @"美发" : @"Hair",
                        @"value":self.hairArray
                    }
                ]
            }];
    }
    return _listArr;
}

- (HTSliderRelatedView *)sliderRelatedView{
    if (!_sliderRelatedView) {
        _sliderRelatedView = [[HTSliderRelatedView alloc] initWithFrame:CGRectZero];
        WeakSelf;
        // 更新效果
        [_sliderRelatedView.sliderView setRefreshValueBlock:^(CGFloat value) {
            [weakSelf updateEffect:value];
        }];
        // 写入缓存
        [_sliderRelatedView.sliderView setEndDragBlock:^(CGFloat value) {
            [weakSelf saveParameters:value];
        }];
        [_sliderRelatedView setHidden:YES];
    }
    return _sliderRelatedView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = HTColors(0, 0.7);
    }
    return _containerView;
}

- (HTHairMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTHairMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf
        [_menuView setOnClickBlock:^(NSArray *array) {
            [weakSelf setOnClickMenu:array];
        }];
        
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


- (HTBtHairView *)hairView{
    if (!_hairView) {
        _hairView = [[HTBtHairView alloc] initWithFrame:CGRectZero listArr:self.hairArray];
        WeakSelf
        _hairView.beautyHairBlock = ^(HTModel * _Nonnull model, NSString * _Nonnull key) {
            if (model.idCard == 0) {
                [weakSelf.sliderRelatedView setHidden:YES];
            }else{
                [weakSelf.sliderRelatedView setHidden:NO];
            }
            weakSelf.currentModel = model;
            [weakSelf.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:[HTTool getFloatValueForKey:key]];
        };
    }
    return _hairView;
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
