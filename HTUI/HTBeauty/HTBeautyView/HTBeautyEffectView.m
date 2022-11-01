//
//  HTBeautyEffectView.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/19.
//

#import "HTBeautyEffectView.h"
#import "HTBeautyEffectViewCell.h"
#import "HTTool.h"

@interface HTBeautyEffectView ()<UICollectionViewDataSource,UICollectionViewDelegate>

typedef NS_ENUM(NSInteger, EffectType) {
    HT_Beauty = 0, // 美肤
    HT_Reshape = 1,// 美型
};

@property (nonatomic, strong) HTButton *resetButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) BOOL subCellOpened;// 是否已经展开子cell
@property (nonatomic, assign) EffectType currentType;

@end

static NSString *const HTBeautyEffectViewCellId = @"HTBeautyEffectViewCellId";

@implementation HTBeautyEffectView

- (HTButton *)resetButton{
    if (!_resetButton) {
        _resetButton = [[HTButton alloc] init];
        [_resetButton setImage:[UIImage imageNamed:@"ht_reset_disabled.png"] imageWidth:HTWidth(42) title:@"恢复"];
        [_resetButton setTextColor:HTColors(189, 0.6)];
        [_resetButton setTextFont:HTFontRegular(10)];
        _resetButton.enabled = false;
        [_resetButton addTarget:self action:@selector(onResetClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HTColors(255, 0.2);
    }
    return _lineView;
}

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
        [_menuCollectionView registerClass:[HTBeautyEffectViewCell class] forCellWithReuseIdentifier:HTBeautyEffectViewCellId];
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
        self.currentType = HT_Beauty;
        self.selectedModel = [[HTModel alloc] initWithDic:self.listArr[0]];
        [self addSubview:self.resetButton];
        [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(HTWidth(20));
            make.top.equalTo(self);
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(62);
        }];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.resetButton.mas_right).offset(HTWidth(14));
            make.top.equalTo(self).offset(HTHeight(7));
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(HTHeight(28));
        }];
        [self addSubview:self.menuCollectionView];
        [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView.mas_right).offset(HTWidth(14));
            make.top.right.bottom.height.equalTo(self);
        }];
        // 注册通知——》刷新功能列表
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpDateListArray:) name:@"NotificationName_HTBeautyEffectView_UpDateListArray" object:nil];
    }
    return self;
    
}

