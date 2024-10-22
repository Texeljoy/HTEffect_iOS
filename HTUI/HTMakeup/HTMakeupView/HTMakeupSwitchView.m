//
//  HTMakeupSwitchView.m
//  HTEffectDemo
//
//  Created by Eddie on 2024/8/17.
//

#import "HTMakeupSwitchView.h"
#import "HTUIConfig.h"
#import "HTTool.h"

@interface HTMakeupSwitchView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSDictionary *colorNameMapping;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger idcard;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UILabel *colorNameLabel;

@end

static NSString *const HTMakeupSwitchViewCellId = @"HTMakeupSwitchViewCellId";

@implementation HTMakeupSwitchView

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
        layout.itemSize = CGSizeMake(HTWidth(26), HTHeight(26));
        layout.minimumLineSpacing = 8;
        
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceHorizontal = YES;
        [_collectionView registerClass:[HTMakeupSwitchViewCell class] forCellWithReuseIdentifier:HTMakeupSwitchViewCellId];
        
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectedIndex = 0;
        
        self.colorNameMapping = @{
                    @"rouhefen": @"柔和粉",
                    @"dousha": @"豆沙色",
                    @"yuanqiju": @"元气橘",
                    @"zhenghong": @"正红色",
                    @"fuguhong": @"复古红",
                    @"jiaotang": @"焦糖色",
                    @"roufenzong": @"柔粉棕",
                    @"wenrouhei": @"温柔黑",
                    @"rouwuzong": @"粉雾棕",
                    @"shenzong": @"深棕色",
                    @"richang": @"日常",
                    @"yuanqi": @"元气",
                    @"jianling": @"减龄",
                    @"fenwei": @"氛围",
                    @"rixi": @"日系",
                    @"mitao": @"蜜桃"
                };
            
        self.colorArray = @[
                            @[
                                @{@"hex": @"#e66565", @"color": @"rouhefen"},//柔和粉
                                @{@"hex": @"#ce7777", @"color": @"dousha"},//豆沙色
                                @{@"hex": @"#d84f30", @"color": @"yuanqiju"},//元气橘
                                @{@"hex": @"#e62c2c", @"color": @"zhenghong"},//正红色
                                @{@"hex": @"#8f1a1a", @"color": @"fuguhong"},//复古红
                                @{@"hex": @"#8d2525", @"color": @"jiaotang"} //焦糖色
                            ],
                            @[
                                @{@"hex": @"#6e5032", @"color": @"roufenzong"},//柔粉棕
                                @{@"hex": @"#4e494a", @"color": @"wenrouhei"},//温柔黑
                                @{@"hex": @"#7c686b", @"color": @"rouwuzong"},//粉雾棕
                                @{@"hex": @"#4c3319", @"color": @"shenzong"} //深棕色
                            ],
                            @[
                                @{@"hex": @"#fdbcb7", @"color": @"richang"},//日常
                                @{@"hex": @"#ef97c7", @"color": @"yuanqi"},//元气
                                @{@"hex": @"#fb9663", @"color": @"jianling"},//减龄
                                @{@"hex": @"#e77a7a", @"color": @"fenwei"},//氛围
                                @{@"hex": @"#e79c97", @"color": @"rixi"},//日系
                                @{@"hex": @"#e35d5d", @"color": @"mitao"} //蜜桃
                            ]
                        ];
        
        NSArray *tempArray = self.colorArray[0];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.mas_equalTo(HTWidth(26)*tempArray.count + (tempArray.count-1)*8 + 20);
        }];
    }

    return self;
}

