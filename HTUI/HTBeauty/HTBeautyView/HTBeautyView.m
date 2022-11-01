//
//  HTBeautyView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import "HTBeautyView.h"
#import "HTTool.h"
#import "HTBeautyMenuView.h"
#import "HTUIConfig.h"
#import "HTBeautyEffectView.h"
#import "HTBeautyFilterView.h"
#import "HTBeautyStyleView.h"
#import "HTUIManager.h"

@interface HTBeautyView ()

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;
// 当前选中的model
@property (nonatomic, strong) HTModel *currentModel;
@property (nonatomic, assign) HTDataCategoryType currentType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HTBeautyMenuView *menuView;
@property (nonatomic, assign) bool menuViewDisabled;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTBeautyEffectView *effectView;
@property (nonatomic, strong) HTBeautyFilterView *filterView;
@property (nonatomic, strong) HTBeautyStyleView *styleView;
// 重置功能View
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *maskContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *resetYesBtn;
@property (nonatomic, strong) UIButton *resetNoBtn;
// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

NSString *stylePath = @"";
NSArray *skinBeautyArray;
NSArray *faceBeautyArray;
NSArray *filterArray;

@implementation HTBeautyView

- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[
            @{
                @"name":NSLocalizedString(@"美肤",nil),
                @"classify":@[
                    @{
                        @"name":NSLocalizedString(@"美肤",nil),
                        @"value":skinBeautyArray
                    }
                ]
            },
            @{
                @"name":NSLocalizedString(@"美型",nil),
                @"classify":@[
                    @{
                        @"name":NSLocalizedString(@"美型",nil),
                        @"value":faceBeautyArray
                    }
                ]
            },
            @{
                @"name":NSLocalizedString(@"滤镜",nil),
                @"classify":@[
                    @{
                        @"name":NSLocalizedString(@"滤镜",nil),
                        @"value":filterArray
                    }
                ]
            },
            @{
                @"name":NSLocalizedString(@"风格推荐",nil),
                @"classify":@[
                    @{
                        @"name":NSLocalizedString(@"风格推荐",nil),
                        @"value":[HTTool jsonModeForPath:stylePath withKey:@"HTStyleBeauty"]
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

- (HTBeautyMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTBeautyMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
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

- (HTBeautyEffectView *)effectView{
    if (!_effectView) {
        _effectView = [[HTBeautyEffectView alloc] initWithFrame:CGRectZero listArr:skinBeautyArray];
        WeakSelf
        [_effectView setOnUpdateSliderHiddenBlock:^(HTModel * _Nonnull model) {
            [weakSelf.sliderRelatedView setHidden:NO];
            weakSelf.currentModel = model;
            [weakSelf.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
        }];
        [_effectView setOnClickResetBlock:^{
            [weakSelf.maskView setHidden:NO];
            [weakSelf.resetYesBtn setEnabled:YES];
            [weakSelf.resetNoBtn setEnabled:YES];
            [HTUIManager shareManager].exitEnable = NO;
        }];
    }
    return _effectView;
}

- (HTBeautyFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[HTBeautyFilterView alloc] initWithFrame:CGRectZero listArr:[filterArray mutableCopy]];
        _filterView.hidden = YES;
        WeakSelf
        [_filterView setOnUpdateSliderHiddenBlock:^(HTModel * _Nonnull model, NSString * _Nonnull key) {
            if ([model.title isEqual: @"原图"]) {
                [weakSelf.sliderRelatedView setHidden:YES];
            }else{
                [weakSelf.sliderRelatedView setHidden:NO];
            }
            weakSelf.currentModel = model;
            [weakSelf.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:[HTTool getFloatValueForKey:key]];
        }];
    }
    return _filterView;
}

- (HTBeautyStyleView *)styleView{
    if (!_styleView) {
        _styleView = [[HTBeautyStyleView alloc] initWithFrame:CGRectZero listArr:[HTTool jsonModeForPath:stylePath withKey:@"HTStyleBeauty"]];
        _styleView.hidden = YES;
        WeakSelf
        [_styleView setOnClickBlock:^(NSInteger index) {
            if (index > 0) {
                // 禁用美肤、美型和滤镜的点击事件
                weakSelf.menuViewDisabled = YES;
            }else{
                weakSelf.menuViewDisabled = NO;
            }
        }];
    }
    return _styleView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"ht_back.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onBackClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        [_cameraBtn setTag:1];
        [_cameraBtn setImage:[UIImage imageNamed:@"ht_camera.png"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(onCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = HTColors(0, 0.6);
        [_maskView setHidden:true];
    }
    return _maskView;
}

- (UIView *)maskContainerView{
    if (!_maskContainerView) {
        _maskContainerView = [[UIView alloc] init];
        _maskContainerView.layer.cornerRadius = 5;
        _maskContainerView.backgroundColor = UIColor.whiteColor;
    }
    return _maskContainerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"是否将所有参数恢复到默认值?",nil);
        _titleLabel.font = HTFontMedium(13);
        _titleLabel.textColor = HTColor(67, 51, 65, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)confirmLabel{
    if (!_confirmLabel) {
        _confirmLabel = [[UILabel alloc] init];
        _confirmLabel.text = NSLocalizedString(@"请先关闭风格推荐",nil);
        _confirmLabel.font = HTFontMedium(15);
        _confirmLabel.textColor = UIColor.whiteColor;
        _confirmLabel.textAlignment = NSTextAlignmentCenter;
        [_confirmLabel setHidden:YES];
    }
    return _confirmLabel;
}

- (UIButton *)resetYesBtn{
    if (!_resetYesBtn) {
        _resetYesBtn = [[UIButton alloc] init];
        [_resetYesBtn setBackgroundImage:[UIImage imageNamed:@"resetYesBG.png"] forState:UIControlStateNormal];
        [_resetYesBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
        [_resetYesBtn setTitleColor: UIColor.whiteColor forState:UIControlStateNormal];
        [_resetYesBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_resetYesBtn.titleLabel setFont:HTFontMedium(12)];
        /* === 确认重置 === */
        [_resetYesBtn setEnabled:NO];
        [_resetYesBtn addTarget:self action:@selector(onResetYesClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetYesBtn;
}

- (UIButton *)resetNoBtn{
    if (!_resetNoBtn) {
        _resetNoBtn = [[UIButton alloc] init];
        [_resetNoBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_resetNoBtn setTitleColor:HTColor(88, 157, 236, 1.0) forState:UIControlStateNormal];
        [_resetNoBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_resetNoBtn.titleLabel setFont:HTFontMedium(12)];
        /* === 取消重置 === */
        [_resetNoBtn setEnabled:NO];
        [_resetNoBtn addTarget:self action:@selector(onResetNoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetNoBtn;
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    skinBeautyArray = [HTTool jsonModeForPath:HTSkinBeautyPath withKey:@"HTSkinBeauty"];
    faceBeautyArray = [HTTool jsonModeForPath:HTFaceBeautyPath withKey:@"HTFaceBeauty"];
    filterArray = [HTTool jsonModeForPath:HTFilterPath withKey:@"ht_filter"];
    if (self) {
        // 获取文件路径
        stylePath = [[NSBundle mainBundle] pathForResource:@"HTStyleBeauty" ofType:@"json"];
        self.currentType = HT_SKIN_SLIDER;
        self.currentModel = [[HTModel alloc] initWithDic:skinBeautyArray[0]];
        [self addSubview:self.sliderRelatedView];
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.currentModel.key]];
        [self.sliderRelatedView setHidden:NO];
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
        [self.containerView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(82));
        }];
        [self.containerView addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(77));
        }];
        [self.containerView addSubview:self.styleView];
        [self.styleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.filterView);
            make.height.mas_equalTo(HTHeight(69));
        }];
        [self.containerView addSubview:self.cameraBtn];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.containerView).offset(-HTHeight(11)-[[HTAdapter shareInstance] getSaftAreaHeight]);
            make.centerX.equalTo(self.containerView);
            make.width.height.mas_equalTo(HTWidth(43));
        }];
        [self.containerView addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(HTWidth(20));
            make.centerY.equalTo(self.cameraBtn);
            make.width.mas_equalTo(HTWidth(15));
            make.height.mas_equalTo(HTHeight(8));
        }];
        [self addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(self.frame.size.height-HTScreenHeight);
        }];
        [self.maskView addSubview:self.maskContainerView];
        [self.maskContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.maskView);
            make.width.mas_equalTo(HTWidth(235));
            make.height.mas_equalTo(HTWidth(145));
        }];
        [self.maskContainerView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.maskContainerView);
            make.top.equalTo(self.maskContainerView).offset(HTHeight(24));
        }];
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-HTHeight(40));
        }];
        [self.maskContainerView addSubview:self.resetYesBtn];
        [self.resetYesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.maskContainerView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(HTHeight(25));
            make.width.mas_equalTo(HTWidth(155));
            make.height.mas_equalTo(HTHeight(35));
        }];
        [self.maskContainerView addSubview:self.resetNoBtn];
        [self.resetNoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.height.equalTo(self.resetYesBtn);
            make.top.equalTo(self.resetYesBtn.mas_bottom).offset(HTHeight(7));
        }];
        // 注册通知——》是否需要跳转至滤镜功能
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchFilter:) name:@"NotificationName_HTBeautyView_SwitchFilter" object:nil];
    }
    return self;
    
}

