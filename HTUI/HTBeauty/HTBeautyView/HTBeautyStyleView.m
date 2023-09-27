//
//  HTBeautyStyleView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import "HTBeautyStyleView.h"
#import "HTUIConfig.h"
#import "HTModel.h"
#import "HTFilterStyleViewCell.h"
#import "HTTool.h"

@interface HTBeautyStyleView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

static NSString *const HTBeautyStyleViewCellId = @"HTBeautyStyleViewCellId";

@implementation HTBeautyStyleView

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
        [_collectionView registerClass:[HTFilterStyleViewCell class] forCellWithReuseIdentifier:HTBeautyStyleViewCellId];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        // 默认选中第一个
        HTModel *model = [[HTModel alloc] initWithDic:self.listArr[0]];
        model.selected = YES;
        [self.listArr replaceObjectAtIndex:0 withObject:[HTTool getDictionaryWithHTModel:model]];
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
    return UIEdgeInsetsMake(0, HTWidth(12), 0, HTWidth(12));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(HTWidth(65) ,HTHeight(69));
    return CGSizeMake(HTWidth(70) ,HTHeight(77));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTBeautyStyleViewCellId forIndexPath:indexPath];
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    
    [cell setModel:indexModel isWhite:self.isThemeWhite];
    
    return cell;
    
};

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    if ([self.selectedModel.title isEqual: indexModel.title]) {
        return;
    }
    indexModel.selected = true;
    [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
    self.selectedModel.selected = false;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
    [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
    self.selectedModel = indexModel;
    
    //保存妆容推荐的选中位置
    [HTTool setFloatValue:indexPath.row forKey:HT_LIGHT_MAKEUP_SELECTED_POSITION];
    // 设置特效
    [[HTEffect shareInstance] setStyle:self.selectedModel.idCard];
    
    if (self.onClickBlock) {
        self.onClickBlock(indexPath.row);
    }
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
