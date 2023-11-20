//
//  HTBeautyMenuViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTBeautyMenuViewCell.h"
#import "HTUIConfig.h"

@interface HTBeautyMenuViewCell ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation HTBeautyMenuViewCell

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

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title textColor:(UIColor *)color{
    [self.label setText:title];
    [self.label setTextColor:color];
}

@end
