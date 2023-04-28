//
//  HTRestoreAlertView.m
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/4/13.
//

#import "HTRestoreAlertView.h"
#import "HTUIConfig.h"
#import "HTUIManager.h"

@interface HTRestoreAlertView ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) id<HTRestoreAlertViewDelegate> delegate;

@end

@implementation HTRestoreAlertView

#pragma mark - 类方法初始化
+ (void)showWithTitle:(NSString *)title delegate:(id<HTRestoreAlertViewDelegate>)delegate {
    
    HTRestoreAlertView *view = [[self alloc] init];
    view.title = title;
//    view.model = model;
    view.delegate = delegate;
//    [view show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[HTUIManager shareManager].superWindow addSubview:self];
    
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(HTWidth(235));
        make.height.mas_equalTo(HTWidth(165));
    }];
    [self.coverView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView).offset(HTWidth(10));
        make.right.equalTo(self.coverView).offset(-HTWidth(10));
        make.top.equalTo(self.coverView).offset(HTHeight(18));
    }];
    
    [self.coverView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(HTWidth(155));
        make.height.mas_equalTo(HTHeight(35));
        make.bottom.equalTo(self.coverView.mas_bottom).offset(-HTHeight(10));
    }];
    
    [self.coverView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(self.cancelButton);
        make.centerX.equalTo(self.coverView);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-HTHeight(12));
        
    }];
    
}

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

#pragma mark - 按钮点击
- (void)buttonClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(alertViewDidSelectedStatus:)]) {
        [self.delegate alertViewDidSelectedStatus:[btn.currentTitle isEqualToString:@"确定"]];
    }
    [self hide];
}

#pragma mark - 隐藏
- (void)hide {
    [self removeFromSuperview];
    self.delegate = nil;
}


- (void)dealloc {
    
    NSLog(@"%@ 销毁了", [self class]);
}

#pragma mark - 懒加载
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.layer.cornerRadius = 5;
        _coverView.backgroundColor = UIColor.whiteColor;
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = HTFontMedium(15);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.layer.cornerRadius = 35/2;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.backgroundColor = HTColors(17, 1);
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_sureButton.titleLabel setFont:HTFontRegular(14)];
        [_sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.cornerRadius = 35/2;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.backgroundColor = HTColors(229, 1);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:HTColors(102, 1) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:HTFontRegular(14)];
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
