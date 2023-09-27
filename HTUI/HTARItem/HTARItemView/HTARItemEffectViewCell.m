//
//  HTARItemEffectViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import "HTARItemEffectViewCell.h"

#import "HTTool.h"
#import <AudioToolbox/AudioToolbox.h>


@interface HTARItemEffectViewCell ()

@property (nonatomic, strong,readwrite) UIImageView *htImageView;
@property (nonatomic, strong) UIImageView *downloadIcon;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *downloadingIcon;
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) UIView *editMaskView;
@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, assign) NSInteger index;
@end

@implementation HTARItemEffectViewCell

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


- (UIView *)editMaskView{
    if (!_editMaskView) {
        _editMaskView = [[UIView alloc] init];
//        _editMaskView.backgroundColor = HTColors(0, 0.4);
//        _editMaskView.layer.cornerRadius = HTWidth(5);
        _editMaskView.hidden = YES;
    }
    return _editMaskView;
}

-(UIButton *)editButton{
    if(_editButton == nil){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_editButton setImage:[UIImage imageNamed:@"banner_sticker"] forState:UIControlStateNormal];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"icon_itme_del"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = HTWidth(9);
        
        self.angle = 0;
        [self.contentView addSubview:self.htImageView];
        [self.htImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(HTWidth(63));
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
        
        
        [self.contentView addSubview:self.editMaskView];
        [self.editMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.htImageView);
        }];
        [self.editMaskView addSubview:self.editButton];
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.centerY.equalTo(self.maskView);
//            make.width.height.mas_equalTo(HTWidth(20));
            make.edges.equalTo(self.editMaskView);
        }];
     
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];//设置长按手势,longPressAction为长按后的操作
    //       [longPress setMinimumPressDuration:1];//设置按1秒之后触发事件
           [self.contentView addGestureRecognizer:longPress];//把长按手势添加到按钮
    }
    return self;
}

 
-(void)setModel:(HTModel *)model effectType:(HTARItemType)type index:(NSInteger)index{
    if(model){
        _model = model;
        self.index = index;
        [self setIsEdit:NO];//没次刷新都取消编辑效果
        if([model.category isEqualToString:@"upload"]&&model.selected!=YES){
            self.canEdit = YES;
        }else{
            self.canEdit = NO;
        }
         
        
        if([model.category isEqualToString:@"upload_watermark"]){
            [self.htImageView setImage:[UIImage imageNamed:model.icon]];
            [self setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
            [self endAnimation];
            [self hiddenDownloaded:YES];
            
        }else{
            
            
            NSString *iconUrl;
            NSString *folder;
            NSString *cachePaths;
            NSString *url;
            switch (type) {
                case HT_Sticker:
                {
                    iconUrl = [[HTEffect shareInstance] getARItemUrlBy:HTItemSticker];
                    folder = @"sticker_icon";
                    cachePaths = [[HTEffect shareInstance] getARItemPathBy:HTItemSticker];
                    url = [NSString stringWithFormat:@"%@%@",iconUrl,model.icon];
                }
                    break;
                case HT_Mask:
                {
                    iconUrl = [[HTEffect shareInstance] getARItemUrlBy:HTItemMask];
                    folder = @"mask_icon";
                    cachePaths = [[HTEffect shareInstance] getARItemPathBy:HTItemMask];
                    url = [NSString stringWithFormat:@"%@%@",iconUrl,model.icon];
                }
                    break;
                case HT_Gift:
                {
                    iconUrl = [[HTEffect shareInstance] getARItemUrlBy:HTItemGift];
                    folder = @"gift_icon";
                    cachePaths = [[HTEffect shareInstance] getARItemPathBy:HTItemGift];
                    url = [NSString stringWithFormat:@"%@%@",iconUrl,model.icon];
                }
                    break;
                case HT_WaterMark:
                {
                    iconUrl = [[HTEffect shareInstance] getARItemUrlBy:HTItemWatermark];
                    folder = @"watermark_icon";
                    cachePaths = [[HTEffect shareInstance] getARItemPathBy:HTItemWatermark];
                    url = [NSString stringWithFormat:@"%@%@",iconUrl,model.icon];
                    
                    //                iconUrl = [[HTEffect shareInstance] getWatermarkUrl];
                    //                folder = model.name;
                    //                cachePaths = [[HTEffect shareInstance] getWatermarkPath];
                    //                url = [NSString stringWithFormat:@"%@%@",iconUrl,model.icon];
                    
                }
                    break;
                default:
                    break;
            }
            
            [self.htImageView setImage:[UIImage imageNamed:@"HTImagePlaceholder.png"]];
            [HTTool getImageFromeURL:url folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
                if (image) {
                    [self.htImageView setImage:image];
                }
            }];
            
            [self setSelectedBorderHidden:!model.selected borderColor:MAIN_COLOR];
            switch (model.download) {
                case 0:// 未下载
                    [self endAnimation];
                    [self hiddenDownloaded:NO];
                    break;
                case 1:// 下载中。。。
                    [self startAnimation];
                    [self hiddenDownloaded:YES];
                    break;
                case 2:// 下载完成
                    [self endAnimation];
                    [self hiddenDownloaded:YES];
                    break;
                default:
                    break;
            }
            
            
        }
    }
}

//- (void)setHtImage:(UIImage * _Nullable)image isCancelEffect:(BOOL)isCancelEffect{
//    if(image) [self.htImageView setImage:image];
//    
//    if (isCancelEffect) {
//        [self.htImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(HTWidth(26));
//        }];
//        self.downloadIcon.hidden = YES;
//    }else{
//        [self.htImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(HTWidth(63));
//        }];
//    }
//}

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


-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if(isEdit){
        [self.editMaskView setHidden:NO];
    }else{
        [self.editMaskView setHidden:YES];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    //不能编辑不响应手势
    if(!_canEdit) return;
 
    if (sender.state == UIGestureRecognizerStateBegan) {
        AudioServicesPlaySystemSound(1520);//添加震动效果
        [self setIsEdit:YES];
        if(self.longPressEditBlock)self.longPressEditBlock(self.index);
  
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
}


-(void)clickEdit:(UIButton *)sender{
    if(self.editDeleteBlock)self.editDeleteBlock(self.index);
}

@end
