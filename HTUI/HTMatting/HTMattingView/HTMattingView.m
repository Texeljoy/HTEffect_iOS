//
//  HTMattingView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/21.
//

#import "HTMattingView.h"
#import "HTMattingMenuView.h"
#import "HTMattingEffectView.h"
#import "HTUIConfig.h"
#import "HTTool.h"

@interface HTMattingView ()

@property (nonatomic, strong) NSArray *listArr;// AI抠图部分全部数据
@property (nonatomic, strong) HTMattingMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTMattingEffectView *effectView;

@end

NSString *aiSegmentationPath = @"";
NSString *greenscreenPath = @"";

@implementation HTMattingView

- (NSArray *)listArr{
    _listArr = @[
        @{
            @"name":NSLocalizedString(@"AI抠图",nil),
            @"classify":[HTTool jsonModeForPath:aiSegmentationPath withKey:@"ht_aiseg_effect"]
        },
        @{
            @"name":NSLocalizedString(@"绿幕抠图",nil),
            @"classify":[HTTool jsonModeForPath:greenscreenPath withKey:@"ht_gsseg_effect"]
        }
    ];
    return _listArr;
}

- (HTMattingMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTMattingMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        [_menuView setOnClickBlock:^(NSArray * _Nonnull array, NSInteger index) {
            NSDictionary *dic = @{@"data":array,@"type":@(index)};
            //刷新effect数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTMattingEffectView_UpDateListArray" object:dic];
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

- (HTMattingEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[HTMattingEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_effectView setOnClickEffectBlock:^(NSInteger index, EffectType type) {
            if (type == HT_AISegmentation) {
                NSString *aiPath = [[[HTEffect shareInstance] getAISegEffectPath] stringByAppendingFormat:@"ht_aiseg_effect_config.json"];
                [HTTool setWriteJsonDicFocKey:@"ht_aiseg_effect" index:index path:aiPath];
            }else{
                NSString *gsPath = [[[HTEffect shareInstance] getGSSegEffectPath] stringByAppendingFormat:@"ht_gsseg_effect_config.json"];
                [HTTool setWriteJsonDicFocKey:@"ht_gsseg_effect" index:index path:gsPath];
            }
            weakSelf.menuView.listArr = weakSelf.listArr;
        }];
    }
    return _effectView;
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

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        aiSegmentationPath = [[[HTEffect shareInstance] getAISegEffectPath] stringByAppendingFormat:@"ht_aiseg_effect_config.json"];
        greenscreenPath = [[[HTEffect shareInstance] getGSSegEffectPath] stringByAppendingFormat:@"ht_gsseg_effect_config.json"];
        [self addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(HTHeight(43));
        }];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        [self addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(HTHeight(14));
            make.left.right.bottom.equalTo(self);
        }];
        [self addSubview:self.cameraBtn];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-HTHeight(11)-[[HTAdapter shareInstance] getSaftAreaHeight]);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(HTWidth(43));
        }];
    }
    return self;
    
}

- (void)onCameraClick:(UIButton *)button{
    if (self.onClickCameraBlock) {
        self.onClickCameraBlock();
    }
}

@end
