//
//  HTGestureEffectView.m
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/4/17.
//

#import "HTGestureEffectView.h"

#import "HTModel.h"
#import "HTGestureViewCell.h"
#import "HTUIConfig.h"
#import "HTTool.h"
#import "HTDownloadZipManager.h"

@interface HTGestureEffectView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSString *gesturePath;

@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;

@end

@implementation HTGestureEffectView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置最小间距
        layout.minimumLineSpacing = HTHeight(14);
        layout.minimumInteritemSpacing = 0;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
//        [_menuCollectionView registerClass:[HTGestureViewCell class] forCellWithReuseIdentifier:HTGestureViewCellId];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _gesturePath = [[[HTEffect shareInstance] getGestureEffectPath] stringByAppendingFormat:@"ht_gesture_effect_config.json"];
        self.selectedModel = [[HTModel alloc] init];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.cellIdentifierDic = [NSMutableDictionary dictionary];
        
        self.listArr = [listArr mutableCopy];
    }
    return self;
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
        return UIEdgeInsetsMake(HTHeight(14), HTWidth(10), 55+kSafeAreaBottom, HTWidth(10));
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
    
    NSString *idkey = [NSString stringWithFormat:@"%@_0_gesture", indexPath];
    NSString *identifier = [_cellIdentifierDic objectForKey:idkey];
    if(identifier == nil){
        identifier = idkey;
        [_cellIdentifierDic setObject:identifier forKey:idkey];
       
        [collectionView registerClass:[HTGestureViewCell class] forCellWithReuseIdentifier:identifier];
    }
     
    
    HTGestureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
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

        [cell.htImageView setImage:[UIImage imageNamed:@"HTImagePlaceholder.png"]];
        [HTTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl,indexModel.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
            [cell setHtImage:image isCancelEffect:NO];
        }];
         
        [cell setSelectedBorderHidden:!indexModel.selected borderColor:MAIN_COLOR];
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
        [HTTool setFloatValue:0 forKey:HT_GESTURE_SELECTED_POSITION];
        [[HTEffect shareInstance] setGestureEffect:@""];
    }else{
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        if ([self.selectedModel.name isEqual: indexModel.name]) {
            return;
        }
        
        //互斥逻辑
        if(![HTTool mutualExclusion:HT_GESTURE_SELECTED_POSITION]){
            return;
        }
        
        if(indexModel.download == 0){
            
            indexModel.download = 1;
            [self.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            WeakSelf;
            [[HTDownloadZipManager shareManager] downloadSuccessedType:HT_DOWNLOAD_STATE_Gesture htModel:indexModel indexPath:indexPath completeBlock:^(BOOL successful, NSIndexPath *index) {
                
                if (successful) {
                    indexModel.download = 2;
                    NSString *gesPath = [[[HTEffect shareInstance] getGestureEffectPath] stringByAppendingFormat:@"ht_gesture_effect_config.json"];
                    [HTTool setWriteJsonDicFocKey:@"ht_gesture_effect" index:index.row-1 path:gesPath];
                }else{
                    indexModel.download = 0;
                }
                [weakSelf.listArr replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }else if(indexModel.download == 2){
            
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
            
            [HTTool setFloatValue:indexPath.row forKey:HT_GESTURE_SELECTED_POSITION];
            [[HTEffect shareInstance] setGestureEffect:self.selectedModel.name];
            
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

#pragma mark - 外部点击menu选项后刷新CollectionView
- (void)updateGestureDataWithDict:(NSDictionary *)dic {
    
    
}


@end
