//
//  HTBeautyMakeupView.m
//  HTEffectDemo
//
//  Created by Eddie on 2023/9/11.
//

#import "HTBeautyMakeupView.h"
#import "HTBeautyEffectViewCell.h"
#import "HTFilterStyleViewCell.h"
#import "HTUIConfig.h"
#import "HTModel.h"
#import "HTTool.h"
#import "HTDownloadZipManager.h"
#import "UIButton+HTImagePosition.h"

// 区分CollectionView
typedef NS_ENUM(NSInteger, MakeupLevel) {
    MakeupLevel_First         = 0, // 一级
    MakeupLevel_Second        = 1, // 二级
};

@interface HTBeautyMakeupView ()<UICollectionViewDataSource, UICollectionViewDelegate>

// 一级视图
@property (nonatomic, strong) UIView *makeupView;
@property (nonatomic, strong) HTButton *makeupResetButton;
@property (nonatomic, strong) UIView *makeupLineView;
@property (nonatomic, strong) UICollectionView *makeupCollectionView;
@property (nonatomic, strong) NSMutableArray *makeupArray;
@property (nonatomic, strong) HTModel *makeupSelectedModel;
// 二级视图
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UICollectionView *detailCollectionView;
@property (nonatomic, strong) UIImageView *backImageView;// 返回按钮
@property (nonatomic, strong) HTModel *selectedModel; // 当前选中的特效模型
@property (nonatomic, assign) NSInteger downloadIndex;
@property (nonatomic, strong) NSMutableArray *detailArray; // 二级数据列表
@property (nonatomic, strong) NSMutableArray *detailModelArray; // 二级模型数组，存放每个类别下具体特效的模型

@end


@implementation HTBeautyMakeupView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _makeupArray = [listArr mutableCopy];
        self.makeupSelectedModel = [[HTModel alloc] initWithDic:self.makeupArray[0]];
        
        // 原理：添加每个分类选中的模型, idCard表示分类, 每次选中具体特效后，替换detailModelArray中对应的模型，默认为空模型，判断依据是name的长度
        for (int i = 0; i < self.makeupArray.count; i++) {
            HTModel *model = [[HTModel alloc] init];
            model.idCard = i;
            model.selected = YES;
            model.name = @"";
            model.key = @"";
            [self.detailModelArray addObject:model];
            if (i == 0) {
                self.selectedModel = model;
            }
        }
        
        // 创建一级视图
        [self setupMakeupView];
        // 创建二级视图
        [self setupMakeupDetailView];
        
    }
    return self;
}


