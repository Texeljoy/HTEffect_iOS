//
//  HTMattingEffectViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import "HTMattingEffectViewCell.h"
#import "HTUIConfig.h"
#import "HTTool.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HTMattingEffectViewCell ()

@property (nonatomic, strong) UIImageView *htImageView;
@property (nonatomic, strong) UIImageView *downloadIcon;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *downloadingIcon;
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) UIView *editMaskView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, assign) NSInteger index;

@end

@implementation HTMattingEffectViewCell

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
        _editMaskView.hidden = YES;
    }
    return _editMaskView;
}

-(UIButton *)editButton{
    if(_editButton == nil){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_editButton setImage:[UIImage imageNamed:@"icon_itme_del.png"] forState:UIControlStateNormal];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"icon_itme_del.png"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
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
        
        // 绿幕背景自定义逻辑用
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

#pragma mark - 绿幕背景赋值
- (void)setDataArray:(NSArray *)dataArray index:(NSInteger)index{
    
    self.index = index;
    [self setIsEdit:NO];//没次刷新都取消编辑效果
    
    if (index == 0) {
        [self setHtImage:[UIImage imageNamed:@"ht_none.png"] isCancelEffect:YES];
        [self setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
    }else{
        
        HTModel *model = [[HTModel alloc] initWithDic:dataArray[index-1]];
        if([model.category isEqualToString:@"upload"]&&model.selected!=YES){
            self.canEdit = YES;
        }else{
            self.canEdit = NO;
        }
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = HTWidth(9);
        
        if([model.category isEqualToString:@"upload_gsseg"]){
            [self.htImageView setImage:[UIImage imageNamed:model.icon]];
            [self setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
            [self endAnimation];
            [self hiddenDownloaded:YES];
            
        }else {
            [self.htImageView setImage:[UIImage imageNamed:@"HTImagePlaceholder.png"]];
            NSString *iconUrl = [[HTEffect shareInstance] getChromaKeyingUrl];
            NSString *folder = model.name;
            NSString *cachePaths = [[HTEffect shareInstance] getChromaKeyingPath];
            [HTTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl, model.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
                if (image) {
                    [self setHtImage:image isCancelEffect:NO];
                }
            }];
         
            [self setSelectedBorderHidden:!model.selected borderColor:MAIN_COLOR];
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
    }
}

#pragma mark - 绿幕背景自定义
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
