//
//  HTMattingMenuView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/21.
//

#import "HTMattingMenuView.h"
#import "HTUIConfig.h"
#import "HTSubMenuViewCell.h"
#import "HTMattingSwitchScreenView.h"

@interface HTMattingMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *menuCollectionView;

@property (nonatomic, strong) HTMattingSwitchScreenView *switchScreenView;

@end

static NSString *const HTMattingMenuViewCellId = @"HTMattingMenuViewCellId";

@implementation HTMattingMenuView

-(HTMattingSwitchScreenView *)switchScreenView{
    if(_switchScreenView == nil){
        _switchScreenView = [[HTMattingSwitchScreenView alloc]init];
    }
    return _switchScreenView;
}

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
        _menuCollectionView.alwaysBounceHorizontal = YES;
        [_menuCollectionView registerClass:[HTSubMenuViewCell class] forCellWithReuseIdentifier:HTMattingMenuViewCellId];
    }
    return _menuCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = listArr;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.menuCollectionView];
        [self addSubview:self.switchScreenView];
        
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.height.equalTo(self);
            make.right.equalTo(self.switchScreenView.mas_left);
        }];
         
        [self.switchScreenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.height.equalTo(self);
        }];
        
    }
    return self;
    
}

#pragma mark - 显示or隐藏绿幕按钮
-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;
    
   
    if(selectedIndexPath.item == 1){//绿幕抠图
        [UIView animateWithDuration:0.22 animations:^{
            [self.switchScreenView setAlpha:1];
        }];
    }else{
        [UIView animateWithDuration:0.22 animations:^{
            [self.switchScreenView setAlpha:0];
        }];
    }
}

//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTScreenWidth/5 ,HTHeight(43));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.listArr[indexPath.row];
    HTSubMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTMattingMenuViewCellId forIndexPath:indexPath];
    if (self.selectedIndexPath.row == indexPath.row) {
        [cell setTitle:dic[@"name"] selected:YES textColor:HTColors(255, 1.0)];
    }else{
        [cell setTitle:dic[@"name"] selected:NO textColor:HTColors(255, 0.6)];
    }
    [cell setLineHeight:HTHeight(2)];
    return cell;
    
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexPath.row == indexPath.row) {
        return;//选中同一个cell不做处理
    }
    self.selectedIndexPath = indexPath;
    NSDictionary *dic = self.listArr[indexPath.row];
    if (self.mattingOnClickBlock) {
        self.mattingOnClickBlock(dic[@"classify"],indexPath.row);
    }
    [collectionView reloadData];
}

@end
