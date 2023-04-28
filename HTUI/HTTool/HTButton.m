//
//  HTButton.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTButton.h"
#import "HTUIConfig.h"

@interface HTButton()

@property (strong, nonatomic) UIImageView *htImgView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation HTButton

- (UIImageView *)htImgView{
    if (!_htImgView) {
        _htImgView = [[UIImageView alloc] init];
        _htImgView.contentMode = UIViewContentModeScaleAspectFill;
        _htImgView.clipsToBounds = YES;
        _htImgView.userInteractionEnabled = NO;
    }
    return _htImgView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.userInteractionEnabled = NO;
        _label.font = HTFontRegular(12);
        _label.textColor = HTColors(68, 1.0);
    }
    return _label;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.htImgView];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
        }];
    }
    return self;
}

- (void)setImage:(UIImage *)image imageWidth:(CGFloat)width title:(NSString *)title{
    self.label.text = title;
    self.htImgView.image = image;
    [self.htImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(width);
    }];
}

- (void)setTextColor:(UIColor *)color{
    self.label.textColor = color;
}

- (void)setTextFont:(UIFont *)font{
    [self.label setFont:font];
}

- (void)setImageCornerRadius:(CGFloat)radius{
    [self.htImgView.layer setMasksToBounds:YES];
    [self.htImgView.layer setCornerRadius:radius];
}

- (void)setTextBackgroundColor:(UIColor *)color{
    [self.label setBackgroundColor:color];
}

- (NSString *)getTitle {
    
    if (self.label) {
        return self.label.text;
    }
    return @"";
}
@end