- (void)toastFinished{
    [self.confirmLabel setHidden:YES];
    [HTUIManager shareManager].exitEnable = YES;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)onBackClick:(UIButton *)button{
    if (self.onClickBackBlock) {
        self.onClickBackBlock();
    }
}

- (void)onCameraClick:(UIButton *)button{
    if (self.onClickCameraBlock) {
        self.onClickCameraBlock();
    }
}

- (void)setOnClickMenu:(NSArray *)array{
    if (self.menuViewDisabled) {
        // 弹出提示框
        if(![HTUIManager shareManager].exitEnable){
        }else{
            self.menuView.disabled = YES;
            [self.confirmLabel setHidden:NO];
            [HTUIManager shareManager].exitEnable = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(toastFinished) userInfo:nil repeats:NO];
        }
    }else{
        self.menuView.disabled = NO;
        NSDictionary *dic = array[0];
        [self.filterView setHidden:YES];
        [self.effectView setHidden:YES];
        [self.styleView setHidden:YES];
        if ([dic[@"name"] isEqual:NSLocalizedString(@"美肤",nil)]) {
            //默认选择第一个
            HTModel *model = [[HTModel alloc] initWithDic:skinBeautyArray[0]];
            self.currentModel = model;
            [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(0)};
            self.currentType = HT_SKIN_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTBeautyEffectView_UpDateListArray" object:newDic];
            [self.effectView setHidden:NO];
        }else if ([dic[@"name"] isEqual:NSLocalizedString(@"美型",nil)]){
            HTModel *model = [[HTModel alloc] initWithDic:faceBeautyArray[0]];
            self.currentModel = model;
            [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(1)};
            self.currentType = HT_RESHAPE_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTBeautyEffectView_UpDateListArray" object:newDic];
            [self.effectView setHidden:NO];
        }else if ([dic[@"name"] isEqual:NSLocalizedString(@"滤镜",nil)]) {
            //获取选中的位置
            int index = [HTTool getFloatValueForKey:@"HT_FILTER_SELECTED_POSITION"];
            if (index == 0) {
                [self.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:100];
                [self.sliderRelatedView setHidden:YES];
            }else{
                HTModel *model = [[HTModel alloc] initWithDic:filterArray[index]];
                self.currentModel = model;
                NSString *key = [@"HT_FILTER_SLIDER" stringByAppendingFormat:@"%d",index];
                [self.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:[HTTool getFloatValueForKey:key]];
                [self.sliderRelatedView setHidden:NO];
            }
            self.currentType = HT_FILTER_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            [self.filterView setHidden:NO];
        }else{
            [self.sliderRelatedView setHidden:YES];
            [self.styleView setHidden:NO];
        }
    }
    
}