- (void)onResetClick:(UIButton *)button{
    WeakSelf
    if (weakSelf.onClickResetBlock) {
        weakSelf.onClickResetBlock();
    }
}

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.listArr){
        return 0;
    }
    return self.listArr.count;
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTWidth(69) ,HTHeight(82));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTBeautyEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTBeautyEffectViewCellId forIndexPath:indexPath];
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    
    if (indexModel.selected) {
        [cell.item setImage:[UIImage imageNamed:indexModel.selectedIcon] imageWidth:HTWidth(42) title:indexModel.title];
        if ([indexModel.title isEqual: @"磨皮"]) {
            [cell.item setTextColor:HTColors(255, 1.0)];
        }else{
            [cell.item setTextColor:HTColor(255, 121, 180, 1.0)];
        }
    }else{
        [cell.item setImage:[UIImage imageNamed:indexModel.icon] imageWidth:HTWidth(42) title:indexModel.title];
        [cell.item setTextColor:HTColors(255, 1.0)];
    }
    [cell.item setTextFont:HTFontRegular(12)];
    
    if([HTTool getFloatValueForKey:indexModel.key] == 0) {
        [cell.pointView setHidden:YES];
    }else{
        [cell.pointView setHidden:NO];
    }
    
    return cell;
    
};

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    if (indexModel.opened) {
        [self openSubCell:collectionView withOpened:self.subCellOpened withStartIndex:(int)indexPath.row];
        if (!indexModel.selected) {
            indexModel.selected = true;
            //刷新数组里的数据
            [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            self.selectedModel.selected = false;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
            [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            //展开后选择展开后的第一个
            HTModel *newModel = [[HTModel alloc] initWithDic:self.listArr[2]];
            self.selectedModel = newModel;
        }else{
            indexModel.selected = false;
            [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            //默认选择第一个
            HTModel *newModel = [[HTModel alloc] initWithDic:self.listArr[0]];
            newModel.selected = true;
            [self.listArr replaceObjectAtIndex:0 withObject:[HTTool getDictionaryWithHTModel:newModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            self.selectedModel = newModel;
        }
    }else{
        if (self.subCellOpened) {
            if (indexModel.subType) {//选中展开后的子cell
                if ([self.selectedModel.title isEqual: indexModel.title]) {
                    return;//选中同一个cell不做处理
                }
                indexModel.selected = true;
                int nowSelectIndex = [self getIndexForTitle:indexModel.title withArray:self.listArr];
                [self.listArr replaceObjectAtIndex:nowSelectIndex withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                self.selectedModel.selected = false;
                int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
                [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],[NSIndexPath indexPathForRow:nowSelectIndex inSection:0]]];
            }else{
                [self openSubCell:collectionView withOpened:self.subCellOpened withStartIndex:1];
                indexModel.selected = true;
                int nowSelectIndex = [self getIndexForTitle:indexModel.title withArray:self.listArr];
                [self.listArr replaceObjectAtIndex:nowSelectIndex withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                HTModel *newModel = [[HTModel alloc] initWithDic:self.listArr[1]];
                newModel.selected = false;
                [self.listArr replaceObjectAtIndex:1 withObject:[HTTool getDictionaryWithHTModel:newModel]];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:nowSelectIndex inSection:0]]];
            }
        }else{
            if ([self.selectedModel.title isEqual: indexModel.title]) {
                return;
            }
            indexModel.selected = true;
            [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            self.selectedModel.selected = false;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
            [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
        }
        self.selectedModel = indexModel;
    }
//    switch (self.currentType) {
//        case HT_Beauty:
//            [[HTEffect shareInstance] setBeauty:self.selectedModel.idCard value:[HTTool getFloatValueForKey:self.selectedModel.key]];
//            break;
//        case HT_Reshape:
//            [[HTEffect shareInstance] setReshape:self.selectedModel.idCard value:[HTTool getFloatValueForKey:self.selectedModel.key]];
//            break;
//        default:
//            break;
//    }
    if (self.onUpdateSliderHiddenBlock) {
        self.onUpdateSliderHiddenBlock(self.selectedModel);
    }
    
}

// 展开or收回cell的子cell
- (void)openSubCell:(UICollectionView *)collectionView withOpened:(BOOL)opened withStartIndex:(int)startIndex{
    
    if (!opened) {
        NSDictionary *dic1 = @{
            @"title":@"朦胧磨皮",
            @"selected":@(true),
            @"subType":@(true),
            @"idCard":@(1),
            @"opened": @(false),
            @"icon":@"hazyBlurriness.png",
            @"selectedIcon":@"hazyBlurriness_selected.png",
            @"key":@"HT_SKIN_HAZYBLURRINESS_SLIDER",
            @"defaultValue":@(0),
            @"sliderType":@(1),
        };
        NSDictionary *dic2 = @{
            @"title":@"精细磨皮",
            @"selected":@(false),
            @"subType":@(true),
            @"idCard":@(2),
            @"opened": @(false),
            @"icon":@"fineBlurriness.png",
            @"selectedIcon":@"fineBlurriness_selected.png",
            @"key":@"HT_SKIN_FINEBLURRINESS_SLIDER",
            @"defaultValue":@(60),
            @"sliderType":@(1),
        };
        HTModel *mode1 = [[HTModel alloc] initWithDic:dic1];
        HTModel *mode2 = [[HTModel alloc] initWithDic:dic2];
        
        [collectionView performBatchUpdates:^{
            // 保持collectionView的item和数据源一致
            [self.listArr insertObject:[HTTool getDictionaryWithHTModel:mode1] atIndex:startIndex+1];
            [self.listArr insertObject:[HTTool getDictionaryWithHTModel:mode2] atIndex:startIndex+2];
            // 然后在此indexPath处插入给collectionView插入两个item
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+1 inSection:0]]];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+2 inSection:0]]];
        } completion:nil];
        self.subCellOpened = true;
    }else{
        [collectionView performBatchUpdates:^{
            [self.listArr removeObjectAtIndex:startIndex+2];
            [self.listArr removeObjectAtIndex:startIndex+1];
            [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+2 inSection:0]]];
            [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:startIndex+1 inSection:0]]];
        } completion:nil];
        self.subCellOpened = false;
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

