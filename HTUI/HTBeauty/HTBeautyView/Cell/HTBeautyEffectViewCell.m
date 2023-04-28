//
//  HTBeautyEffectViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import "HTBeautyEffectViewCell.h"
#import "HTUIConfig.h"

@implementation HTBeautyEffectViewCell

- (HTButton *)item{
    if (!_item) {
        _item = [[HTButton alloc] init];
        _item.userInteractionEnabled = NO;
    }
    return _item;
}

- (UIView *)pointView{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = MAIN_COLOR;
        _pointView.layer.cornerRadius = HTWidth(2);
        [_pointView setHidden:YES];
    }
    return _pointView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.contentView);
            make.width.mas_equalTo(HTWidth(48));
            make.height.mas_equalTo(HTHeight(70));
        }];
        [self.contentView addSubview:self.pointView];
        [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self.contentView);
            make.width.height.mas_equalTo(HTWidth(4));
        }];
    }
    return self;
}

@end