#pragma mark - CollectionView DataSource
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == MakeupLevel_First) {
        return self.makeupArray.count;
    }
    return self.detailArray.count + 1;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == MakeupLevel_First) {
        return UIEdgeInsetsMake(0, HTWidth(14), 0, HTWidth(14));
    }
    return UIEdgeInsetsMake(0, HTWidth(12), 0, HTWidth(12));
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == MakeupLevel_First) {
        return CGSizeMake(HTWidth(69) ,HTHeight(82));
    }
    return CGSizeMake(HTWidth(70) ,HTHeight(77));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == MakeupLevel_First) {
        HTBeautyEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTBeautyEffectViewCell" forIndexPath:indexPath];
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.makeupArray[indexPath.row]];
        [cell setBodyModel:indexModel themeWhite:self.isThemeWhite];
        
        return cell;
    }
    
    HTFilterStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTFilterStyleViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell setNoneImage:!self.selectedModel.name.length isThemeWhite:self.isThemeWhite];
    }else {
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.detailArray[indexPath.row - 1]];
        [cell setModel:indexModel isWhite:self.isThemeWhite];
    }
    
    return cell;
    
};

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == MakeupLevel_First) {
        
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.makeupArray[indexPath.row]];
        if (!indexModel.selected) {
            // 未选中状态下进行点击
            indexModel.selected = YES;
            [self.makeupArray replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            self.makeupSelectedModel.selected = NO;
            int lastSelectIndex = [self getIndexForTitle:self.makeupSelectedModel.name withArray:self.makeupArray];
            [self.makeupArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.makeupSelectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
            self.makeupSelectedModel = indexModel;
            
            // 获取数据
            NSString *itemPath = [[[HTEffect shareInstance] getMakeupPath:self.makeupSelectedModel.idCard] stringByAppendingFormat:@"/%@_config.json", self.makeupSelectedModel.name];
            NSString *jsonKey = self.makeupSelectedModel.name;
            
            [self.detailArray removeAllObjects];
            [self.detailArray addObjectsFromArray:[HTTool jsonModeForPath:itemPath withKey:jsonKey]];
            
            self.makeupView.hidden = YES;
            self.detailView.hidden = NO;
            
            // 查找具体效果并选中
            for (HTModel *model in self.detailModelArray) {
                if (model.idCard == self.makeupSelectedModel.idCard) {
                    self.selectedModel = model;
                    break;
                }
            }
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.detailArray];
            for (NSInteger i = 0; i < tempArray.count; i++) {
                HTModel *detailModel = [[HTModel alloc] initWithDic:tempArray[i]];
                if (self.selectedModel.name.length && [self.selectedModel.name isEqualToString:detailModel.name]) {
                    [self.detailArray replaceObjectAtIndex:i withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
                    break;
                }
            }
            [self.detailCollectionView reloadData];
            
        }else {
            // 选中状态依然可以进入子列表进行效果选择
            if (!self.detailArray.count) {
                // 避免第一次进第一个选项没有数据，也用于重置后第一次进来
                // 获取数据
                NSString *itemPath = [[[HTEffect shareInstance] getMakeupPath:self.makeupSelectedModel.idCard] stringByAppendingFormat:@"/%@_config.json", self.makeupSelectedModel.name];
                NSString *jsonKey = self.makeupSelectedModel.name;
                
                [self.detailArray removeAllObjects];
                [self.detailArray addObjectsFromArray:[HTTool jsonModeForPath:itemPath withKey:jsonKey]];
                [self.detailCollectionView reloadData];
            }
            
            self.makeupView.hidden = YES;
            self.detailView.hidden = NO;
        }
//        NSLog(@"55555555555555555 = %@", self.selectedModel.name);
        // 通知外部显示标题、拉条
        if (_makeupDidSelectedBlock) {
            _makeupDidSelectedBlock(YES, self.makeupSelectedModel.title, self.selectedModel.name.length, self.selectedModel);
        }
        return;
    }
    
    if (indexPath.row == 0) {
        if (!self.selectedModel.name.length) {
            return;
        }
        self.selectedModel.selected = NO;
        int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.detailArray];
        [self.detailArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
        
        self.selectedModel = [[HTModel alloc] init];
        self.selectedModel.selected = YES;
        self.selectedModel.idCard = self.makeupSelectedModel.idCard;
        self.selectedModel.name = @"";
        self.selectedModel.key = @"";
        
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0], [NSIndexPath indexPathForRow:0 inSection:0]]];
        // 设置特效
        [[HTEffect shareInstance] setMakeup:self.makeupSelectedModel.idCard name:@"" value:0];
        
    }else{
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.detailArray[indexPath.row-1]];
        if ([self.selectedModel.name isEqualToString:indexModel.name]) {
            return;
        }
        
        indexModel.selected = YES;
        [self.detailArray replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
        if (self.selectedModel.name.length) {
            // 上一个选中的不是“无”
            self.selectedModel.selected = NO;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.detailArray];
            [self.detailArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
            self.selectedModel = indexModel;
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0], indexPath]];
        }else {
            // 上一个选中的是“无”
            self.selectedModel.selected = NO;
            self.selectedModel = indexModel;
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0], indexPath]];
        }
