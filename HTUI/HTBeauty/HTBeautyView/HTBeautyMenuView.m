//
//  HTBeautyMenuView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTBeautyMenuView.h"
#import "HTBeautyMenuViewCell.h"
#import "HTUIConfig.h"

@interface HTBeautyMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *listArr;

@end

static NSString *const HTBeautyMenuViewCellId = @"HTBeautyMenuViewCellId";

@implementation HTBeautyMenuView

- (UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
        _menuCollectionView.alwaysBounceHorizontal = YES;
        [_menuCollectionView registerClass:[HTBeautyMenuViewCell class] forCellWithReuseIdentifier:HTBeautyMenuViewCellId];
    }
    return _menuCollectionView;
}

- (UILabel *)makeupTitleLabel {
    if (!_makeupTitleLabel) {
        _makeupTitleLabel = [[UILabel alloc] init];
        _makeupTitleLabel.textAlignment = NSTextAlignmentCenter;
        _makeupTitleLabel.font = HTFontRegular(15);
        _makeupTitleLabel.textColor = HTColors(255, 1.0);
    }
    return _makeupTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = listArr;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(self);
        }];
        
        [self addSubview:self.makeupTitleLabel];
        self.makeupTitleLabel.hidden = YES;
        [self.makeupTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(self);
        }];
    }
    return self;
    
}

#pragma mark ---UICollectionViewDataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTWidth(70) ,HTHeight(45));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    HTBeautyMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTBeautyMenuViewCellId forIndexPath:indexPath];
    if (self.selectedIndexPath.row == indexPath.row) {
        [cell setTitle:dic[@"name"] textColor:MAIN_COLOR];
    }else{
        [cell setTitle:dic[@"name"] textColor:self.isThemeWhite ? [UIColor blackColor] : HTColors(255, 1.0)];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexPath.row == indexPath.row) return;
    
    NSDictionary *dic = self.listArr[indexPath.row];
    if (self.onClickBlock) {
        self.onClickBlock(dic[@"classify"]);
    }
    if (!self.disabled) {
        self.selectedIndexPath = indexPath;
        [collectionView reloadData];
    }
}

#pragma mark - 主题色切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.makeupTitleLabel.textColor = isThemeWhite ? [UIColor blackColor] : HTColors(255, 1.0);
    [self.menuCollectionView reloadData];
}

@end
