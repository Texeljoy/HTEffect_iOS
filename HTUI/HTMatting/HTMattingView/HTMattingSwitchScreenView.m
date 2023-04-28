//
//  HTMattingSwitchScreenView.m
//  HTEffectDemo
//
//  Created by Eddie on 2023/4/4.
//

#import "HTMattingSwitchScreenView.h"
#import "HTUIConfig.h"
#import "HTTool.h"




@interface HTMattingSwitchScreenView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

static NSString *const HTMattingSwitchScreenViewCellId = @"HTMattingSwitchScreenViewCellId";

@implementation HTMattingSwitchScreenView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
        layout.itemSize = CGSizeMake(HTHeight(26), HTHeight(26));
        layout.minimumLineSpacing = 8;
        
        
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceHorizontal = YES;
        [_collectionView registerClass:[HTMattingSwitchScreenViewCell class] forCellWithReuseIdentifier:HTMattingSwitchScreenViewCellId];
        
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.mas_equalTo(HTHeight(26) * 3 + 2*8 + 20);
        }];
        
//        self.selectedIndex = [HTTool getFloatValueForKey:HT_MATTING_SWITCHSCREEN_POSITION];
        
        [HTTool setFloatValue:0 forKey:HT_MATTING_SWITCHSCREEN_POSITION];
        self.selectedIndex = 0;
    }
    return self;
}


//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}


// 返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTMattingSwitchScreenViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTMattingSwitchScreenViewCellId forIndexPath:indexPath];
    
    BOOL sel = NO;
    if(indexPath.item == self.selectedIndex){
        sel = YES;
    }
    
    [cell setColor:[UIColor colorWithHexString:HTScreenCurtainColorMap[indexPath.item] withAlpha:1] Sel:sel];
    
    return cell;
    
    
}

// 选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == indexPath.item) {
        return;//选中同一个cell不做处理
    }
    self.selectedIndex = indexPath.item;
    
    //TODO:换成正确的切换幕布接口
//    [[HTEffect shareInstance] setGSSegEffect:@"" curtainColor:@"#00ff00"];
    [HTTool setFloatValue:indexPath.item forKey:HT_MATTING_SWITCHSCREEN_POSITION];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_HTMattingSwitchScreenView_SwitchScreen" object:HTScreenCurtainColorMap[indexPath.item]];
    
    [collectionView reloadData];
}



@end


@interface HTMattingSwitchScreenViewCell ()

@property (nonatomic, strong) UIView *contentV;



@end

@implementation HTMattingSwitchScreenViewCell

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

-(void)setColor:(UIColor *)color  Sel:(BOOL)sel{
    
    self.contentV.backgroundColor = color;
    
    if(sel){
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}

@end
