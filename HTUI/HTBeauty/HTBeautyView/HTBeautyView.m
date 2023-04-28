//
//  HTBeautyView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTBeautyView.h"
#import "HTTool.h"
#import "HTBeautyMenuView.h"
#import "HTUIConfig.h"
#import "HTBeautyEffectView.h"
#import "HTBeautyStyleView.h"
#import "HTUIManager.h"
#import "HTBeautyHairView.h"
#import "HTRestoreAlertView.h"

@interface HTBeautyView ()<HTRestoreAlertViewDelegate>

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;
// 当前选中的model
@property (nonatomic, strong) HTModel *currentModel;
@property (nonatomic, assign) HTDataCategoryType currentType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HTBeautyMenuView *menuView;
@property (nonatomic, assign) BOOL menuViewDisabled;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTBeautyEffectView *effectView;
@property (nonatomic, strong) HTBeautyHairView *hairView;
@property (nonatomic, strong) HTBeautyStyleView *styleView;
// 重置按钮的状态
@property (nonatomic, assign) BOOL needResetBeauty;
@property (nonatomic, assign) BOOL needResetShape;
// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

@end

//NSString *stylePath = @"";
NSArray *styleArray;
NSArray *skinBeautyArray;
NSArray *faceBeautyArray;
NSArray *hairArray;

@implementation HTBeautyView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    styleArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTStyleBeauty" ofType:@"json"] withKey:@"HTStyleBeauty"];
    skinBeautyArray = [HTTool jsonModeForPath:HTSkinBeautyPath withKey:@"HTSkinBeauty"];
    faceBeautyArray = [HTTool jsonModeForPath:HTFaceBeautyPath withKey:@"HTFaceBeauty"];
    hairArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTHair" ofType:@"json"] withKey:@"ht_hair"];
    
    if (self) {
        // 获取文件路径
//        stylePath = [[NSBundle mainBundle] pathForResource:@"HTStyleBeauty" ofType:@"json"];
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
        [self.containerView addSubview:self.hairView];
        [self.hairView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(77));
        }];
        [self.containerView addSubview:self.styleView];
        [self.styleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.hairView);
            make.height.mas_equalTo(HTHeight(69));
        }];
//        [self.containerView addSubview:self.backButton];
//        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.containerView).offset(HTWidth(20));
//            make.bottom.equalTo(self.containerView).offset(-HTHeight(44)-[[HTAdapter shareInstance] getSaftAreaHeight]);
//            make.width.mas_equalTo(HTWidth(15));
//            make.height.mas_equalTo(HTHeight(8));
//        }];
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-HTHeight(40));
        }];
        
        [self checkResetButton];
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
    
    if ([name isEqualToString:@"美发"]) {
        self.menuView.disabled = NO;
        [self.hairView setHidden:YES];
        [self.effectView setHidden:YES];
        [self.styleView setHidden:YES];
        
        //获取选中的位置
        int index = [HTTool getFloatValueForKey:HT_HAIR_SELECTED_POSITION];
        if (index == 0) {
            [self.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:100];
            [self.sliderRelatedView setHidden:YES];
        }else{
            HTModel *model = [[HTModel alloc] initWithDic:hairArray[index]];
            self.currentModel = model;
//                NSLog(@"======= %.2f ===== %@", [HTTool getFloatValueForKey:model.key], model.key);
            [self.sliderRelatedView.sliderView setSliderType:HTSliderTypeI WithValue:[HTTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
        }
        self.currentType = HT_HAIR_SLIDER;
        [self.menuView.menuCollectionView reloadData];
        [self.hairView setHidden:NO];
        
    }else if ([name isEqualToString:@"风格"]) {
        
        self.menuView.disabled = NO;
//        NSDictionary *dic = array[0];
        [self.hairView setHidden:YES];
        [self.effectView setHidden:YES];
//        [self.styleView setHidden:YES];
        
        [self.sliderRelatedView setHidden:YES];
        [self.styleView setHidden:NO];
        
    }else {
        
        if (self.menuViewDisabled) {
            // 弹出提示框
            if(![HTUIManager shareManager].exitEnable){
            }else{
                self.menuView.disabled = YES;
                [self.confirmLabel setHidden:NO];
                [HTUIManager shareManager].exitEnable = NO;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.confirmLabel setHidden:YES];
                    [HTUIManager shareManager].exitEnable = YES;
                });
            }
        }else{
            self.menuView.disabled = NO;
            //        NSDictionary *dic = array[0];
            [self.hairView setHidden:YES];
            [self.effectView setHidden:YES];
            [self.styleView setHidden:YES];
            if ([name isEqualToString:@"美颜"]) {
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
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTBeautyEffectView_UpDateListArray" object:newDic];
                [self.effectView updateBeautyAndShapeEffectData:newDic];
                [self.effectView setHidden:NO];
                [self.effectView updateResetButtonState:self.needResetBeauty];
            }else if ([name isEqualToString:@"美型"]){
                HTModel *model = [[HTModel alloc] initWithDic:faceBeautyArray[0]];
                self.currentModel = model;
                [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
                [self.sliderRelatedView setHidden:NO];
                NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(1)};
                self.currentType = HT_RESHAPE_SLIDER;
                self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.menuView.menuCollectionView reloadData];
                //刷新effect数据
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTBeautyEffectView_UpDateListArray" object:newDic];
                [self.effectView updateBeautyAndShapeEffectData:newDic];
                [self.effectView setHidden:NO];
                [self.effectView updateResetButtonState:self.needResetShape];
            }
        }
    }
    
    
}

