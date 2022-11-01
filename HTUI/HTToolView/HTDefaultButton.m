//
//  HTDefaultButton.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import "HTDefaultButton.h"
#import "HTUIConfig.h"

@implementation HTDefaultButton

- (UIButton *)enterBeautyBtn{
    if (!_enterBeautyBtn){
        _enterBeautyBtn = [[UIButton alloc] init];
        [_enterBeautyBtn setTag:0];
        [_enterBeautyBtn setImage:[UIImage imageNamed:@"HTBeautyW.png"] forState:UIControlStateNormal];
        [_enterBeautyBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBeautyBtn;
}

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        [_cameraBtn setTag:1];
        [_cameraBtn setImage:[UIImage imageNamed:@"HTCameraW.png"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UIButton *)demoShowBtn{
    if (!_demoShowBtn) {
        _demoShowBtn = [[UIButton alloc] init];
        [_demoShowBtn setTag:0];
        [_demoShowBtn setImage:[UIImage imageNamed:@"HTBeautyW.png"] forState:UIControlStateNormal];
        [_demoShowBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _demoShowBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.enterBeautyBtn];
    [self addSubview:self.cameraBtn];
    [self.enterBeautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HTWidth(52));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(HTWidth(40));
    }];
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.mas_equalTo(HTWidth(66));
    }];
    //    [self addSubview:self.demoShowBtn];
    //    [self.demoShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self).offset(-HTWidth(20));
    //        make.bottom.equalTo(self).offset(-HTHeight(300));
    //        make.width.height.mas_equalTo(HTWidth(40));
    //    }];
}

- (void)onButtonClick:(UIButton *)button{
    if (self.onClickBlock) {
        self.onClickBlock(button.tag);
    }
}

// 让超出父控件的方法触发响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        // 转换坐标系
        CGPoint demoShowButton = [self.demoShowBtn convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.demoShowBtn.bounds, demoShowButton)) {
            view = self.demoShowBtn;
        }
    }
    return view;
}

@end
