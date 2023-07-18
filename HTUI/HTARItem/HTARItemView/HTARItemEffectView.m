//
//  HTARItemEffectView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/20.
//

#import "HTARItemEffectView.h"
#import "HTModel.h"
#import "HTARItemEffectViewCell.h"
#import "HTUIConfig.h"
#import "HTTool.h"
#import "HTDownloadZipManager.h"
#import "QZImagePickerController.h"
#import "HTUIManager.h"
#import "HTStickerView.h"
//#import <HTEffectCustomizeUI/HTStickerView.h>

@interface HTARItemEffectView ()<UICollectionViewDataSource,UICollectionViewDelegate,QZImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HTModel *selectedModel;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) HTARItemType arItmeType;

@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;

// 用于保存最后一个被选中且未下载的特效index，数组长度等于特效类型的数量，目前是4个
@property (strong, nonatomic) NSMutableArray *downloadIndexArray;
//是否在编辑中
@property (nonatomic, assign) BOOL editing;


//@property (nonatomic, strong) UIView *test1;
//@property (nonatomic, strong) UIView *test2;
//@property (nonatomic, strong) UIView *test3;
//@property (nonatomic, strong) UIView *test4;


@end

static NSString *const HTARItemEffectViewCellId = @"HTARItemEffectViewCellId";

@implementation HTARItemEffectView

//-(UIView *)testv{
//    if(_testv == nil){
//        _testv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _testv.backgroundColor = [UIColor redColor];
//
//    }
//    return _testv;
//}

#pragma mark - 懒加载
- (NSMutableArray *)downloadIndexArray {
    if (_downloadIndexArray == nil) {
        _downloadIndexArray = [NSMutableArray arrayWithArray:@[@-1, @-1, @-1, @-1]];
    }
    return _downloadIndexArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = HTHeight(14);
        // 设置尾部间距
        //        layout.footerReferenceSize = CGSizeMake(0, HTHeight(50));
        layout.minimumInteritemSpacing = 0;
        _collectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource= self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        //        [_collectionView registerClass:[HTARItemEffectViewCell class] forCellWithReuseIdentifier:HTARItemEffectViewCellId];
        
    }
    return _collectionView;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame listArr:(NSArray *)listArr{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.listArr = [listArr mutableCopy];
        self.arItmeType = HT_Sticker;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.height.equalTo(self);
        }];
        
        self.cellIdentifierDic = [NSMutableDictionary dictionary];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancEditlEevent:)];
        tapGesture.delegate = self;
        tapGesture.name = @"cancEditlTap";
        //            //将手势添加到需要相应的view中去
        [self.collectionView addGestureRecognizer:tapGesture];
        
        //        [[HTUIManager shareManager].superWindow addSubview:self.testv];
        
        
//                self.test1 = [[UIView alloc]init];
//                self.test1.backgroundColor = [UIColor redColor];
//                [[HTUIManager shareManager].superWindow addSubview:self.test1];
//                self.test2 = [[UIView alloc]init];
//                self.test2.backgroundColor = [UIColor yellowColor];
//                [[HTUIManager shareManager].superWindow addSubview:self.test2];
//                self.test3 = [[UIView alloc]init];
//                self.test3.backgroundColor = [UIColor blueColor];
//                [[HTUIManager shareManager].superWindow addSubview:self.test3];
//                self.test4 = [[UIView alloc]init];
//                self.test4.backgroundColor = [UIColor orangeColor];
//                [[HTUIManager shareManager].superWindow addSubview:self.test4];
        
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //为编辑状态 不响应手势
    return _editing;
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(HTHeight(14), HTWidth(10), 55+kSafeAreaBottom, HTWidth(10));
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HTWidth(63),HTWidth(63));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *idkey = [NSString stringWithFormat:@"%@_%ld_arItme", indexPath,self.arItmeType];
    NSString *identifier = [_cellIdentifierDic objectForKey:idkey];
    if(identifier == nil){
        identifier = idkey;
        [_cellIdentifierDic setObject:identifier forKey:idkey];
        
        [collectionView registerClass:[HTARItemEffectViewCell class] forCellWithReuseIdentifier:identifier];
    }
    
    HTARItemEffectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    [cell setModel:indexModel effectType:self.arItmeType index:indexPath.item];
    
    //长按返回当前的下标
    WeakSelf
    [cell setLongPressEditBlock:^(NSInteger index) {
        //通知view 进入了编辑状态
        weakSelf.editing = YES;
    }];
    [cell setEditDeleteBlock:^(NSInteger index) {
        [weakSelf deleteUploadItme:index];
    }];
    
    return cell;
    
};

