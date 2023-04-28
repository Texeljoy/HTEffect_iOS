//
//  HTFilterStyleViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import "HTFilterStyleViewCell.h"
#import "HTUIConfig.h"

@interface HTFilterStyleViewCell ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *lineView;

@end

@implementation HTFilterStyleViewCell

- (HTButton *)item{
    if (!_item) {
        _item = [[HTButton alloc] init];
        _item.userInteractionEnabled = NO;
    }
    return _item;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.image = [UIImage imageNamed:@"ht_line.png"];
    }
    return _lineView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(HTWidth(55));
        }];
        [self.contentView addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.contentView);
            make.width.height.mas_equalTo(HTWidth(55));
        }];
        [self.maskView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.maskView);
            make.width.mas_equalTo(HTWidth(30));
            make.height.mas_equalTo(HTHeight(3));
        }];
    }
    return self;
}

- (void)setMaskViewColor:(UIColor *)color selected:(BOOL)selected{
    if (selected) {
        [self.maskView setBackgroundColor:color];
    }
    [self.maskView setHidden:!selected];
}

- (void)setItemCornerRadius:(CGFloat)radius{
    [self.maskView.layer setCornerRadius:radius];
    [self.item setImageCornerRadius:radius];
}

@end
