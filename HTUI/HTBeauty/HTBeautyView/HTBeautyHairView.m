//
//  HTBeautyHairView.m
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/3/31.
//

#import "HTBeautyHairView.h"
#import "HTModel.h"
#import "HTFilterStyleViewCell.h"
#import "HTTool.h"

@interface HTBeautyHairView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

@implementation HTBeautyHairView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[HTFilterStyleViewCell class] forCellWithReuseIdentifier:@"HTFilterStyleViewCell"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        //获取选中的位置
        int index = [HTTool getFloatValueForKey:HT_HAIR_SELECTED_POSITION];
        HTModel *model = [[HTModel alloc] initWithDic:self.listArr[index]];
        model.selected = YES;
        [self.listArr replaceObjectAtIndex:index withObject:[HTTool getDictionaryWithHTModel:model]];
        self.selectedModel = model;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.height.equalTo(self);
        }];
    }
    return self;
    
}

#pragma mark ---UICollectionViewDataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, HTWidth(12.5), 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTWidth(70) ,HTHeight(77));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTFilterStyleViewCell" forIndexPath:indexPath];
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    [cell.item setImage:[UIImage imageNamed:indexModel.icon] imageWidth:HTWidth(55) title:indexModel.title];
    if (indexModel.selected) {
        [cell.item setTextColor:self.isThemeWhite ? [UIColor blackColor] : MAIN_COLOR];
    }else{
        [cell.item setTextColor:self.isThemeWhite ? [UIColor blackColor] : HTColors(255, 1.0)];
    }
    [cell setItemCornerRadius:HTWidth(5)];
    [cell setMaskViewColor:HTColor(185, 174, 173, 0.8) selected:indexModel.selected];
    [cell.item setTextFont:HTFontRegular(12)];
    
    return cell;
    
};

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    if (self.selectedModel.idCard == indexModel.idCard) return;
    
    indexModel.selected = YES;
    [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
    self.selectedModel.selected = NO;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
    [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
    self.selectedModel = indexModel;
//    NSString *key = [@"HT_HAIR_SLIDER" stringByAppendingFormat:@"%ld",(long)indexPath.row];
//    NSLog(@"========%d === %.2f", self.selectedModel.idCard, [HTTool getFloatValueForKey:indexModel.key]);
    [[HTEffect shareInstance] setHairStyling:self.selectedModel.idCard value:[HTTool getFloatValueForKey:indexModel.key]];
    if (self.beautyHairBlock) {
        self.beautyHairBlock(self.selectedModel, indexModel.key);
    }
    //保存美发的选中位置
    [HTTool setFloatValue:indexPath.row forKey:HT_HAIR_SELECTED_POSITION];
    
}

// 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        HTModel *mode = [[HTModel alloc] initWithDic:array[i]];
        if ([mode.title isEqual:title]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 主题切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    [self.collectionView reloadData];
}

@end
