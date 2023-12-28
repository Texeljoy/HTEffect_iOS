//
//  HTMakeupCollectionViewCell.m
//  HTEffectDemo
//
//  Created by Eddie on 2023/9/11.
//

#import "HTMakeupCollectionViewCell.h"
#import "HTUIConfig.h"
#import "HTTool.h"

@interface HTMakeupCollectionViewCell ()

@property (nonatomic, strong) UIImageView *htImageView;
@property (nonatomic, strong) UIImageView *downloadIcon;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *downloadingIcon;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIView *selectMaskView;
@property (nonatomic, strong) UIImageView *lineView;

@end

@implementation HTMakeupCollectionViewCell

- (UIImageView *)htImageView{
    if (!_htImageView) {
        _htImageView = [[UIImageView alloc] init];
        _htImageView.layer.masksToBounds = YES;
        _htImageView.layer.cornerRadius = HTWidth(5);
//        _htImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _htImageView;
}

- (UIImageView *)downloadIcon{
    if (!_downloadIcon) {
        _downloadIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ht_download"]];
    }
    return _downloadIcon;
}

- (UIImageView *)downloadingIcon{
    if (!_downloadingIcon) {
        _downloadingIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ht_downloading"]];
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

- (UIView *)selectMaskView {
    if (!_selectMaskView) {
        _selectMaskView = [[UIView alloc] init];
        _selectMaskView.backgroundColor = HTColors(0, 0.4);
        _selectMaskView.layer.cornerRadius = HTWidth(5);
        _selectMaskView.hidden = YES;
    }
    return _selectMaskView;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.image = [UIImage imageNamed:@"ht_line"];
    }
    return _lineView;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
//        _title.userInteractionEnabled = NO;
        _title.font = HTFontRegular(12);
        _title.textColor = HTColors(255, 1.0);
    }
    return _title;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.angle = 0;
        [self.contentView addSubview:self.htImageView];
        [self.htImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(HTWidth(55));
            make.top.centerX.equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.downloadIcon];
        [self.downloadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.centerY.equalTo(self.htImageView).offset(HTWidth(23.5));
            make.centerX.equalTo(self.htImageView.mas_right);
            make.centerY.equalTo(self.htImageView.mas_bottom);
            make.width.height.mas_equalTo(HTWidth(15));
        }];
        
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(self.htImageView);
        }];
        
        [self.contentView addSubview:self.selectMaskView];
        [self.selectMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.htImageView);
        }];
        [self.selectMaskView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.selectMaskView);
            make.width.mas_equalTo(HTWidth(30));
            make.height.mas_equalTo(HTHeight(3));
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

#pragma mark - 赋值
- (void)setMaskViewColor:(UIColor *)color selected:(BOOL)selected{
    if (selected) {
        [self.selectMaskView setBackgroundColor:color];
    }
    [self.selectMaskView setHidden:!selected];
}

- (void)setNoneImage:(BOOL)selected isThemeWhite:(BOOL)isWhite{
    
    [self.htImageView setImage:[UIImage imageNamed:@"makeup_none"]];
    self.title.text = [HTTool isCurrentLanguageChinese] ? @"无" : @"None";
    if (selected) {
        self.title.textColor = isWhite ? [UIColor blackColor] : MAIN_COLOR;
    }else{
        self.title.textColor = isWhite ? [UIColor blackColor] : HTColors(255, 1.0);
    }
    
    [self endAnimation];
    [self hiddenDownloaded:YES];
    [self setMaskViewColor:COVER_COLOR selected:selected];
}

- (void)setModel:(HTModel *)model type:(NSInteger)type isThemeWhite:(BOOL)isWhite{
    
    self.title.text = model.title;
    if (model.selected) {
        self.title.textColor = isWhite ? [UIColor blackColor] : MAIN_COLOR;
    }else{
        self.title.textColor = isWhite ? [UIColor blackColor] : HTColors(255, 1.0);
    }
    
    [self.htImageView setImage:[UIImage imageNamed:@"HTImagePlaceholder"]];
    
    NSString *iconUrl = [[HTEffect shareInstance] getMakeupUrl:(int)type];
    NSString *folder = model.category;
    NSString *cachePaths = [[HTEffect shareInstance] getMakeupPath];
//    NSLog(@"================ %@ ==== %@ ---- %@ ---- %@", iconUrl, cachePaths, folder, [NSString stringWithFormat:@"%@%@",iconUrl, model.icon]);
    [HTTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl, model.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
//        [self setHtImage:image isCancelEffect:NO];
        if (image) {
            [self.htImageView setImage:image];
        }
    }];
 
    [self setMaskViewColor:COVER_COLOR selected:model.selected];
    switch (model.download) {
        case 0:// 未下载
        {
            [self endAnimation];
            [self hiddenDownloaded:NO];
        }
            break;
        case 1:// 下载中。。。
        {
            [self startAnimation];
            [self hiddenDownloaded:YES];
        }
            break;
        case 2:// 下载完成
        {
            [self endAnimation];
            [self hiddenDownloaded:YES];
        }
            break;
        default:
            break;
    }
}

@end
