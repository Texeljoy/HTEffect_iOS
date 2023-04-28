//
//  HTMattingGreenView.m
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/4/12.
//

#import "HTMattingGreenView.h"
#import "HTUIConfig.h"
#import "HTMattingEffectViewCell.h"
#import "HTModel.h"
#import "HTTool.h"
#import "HTDownloadZipManager.h"
#import "HTBeautyEffectViewCell.h"
#import "UIButton+HTImagePosition.h"

// 区分CollectionView
typedef NS_ENUM(NSInteger, GreenType) {
    GreenType_Edit              = 0, // 编辑
    GreenType_Background        = 1, // 背景
};

@interface HTMattingGreenView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleButtonArray;
@property (nonatomic, weak) UIButton *preivousButton;
@property (nonatomic, weak) UIView *underLineView;
@property (nonatomic, strong) NSMutableArray *listArray;
// 背景视图
@property (nonatomic, strong) UICollectionView *bgCollectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, assign) NSInteger downloadIndex;
@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;
// 编辑视图
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIButton *editResetButton;
@property (nonatomic, strong) UIView *editLineView;
@property (nonatomic, strong) UICollectionView *editCollectionView;
@property (nonatomic, strong) NSMutableArray *editArray;
@property (nonatomic, strong) HTModel *editSelectedModel;

@end


@implementation HTMattingGreenView

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleArray = @[
                            @"编辑",
                            @"背景"
                        ];
        _listArray = [listArr mutableCopy];
        self.cellIdentifierDic = [NSMutableDictionary dictionary];
        _editArray = [[HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTMattingEdit" ofType:@"json"] withKey:@"ht_matting_edit"] mutableCopy];
        self.editSelectedModel = [[HTModel alloc] initWithDic:_editArray[0]];
        // 创建标题栏
        [self setupTitleView];
        // 创建编辑视图
        [self setupEditView];
        // 创建背景视图
        [self setupBackgroundView];
        
        // 切换幕布背景颜色的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchScreen:) name:@"NotificationName_HTMattingSwitchScreenView_SwitchScreen" object:nil];
    }
    return self;
}

#pragma mark - CollectionView DataSource
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == GreenType_Edit) {
        return 3;
    }
    return self.listArray.count + 1;
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == GreenType_Edit) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(HTHeight(14), HTWidth(10), 55+kSafeAreaBottom, HTWidth(10));
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == GreenType_Edit) {
        return CGSizeMake(HTWidth(69) ,HTHeight(82));
    }
    return CGSizeMake(HTWidth(63),HTWidth(63));
}

// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == GreenType_Edit) {
        HTBeautyEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTMattingGreenEditCell" forIndexPath:indexPath];
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.editArray[indexPath.row]];
        
        if (indexModel.selected) {
            [cell.item setImage:[UIImage imageNamed:indexModel.selectedIcon] imageWidth:HTWidth(48) title:indexModel.name];
            [cell.item setTextColor:MAIN_COLOR];
        }else{
            [cell.item setImage:[UIImage imageNamed:indexModel.icon] imageWidth:HTWidth(48) title:indexModel.name];
            [cell.item setTextColor:HTColors(255, 1.0)];
        }
        [cell.item setTextFont:HTFontRegular(12)];
        
        return cell;
    }
    
    NSString *idkey = [NSString stringWithFormat:@"%@_1_Matting", indexPath];
    NSString *identifier = [_cellIdentifierDic objectForKey:idkey];

    if(identifier == nil){
        identifier = idkey;
        [_cellIdentifierDic setObject:identifier forKey:idkey];
        
        [collectionView registerClass:[HTMattingEffectViewCell class] forCellWithReuseIdentifier:identifier];
    }
    
    HTMattingEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell setHtImage:[UIImage imageNamed:@"ht_none.png"] isCancelEffect:YES];
        [cell setSelectedBorderHidden:YES borderColor:UIColor.clearColor];
    }else{
        cell.contentView.layer.masksToBounds = YES;
        cell.contentView.layer.cornerRadius = HTWidth(9);
        
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArray[indexPath.row-1]];
        
        [cell.htImageView setImage:[UIImage imageNamed:@"HTImagePlaceholder.png"]];
        NSString *iconUrl = [[HTEffect shareInstance] getGSSegEffectUrl];
        NSString *folder = indexModel.name;
        NSString *cachePaths = [[HTEffect shareInstance] getGSSegEffectPath];
        [HTTool getImageFromeURL:[NSString stringWithFormat:@"%@%@",iconUrl,indexModel.icon] folder:folder cachePaths:cachePaths downloadComplete:^(UIImage * _Nonnull image) {
            [cell setHtImage:image isCancelEffect:NO];
        }];
     
        [cell setSelectedBorderHidden:!indexModel.selected borderColor:MAIN_COLOR];
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
    
    if (collectionView.tag == GreenType_Edit) {
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.editArray[indexPath.row]];
        if (indexModel.selected) return;
        indexModel.selected = YES;
        [self.editArray replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
        self.editSelectedModel.selected = NO;
        int lastSelectIndex = [self getIndexForTitle:self.editSelectedModel.name withArray:self.editArray];
        [self.editArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.editSelectedModel]];
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0],indexPath]];
        self.editSelectedModel = indexModel;
        //TODO: 展示特效