- (void)UpDateListArray:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    self.listArr = [dic[@"data"] mutableCopy];
    self.currentType = [dic[@"type"] integerValue];
    self.selectedModel = [[HTModel alloc] initWithDic:self.listArr[0]];
    [self.menuCollectionView reloadData];
    
}

- (void)updateResetButtonState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:
            [self.resetButton setImage:[UIImage imageNamed:@"ht_reset.png"] imageWidth:HTWidth(42) title:@"恢复"];
            [self.resetButton setTextColor:HTColors(255, 1.0)];
            self.resetButton.enabled = true;
            break;
        case UIControlStateDisabled:
            [self.resetButton setImage:[UIImage imageNamed:@"ht_reset_disabled.png"] imageWidth:HTWidth(42) title:@"恢复"];
            [self.resetButton setTextColor:HTColors(189, 0.6)];
            self.resetButton.enabled = false;
            break;
        default:
            break;
    }
    [self.menuCollectionView reloadData];
}

- (void)clickResetSuccess{
    
    if (self.currentType == HT_Beauty) {
        for (int i = 0; i < self.listArr.count; i++) {
            if (i == 1) {
                [HTTool setFloatValue:60 forKey:@"HT_SKIN_FINEBLURRINESS_SLIDER"];
                [[HTEffect shareInstance] setBeauty:2 value:60];
                [HTTool setFloatValue:0 forKey:@"HT_SKIN_HAZYBLURRINESS_SLIDER"];
            }else{
                HTModel *model = [[HTModel alloc] initWithDic:self.listArr[i]];
                [HTTool setFloatValue:model.defaultValue forKey:model.key];
                [[HTEffect shareInstance] setBeauty:model.idCard value:(int)model.defaultValue];
            }
        }
    }else{
        for (int i = 0; i < self.listArr.count; i++) {
            HTModel *model = [[HTModel alloc] initWithDic:self.listArr[i]];
            [HTTool setFloatValue:model.defaultValue forKey:model.key];
            [[HTEffect shareInstance] setBeauty:model.idCard value:(int)model.defaultValue];
        }
    }
    int lastSelectIndex = -1;
    if (self.subCellOpened) {
        [self openSubCell:self.menuCollectionView withOpened:self.subCellOpened withStartIndex:1];
        HTModel *newModel2 = [[HTModel alloc] initWithDic:self.listArr[1]];
        newModel2.selected = false;
        [self.listArr replaceObjectAtIndex:1 withObject:[HTTool getDictionaryWithHTModel:newModel2]];
    }else{
        self.selectedModel.selected = false;
        lastSelectIndex = [self getIndexForTitle:self.selectedModel.title withArray:self.listArr];
        [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
    }
    //默认选择第一个
    HTModel *newModel1 = [[HTModel alloc] initWithDic:self.listArr[0]];
    newModel1.selected = true;
    [self.listArr replaceObjectAtIndex:0 withObject:[HTTool getDictionaryWithHTModel:newModel1]];
    [self.menuCollectionView reloadData];
    if (lastSelectIndex == -1) {
        [self.menuCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]]];
    }else{
        [self.menuCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
    self.selectedModel = newModel1;
    
}

@end
