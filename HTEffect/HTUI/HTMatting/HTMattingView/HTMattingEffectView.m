//
//  HTMattingEffectView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/21.
//

#import "HTMattingEffectView.h"
#import "HTModel.h"
#import "HTMattingEffectViewCell.h"
#import "HTUIConfig.h"
#import "HTTool.h"
#import "HTDownloadZipManager.h"

@interface HTMattingEffectView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) EffectType effectType;

@end

static NSString *const HTMattingEffectViewCellId = @"HTMattingEffectViewCellId";

@implementation HTMattingEffectView

- (UICollectionView *)menuCollectionView{
    if (!_menuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = HTHeight(14);
        layout.minimumInteritemSpacing = 0;
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsVerticalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor clearColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
        [_menuCollectionView registerClass:[HTMattingEffectViewCell class] forCellWithReuseIdentifier:HTMattingEffectViewCellId];
    }
    return _menuCollectionView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        self.effectType = HT_AISegmentation;
        self.selectedModel = [[HTModel alloc] init];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        // 注册通知——》刷新功能列表
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpDateListArray:) name:@"NotificationName_HTMattingEffectView_UpDateListArray" object:nil];
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
    
    HTMattingEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTMattingEffectViewCellId forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setHtImage:[UIImage imageNamed:@"ht_none.png"] isCancelEffect:YES];
        [cell setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
    }else{
        cell.contentView.layer.masksToBounds = YES;
        cell.contentView.layer.cornerRadius = HTWidth(9);
        
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row-1]];
        
        switch (self.effectType) {
            case HT_AISegmentation:
            {
                NSString *iconUrl = [[HTEffect shareInstance] getAISegEffectUrl];
                NSString *folder = @"portrait_icon";
                NSString *cachePaths = [[HTEffect shareInstance] getAISegEffectPath];
                [HTTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl,indexModel.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
                    [cell setHtImage:image isCancelEffect:NO];
                }];
            }
                break;
            case HT_Greenscreen:
            {
                NSString *iconUrl = [[HTEffect shareInstance] getGSSegEffectUrl];
                NSString *folder = indexModel.name;
                NSString *cachePaths = [[HTEffect shareInstance] getGSSegEffectPath];
                [HTTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl,indexModel.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
                    [cell setHtImage:image isCancelEffect:NO];
                }];
            }
                break;
            default:
                break;
        }
        
        [cell setSelectedBorderHidden:!indexModel.selected borderColor:HTColor(255, 121, 180, 1.0)];
        switch (indexModel.download) {
            case 0:// 未下载
            {
                [cell endAnimation];
                [cell hiddenDownloaded:NO];
            }
                break;
            case 1:// 下载中。。。
            {
                [cell startAnimation];
                [cell hiddenDownloaded:YES];
            }
                break;
            case 2:// 下载完成
            {
                [cell endAnimation];
                [cell hiddenDownloaded:YES];
            }
                break;
            default:
                break;
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
        if (self.effectType == HT_AISegmentation) {
            [[HTEffect shareInstance] setAISegEffect:@""];
            [HTTool setFloatValue:0 forKey:@"HT_MATTING_AI_POSITION"];
        }else{
            [[HTEffect shareInstance] setGSSegEffect:@""];
            [HTTool setFloatValue:0 forKey:@"HT_MATTING_GS_POSITION"];
        }
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
                [[HTDownloadZipManager shareManager] downloadSuccessedType:(self.effectType + 1) htModel:indexModel completeBlock:^(BOOL successful) {
                    if (successful) {
                        indexModel.download = 2;
                        if(weakSelf.onClickEffectBlock){
                            weakSelf.onClickEffectBlock(indexPath.row-1, weakSelf.effectType);
                        }
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
                if (self.effectType == HT_AISegmentation) {
                    [[HTEffect shareInstance] setAISegEffect:self.selectedModel.name];
                    [HTTool setFloatValue:indexPath.row forKey:@"HT_MATTING_AI_POSITION"];
                }else{
                    [[HTEffect shareInstance] setGSSegEffect:self.selectedModel.name];
                    [HTTool setFloatValue:indexPath.row forKey:@"HT_MATTING_GS_POSITION"];
                }
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

- (void)UpDateListArray:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    self.listArr = [dic[@"data"] mutableCopy];
    self.effectType = [dic[@"type"] integerValue];
    self.selectedModel = [[HTModel alloc] init];
    NSInteger selectedIndex = 0;
    if (self.effectType == HT_AISegmentation) {
        selectedIndex = [HTTool getFloatValueForKey:@"HT_MATTING_AI_POSITION"];
    }else{
        selectedIndex = [HTTool getFloatValueForKey:@"HT_MATTING_GS_POSITION"];
    }
    if(selectedIndex >= 1){
        self.selectedModel = [[HTModel alloc] initWithDic:self.listArr[selectedIndex-1]];
        self.selectedModel.selected = YES;
        int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
        [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
    }else{
        self.selectedModel = [[HTModel alloc] init];
    }
    [self.menuCollectionView reloadData];
    
}

@end