//        NSInteger index = [HTTool getFloatValueForKey:HT_MATTING_SWITCHSCREEN_POSITION];
//        //TODO: 切换幕布颜色逻辑需要修改
//        [[HTEffect shareInstance] setGSSegEffect:self.selectedModel.name curtainColor:HTScreenCurtainColorMap[index]];
        
        // 通知外部滑条是否显示，展示特效
        if (self.mattingSliderHiddenBlock) {
            self.mattingSliderHiddenBlock(YES, self.editSelectedModel);
        }
        return;
    }
    
    if (indexPath.row == 0) {
        if (self.selectedModel.name) {
            self.selectedModel.selected = NO;
            int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArray];
            [self.listArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0]]];
        }
        self.selectedModel = [[HTModel alloc] init];
        // 设置特效
        [self effectWithName:@"" color:HTScreenCurtainColorMap[0] idCard:-1 value:-1];
        [HTTool setFloatValue:indexPath.row forKey:HT_MATTING_GS_POSITION];
    }else{
        HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArray[indexPath.row-1]];
        if ([self.selectedModel.name isEqualToString: indexModel.name]) {
            return;
        }
        
        if(indexModel.download == 0){
            
            indexModel.download = 1;
            [self.listArray replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            
            DownloadedType downloadedType = HT_DOWNLOAD_STATE_Greenscreen;
            NSString *itemPath = [[[HTEffect shareInstance] getGSSegEffectPath] stringByAppendingFormat:@"ht_gsseg_effect_config.json"];
            NSString *jsonKey = @"ht_gsseg_effect";
            
            self.downloadIndex = indexPath.row;
            
            //ERROR:同时下载多个文件导致完成时候顺序下标不一致 导致崩溃
            WeakSelf;
            [[HTDownloadZipManager shareManager] downloadSuccessedType:downloadedType htModel:indexModel indexPath:indexPath completeBlock:^(BOOL successful, NSIndexPath *index) {
                
                if (successful) {
                    indexModel.download = 2;
                    
                    [HTTool setWriteJsonDicFocKey:jsonKey index:index.row-1  path:itemPath];
                    if(weakSelf.mattingGreenDownladCompleteBlock){
                        weakSelf.mattingGreenDownladCompleteBlock(index.row-1);
                    }
                }else{
                    indexModel.download = 0;
                }
                // 如果下载完成后还在当前页，进行刷新
                [weakSelf.listArray replaceObjectAtIndex:index.row-1 withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[index]];
                
                // 最后一个选中的生成特效
                if (weakSelf.downloadIndex == index.row) {
                    [weakSelf collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.downloadIndex inSection:0]];
                }
            }];
        }else if(indexModel.download == 2){
            
            indexModel.selected = YES;
            [self.listArray replaceObjectAtIndex:(indexPath.row-1) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            if (self.selectedModel.name) {
                self.selectedModel.selected = NO;
                int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArray];
                [self.listArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex+1 inSection:0],indexPath]];
            }else{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
            self.selectedModel = indexModel;
            
            [HTTool setFloatValue:indexPath.row forKey:HT_MATTING_GS_POSITION];
            
            NSInteger index = [HTTool getFloatValueForKey:HT_MATTING_SWITCHSCREEN_POSITION];
            // 设置特效
            [self effectWithName:self.selectedModel.name color:HTScreenCurtainColorMap[index] idCard:self.editSelectedModel.idCard value:[HTTool getFloatValueForKey:self.editSelectedModel.key]];
            
            if (_mattingDidSelectedBlock) {
                _mattingDidSelectedBlock(self.selectedModel);
            }
        }
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

#pragma mark - 设置特效
- (void)effectWithName:(NSString *)name color:(NSString *_Nullable)color idCard:(NSInteger)idCard value:(int)value {
//    NSLog(@"========= updateGreenEffectWithValue == name: %@ \n color: %@ \n id: %zd \n value: %d \n", name, color, idCard, value);
    [[HTEffect shareInstance] setGSSegEffectScene:name];
    // 如果是取消特效，不需要设置其他特效
    if (name.length > 0) {
        [[HTEffect shareInstance] setGSSegEffectCurtain:color];
        if (idCard == 0) {
            [[HTEffect shareInstance] setGSSegEffectSimilarity:value];
        }else if (idCard == 1) {
            [[HTEffect shareInstance] setGSSegEffectSmoothness:value];
        }else {
            [[HTEffect shareInstance] setGSSegEffectTransparency:value];
        }
    }
}

