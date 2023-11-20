//
//  HTARItemView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
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
//@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) HTARItemEffectView *effectView;
@property (strong, nonatomic) UIButton *cleanButton;
@property (strong, nonatomic) UIView *cleanLineView;

@end

NSString *arItemPath = @"";
NSString *maskPath = @"";
NSString *giftPath = @"";
NSString *waterMarkPath = @"";


@implementation HTARItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HTColors(0, 0.7);
        
        arItemPath = [[[HTEffect shareInstance] getARItemPathBy:HTItemSticker] stringByAppendingFormat:@"ht_sticker_config.json"];
        
       // TODO: 改为自己的路径
        maskPath = [[[HTEffect shareInstance] getARItemPathBy:HTItemMask] stringByAppendingFormat:@"ht_mask_config.json"];
        
        giftPath = [[[HTEffect shareInstance] getARItemPathBy:HTItemGift] stringByAppendingFormat:@"ht_gift_config.json"];
        
        waterMarkPath = [[[HTEffect shareInstance] getARItemPathBy:HTItemWatermark] stringByAppendingFormat:@"ht_watermark_config.json"];
        
        [self addSubview:self.cleanButton];
        [self.cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.top.mas_equalTo(self);
            make.height.mas_equalTo(HTHeight(43));
            make.width.mas_equalTo(HTHeight(50));
        }];
        
        [self addSubview:self.cleanLineView];
        [self.cleanLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.right.mas_equalTo(self.cleanButton);
            make.centerY.mas_equalTo(self.cleanButton);
            make.width.mas_equalTo(HTWidth(0.5));
            make.height.mas_equalTo(HTHeight(22));
        }];
        
        [self addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cleanButton.mas_right);
            make.top.right.equalTo(self);
            make.height.mas_equalTo(self.cleanButton);
        }];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        [self addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(0);
            make.left.right.bottom.equalTo(self);
        }];
//        [self addSubview:self.watermarkView];
//        [self.watermarkView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).offset(0);
//            make.left.right.bottom.equalTo(self);
//        }];
//        
        
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(0);
            make.left.right.bottom.equalTo(self);
        }];
        
        
//        [self addSubview:self.cameraBtn];
//        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).offset(-HTHeight(11)-[[HTAdapter shareInstance] getSaftAreaHeight]);
//            make.centerX.equalTo(self);
//            make.width.height.mas_equalTo(HTWidth(43));
//        }];
    }
    return self;
    
}

#pragma mark - 清除按钮点击
- (void)cleanButtonClick:(UIButton *)btn {
    
    [self.effectView clean];
}

#pragma mark - 懒加载
- (NSArray *)listArr{
    _listArr = @[
        @{
            @"name":@"贴纸",
            @"classify":[HTTool jsonModeForPath:arItemPath withKey:@"ht_sticker"]
        },
        //TODO: 换成面具
        @{
            @"name":@"面具",
            @"classify":[HTTool jsonModeForPath:maskPath withKey:@"ht_mask"]
        },
        //TODO: 换成礼物
        @{
            @"name":@"礼物",
            @"classify":[HTTool jsonModeForPath:giftPath withKey:@"ht_gift"]
        },
        @{
            @"name":@"水印",
            @"classify":[HTTool jsonModeForPath:waterMarkPath withKey:@"ht_watermark"]
        }];
    return _listArr;
}

- (HTARItemMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[HTARItemMenuView alloc] initWithFrame:CGRectZero listArr:self.listArr];
        WeakSelf
        [_menuView setArItemMenuOnClickBlock:^(NSArray * _Nonnull array, NSInteger index) {
            NSDictionary *dic = @{@"data":array,@"type":@(index)};
            //刷新effect数据
            [weakSelf.effectView updateDataWithDict:dic];
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
        [_effectView setArDownladCompleteBlock:^(NSInteger index) {
            // 这步是作甚？
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

- (UIButton *)cleanButton {
    if (!_cleanButton) {
        _cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cleanButton setImage:[UIImage imageNamed:@"ar_clean_disable"] forState:UIControlStateNormal];
        [_cleanButton setImage:[UIImage imageNamed:@"ar_clean"] forState:UIControlStateNormal];
        [_cleanButton addTarget:self action:@selector(cleanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cleanButton;
}

- (UIView *)cleanLineView {
    if (!_cleanLineView) {
        _cleanLineView = [[UIView alloc] init];
        _cleanLineView.backgroundColor = HTColors(255, 0.3);
    }
    return _cleanLineView;
}
@end
