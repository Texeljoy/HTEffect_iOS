//
//  HTFilterHahaViewCell.m
//  HTEffectDemo
//
//  Created by Eddie on 2023/4/6.
//

#import "HTFilterHahaViewCell.h"
#import "HTUIConfig.h"

@interface HTFilterHahaViewCell ()

@property (nonatomic, strong) HTModel *model;

@end

@implementation HTFilterHahaViewCell
- (HTButton *)item{
    if (!_item) {
        _item = [[HTButton alloc] init];
        _item.userInteractionEnabled = NO;
        [_item setTextColor:MAIN_COLOR];
        [_item setTextFont:HTFontRegular(12)];
    }
    return _item;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.item];
        [self.item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.contentView);
            make.width.mas_equalTo(HTWidth(55));
            make.height.mas_equalTo(HTHeight(75));
        }];
        
    }
    return self;
}
-(void)setModel:(HTModel *)model theme:(BOOL)white{
    _model = model;
    [self.item setTextColor:white ? [UIColor blackColor] : [UIColor whiteColor]];
    if (model.selected) {
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.selectedIcon] : model.selectedIcon] imageWidth:HTWidth(50) title:model.title];
    }else{
        [self.item setImage:[UIImage imageNamed:white ? [NSString stringWithFormat:@"34_%@", model.icon] : model.icon] imageWidth:HTWidth(50) title:model.title];
//        [self.item setTextColor:white ? [UIColor blackColor] : HTColors(255, 1.0)];
    }
    
}

-(void)setSel:(BOOL)sel{
    _sel = sel;
  
}


@end
