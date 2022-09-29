//
//  HTOptionalView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import "HTOptionalView.h"
#import "HTMenuCell.h"
#import "HTUIConfig.h"

@interface HTOptionalView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@end

static NSString *const HTOptionalViewCellId = @"HTOptionalViewCellId";

@implementation HTOptionalView

- (UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
        [_menuCollectionView registerClass:[HTMenuCell class] forCellWithReuseIdentifier:HTOptionalViewCellId];
    }
    return _menuCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = @[
            @{
                @"title":@"美颜",
                @"image":@"ht_beauty.png",
            },
            @{
                @"title":@"AR道具",
                @"image":@"ht_ar.png",
            },
            @{
                @"title":@"手势识别",
                @"image":@"ht_gesture.png",
            },
            @{
                @"title":@"人像抠图",
                @"image":@"ht_matting.png",
            },
        ];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(HTHeight(34));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(HTHeight(65));
        }];
    }
    return self;
    
}

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTScreenWidth/4 ,HTHeight(65));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    HTMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTOptionalViewCellId forIndexPath:indexPath];
    [cell.item setImage:[UIImage imageNamed:dic[@"image"]] imageWidth:HTWidth(35) title:dic[@"title"]];
    [cell.item setTextColor:HTColors(255, 1.0)];
    
    return cell;
    
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.onClickBlock) {
        self.onClickBlock(indexPath.row);
    }
}

@end
