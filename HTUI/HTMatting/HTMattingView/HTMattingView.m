//
//  HTMattingView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import "HTMattingView.h"
#import "HTMattingMenuView.h"
#import "HTMattingEffectView.h"
#import "HTMattingGreenView.h"
#import "HTUIConfig.h"
#import "HTTool.h"
#import "HTSliderRelatedView.h"
#import "HTRestoreAlertView.h"
#import "HTUIManager.h"

@interface HTMattingView ()<HTRestoreAlertViewDelegate>

@property (nonatomic, strong) NSArray *listArr;// 人像分割部分全部数据
@property (nonatomic, strong) HTMattingMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTMattingEffectView *effectView;
@property (nonatomic, strong) HTMattingGreenView *greenView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HTSliderRelatedView *sliderRelatedView;
@property (nonatomic, strong) NSArray *editArray;
@property (nonatomic, strong) HTModel *editCurrentModel;
@property (nonatomic, strong) HTModel *greenCurrentModel;
@property (nonatomic, assign) NSInteger greenCurrentColor;// 当前幕布颜色

@end

NSString *aiSegmentationPath = @"";
NSString *greenscreenPath = @"";

@implementation HTMattingView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        aiSegmentationPath = [[[HTEffect shareInstance] getAISegEffectPath] stringByAppendingFormat:@"ht_aiseg_effect_config.json"];
        greenscreenPath = [[[HTEffect shareInstance] getGSSegEffectPath] stringByAppendingFormat:@"ht_gsseg_effect_config.json"];
        
        _editArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTMattingEdit" ofType:@"json"] withKey:@"ht_matting_edit"];
        self.editCurrentModel = [[HTModel alloc] initWithDic:_editArray[0]];
        // 清空绿幕编辑的保存的值
        for (NSInteger i = 0; i < _editArray.count; i++) {
            NSDictionary *dict = _editArray[i];
            [HTTool setFloatValue:[[HTModel alloc] initWithDic:_editArray[i]].defaultValue forKey:dict[@"key"]];
        }
        [self addSubview:self.sliderRelatedView];
        [self.sliderRelatedView.sliderView setSliderType:self.editCurrentModel.sliderType WithValue:[HTTool getFloatValueForKey:self.editCurrentModel.key]];
        [self.sliderRelatedView setHidden:YES];
        [self.sliderRelatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(HTHeight(53));
        }];
        
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(HTHeight(285));
        }];
        
        [self.containerView addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.mas_equalTo(HTHeight(43));
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
        
        [self.containerView addSubview:self.greenView];
        [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.effectView);
        }];
        self.greenView.hidden = YES;
        
//        [self addSubview:self.cameraBtn];
//        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).offset(-HTHeight(11)-[[HTAdapter shareInstance] getSaftAreaHeight]);
//            make.centerX.equalTo(self);
//            make.width.height.mas_equalTo(HTWidth(43));
//        }];
    }
    return self;
    
}

#pragma mark - 弹框代理方法 HTRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        [self.greenView restore];
    }
}

#pragma mark - 更新特效
- (void)updateGreenEffectWithValue:(int)value {
    
    [[HTEffect shareInstance] setGSSegEffectScene:self.greenCurrentModel.name];
//    [[HTEffect shareInstance] setGSSegEffectCurtain:HTScreenCurtainColorMap[self.greenCurrentColor]];
    NSInteger index = self.editCurrentModel.idCard;
//    NSLog(@"========= updateGreenEffectWithValue == name: %@ \n color: %@ \n id: %zd \n value: %d \n", self.greenCurrentModel.name, HTScreenCurtainColorMap[self.greenCurrentColor], index, value);
    if (index == 0) {
        [[HTEffect shareInstance] setGSSegEffectSimilarity:value];
    }else if (index == 1) {
        [[HTEffect shareInstance] setGSSegEffectSmoothness:value];
    }else {
        [[HTEffect shareInstance] setGSSegEffectTransparency:value];
    }
}