- (void)onResetYesClick:(UIButton *)button{
    [self.effectView clickResetSuccess];
    if (self.currentType == HT_SKIN_SLIDER) {
        self.currentModel = [[HTModel alloc] initWithDic:skinBeautyArray[0]];
    }else if (self.currentType == HT_RESHAPE_SLIDER) {
        self.currentModel = [[HTModel alloc] initWithDic:faceBeautyArray[0]];
    }
    [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.currentModel.key]];
    [self.sliderRelatedView setHidden:NO];
    [self.maskView setHidden:true];
    [HTUIManager shareManager].exitEnable = YES;
    [self.effectView updateResetButtonState:UIControlStateDisabled];
    [self.resetYesBtn setEnabled:NO];
    [self.resetNoBtn setEnabled:NO];
}

- (void)onResetNoClick:(UIButton *)button{
    [self.maskView setHidden:true];
    [HTUIManager shareManager].exitEnable = YES;
    [self.resetYesBtn setEnabled:NO];
    [self.resetNoBtn setEnabled:NO];
}

- (void)updateEffect:(int)value{
    // 设置美颜参数
    [HTTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
}

- (void)saveParameters:(int)value{
    NSString *key = self.currentModel.key;
    if (self.currentType == HT_FILTER_SLIDER) {
        for (int i = 0; i < filterArray.count; i++) {
            HTModel *model = [[HTModel alloc] initWithDic:filterArray[i]];
            if ([model.title isEqual: self.currentModel.title]) {
                key = [@"HT_FILTER_SLIDER" stringByAppendingFormat:@"%d",i];
                break;
            }
        }
    }else{
        if (value != self.currentModel.defaultValue) {
            [self.effectView updateResetButtonState:UIControlStateNormal];
        }
    }
    // 储存滑动条参数
    [HTTool setFloatValue:value forKey:key];
    if([key isEqual: @"HT_SKIN_FINEBLURRINESS_SLIDER"] && value > 0){
        [HTTool setFloatValue:0 forKey:@"HT_SKIN_HAZYBLURRINESS_SLIDER"];
    }
    if([key isEqual: @"HT_SKIN_HAZYBLURRINESS_SLIDER"] && value > 0){
        [HTTool setFloatValue:0 forKey:@"HT_SKIN_FINEBLURRINESS_SLIDER"];
    }
}

- (void)switchFilter:(NSNotification *)notification{
    
    if([notification.object boolValue]){
        NSArray *array = @[
            @{
                @"name":NSLocalizedString(@"滤镜",nil),
                @"value":filterArray
            }
        ];
        [self setOnClickMenu:array];
    }else{
        NSArray *array = @[
            @{
                @"name":NSLocalizedString(@"美肤",nil),
                @"value":skinBeautyArray
            }
        ];
        [self setOnClickMenu:array];
    }
    
}

// 让超出父控件的方法触发响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        // 转换坐标系
        CGPoint resetYesBtn = [self.resetYesBtn convertPoint:point fromView:self];
        CGPoint resetNoBtn = [self.resetNoBtn convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.resetYesBtn.bounds, resetYesBtn)) {
            view = self.resetYesBtn;
        }
        if (CGRectContainsPoint(self.resetNoBtn.bounds, resetNoBtn)) {
            view = self.resetNoBtn;
        }
    }
    return view;
}

@end