- (void)showColorNameLabel:(NSString *)colorName {
        // 获取 keyWindow
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        // 移除之前的 colorNameLabel
        UIView *existingLabel = [keyWindow viewWithTag:999];
        [existingLabel removeFromSuperview];
        // 创建 colorNameLabel
        UILabel *colorNameLabel = [[UILabel alloc] init];
        colorNameLabel.text = colorName;
        colorNameLabel.textColor = [UIColor whiteColor];
        colorNameLabel.textAlignment = NSTextAlignmentCenter;
        colorNameLabel.font = [UIFont systemFontOfSize:20];
        colorNameLabel.backgroundColor = [UIColor clearColor];
        colorNameLabel.layer.cornerRadius = 8;
        colorNameLabel.layer.masksToBounds = YES;
        colorNameLabel.hidden = NO;
        colorNameLabel.tag = 999; // 设置唯一的 tag
    
        [keyWindow addSubview:colorNameLabel];

        // 设置约束
        colorNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [colorNameLabel.centerXAnchor constraintEqualToAnchor:keyWindow.centerXAnchor],
            [colorNameLabel.centerYAnchor constraintEqualToAnchor:keyWindow.centerYAnchor],
            [colorNameLabel.widthAnchor constraintEqualToConstant:150],
            [colorNameLabel.heightAnchor constraintEqualToConstant:40]
        ]];

        // 隐藏 label
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [colorNameLabel removeFromSuperview];
        });
}


//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTMakeupSwitchViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTMakeupSwitchViewCellId forIndexPath:indexPath];
    
    BOOL sel = NO;
    if(indexPath.item == [HTTool getFloatValueForKey:HT_MAKEUP_POSITION_MAP[self.idcard]]){
        sel = YES;
    }
    
    [cell setColor:[UIColor colorWithHexString:self.dataArray[indexPath.row][@"hex"] withAlpha:1] sel:sel borderColor:self.isThemeWhite ? [UIColor blackColor] : [UIColor whiteColor]];
    
    return cell;
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.selectedIndex == indexPath.item) {
//        return;//选中同一个cell不做处理
//    }
    self.selectedIndex = indexPath.item;
    
    // 更新选中的颜色
    NSDictionary *selectedColor = self.dataArray[indexPath.row];
    NSString *colorNameKey = selectedColor[@"color"]; // 这个是英文名称
    NSString *colorName = self.colorNameMapping[colorNameKey]; // 获取对应的中文名称
    
    // 显示 colorNameLabel
    [self showColorNameLabel:colorName];
    // 保存选择
    [HTTool setFloatValue:indexPath.item forKey:HT_MAKEUP_POSITION_MAP[self.idcard]];
        
    // 通知执行美妆效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HTMakeupColorSwitchNotification" object:@{@"idCard": @(self.idcard), @"color": colorNameKey}];
    
    //TODO:换成正确的切换幕布接口
//    [[HTEffect shareInstance] setGSSegEffect:@"" curtainColor:@"#00ff00"];
    [HTTool setFloatValue:indexPath.item forKey:HT_MAKEUP_POSITION_MAP[self.idcard]];
   
    // 通知执行美妆效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HTMakeupColorSwitchNotification" object:@{@"idCard": @(self.idcard), @"color": self.dataArray[indexPath.row][@"color"]}];
    
    [collectionView reloadData];
}

- (void)updateWithIndex:(NSInteger)index {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.colorArray[index]];
    self.idcard = index;
    
    // 更新宽度
    NSArray *tempArray = self.colorArray[index];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(HTWidth(26)*tempArray.count + (tempArray.count-1)*8 + 20);
    }];
    
    [self.collectionView reloadData];
    
}

- (void)setIsThemeWhite:(BOOL)isThemeWhite {
    
    _isThemeWhite = isThemeWhite;
    
    [self.collectionView reloadData];
}

@end



@interface HTMakeupSwitchViewCell ()

@property (nonatomic, strong) UIView *contentV;

@end

@implementation HTMakeupSwitchViewCell

-(UIView *)contentV{
    if(_contentV == nil){
        _contentV = [[UIView alloc]init];
        _contentV.layer.cornerRadius = HTHeight(18)/2;
        _contentV.layer.masksToBounds = YES;
        _contentV.backgroundColor = [UIColor clearColor];
    }
    return _contentV;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = HTHeight(26)/2;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.contentV];
        [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(HTHeight(18));
        }];
        
    }
    return self;
}

-(void)setColor:(UIColor *)color sel:(BOOL)sel borderColor:(nonnull UIColor *)borderColor{
    
    self.contentV.backgroundColor = color;
    
    if(sel){
        self.contentView.layer.borderColor = borderColor.CGColor;
    }else{
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}

@end