//            self.selectedModel = indexModel;
        float selectedValue = [HTTool getFloatValueForKey:self.selectedModel.key];
        [HTTool setFloatValue:selectedValue forKey:self.selectedModel.key];
        
        // 设置特效
        [[HTEffect shareInstance] setMakeup:self.makeupSelectedModel.idCard name:self.selectedModel.name value:selectedValue];
    }
    
    // 查找具体效果并替换
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.detailModelArray];
    for (NSInteger i = 0; i < tempArray.count; i++) {
        HTModel *model = tempArray[i];
        if (model.idCard == self.selectedModel.idCard) {
            [self.detailModelArray replaceObjectAtIndex:i withObject:self.selectedModel];
            break;
        }
    }
    
    // 刷新一级界面小圆点，逻辑：只要二级列表选中任意特效，即显示小圆点，UI展示根据美妆json的defaulevalue，非0即1
    for (NSInteger i = 0; i < self.detailModelArray.count; i++) {
        HTModel *model = self.detailModelArray[i];
        HTModel *makeupModel = [[HTModel alloc] initWithDic:self.makeupArray[i]];
        if (model.name.length) {
            // 选中某一个特效
            [HTTool setFloatValue:1 forKey:makeupModel.key];
        }else {
            // 选择原图，无特效
            [HTTool setFloatValue:0 forKey:makeupModel.key];
        }
    }
    [self.makeupCollectionView reloadData];
    
    if (_makeupDidSelectedBlock) {
        _makeupDidSelectedBlock(YES, self.makeupSelectedModel.title, self.selectedModel.name.length, self.selectedModel);
    }
}


#pragma mark - 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        HTModel *mode = [[HTModel alloc] initWithDic:array[i]];
        if ([mode.name isEqual:title]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 编辑恢复按钮点击
- (void)resetButtonClick:(UIButton *)btn {
    
    // 通知外部弹出确认框
    if (_makeupShowAlertBlock) {
        _makeupShowAlertBlock();
    }
}

#pragma mark - 恢复按钮是否可以点击
- (void)checkRestoreButton {
    
    // 列表中如果有一个值不等于初始值，恢复按钮即可点击
    BOOL restore = NO;
    // 获取数据
    NSString *itemPath;
    NSString *jsonKey;
    NSMutableArray *pathArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.makeupArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:self.makeupArray[i]];
        itemPath = [[[HTEffect shareInstance] getMakeupPath:model.idCard] stringByAppendingFormat:@"/%@_config.json", model.name];
        jsonKey = model.name;
        [pathArray addObject:[HTTool jsonModeForPath:itemPath withKey:jsonKey]];
    }
    
    for (NSInteger j = 0; j < pathArray.count; j++) {
        NSArray *arr = pathArray[j];
        BOOL tempTag = NO;
        for (NSInteger i = 0; i < arr.count; i++) {
            HTModel *detailModel = [[HTModel alloc] initWithDic:arr[i]];
            int value = [HTTool getFloatValueForKey:detailModel.key];
            if (value != detailModel.defaultValue) {
                // 可以恢复
                restore = YES;
                tempTag = YES;
                break;
            }
        }
        if (tempTag) {
            break;
        }
    }
    
    if (restore) {
        [self.makeupResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset" : @"ht_reset"]];
        [self.makeupResetButton setTextColor:self.isThemeWhite ? [UIColor blackColor] : HTColors(255, 1.0)];
        self.makeupResetButton.enabled = YES;
    }else {
        [self.makeupResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset_disabled" : @"ht_reset_disabled"]];
        [self.makeupResetButton setTextColor:HTColors(189, 0.6)];
        self.makeupResetButton.enabled = NO;
    }
}

#pragma mark - 恢复默认值
- (void)restore{
    
    [self updateResetButtonState:NO];
    
    // 恢复所有保存的编辑数值为默认值，并特效
    NSString *itemPath;
    NSString *jsonKey;
    [self.detailModelArray removeAllObjects];
    for (int i = 0; i < self.makeupArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:self.makeupArray[i]];
        [HTTool setFloatValue:model.defaultValue forKey:model.key];
        itemPath = [[[HTEffect shareInstance] getMakeupPath:model.idCard] stringByAppendingFormat:@"/%@_config.json", model.name];
        jsonKey = model.name;
        NSArray *tempArray = [HTTool jsonModeForPath:itemPath withKey:jsonKey];
        for (int j = 0; j < tempArray.count; j++) {
            HTModel *detailModel = [[HTModel alloc] initWithDic:tempArray[j]];
            [HTTool setFloatValue:detailModel.defaultValue forKey:detailModel.key];
        }
        // 设置特效
        [[HTEffect shareInstance] setMakeup:model.idCard name:@"" value:0];
        
        // 默认选中第一个类型的第一个模型
        HTModel *indexModel = [[HTModel alloc] init];
        indexModel.idCard = i;
        indexModel.selected = YES;
        indexModel.name = @"";
        indexModel.key = @"";
        [self.detailModelArray addObject:indexModel];
        if (i == 0) {
            self.selectedModel = indexModel;
        }
    }
    
    // 更新数据源
    self.makeupSelectedModel.selected = NO;
    int lastSelectIndex = [self getIndexForTitle:self.makeupSelectedModel.name withArray:self.makeupArray];
    [self.makeupArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.makeupSelectedModel]];
    
    //默认选择第一个
    HTModel *newModel1 = [[HTModel alloc] initWithDic:self.makeupArray[0]];
    newModel1.selected = YES;
    [self.makeupArray replaceObjectAtIndex:0 withObject:[HTTool getDictionaryWithHTModel:newModel1]];
    [self.makeupCollectionView reloadData];
    self.makeupSelectedModel = newModel1;
    
    // 移除二级数据
    [self.detailArray removeAllObjects];
}