#pragma mark - 切换幕布背景颜色的通知
-(void)switchScreen:(NSNotification *)notification{
    
    [self effectWithName:self.selectedModel.name color:notification.object idCard:self.editSelectedModel.idCard value:[HTTool getFloatValueForKey:self.editSelectedModel.key]];
}

#pragma mark - 编辑恢复按钮点击
- (void)resetButtonClick:(UIButton *)btn {
    
    // 通知外部弹出确认框
    if (_mattingShowAlertBlock) {
        _mattingShowAlertBlock();
    }
}

#pragma mark - 恢复按钮是否可以点击
- (void)checkRestoreButton {
    
    // 列表中如果有一个值不等于初始值，恢复按钮即可点击
    BOOL restore = NO;
    for (NSInteger i = 0; i < self.editArray.count; i++) {
        NSDictionary *dict = self.editArray[i];
        int value = [HTTool getFloatValueForKey:dict[@"key"]];
        if (value != [dict[@"defaultValue"] integerValue]) {
            // 可以恢复
            restore = YES;
            break;
        }
    }
    
    self.editResetButton.enabled = restore;
}

#pragma mark - 标题按钮点击
- (void)titleButtonClick:(UIButton *)btn {
    
    if (self.preivousButton == btn) return;
    
    self.preivousButton.selected = NO;
    btn.selected = YES;
    self.preivousButton = btn;
    
    // 下划线的位移
    NSInteger index = btn.tag-333;
    CGPoint center = self.underLineView.center;
    center.x = HTWidth(10) + (HTWidth(50) * (index +1)) - HTWidth(50)/2;
    self.underLineView.center = center;
    
    // 切换页面
    if (index == 0) {
        self.bgCollectionView.hidden = YES;
        self.editView.hidden = NO;
    }else {
        self.bgCollectionView.hidden = NO;
        self.editView.hidden = YES;
    }
    // 通知外部滑条显示或者隐藏
    [self showOrHideSilder];
}

#pragma mark - 通知外部是否显示滑条
- (void)showOrHideSilder {
    
    if (self.mattingSliderHiddenBlock) {
        self.mattingSliderHiddenBlock(self.preivousButton.tag == 333, self.editSelectedModel);
    }
}

#pragma mark - 恢复默认值
- (void)restore{
    
    self.editResetButton.enabled = NO;
    
//    [[HTEffect shareInstance] setGSSegEffectScene:@""];
//    [[HTEffect shareInstance] setGSSegEffectCurtain:HTMattingScreenGreen];
    // 恢复所有保存的编辑数值为默认值，并特效
    for (int i = 0; i < self.editArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:self.editArray[i]];
        [HTTool setFloatValue:model.defaultValue forKey:model.key];
        if (model.idCard == 0) {
            [[HTEffect shareInstance] setGSSegEffectSimilarity:(int)model.defaultValue];
        }else if (model.idCard == 1) {
            [[HTEffect shareInstance] setGSSegEffectSmoothness:(int)model.defaultValue];
        }else {
            [[HTEffect shareInstance] setGSSegEffectTransparency:(int)model.defaultValue];
        }
    }
    
    // 更新数据源
    self.editSelectedModel.selected = NO;
    int lastSelectIndex = [self getIndexForTitle:self.editSelectedModel.name withArray:self.editArray];
    [self.editArray replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.editSelectedModel]];
    
    //默认选择第一个
    HTModel *newModel1 = [[HTModel alloc] initWithDic:self.editArray[0]];
    newModel1.selected = YES;
    [self.editArray replaceObjectAtIndex:0 withObject:[HTTool getDictionaryWithHTModel:newModel1]];
    [self.editCollectionView reloadData];
    self.editSelectedModel = newModel1;
    
    // 通知外部滑条状态
    [self showOrHideSilder];
}


#pragma mark - UI
#pragma mark 创建编辑视图
- (void)setupEditView {
    
    [self addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(HTHeight(14));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(HTHeight(82));
    }];
    
    [self.editView addSubview:self.editResetButton];
    [self.editResetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editView).offset(HTWidth(20));
        make.top.equalTo(self.editView);
        make.width.mas_equalTo(HTHeight(69));
        make.height.mas_equalTo(HTHeight(70));
    }];
    
    [self.editView addSubview:self.editLineView];
    [self.editLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editResetButton.mas_right).offset(HTWidth(10));
        make.top.equalTo(self.editView).offset(HTHeight(10));
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(HTHeight(28));
    }];
    
    [self.editView addSubview:self.editCollectionView];
    [self.editCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editLineView.mas_right).offset(HTWidth(14));
        make.top.right.bottom.equalTo(self.editView);
    }];
}