- (void)updateEffect:(int)value{
    // 设置美颜参数
    [HTTool setBeautySlider:value forType:self.currentType withSelectMode:self.currentModel];
}

- (void)saveParameters:(int)value{
    NSString *key = self.currentModel.key;
//    if (self.currentType == HT_FILTER_SLIDER) {
//        for (int i = 0; i < hairArray.count; i++) {
//            HTModel *model = [[HTModel alloc] initWithDic:hairArray[i]];
//            if ([model.title isEqual: self.currentModel.title]) {
//                key = [@"HT_FILTER_SLIDER" stringByAppendingFormat:@"%d",i];
//                break;
//            }
//        }
//    }else{
//        if (value != self.currentModel.defaultValue) {
//            [self.effectView updateResetButtonState:UIControlStateNormal];
//        }
//    }
    if (value != self.currentModel.defaultValue) {
        if (self.currentType == HT_SKIN_SLIDER) {
            self.needResetBeauty = YES;
            [self.effectView updateResetButtonState:self.needResetBeauty];
        }else {
            self.needResetShape = YES;
            [self.effectView updateResetButtonState:self.needResetShape];
        }
    }
    // 储存滑动条参数
//    NSLog(@"========== %d == %@", value, key);
    [HTTool setFloatValue:value forKey:key];
    if([key isEqualToString:@"HT_SKIN_FINEBLURRINESS_SLIDER"] && value > 0){
        [HTTool setFloatValue:0 forKey:@"HT_SKIN_HAZYBLURRINESS_SLIDER"];
    }
    if([key isEqualToString:@"HT_SKIN_HAZYBLURRINESS_SLIDER"] && value > 0){
        [HTTool setFloatValue:0 forKey:@"HT_SKIN_FINEBLURRINESS_SLIDER"];
    }
}

#pragma mark - 风格取消后恢复美颜美型的效果
- (void)backToBeautyAndShapeEffect {
    
    //美颜
    for (int i = 0; i < skinBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:skinBeautyArray[i]];
        if (![HTTool judgeCacheValueIsNullForKey:model.key]) {
            [HTTool setFloatValue:model.defaultValue forKey:model.key];
        }
        [[HTEffect shareInstance] setBeauty:model.idCard value:[HTTool getFloatValueForKey:model.key]];
    }
    
    //美型
    for (int i = 0; i < faceBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:faceBeautyArray[i]];
        if (![HTTool judgeCacheValueIsNullForKey:model.key]) {
            [HTTool setFloatValue:model.defaultValue forKey:model.key];
        }
        [[HTEffect shareInstance] setReshape:model.idCard value:[HTTool getFloatValueForKey:model.key]];
    }
}

