//
//  HTSubMenuViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import "HTSubMenuViewCell.h"
#import "HTUIConfig.h"

@interface HTSubMenuViewCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HTSubMenuViewCell

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.userInteractionEnabled = NO;
        _label.font = HTFontRegular(14);
        _label.textColor = HTColors(255, 1.0);
    }
    return _label;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(HTWidth(20));
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title selected:(BOOL)selected textColor:(UIColor *)color{
    [self.label setText:title];
    [self.label setTextColor:color];
    [self.lineView setHidden:!selected];
    [self.lineView setBackgroundColor:color];
}

- (void)setLineHeight:(CGFloat)height{
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

@end