#pragma mark 创建背景视图
- (void)setupBackgroundView {
    
    [self addSubview:self.bgCollectionView];
    [self.bgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
    self.bgCollectionView.hidden = YES;
}

#pragma mark 创建标题栏
- (void)setupTitleView{
    
    UIView *titleView = [[UIView alloc] init];
//    titleView.backgroundColor = [UIColor redColor];
    titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HTHeight(35));
    [self addSubview:titleView];
    _titleView = titleView;
    
    // 创建标题按钮
    [self setupTitleButton];
    // 创建下划线
    [self setupUnderLine];
}

#pragma mark 创建标题按钮
- (void)setupTitleButton{
    
    CGFloat w = HTWidth(50);
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(HTWidth(10)+w*i, HTWidth(5), w, CGRectGetHeight(self.titleView.frame)-HTWidth(5));
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = HTFontRegular(13);
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 333;
        if (i == 0) {
            btn.selected = YES;
            self.preivousButton = btn;
        }
        
        [self.titleView addSubview:btn];
        [self.titleButtonArray addObject:btn];
    }
}

#pragma mark 创建下划线
- (void)setupUnderLine{
    
    UIButton *btn = self.titleButtonArray.firstObject;
    
    UIView *underLineView = [[UIView alloc] init];
    underLineView.layer.cornerRadius = HTHeight(2)/2;
    underLineView.layer.masksToBounds = YES;
    underLineView.backgroundColor = MAIN_COLOR;
    _underLineView = underLineView;
    [self.titleView addSubview:underLineView];
    
    CGRect rect = underLineView.frame;
    rect.size.height = HTHeight(2);
    rect.origin.y = CGRectGetHeight(self.titleView.frame) - rect.size.height;
    rect.size.width = HTWidth(20);
    underLineView.frame = rect;
    
    CGPoint center = underLineView.center;
    center.x = btn.center.x;
    underLineView.center = center;

}

#pragma mark - 懒加载
- (UIView *)editView {
    if (!_editView) {
        _editView = [[UIView alloc] init];
    }
    return _editView;
}

- (UIButton *)editResetButton{
    if (!_editResetButton) {
        _editResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editResetButton setTitle:@"恢复" forState:UIControlStateNormal];
        [_editResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editResetButton setTitleColor:HTColors(189, 0.6) forState:UIControlStateDisabled];
        _editResetButton.titleLabel.font = HTFontRegular(12);
        [_editResetButton setImage:[UIImage imageNamed:@"matting_restore"] forState:UIControlStateNormal];
        [_editResetButton setImage:[UIImage imageNamed:@"matting_restore_sel"] forState:UIControlStateDisabled];
        _editResetButton.enabled = NO;
        [_editResetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editResetButton layoutButtonWithEdgeInsetsStyle:HTImagePositionTop imageTitleSpace:15];
    }
    return _editResetButton;
}

- (UIView *)editLineView{
    if (!_editLineView) {
        _editLineView = [[UIView alloc] init];
        _editLineView.backgroundColor = HTColors(255, 0.2);
    }
    return _editLineView;
}

- (UICollectionView *)editCollectionView{
    if (!_editCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _editCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _editCollectionView.showsHorizontalScrollIndicator = NO;
        _editCollectionView.backgroundColor = [UIColor clearColor];
        _editCollectionView.dataSource= self;
        _editCollectionView.delegate = self;
//        _editCollectionView.alwaysBounceHorizontal = YES;
        [_editCollectionView registerClass:[HTBeautyEffectViewCell class] forCellWithReuseIdentifier:@"HTMattingGreenEditCell"];
        _editCollectionView.tag = GreenType_Edit;
    }
    return _editCollectionView;
}

- (NSMutableArray *)titleButtonArray{
    if (_titleButtonArray == nil) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}

- (UICollectionView *)bgCollectionView{
    if (!_bgCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        _bgCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _bgCollectionView.showsVerticalScrollIndicator = NO;
        _bgCollectionView.backgroundColor = [UIColor clearColor];
        _bgCollectionView.dataSource= self;
        _bgCollectionView.delegate = self;
        _bgCollectionView.alwaysBounceVertical = YES;
        _bgCollectionView.tag = GreenType_Background;
    }
    return _bgCollectionView;
}

#pragma mark - 销毁
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