-(void)cancEditlEevent:(UIGestureRecognizer *)sender{
    self.editing = NO;
    [self.collectionView reloadData];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTModel *indexModel = [[HTModel alloc] initWithDic:self.listArr[indexPath.row]];
    
    if(indexModel.download == 0){ // 未下载
        
        DownloadedType downloadedType = HT_DOWNLOAD_TYPE_None;
        NSString *arItemPath;
        NSString *jsonKey;
        
        switch (self.arItmeType) {
            case HT_Sticker:
                downloadedType = HT_DOWNLOAD_TYPE_Sticker;
                arItemPath = [[[HTEffect shareInstance] getARItemPathBy:HTItemSticker] stringByAppendingFormat:@"ht_sticker_config.json"];
                jsonKey = @"ht_sticker";
                break;
                
            case HT_Mask:
                downloadedType = HT_DOWNLOAD_TYPE_Mask;
                arItemPath = [[[HTEffect shareInstance] getARItemPathBy:HTItemMask] stringByAppendingFormat:@"ht_mask_config.json"];
                jsonKey = @"ht_mask";
                break;
                
            case HT_Gift:
                downloadedType = HT_DOWNLOAD_TYPE_Gift;
                arItemPath = [[[HTEffect shareInstance] getARItemPathBy:HTItemGift] stringByAppendingFormat:@"ht_gift_config.json"];
                jsonKey = @"ht_gift";
                break;
                
            case HT_WaterMark:
                //                    downloadedType = HT_DOWNLOAD_TYPE_Sticker;
                break;
                
            default:
                break;
        }
        
        indexModel.download = 1;
        [self.listArr replaceObjectAtIndex:(indexPath.row) withObject:[HTTool getDictionaryWithHTModel:indexModel]];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        // 更换对应类型选中的index
        [self.downloadIndexArray replaceObjectAtIndex:self.arItmeType withObject:@(indexPath.row)];
        
        WeakSelf;
        [[HTDownloadZipManager shareManager] downloadSuccessedType:downloadedType htModel:indexModel indexPath:indexPath completeBlock:^(BOOL successful, NSIndexPath *index) {
            
            if (successful) {
                
                indexModel.download = 2;
                
                [HTTool setWriteJsonDicFocKey:jsonKey index:index.row path:arItemPath];
                
                if(weakSelf.arDownladCompleteBlock){
                    weakSelf.arDownladCompleteBlock(index.row);
                }
            }else{
                indexModel.download = 0;
            }
            
            // 最后一个选中的index
            NSInteger sel = [weakSelf.downloadIndexArray[downloadedType-1] integerValue];
            if (downloadedType == weakSelf.arItmeType+1) {
                // 如果下载完成后还在当前页，进行刷新
                [weakSelf.listArr replaceObjectAtIndex:index.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[index]];
                
                // 最后一个选中的生成特效
                if (sel == index.row) {
                    [weakSelf collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:sel inSection:0]];
                }
            }else {
                // 如果不在当前页，下载完完成后生成特效
                if (indexModel.download == 2 && sel == index.row) {
                    [weakSelf generateEffectWithEffectType:downloadedType-1 model:indexModel index:index.row];
                }
            }
        }];
        
    }else if(indexModel.download == 2){ // 已下载
        
        if([indexModel.category isEqualToString:@"upload_watermark"]){
            
            [[HTUIManager shareManager] hideView:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HTUIManager shareManager].superWindow.hidden = YES;
                [[HTUIManager shareManager] cameraButtonShow:ShowNone];
            });
            
            QZImagePickerController *vc = [[QZImagePickerController alloc] init];
            vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            vc.qzDelegate = self;
            vc.allowsEditing = NO;
            
            [vc setViewWillDisappearBlock:^(void) {
                [[HTUIManager shareManager] showARItemView];
            }];
            [GetCurrentActivityViewController() presentViewController:vc animated:YES completion:nil];
            
            
            return;
        }
        
        //互斥逻辑
        if(![HTTool mutualExclusion:HT_ARITEM_POSITION_MAP[self.arItmeType]]){
            return;
        }
        
        if (self.selectedModel == nil) {
            // 选中效果
            indexModel.selected = YES;
            [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
            self.selectedModel = indexModel;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            // 特效
            [self generateEffectWithEffectType:self.arItmeType model:self.selectedModel index:indexPath.row];
        }else{
            // 取消效果
            if ([indexModel.name isEqualToString:self.selectedModel.name]) {
                
                indexModel.selected = NO;
                [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                self.selectedModel = nil;
                // 特效
                [self generateEffectWithEffectType:self.arItmeType model:self.selectedModel index:-1];
                
            }else{
                // 选择其他效果
                int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
                self.selectedModel.selected = NO;
                [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
                indexModel.selected = YES;
                [self.listArr replaceObjectAtIndex:indexPath.row withObject:[HTTool getDictionaryWithHTModel:indexModel]];
                
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0], indexPath]];
                self.selectedModel = indexModel;
                // 特效
                [self generateEffectWithEffectType:self.arItmeType model:self.selectedModel index:indexPath.row];
            }
        }
    }
}

