//
//  HTGestureView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/9/13.
//

#import "HTGestureView.h"
#import "HTModel.h"
#import "HTGestureViewCell.h"
#import "HTUIConfig.h"
#import "HTTool.h"
#import "HTDownloadZipManager.h"

@interface HTGestureView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *listArr;// 手势部分全部数据
@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) UIButton *cameraBtn;

@end

NSString *gesturePath = @"";
static NSString *const HTGestureViewCellId = @"HTGestureViewCellId";

@implementation HTGestureView

- (NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[HTTool jsonModeForPath:gesturePath withKey:@"ht_gesture_effect"] mutableCopy];
    }
    return _listArr;
}

- (UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置最小间距
        layout.minimumLineSpacing = HTHeight(14);
        layout.minimumInteritemSpacing = 0;
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsVerticalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
        [_menuCollectionView registerClass:[HTGestureViewCell class] forCellWithReuseIdentifier:HTGestureViewCellId];
    }
    return _menuCollectionView;
}

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        [_cameraBtn setTag:1];
        [_cameraBtn setImage:[UIImage imageNamed:@"ht_camera.png"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(onCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gesturePath = [[[HTEffect shareInstance] getGestureEffectPath] stringByAppendingFormat:@"ht_gesture_effect_config.json"];
        self.selectedModel = [[HTModel alloc] init];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(HTWidth(22));
        }];
        [self addSubview:self.cameraBtn];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-HTHeight(11)-[[HTAdapter shareInstance] getSaftAreaHeight]);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(HTWidth(43));
        }];
    }
    return self;
}

- (void)onCameraClick:(UIButton *)button{
    if (self.onClickCameraBlock) {
        self.onClickCameraBlock();
    }
}

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count + 1;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, HTWidth(10), 0, HTWidth(10));
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTWidth(63),HTWidth(63));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTGestureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTGestureViewCellId forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setHtImage:[UIImage imageNamed:@"ht_none.png"] isCancelEffect:YES];
        [cell setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
    }else{
        cell.contentView.layer.masksToBounds = YES;
        cell.contentView.layer.cornerRadius = HTWidth(9);
        
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        
        NSString *iconUrl = [[HTEffect shareInstance] getGestureEffectUrl];
        NSString *folder = @"portrait_icon";
        NSString *cachePaths = [[HTEffect shareInstance] getGestureEffectPath];
        [HTTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl,indexModel.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
            [cell setHtImage:image isCancelEffect:NO];
        }];
        [cell setSelectedBorderHidden:!indexModel.selected borderColor:HTColor(255, 121, 180, 1.0)];
        if (indexModel.download == 2){//下载完成
            [cell endAnimation];
            [cell hiddenDownloaded:YES];
        }else if(indexModel.download == 1){//下载中。。。
            [cell startAnimation];
            [cell hiddenDownloaded:YES];
        }else if(indexModel.download == 0){//未下载
            [cell endAnimation];
            [cell hiddenDownloaded:NO];
        }
    }
    
    return cell;
    
};

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (self.selectedModel.name) {
            self.selectedModel.selected = false;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
            [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0]]];
        }
        self.selectedModel = [[HTModel alloc] init];
        [[HTEffect shareInstance] setGestureEffect:@""];
    }else{
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        if ([self.selectedModel.name isEqual: indexModel.name]) {
            return;
        }
        switch (indexModel.download) {
            case 0:
            {
                indexModel.download = 1;
                [self.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                WeakSelf;
                [[HTDownloadZipManager shareManager] downloadSuccessedType:HT_DOWNLOAD_STATE_Gesture htModel:indexModel completeBlock:^(BOOL successful) {
                    if (successful) {
                        indexModel.download = 2;
                        NSString *gesPath = [[[HTEffect shareInstance] getGestureEffectPath] stringByAppendingFormat:@"ht_gesture_effect_config.json"];
                        [HTTool setWriteJsonDicFocKey:@"ht_gesture_effect" index:indexPath.row-1 path:gesPath];
                    }else{
                        indexModel.download = 0;
                    }
                    [weakSelf.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
            }
                break;
            case 1:
                break;
            case 2:
                indexModel.selected = true;
                [self.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                if (self.selectedModel.name) {
                    self.selectedModel.selected = false;
                    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
                    [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
                    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0],indexPath]];
                }else{
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
                self.selectedModel = indexModel;
                [[HTEffect shareInstance] setGestureEffect:self.selectedModel.name];
                break;
            default:
                break;
        }
    }
    
}

// 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        HTModel *mode = [[HTModel alloc] initWithDic:array[i]];
        if ([mode.name isEqual:title]) {
            return i;
        }
    }
    return -1;
}

@end

