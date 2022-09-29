//
//  HTARItemView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/20.
//

#import "HTARItemView.h"
#import "HTARItemMenuView.h"
#import "HTARItemEffectView.h"
#import "HTUIConfig.h"
#import "HTTool.h"

@interface HTARItemView ()

@property (nonatomic, strong) NSArray *listArr;// AR道具部分全部数据
@property (nonatomic, strong) HTARItemMenuView *menuView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTARItemEffectView *effectView;

@end

NSString *arItemPath = @"";
NSString *waterMarkPath = @"";

@implementation HTARItemView

- (NSArray *)listArr{
    _listArr = @[
        @{
            @"name":NSLocalizedString(@"道具",nil),
            @"classify":[HTTool jsonModeForPath:arItemPath withKey:@"ht_sticker"]
        },
        @{
            @"name":NSLocalizedString(@"水印",nil),
            @"classify":[HTTool jsonModeForPath:waterMarkPath withKey:@"ht_watermark"]
        }];
    return _listArr;
}

- (HTARItemMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTARItemMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        [_menuView setOnClickBlock:^(NSArray * _Nonnull array, NSInteger index, NSInteger selectedIndex) {
            NSDictionary *dic = @{@"data":array,@"type":@(index),@"selected":@(selectedIndex)};
            //刷新effect数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTARItemEffectView_UpDateListArray" object:dic];
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

- (HTARItemEffectView *)effectView{
    if (!_effectView) {
        NSDictionary *dic = self.listArr[0];
        _effectView = [[HTARItemEffectView alloc] initWithFrame:CGRectZero listArr:dic[@"classify"]];
        WeakSelf;
        [_effectView setOnClickEffectBlock:^(NSInteger index) {
            NSString *arItemPath = [[[HTEffect shareInstance] getStickerPath] stringByAppendingFormat:@"ht_sticker_config.json"];
            [HTTool setWriteJsonDicFocKey:@"ht_sticker" index:index path:arItemPath];
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
        arItemPath = [[[HTEffect shareInstance] getStickerPath] stringByAppendingFormat:@"ht_sticker_config.json"];
        waterMarkPath = [[[HTEffect shareInstance] getWatermarkPath] stringByAppendingFormat:@"ht_watermark_config.json"];
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