#pragma mark - 弹框代理方法 HTRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        [self.effectView clickResetSuccess];
        if (self.currentType == HT_SKIN_SLIDER) {
            self.currentModel = [[HTModel alloc] initWithDic:skinBeautyArray[0]];
            self.needResetBeauty = NO;
            [self.effectView updateResetButtonState:self.needResetBeauty];
        }else if (self.currentType == HT_RESHAPE_SLIDER) {
            self.currentModel = [[HTModel alloc] initWithDic:faceBeautyArray[0]];
            self.needResetShape = NO;
            [self.effectView updateResetButtonState:self.needResetShape];
        }
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.currentModel.key]];
        [self.sliderRelatedView setHidden:NO];
    }
}

#pragma mark - 美颜美型重启APP检查恢复按钮的状态
- (void)checkResetButton {
    
    //美颜
    for (int i = 0; i < skinBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:skinBeautyArray[i]];
        if ([HTTool getFloatValueForKey:model.key] != model.defaultValue) {
            self.needResetBeauty = YES;
            [self.effectView updateResetButtonState:self.needResetBeauty];
            break;
        }
    }
    
    //美型
    for (int i = 0; i < faceBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:faceBeautyArray[i]];
        if ([HTTool getFloatValueForKey:model.key] != model.defaultValue) {
            self.needResetShape = YES;
//            [self.effectView updateResetButtonState:self.needResetShape];
            break;
        }
    }
}

#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
    self.effectView.isThemeWhite = isThemeWhite;
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
                @"name":@"美颜",
                @"classify":@[
                    @{
                        @"name":@"美颜",
                        @"value":skinBeautyArray
                    }
                ]
            },
            @{
                @"name":@"美型",
                @"classify":@[
                    @{
                        @"name":@"美型",
                        @"value":faceBeautyArray
                    }
                ]
            },
            @{
                @"name":@"美发",
                @"classify":@[
                    @{
                        @"name":@"美发",
                        @"value":hairArray
                    }
                ]
            },
            @{
                @"name":@"风格",
                @"classify":@[
                    @{
                        @"name":@"风格",
                        @"value":styleArray
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
            [HTRestoreAlertView showWithTitle:@"是否将该模块的所有参数恢复到默认值?" delegate:weakSelf];
        }];
    }
    return _effectView;
}

- (HTBeautyHairView *)hairView{
    if (!_hairView) {
        _hairView = [[HTBeautyHairView alloc] initWithFrame:CGRectZero listArr:hairArray];
        _hairView.hidden = YES;
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

- (HTBeautyStyleView *)styleView{
    if (!_styleView) {
        _styleView = [[HTBeautyStyleView alloc] initWithFrame:CGRectZero listArr:styleArray];
        _styleView.hidden = YES;
        WeakSelf
        [_styleView setOnClickBlock:^(NSInteger index) {
            if (index > 0) {
                // 禁用美肤、美型的点击事件
                weakSelf.menuViewDisabled = YES;
            }else{
                // 恢复美颜美型之前的效果
                weakSelf.menuViewDisabled = NO;
                [weakSelf backToBeautyAndShapeEffect];
            }
        }];
    }
    return _styleView;
}

//- (UIButton *)backButton{
//    if (!_backButton) {
//        _backButton = [[UIButton alloc] init];
//        [_backButton setImage:[UIImage imageNamed:@"ht_back.png"] forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(onBackClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backButton;
//}

- (UILabel *)confirmLabel{
    if (!_confirmLabel) {
        _confirmLabel = [[UILabel alloc] init];
        _confirmLabel.text = @"请先关闭风格";
        _confirmLabel.font = HTFontMedium(15);
        _confirmLabel.textColor = UIColor.whiteColor;
        _confirmLabel.textAlignment = NSTextAlignmentCenter;
        [_confirmLabel setHidden:YES];
    }
    return _confirmLabel;
}

@end