#pragma mark - 恢复效果，用于外界妆容推荐取消后的效果恢复，UI不动
- (void)restoreEffect {
        
    for (HTModel *model in self.detailModelArray) {
        // 设置特效
        [[HTEffect shareInstance] setMakeup:model.idCard name:model.name value:[HTTool getFloatValueForKey:model.key]];
    }
}

#pragma mark - 返回按钮点击
- (void)backToMakeupViewClick {
    
    self.makeupView.hidden = NO;
    self.detailView.hidden = YES;
    // 通知菜单栏隐藏标题
    if (_makeupDidSelectedBlock) {
        _makeupDidSelectedBlock(NO, nil, NO, nil);
    }
}

#pragma mark - 主题切换
- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    _isThemeWhite = isThemeWhite;
    self.backImageView.image = [UIImage imageNamed: isThemeWhite ? @"34_meizhuang_back" : @"meizhuang_back"];
    self.makeupLineView.backgroundColor = isThemeWhite ? [[UIColor lightGrayColor] colorWithAlphaComponent:0.6] : HTColors(255, 0.3);
    [self updateResetButtonState:self.makeupResetButton.enabled];
    [self.makeupCollectionView reloadData];
    [self.detailCollectionView reloadData];
}

#pragma mark - 更新重置按钮状态
- (void)updateResetButtonState:(BOOL)state{
    if (state) {
        [self.makeupResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset" : @"ht_reset"]];
        [self.makeupResetButton setTextColor:self.isThemeWhite ? [UIColor blackColor] : HTColors(255, 1.0)];
        self.makeupResetButton.enabled = YES;
    }else {
        [self.makeupResetButton setImage:[UIImage imageNamed:self.isThemeWhite ? @"34_ht_reset_disabled" : @"ht_reset_disabled"]];
        [self.makeupResetButton setTextColor:HTColors(189, 0.6)];
        self.makeupResetButton.enabled = NO;
    }
}

#pragma mark - UI
#pragma mark 创建美妆视图
- (void)setupMakeupView {
    
    [self addSubview:self.makeupView];
    [self.makeupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.makeupView addSubview:self.makeupResetButton];
    [self.makeupResetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.makeupView).offset(HTWidth(20));
        make.top.equalTo(self.makeupView);
        make.width.mas_equalTo(HTHeight(53));
        make.height.mas_equalTo(HTHeight(70));
    }];
    [self.makeupView addSubview:self.makeupLineView];
    [self.makeupLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.makeupResetButton.mas_right).offset(HTWidth(14));
        make.top.equalTo(self.makeupView).offset(HTHeight(7));
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(HTHeight(28));
    }];
    [self.makeupView addSubview:self.makeupCollectionView];
    [self.makeupCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.makeupLineView.mas_right);
        make.top.right.equalTo(self.makeupView);
        make.height.mas_equalTo(HTWidth(82));
    }];
}

