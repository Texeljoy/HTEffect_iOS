//
//  HTBodyView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTBodyView.h"
#import "HTTool.h"
#import "HTBodyMenuView.h"
#import "HTUIConfig.h"
#import "HTUIManager.h"
#import "HTRestoreAlertView.h"
#import "HTBtBodyView.h"

@interface HTBodyView ()<HTRestoreAlertViewDelegate>

// 美颜部分全部数据
@property (nonatomic, strong) NSArray *listArr;
// 当前选中的model
@property (nonatomic, strong) HTModel *currentModel;
@property (nonatomic, assign) HTDataCategoryType currentType;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HTBodyMenuView *menuView;
@property (nonatomic, assign) BOOL menuViewDisabled;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTBtBodyView *bodyView;

//@property (nonatomic, strong) HTModel *makeupModel;
// 重置按钮的状态
//@property (nonatomic, assign) BOOL needResetBeauty;
//@property (nonatomic, assign) BOOL needResetShape;
//@property (nonatomic, assign) BOOL needResetMakeup;

// 提示文字
@property (nonatomic, strong) UILabel *confirmLabel;
//@property (nonatomic, strong) NSTimer *timer;

//@property (nonatomic, strong) NSArray *skinBeautyArray; // 美颜
//@property (nonatomic, strong) NSArray *faceBeautyArray; // 美型
@property (nonatomic, strong) NSArray *bodyArray; // 美体

@end

@implementation HTBodyView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.bodyArray = [HTTool jsonModeForPath:HTBodyBeautyPath withKey:@"HTBodyBeauty"];
    if (self) {
        self.currentType = HT_BODY_SLIDER;
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
        
        [self.containerView addSubview:self.bodyView];
        [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(23));
            make.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(82));
//            make.bottom.equalTo(self.containerView);
        }];
        
        [self addSubview:self.confirmLabel];
        [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(-HTHeight(40));
        }];
        
       // [self checkResetButton];
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

    if ([name isEqualToString:[HTTool isCurrentLanguageChinese] ? @"美体" : @"Body"]) {
        
        self.menuView.disabled = NO;
        [self.sliderRelatedView setHidden:YES];
        
        self.currentType = HT_BODY_SLIDER;
        
        //默认选择第一个
        HTModel *model = [[HTModel alloc] initWithDic:self.bodyArray[0]];
        self.currentModel = model;
        [self.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
        [self.sliderRelatedView setHidden:NO];
        self.menuView.selectedIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.menuView.menuCollectionView reloadData];
        //刷新数据
        [self.bodyView updateBodyEffectData:self.bodyArray];
        [self.bodyView setHidden:NO];
        
    }else {
        // 美颜和美型
        self.menuView.disabled = NO;
        [self.bodyView setHidden:YES];
        
    }
    
}

- (void)updateEffect:(int)value{
    if (self.currentType == HT_BODY_SLIDER) {
        // 设置美体特效
        [[HTEffect shareInstance] setBodyBeauty:self.currentModel.idCard value:value];
        
    }
}

- (void)saveParameters:(int)value{
    NSString *key = self.currentModel.key;
    [HTTool setFloatValue:value forKey:key];
    
    
    // 美妆和美体进行精准监听，即所有参数与初始值相等时，恢复按钮可以恢复到不能点击的状态
    if (self.currentType == HT_BODY_SLIDER) {
        [self.bodyView checkRestoreButton];
    }
    
    // 储存滑动条参数
//    NSLog(@"aaaaaaaaaaaa %d == %@", value, key);
//    [HTTool setFloatValue:value forKey:key];
}

#pragma mark - 弹框代理方法 HTRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        
        if (self.currentType == HT_BODY_SLIDER) {
            self.currentModel = [[HTModel alloc] initWithDic:self.bodyArray[0]];
            [self.bodyView restore];
            [self.sliderRelatedView setHidden:NO];
        }
        [self.sliderRelatedView.sliderView setSliderType:self.currentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.currentModel.key]];
//        [self.sliderRelatedView setHidden:NO];
    }
}


  

#pragma mark - 设置主题色
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    self.menuView.isThemeWhite = isThemeWhite;
    self.bodyView.isThemeWhite = isThemeWhite;
    self.sliderRelatedView.isThemeWhite = isThemeWhite;
    self.containerView.backgroundColor = isThemeWhite ? [UIColor whiteColor] : HTColors(0, 0.7);
    self.lineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : HTColors(255, 0.3);
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    if (!_listArr) {
        _listArr = @[
            @{
                @"name":[HTTool isCurrentLanguageChinese] ? @"美体" : @"Body",
                @"classify":@[
                    @{
                        @"name":[HTTool isCurrentLanguageChinese] ? @"美体" : @"Body",
                        @"value":self.bodyArray
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

- (HTBodyMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTBodyMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
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


- (HTBtBodyView *)bodyView{
    if (!_bodyView) {
        _bodyView = [[HTBtBodyView alloc] initWithFrame:CGRectZero listArr:self.bodyArray];
        WeakSelf
        // 展示弹框
        _bodyView.bodyShowAlertBlock = ^{
          
            [HTRestoreAlertView showWithTitle:[HTTool isCurrentLanguageChinese] ? @"是否将该模块的所有参数恢复到默认值?" : @"Reset all parameters in this module to default?" delegate:weakSelf];
        };
        
        // 通知滑动条
        _bodyView.bodyDidSelectedBlock = ^(HTModel * _Nonnull model) {
          
            [weakSelf.sliderRelatedView setHidden:NO];
            weakSelf.currentModel = model;
            [weakSelf.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
        };
    }
    return _bodyView;
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