#pragma mark - 设置特效
/// 设置特效的方法: index = -1:没有选择的特效，index >-1:被选中的索引
- (void)generateEffectWithEffectType:(HTARItemType)effectType model:(HTModel *)model index:(NSInteger)index {
    
    switch (effectType) {
        case HT_Sticker:
            [HTTool setFloatValue:index forKey:HT_ARITEM_STICKER_POSITION];
            [[HTEffect shareInstance] setARItem:HTItemSticker name:model.name?:@""];
            break;
        case HT_Mask:
            [HTTool setFloatValue:index forKey:HT_ARITEM_MASK_POSITION];
            [[HTEffect shareInstance] setARItem:HTItemMask name:model.name?:@""];
            break;
        case HT_Gift:
            [HTTool setFloatValue:index forKey:HT_ARITEM_GIFT_POSITION];
            [[HTEffect shareInstance] setARItem:HTItemGift name:model.name?:@""];
            break;
        case HT_WaterMark:
            [HTTool setFloatValue:index forKey:HT_ARITEM_WATERMARK_POSITION];
            [[HTEffect shareInstance] setARItem:HTItemWatermark name:model.name?:@""];
            [self addWaterMarkView:model.name?:@""];
            //TODO:qzw setARItem:HTItemWatermark
            break;
            
        default:
            break;
    }
}

#pragma mark - 清除特效
-(void)clean{
    
    if (!self.selectedModel) {
        return;
    }
    self.selectedModel.selected = false;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
    [self.listArr replaceObjectAtIndex:(lastSelectIndex) withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
    
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectIndex inSection:0]]];
    self.selectedModel = nil;
    // 特效
    [self generateEffectWithEffectType:self.arItmeType model:self.selectedModel index:-1];
}

