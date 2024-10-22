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
#import "HTUIManager.h"
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

//@property (nonatomic, strong) HTModel *makeupModel;
// 重置按钮的状态
@property (nonatomic, assign) BOOL needResetBeauty;
@property (nonatomic, assign) BOOL needResetShape;
//@property (nonatomic, assign) BOOL needResetMakeup;

// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *skinBeautyArray; // 美颜
@property (nonatomic, strong) NSArray *faceBeautyArray; // 美型

@end

@implementation HTBeautyView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.skinBeautyArray = [HTTool jsonModeForPath:HTSkinBeautyPath withKey:@"HTSkinBeauty"];
    self.faceBeautyArray = [HTTool jsonModeForPath:HTFaceBeautyPath withKey:@"HTFaceBeauty"];
    if (self) {
        // 获取文件路径
//        stylePath = [[NSBundle mainBundle] pathForResource:@"HTStyleBeauty" ofType:@"json"];
        self.currentType = HT_SKIN_SLIDER;
        self.currentModel = [[HTModel alloc] initWithDic:self.skinBeautyArray[0]];
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
    
    if ([name isEqualToString:[HTTool isCurrentLanguageChinese] ? @"美发" : @"Hair"]) {
        self.menuView.disabled = NO;
        [self.effectView setHidden:YES];
    }else {
        // 美颜和美型
        self.menuView.disabled = NO;
        [self.effectView setHidden:YES];;
        
        if ([name isEqualToString:[HTTool isCurrentLanguageChinese] ? @"美肤" : @"Skin"]) {
            //默认选择第一个
            HTModel *model = [[HTModel alloc] initWithDic:self.skinBeautyArray[0]];
            self.currentModel = model;
            [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(0)};
            self.currentType = HT_SKIN_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [self.effectView updateBeautyAndShapeEffectData:newDic];
            [self.effectView setHidden:NO];
            [self.effectView updateResetButtonState:self.needResetBeauty];
        }else if ([name isEqualToString:[HTTool isCurrentLanguageChinese] ? @"美型" : @"Reshape"]){
            HTModel *model = [[HTModel alloc] initWithDic:self.faceBeautyArray[0]];
            self.currentModel = model;
            [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
            [self.sliderRelatedView setHidden:NO];
            NSDictionary *newDic = @{@"data":dic[@"value"],@"type":@(1)};
            self.currentType = HT_RESHAPE_SLIDER;
            self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.menuView.menuCollectionView reloadData];
            //刷新effect数据
            [self.effectView updateBeautyAndShapeEffectData:newDic];
            [self.effectView setHidden:NO];
            [self.effectView updateResetButtonState:self.needResetShape];
        }
    }
    
}

- (void)updateEffect:(int)value{
    if (self.currentType == HT_MAKEUP_SLIDER) {
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
    }
}

- (void)saveParameters:(int)value{
    NSString *key = self.currentModel.key;
    [HTTool setFloatValue:value forKey:key];
    
    // 美颜和美型目前没有做精准监听进度条与初始值的比较，恢复按钮不会恢复到不能点击的状态
    if (value != self.currentModel.defaultValue) {
        if (self.currentType == HT_SKIN_SLIDER) {
            self.needResetBeauty = YES;
            [self.effectView updateResetButtonState:self.needResetBeauty];
        }else if (self.currentType == HT_RESHAPE_SLIDER){
            self.needResetShape = YES;
            [self.effectView updateResetButtonState:self.needResetShape];
        }
    }
    
    // 储存滑动条参数
//    NSLog(@"aaaaaaaaaaaa %d == %@", value, key);
//    [HTTool setFloatValue:value forKey:key];
}

#pragma mark - 弹框代理方法 HTRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        
        if (self.currentType == HT_SKIN_SLIDER) {
            [self.effectView clickResetSuccess];
            self.currentModel = [[HTModel alloc] initWithDic:self.skinBeautyArray[0]];
            self.needResetBeauty = NO;
            [self.effectView updateResetButtonState:self.needResetBeauty];
            [self.sliderRelatedView setHidden:NO];
        }else if (self.currentType == HT_RESHAPE_SLIDER) {
            [self.effectView clickResetSuccess];
            self.currentModel = [[HTModel alloc] initWithDic:self.faceBeautyArray[0]];
            self.needResetShape = NO;
            [self.effectView updateResetButtonState:self.needResetShape];
            [self.sliderRelatedView setHidden:NO];
        }
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.currentModel.key]];
//        [self.sliderRelatedView setHidden:NO];
    }
}

#pragma mark - 美颜美型重启APP检查恢复按钮的状态
- (void)checkResetButton {
    
    //美颜
    for (int i = 0; i < self.skinBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:self.skinBeautyArray[i]];
        if ([HTTool getFloatValueForKey:model.key] != model.defaultValue) {
            self.needResetBeauty = YES;
            [self.effectView updateResetButtonState:self.needResetBeauty];
            break;
        }
    }
    
    //美型
    for (int i = 0; i < self.faceBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:self.faceBeautyArray[i]];
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
    self.sliderRelatedView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : HTColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : HTColors(255, 0.3);
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[
            @{
                @"name":[HTTool isCurrentLanguageChinese] ? @"美肤" : @"Skin",
                @"classify":@[
                    @{
                        @"name":[HTTool isCurrentLanguageChinese] ? @"美肤" : @"Skin",
                        @"value":self.skinBeautyArray
                    }
                ]
            },
            @{
                @"name":[HTTool isCurrentLanguageChinese] ? @"美型" : @"Reshape",
                @"classify":@[
                    @{
                        @"name":[HTTool isCurrentLanguageChinese] ? @"美型" : @"Reshape",
                        @"value":self.faceBeautyArray
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
        _effectView = [[HTBeautyEffectView alloc] initWithFrame:CGRectZero listArr:self.skinBeautyArray];
        WeakSelf
        [_effectView setOnUpdateSliderHiddenBlock:^(HTModel * _Nonnull model) {
            [weakSelf.sliderRelatedView setHidden:NO];
            weakSelf.currentModel = model;
            [weakSelf.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
        }];
        [_effectView setOnClickResetBlock:^{
            [HTRestoreAlertView showWithTitle:[HTTool isCurrentLanguageChinese] ? @"是否将该模块的所有参数恢复到默认值?" : @"Reset all parameters in this module to default?" delegate:weakSelf];
        }];
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
