//
//  HTBeautyEffectViewCell.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/19.
//

#import "HTBeautyEffectViewCell.h"
#import "HTUIConfig.h"
#import "HTTool.h"

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


#pragma mark - 美体赋值
- (void)setBodyModel:(HTModel *)model themeWhite:(BOOL)white {
    
    if (model.selected) {
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.selectedIcon] : model.selectedIcon] imageWidth:HTWidth(48) title:model.title];
        [self.item setTextColor:MAIN_COLOR];
    }else{
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.icon] : model.icon] imageWidth:HTWidth(48) title:model.title];
        [self.item setTextColor:white ? [UIColor blackColor] : HTColors(255, 1.0)];
    }
    [self.item setTextFont:HTFontRegular(12)];
    
    if([HTTool getFloatValueForKey:model.key] == model.defaultValue) {
        [self.pointView setHidden:YES];
    }else{
        [self.pointView setHidden:NO];
    }
    
}

@end
