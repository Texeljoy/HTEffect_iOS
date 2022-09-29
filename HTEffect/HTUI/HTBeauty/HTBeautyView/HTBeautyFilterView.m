//
//  HTBeautyFilterView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/20.
//

#import "HTBeautyFilterView.h"
#import "HTModel.h"
#import "HTFilterStyleViewCell.h"
#import "HTTool.h"

@interface HTBeautyFilterView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

static NSString *const HTFilterStyleViewCellId = @"HTFilterStyleViewCellId";

@implementation HTBeautyFilterView

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
        [_menuCollectionView registerClass:[HTFilterStyleViewCell class] forCellWithReuseIdentifier:HTFilterStyleViewCellId];
    }
    return _menuCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        //获取选中的位置
        int index = [HTTool getFloatValueForKey:@"HT_FILTER_SELECTED_POSITION"];
        HTModel *model = [[HTModel alloc] initWithDic:self.listArr[index]];
        model.selected = YES;
        [self.listArr replaceObjectAtIndex:index withObject:[HTTool getDictionaryWithHTModel:model]];
        self.selectedModel = model;
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.height.equalTo(self);
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
    
    HTFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTFilterStyleViewCellId forIndexPath:indexPath];
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    [cell.item setImage:[UIImage imageNamed:indexModel.icon] imageWidth:HTWidth(55) title:indexModel.title];
    if (indexModel.selected) {
        [cell.item setTextColor:HTColor(255, 121, 180, 1.0)];
    }else{
        [cell.item setTextColor:HTColors(255, 1.0)];
    }
    [cell setItemCornerRadius:HTWidth(5)];
    [cell setMaskViewColor:HTColor(185, 174, 173, 0.8) selected:indexModel.selected];
    [cell.item setTextFont:HTFontRegular(12)];
    
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
    NSString *key = [@"HT_FILTER_SLIDER" stringByAppendingFormat:@"%ld",(long)indexPath.row];
    [[HTEffect shareInstance] setFilter:self.selectedModel.name value:[HTTool getFloatValueForKey:key]];
    if (self.onUpdateSliderHiddenBlock) {
        self.onUpdateSliderHiddenBlock(self.selectedModel, key);
    }
    //保存滤镜的选中位置
    [HTTool setFloatValue:indexPath.row forKey:@"HT_FILTER_SELECTED_POSITION"];
    
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

@end