#pragma mark - 通过name返回在数组中的位置
- (int)getIndexForTitle:(NSString *)title withArray:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        HTModel *mode = [[HTModel alloc] initWithDic:array[i]];
        if ([mode.name isEqualToString:title]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - 外部点击menu选项后刷新CollectionView
- (void)updateDataWithDict:(NSDictionary *)dic{
    
    self.listArr = [dic[@"data"] mutableCopy];
    self.arItmeType = [dic[@"type"] integerValue];
    NSInteger selectedIndex = 0;
    
    switch (self.arItmeType) {
        case HT_Sticker:
            selectedIndex = [HTTool getFloatValueForKey:HT_ARITEM_STICKER_POSITION];
            break;
        case HT_Mask:
            selectedIndex = [HTTool getFloatValueForKey:HT_ARITEM_MASK_POSITION];
            break;
        case HT_Gift:
            selectedIndex = [HTTool getFloatValueForKey:HT_ARITEM_GIFT_POSITION];
            break;
        case HT_WaterMark:
            selectedIndex = [HTTool getFloatValueForKey:HT_ARITEM_WATERMARK_POSITION];
            break;
            
        default:
            break;
    }
    
    if (selectedIndex == -1) {
        // 没有选中的特效，直接刷新数据源
        self.selectedModel = nil;
        [self.collectionView reloadData];
        return;
    }
    
    self.selectedModel = [[HTModel alloc] initWithDic:self.listArr[selectedIndex]];
    self.selectedModel.selected = YES;
    int lastSelectIndex = [self getIndexForTitle:self.selectedModel.name withArray:self.listArr];
    [self.listArr replaceObjectAtIndex:lastSelectIndex withObject:[HTTool getDictionaryWithHTModel:self.selectedModel]];
    [self.collectionView reloadData];
}



#pragma mark - QZImagePickerController Delegate 相册或者拍照
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithOriginImage:(UIImage *)image {
    
    NSString *filePath = [[HTEffect shareInstance] getARItemPathBy:HTItemWatermark];
    //    upload
    
    NSInteger count = self.listArr.count;
    NSString *itmeName = [NSString stringWithFormat:@"ht_upload_%ld",count];
    //防止命名重复
    while ([self getIndexForTitle:itmeName withArray:self.listArr] != -1) {
        count ++;
        itmeName = [NSString stringWithFormat:@"ht_upload_%ld",count];
    }
    
    NSString *itmeFolder = [NSString stringWithFormat:@"%@%@",filePath,itmeName];
    
    NSString *iconName = [itmeName stringByAppendingString:@"_icon.png"];
    NSString *iconFolder = [NSString stringWithFormat:@"%@watermark_icon",filePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL itmeFolderResult = [fileManager fileExistsAtPath:itmeFolder];
    if (!itmeFolderResult) {
        // 不存在目录 则创建
        NSError *err;
        [fileManager createDirectoryAtPath:itmeFolder withIntermediateDirectories:NO attributes:nil error:&err];
        if(err){
            [MJHUD showMessage:@"资源文件夹创建失败"];
            return;
        }
    }
    BOOL iconFolderResult = [fileManager fileExistsAtPath:iconFolder];
    if (!iconFolderResult) {
        // 不存在目录 则创建
        NSError *err;
        [fileManager createDirectoryAtPath:iconFolder withIntermediateDirectories:NO attributes:nil error:&err];
        if(err){
            [MJHUD showMessage:@"图标文件夹创建失败"];
            return;
        }
    }
    
    UIImage *iconImage = [QZImagePickerController image:image scaleToSize:CGSizeMake(128, 128)];
    
    BOOL iconImageResult = [UIImagePNGRepresentation(iconImage) writeToFile:[NSString stringWithFormat:@"%@/%@",iconFolder,iconName]   atomically:YES];
    if (!iconImageResult) {
        [MJHUD showMessage:@"上传icon图片失败"];
        return;
    }
    
    
    //保存操作
    //        [[UIScreen mainScreen] bounds].size
    
    //   压缩PNG
    float imageW = image.size.width;
    float imageH = image.size.height;
    float maxW = [[UIScreen mainScreen] bounds].size.width/2;
    float maxH = [[UIScreen mainScreen] bounds].size.height/2;
    if(imageW > imageH){
        if(imageW > maxW){
            //等比缩小
            float  scale = maxW/imageW;
            image = [QZImagePickerController image:image scaleToSize:CGSizeMake(maxW, scale *  imageH)];
        }
    }else{
        if(imageH > maxH){
            //等比缩小
            float  scale = maxH / imageH;
            image = [QZImagePickerController image:image scaleToSize:CGSizeMake(scale * imageW,maxH)];
        }
    }
    
    BOOL itmeImageResult = [UIImagePNGRepresentation(image) writeToFile:[NSString stringWithFormat:@"%@/%@.png",itmeFolder,itmeName]   atomically:YES];
    if (itmeImageResult == YES) {
        
        NSString *configPath = [filePath stringByAppendingFormat:@"ht_watermark_config.json"];
        
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        [newDic setValue:itmeName forKey:@"name"];
        [newDic setValue:@"upload" forKey:@"category"];
        [newDic setValue:iconName forKey:@"icon"];
        [newDic setValue:@2 forKey:@"download"];
        [self.listArr addObject:newDic];
        [HTTool addWriteJsonDicFocKey:@"ht_watermark" newItme:newDic path:configPath];
//        NSLog(@"====== before = %@", self.listArr);
        [self.collectionView reloadData];
    }else{
        [MJHUD showMessage:@"上传资源图片失败"];
    }
    
}

-(void)deleteUploadItme:(NSInteger)index{
    
    NSString *filePath = [[HTEffect shareInstance] getARItemPathBy:HTItemWatermark];
    NSString *configPath = [filePath stringByAppendingFormat:@"ht_watermark_config.json"];
    
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithDictionary:[HTTool getJsonDataForPath:configPath]];
    NSMutableArray *configArray = [NSMutableArray arrayWithArray:[config objectForKey:@"ht_watermark"]];
    NSDictionary *itmeDic = [configArray objectAtIndex:index];
    
    NSString *iconName = [itmeDic objectForKey:@"icon"];
    NSString *iconFolder = [NSString stringWithFormat:@"%@watermark_icon",filePath];
    
    
    NSString *itmeName = [itmeDic objectForKey:@"name"];
    NSString *itmeFolder = [NSString stringWithFormat:@"%@%@",filePath,itmeName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error1;
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",iconFolder,iconName] error:&error1];
    
    //删除整个文件夹
    NSError *error2;
    [fileManager removeItemAtPath:itmeFolder error:&error2];
    
    
    [configArray removeObject:itmeDic];
    [config setValue:configArray forKey:@"ht_watermark"];
    
//    [self.listArr removeObject:itmeDic];
    [self.listArr removeObjectAtIndex:index];

    //重新写入
    [HTTool setWriteJsonDic:config toPath:configPath];
//    NSLog(@"====== after = %@", self.listArr);
    [self.collectionView reloadData];
//    [self.collectionView performBatchUpdates:^{
//        // 在执行完插入的操作之后, 紧接着会调用UICollectionViewController的数据源方法:collectionView: numberOfItemsInSection:
//        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//
//    } completion:^(BOOL finished) {
//        [self.collectionView reloadData];
//        // 在此执行插入操作完成后的代码
//    }];
}


- (void)addWaterMarkView:(NSString *)name{
    //移除旧的
    for (UIView *old in [HTUIManager shareManager].superWindow.subviews) {
        if(old.tag == 55555){
            [old removeFromSuperview];
        }
        //        if([old isKindOfClass:[HTStickerView class]]){
        //            [old removeFromSuperview];
        //        }
    }
    
    if([name isEqualToString:@""])return;
    
    NSString *itmeFolder = [[[HTEffect shareInstance] getARItemPathBy:HTItemWatermark] stringByAppendingString:name];
    UIImage *im = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png",itmeFolder,name]];
    
    CGSize mainSize = [HTUIManager shareManager].superWindow.frame.size;
    CGSize resolutionSize = [HTUIManager shareManager].resolutionSize;
    CGRect bounds = CGRectMake(0, 0, im.size.width, im.size.height);
    CGRect imr = [HTStickerView superView:resolutionSize convertBounds:bounds toSize:mainSize];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(mainSize.width/2 - imr.size.width/2, mainSize.height/2 - imr.size.height/2, imr.size.width, imr.size.height);
    
    //    imageView.image = im;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 0.8;
    
    HTStickerView *stickerView = [[HTStickerView alloc] initWithContentView:imageView];
    stickerView.tag = 55555;
    stickerView.ctrlType = HTStickerViewCtrlTypeOne;
    [stickerView setTransformCtrlImage:[UIImage imageNamed:@"shuiyin_rotate"]];
    [stickerView setRemoveCtrlImage:[UIImage imageNamed:@"shuiyin_close"]];
    [[HTUIManager shareManager].superWindow addSubview:stickerView];
    
//    [stickerView setUpdateCurrentLocationBlock:^(CGRect rect, float degrees, CGAffineTransform transform) {
//
//        CGSize mainSize = [[UIScreen mainScreen] bounds].size;
//        CGSize resolutionSize = [HTUIManager shareManager].resolutionSize;
//        CGRect r = [HTStickerView superView:mainSize convertBounds:rect toSize:resolutionSize];
//
//        //TODO:qzw setWatermarkParam
//        [[HTEffect shareInstance] setWatermarkParam:r.origin.x/resolutionSize.width y:r.origin.y/resolutionSize.height width:r.size.width height:r.size.height rotation:360-degrees];
//
//    }];
    
    [stickerView setUpdateCornerPositionBlock:^(CGPoint topLeft, CGPoint topRight, CGPoint bottomLeft, CGPoint bottomRight) {
        
        
        CGSize mainSize = [HTUIManager shareManager].superWindow.frame.size;
        CGSize resolutionSize = [HTUIManager shareManager].resolutionSize;
        
        CGRect rect = CGRectZero;
        rect.origin = topLeft;
        CGRect rtopLeft = [HTStickerView superView:mainSize convertBounds:rect toSize:resolutionSize];
        rect.origin = topRight;
        CGRect rtopRight = [HTStickerView superView:mainSize convertBounds:rect toSize:resolutionSize];
        rect.origin = bottomLeft;
        CGRect rbottomLeft = [HTStickerView superView:mainSize convertBounds:rect toSize:resolutionSize];
        rect.origin = bottomRight;
        CGRect rbottomRight = [HTStickerView superView:mainSize convertBounds:rect toSize:resolutionSize];
        
        NSMutableArray *corners = [NSMutableArray array];
        [corners addObject:@(rtopLeft.origin.x / resolutionSize.width)];
        [corners addObject:@(rtopLeft.origin.y / resolutionSize.height)];
        [corners addObject:@(rbottomLeft.origin.x / resolutionSize.width)];
        [corners addObject:@(rbottomLeft.origin.y / resolutionSize.height)];
        [corners addObject:@(rbottomRight.origin.x / resolutionSize.width)];
        [corners addObject:@(rbottomRight.origin.y / resolutionSize.height)];
        [corners addObject:@(rtopRight.origin.x / resolutionSize.width)];
        [corners addObject:@(rtopRight.origin.y / resolutionSize.height)];
       
        [[HTEffect shareInstance] setWatermarkParam:rtopLeft.origin.x / resolutionSize.width
                                                 y1:rtopLeft.origin.y / resolutionSize.height
                                                 x2:rbottomLeft.origin.x / resolutionSize.width
                                                 y2:rbottomLeft.origin.y / resolutionSize.height
                                                 x3:rbottomRight.origin.x / resolutionSize.width
                                                 y3:rbottomRight.origin.y / resolutionSize.height
                                                 x4:rtopRight.origin.x / resolutionSize.width
                                                 y4:rtopRight.origin.y / resolutionSize.height];
         
//                self.test1.bounds = CGRectMake(0, 0, 10, 10);
//                self.test1.center = topLeft;
//                self.test2.bounds = CGRectMake(0, 0, 10, 10);
//                self.test2.center = topRight;
//                self.test3.bounds = CGRectMake(0, 0, 10, 10);
//                self.test3.center = bottomLeft;
//                self.test4.bounds = CGRectMake(0, 0, 10, 10);
//                self.test4.center = bottomRight;
    }];
    
    [stickerView allGestureEevent];
    
    WeakSelf;
    [stickerView setRemoveBlock:^{
        [weakSelf clean];
    }];
    
    
}

@end


