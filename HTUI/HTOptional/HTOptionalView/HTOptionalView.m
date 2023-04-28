//
//  HTOptionalView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTOptionalView.h"
#import "HTMenuCell.h"
#import "HTUIConfig.h"

@interface HTOptionalView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HTOptionalView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[HTMenuCell class] forCellWithReuseIdentifier:@"HTMenuCell"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HTColors(0, 0.6);
        
        self.listArr = @[
            @{
                @"title":@"美颜",
                @"image":@"function_beauty",
                @"34_image": @"34_function_beauty",
            },
            @{
                @"title":@"AR道具",
                @"image":@"function_AR",
                @"34_image": @"34_function_AR",
            },
            @{
                @"title":@"AI抠图",
                @"image":@"function_AI",
                @"34_image": @"34_function_AI",
            },
            @{
                @"title":@"手势特效",
                @"image":@"function_gesture",
                @"34_image": @"34_function_gesture",
            },
            @{
                @"title":@"滤镜",
                @"image":@"function_filter",
                @"34_image": @"34_function_filter",
            },
            
        ];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    return CGSizeMake(HTScreenWidth/self.listArr.count ,HTHeight(65));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    HTMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTMenuCell" forIndexPath:indexPath];
    [cell.item setImage:[UIImage imageNamed:self.isThemeWhite ? dic[@"34_image"] : dic[@"image"]] imageWidth:HTWidth(40) title:dic[@"title"]];
    [cell.item setTextColor:self.isThemeWhite ? [UIColor blackColor] : HTColors(255, 1.0)];
    
    return cell;
    
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.onClickOptionalBlock) {
        self.onClickOptionalBlock(indexPath.row);
    }
}

#pragma mark - 设置主题
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.backgroundColor = isThemeWhite ? [UIColor whiteColor] : HTColors(0, 0.6);
    [self.collectionView reloadData];
}

@end
