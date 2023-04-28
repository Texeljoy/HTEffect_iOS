//
//  HTGestureViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/9/13.
//

#import "HTGestureViewCell.h"
#import "HTUIConfig.h"

@interface HTGestureViewCell ()

@property (nonatomic, strong,readwrite) UIImageView *htImageView;
@property (nonatomic, strong) UIImageView *downloadIcon;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *downloadingIcon;
@property (nonatomic, assign) CGFloat angle;

@end

@implementation HTGestureViewCell

- (UIImageView *)htImageView{
    if (!_htImageView) {
        _htImageView = [[UIImageView alloc] init];
        _htImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _htImageView;
}

- (UIImageView *)downloadIcon{
    if (!_downloadIcon) {
        _downloadIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ht_download.png"]];
    }
    return _downloadIcon;
}

- (UIImageView *)downloadingIcon{
    if (!_downloadingIcon) {
        _downloadingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ht_downloading.png"]];
    }
    return _downloadingIcon;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = HTColors(0, 0.4);
        _maskView.layer.cornerRadius = HTWidth(5);
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.angle = 0;
        [self.contentView addSubview:self.htImageView];
        [self.htImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(HTWidth(47));
        }];
        [self.contentView addSubview:self.downloadIcon];
        [self.downloadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.htImageView).offset(HTWidth(23.5));
            make.width.height.mas_equalTo(HTWidth(15));
        }];
        [self.contentView addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.htImageView);
        }];
        [self.maskView addSubview:self.downloadingIcon];
        [self.downloadingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.maskView);
            make.width.height.mas_equalTo(HTWidth(20));
        }];
    }
    return self;
}

- (void)setHtImage:(UIImage *_Nullable)image isCancelEffect:(BOOL)isCancelEffect{
    [self.htImageView setImage:image];
    if (isCancelEffect) {
        [self.htImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(HTWidth(26));
        }];
        self.downloadIcon.hidden = YES;
    }else{
        [self.htImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(HTWidth(63));
        }];
    }
}

- (void)setSelectedBorderHidden:(BOOL)hidden borderColor:(UIColor *)color{
    if (hidden) {
        self.contentView.layer.borderWidth = 0;
        self.contentView.layer.borderColor = UIColor.clearColor.CGColor;
    }else{
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = color.CGColor;
    }
}

- (void)hiddenDownloaded:(BOOL)hidden{
    self.downloadIcon.hidden = hidden;
}

- (void)startAnimation{
    [self.downloadIcon setHidden:YES];
    [self.maskView setHidden:NO];
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.downloadingIcon.transform = endAngle;
    } completion:^(BOOL finished) {
        if (finished) {
            self.angle += 30;
            [self startAnimation];
        }
    }];
}

- (void)endAnimation
{
    [self.downloadIcon setHidden:NO];
    [self.maskView setHidden:YES];
    [self.layer removeAllAnimations];
}

@end