#pragma mark - 创建二级视图
- (void)setupMakeupDetailView {
    
    [self addSubview:self.detailView];
    //    self.detailView.backgroundColor = [UIColor redColor];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    self.detailView.hidden = YES;
    
    [self.detailView addSubview:self.detailCollectionView];
    [self.detailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.detailView);
        make.height.mas_equalTo(HTHeight(77));
    }];
    
    [self.detailView addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(HTWidth(20));
        make.left.equalTo(self.detailView).offset(HTWidth(20));
        make.bottom.equalTo(self.detailView.mas_bottom).offset(-kSafeAreaBottom - HTHeight(35));
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)detailModelArray {
    if (!_detailModelArray) {
        _detailModelArray = [NSMutableArray array];
    }
    return _detailModelArray;
}

- (NSMutableArray *)detailArray {
    if (!_detailArray) {
        _detailArray = [NSMutableArray array];
    }
    return _detailArray;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meizhuang_back"]];
        _backImageView.contentMode = UIViewContentModeScaleAspectFit;
        _backImageView.userInteractionEnabled = YES;
        [_backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToMakeupViewClick)]];
    }
    return _backImageView;
}

- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
    }
    return  _detailView;
}

- (UIView *)makeupView{
    if (!_makeupView) {
        _makeupView = [[UIView alloc] init];
    }
    return _makeupView;
}
- (HTButton *)makeupResetButton{
    if (!_makeupResetButton) {
        _makeupResetButton = [[HTButton alloc] init];
        [_makeupResetButton setImageWidthAndHeight:HTWidth(45) title:[HTTool isCurrentLanguageChinese] ? @"恢复" : @"Restore"];
        [_makeupResetButton setImage:[UIImage imageNamed:@"ht_reset_disabled"]];
        [_makeupResetButton setTextColor:HTColors(189, 0.6)];
        [_makeupResetButton setTextFont:HTFontRegular(12)];
        _makeupResetButton.enabled = NO;
        [_makeupResetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _makeupResetButton;
}

- (UIView *)makeupLineView{
    if (!_makeupLineView) {
        _makeupLineView = [[UIView alloc] init];
        _makeupLineView.backgroundColor = HTColors(255, 0.2);
    }
    return _makeupLineView;
}

- (UICollectionView *)makeupCollectionView{
    if (!_makeupCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _makeupCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _makeupCollectionView.showsHorizontalScrollIndicator = NO;
        _makeupCollectionView.backgroundColor = [UIColor clearColor];
        _makeupCollectionView.dataSource= self;
        _makeupCollectionView.delegate = self;
//        _editCollectionView.alwaysBounceHorizontal = YES;
        [_makeupCollectionView registerClass:[HTBeautyEffectViewCell class] forCellWithReuseIdentifier:@"HTBeautyEffectViewCell"];
        _makeupCollectionView.tag = MakeupLevel_First;
    }
    return _makeupCollectionView;
}


- (UICollectionView *)detailCollectionView{
    if (!_detailCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 5;
        _detailCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _detailCollectionView.showsHorizontalScrollIndicator = NO;
        _detailCollectionView.backgroundColor = [UIColor clearColor];
        _detailCollectionView.dataSource= self;
        _detailCollectionView.delegate = self;
//        _detailCollectionView.alwaysBounceVertical = YES;
        [_detailCollectionView registerClass:[HTFilterStyleViewCell class] forCellWithReuseIdentifier:@"HTFilterStyleViewCell"];
        _detailCollectionView.tag = MakeupLevel_Second;
    }
    return _detailCollectionView;
}

@end