#pragma mark - 懒加载
- (HTSliderRelatedView *)sliderRelatedView{
    if (!_sliderRelatedView) {
        _sliderRelatedView = [[HTSliderRelatedView alloc] initWithFrame:CGRectZero];
        WeakSelf;
        // 更新效果
        [_sliderRelatedView.sliderView setRefreshValueBlock:^(CGFloat value) {
            [weakSelf updateGreenEffectWithValue:(int)value];
        }];
        // 写入缓存
        [_sliderRelatedView.sliderView setEndDragBlock:^(CGFloat value) {
            // 储存滑动条参数
        //    NSLog(@"========== %d == %@", value, key);
            [HTTool setFloatValue:(int)value forKey:weakSelf.editCurrentModel.key];
            // 检查恢复按钮是否可以点击
            [weakSelf.greenView checkRestoreButton];
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

- (NSArray *)listArr{
    _listArr = @[
        @{
            @"name":@"人像分割",
            @"classify":[HTTool jsonModeForPath:aiSegmentationPath withKey:@"ht_aiseg_effect"]
        },
        @{
            @"name":@"绿幕抠图",
            @"classify":[HTTool jsonModeForPath:greenscreenPath withKey:@"ht_gsseg_effect"]
        }
    ];
    return _listArr;
}

- (HTMattingMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTMattingMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf
        [_menuView setMattingOnClickBlock:^(NSArray * _Nonnull array, NSInteger index) {
            weakSelf.greenCurrentColor = index;
//            NSDictionary *dic = @{@"data":array,@"type":@(index)};
            if (index == 0) {
                weakSelf.effectView.hidden = NO;
                weakSelf.greenView.hidden = YES;
                weakSelf.sliderRelatedView.hidden = YES;
//                //刷新effect数据
//                [weakSelf.effectView updateMattingData:dic];
            }else {
                weakSelf.effectView.hidden = YES;
                weakSelf.greenView.hidden = NO;
                // 通知滑条显示或者隐藏
                [weakSelf.greenView showOrHideSilder];
            }
            
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

- (HTMattingGreenView *)greenView{
    if (!_greenView) {
        NSDictionary *dic = self.listArr[1];
        _greenView = [[HTMattingGreenView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_greenView setMattingGreenDownladCompleteBlock:^(NSInteger index) {
            // ???
            weakSelf.menuView.listArr = weakSelf.listArr;
        }];
        
        // 根据传值展示滑条
        _greenView.mattingSliderHiddenBlock = ^(BOOL show, HTModel * _Nonnull model) {
            if (!show) {
                weakSelf.sliderRelatedView.hidden = YES;
            }else {
                weakSelf.sliderRelatedView.hidden = NO;
                weakSelf.editCurrentModel = model;
                [weakSelf.sliderRelatedView.sliderView setSliderType:model.sliderType WithValue:[HTTool getFloatValueForKey:model.key]];
            }
        };
        
        // 选中模型
        _greenView.mattingDidSelectedBlock = ^(HTModel * _Nonnull model) {
            weakSelf.greenCurrentModel = model;
        };
        // 展示弹框
        _greenView.mattingShowAlertBlock = ^{
          
            [HTRestoreAlertView showWithTitle:@"是否将该模块的所有参数恢复到默认值?" delegate:weakSelf];
        };
    }
    return _greenView;
}


- (HTMattingEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[HTMattingEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_effectView setMattingDownladCompleteBlock:^(NSInteger index) {
            // ???
            weakSelf.menuView.listArr = weakSelf.listArr;
        }];
    }
    return _effectView;
}

//- (UIButton *)cameraBtn{
//    if (!_cameraBtn) {
//        _cameraBtn = [[UIButton alloc] init];
//        [_cameraBtn setTag:1];
//        [_cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
//        [_cameraBtn addTarget:self action:@selector(onCameraClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _cameraBtn;
//}

@end
