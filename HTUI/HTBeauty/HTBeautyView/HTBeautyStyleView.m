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

@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

static NSString *const HTBeautyStyleViewCellId = @"HTBeautyStyleViewCellId";

@implementation HTBeautyStyleView

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
        [_menuCollectionView registerClass:[HTFilterStyleViewCell class] forCellWithReuseIdentifier:HTBeautyStyleViewCellId];
    }
    return _menuCollectionView;
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
        return UIEdgeInsetsMake(0, HTWidth(15), 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTWidth(65) ,HTHeight(69));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTBeautyStyleViewCellId forIndexPath:indexPath];
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    [cell.item setImage:[UIImage imageNamed:indexModel.icon] imageWidth:HTWidth(55) title:indexModel.title];
    [cell.item setTextColor:HTColors(255, 1.0)];
    [cell.item setTextBackgroundColor:[UIColor colorWithHexString:indexModel.fillColor withAlpha:1.0]];
    [cell setMaskViewColor:[UIColor colorWithHexString:indexModel.fillColor withAlpha:0.6] selected:indexModel.selected];
    [cell.item setTextFont:HTFontRegular(11)];
    
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
    
//    [[HTEffect shareInstance] setStyle:self.selectedModel.idCard];
    
//    if(self.selectedModel.idCard == 0){
//        [HTTool initEffectValue];
//    }else{
//        [[HTEffect shareInstance] setStyle:self.selectedModel.idCard];
//    }
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

@end
