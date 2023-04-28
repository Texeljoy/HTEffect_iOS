//
//  HTGestureMenuView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2023/4/17.
//

#import "HTGestureMenuView.h"
#import "HTUIConfig.h"
#import "HTSubMenuViewCell.h"

@interface HTGestureMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HTGestureMenuView

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
        _collectionView.alwaysBounceHorizontal = YES;
        [_collectionView registerClass:[HTSubMenuViewCell class] forCellWithReuseIdentifier:@"HTGestureMenuViewCell"];
    }
    return _collectionView;
}



- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = listArr;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.equalTo(self);
        }];
    }
    return self;
    
}
 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTScreenWidth/5 ,HTHeight(45));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    HTSubMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTGestureMenuViewCell" forIndexPath:indexPath];
    if (self.selectedIndexPath.row == indexPath.row) {
        [cell setTitle:dic[@"name"] selected:YES textColor:HTColors(255, 1.0)];
    }else{
        [cell setTitle:dic[@"name"] selected:NO textColor:HTColors(255, 0.6)];
    }
    [cell setLineHeight:HTHeight(2)];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexPath.row == indexPath.row) return;
    
    self.selectedIndexPath = indexPath;
    NSDictionary *dic = self.listArr[indexPath.row];
    if (self.gestureMenuBlock) {
        self.gestureMenuBlock(dic[@"classify"], indexPath.row);
    }
    [collectionView reloadData];
}



@end
