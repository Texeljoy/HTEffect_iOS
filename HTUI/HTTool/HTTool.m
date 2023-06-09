//
//  HTTool.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTTool.h"
#import <objc/runtime.h>
#import "HTModel.h"
#import "HTUIManager.h"


@implementation HTTool

// 重置
+ (void)resetAll {
    
    /* ========================================《 美颜 》======================================== */
    NSArray *skinBeautyArray = [HTTool jsonModeForPath:HTSkinBeautyPath withKey:@"HTSkinBeauty"];
    NSArray *faceBeautyArray = [HTTool jsonModeForPath:HTFaceBeautyPath withKey:@"HTFaceBeauty"];
    NSArray *hairArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTHair" ofType:@"json"] withKey:@"ht_hair"];
//    NSArray *styleArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTStyleBeauty" ofType:@"json"] withKey:@"HTStyleBeauty"];
   
    // 美颜
    for (int i = 0; i < skinBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:skinBeautyArray[i]];
        [HTTool setFloatValue:model.defaultValue forKey:model.key];
        [[HTEffect shareInstance] setBeauty:model.idCard value:(int)model.defaultValue];
    }
    
    // 美型
    for (int i = 0; i < faceBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:faceBeautyArray[i]];
        [HTTool setFloatValue:model.defaultValue forKey:model.key];
        [[HTEffect shareInstance] setReshape:model.idCard value:(int)model.defaultValue];
    }
    
    // 美发
    [HTTool setFloatValue:0 forKey:HT_HAIR_SELECTED_POSITION];
    for (int i = 0; i < hairArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:hairArray[i]];
        [HTTool setFloatValue:model.defaultValue forKey:model.key];
        [[HTEffect shareInstance] setHairStyling:model.idCard value:(int)model.defaultValue];
    }
    
    // 风格
    [[HTEffect shareInstance] setStyle:0];
    
    /* ========================================《 AR道具 》================================== */
    // 缓存
    [HTTool setFloatValue:-1 forKey:HT_ARITEM_STICKER_POSITION];
    [HTTool setFloatValue:-1 forKey:HT_ARITEM_MASK_POSITION];
    [HTTool setFloatValue:-1 forKey:HT_ARITEM_GIFT_POSITION];
    [HTTool setFloatValue:-1 forKey:HT_ARITEM_WATERMARK_POSITION];
    // 效果
    [[HTEffect shareInstance] setARItem:HTItemSticker name:@""];
    [[HTEffect shareInstance] setARItem:HTItemMask name:@""];
    [[HTEffect shareInstance] setARItem:HTItemGift name:@""];
    [[HTEffect shareInstance] setARItem:HTItemWatermark name:@""];
    
    /* ========================================《 AI抠图 》================================== */
    // 缓存
    [HTTool setFloatValue:0 forKey:HT_MATTING_AI_POSITION];
    [HTTool setFloatValue:0 forKey:HT_MATTING_GS_POSITION];
    
    // 特效
    // 人像抠图
    [[HTEffect shareInstance] setAISegEffect:@""];
    // 绿幕抠图
    [[HTEffect shareInstance] setGSSegEffectScene:@""];
    [[HTEffect shareInstance] setGSSegEffectCurtain:HTMattingScreenGreen];
    
    NSArray *greenEditArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTMattingEdit" ofType:@"json"] withKey:@"ht_matting_edit"];
    for (int i = 0; i < greenEditArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:greenEditArray[i]];
        [HTTool setFloatValue:model.defaultValue forKey:model.key];
        if (model.idCard == 0) {
            [[HTEffect shareInstance] setGSSegEffectSimilarity:(int)model.defaultValue];
        }else if (model.idCard == 1) {
            [[HTEffect shareInstance] setGSSegEffectSmoothness:(int)model.defaultValue];
        }else {
            [[HTEffect shareInstance] setGSSegEffectTransparency:(int)model.defaultValue];
        }
    }
    
    /* ========================================《 手势特效 》================================== */
    // 缓存
    [HTTool setFloatValue:0 forKey:HT_GESTURE_SELECTED_POSITION];
    // 效果
    [[HTEffect shareInstance] setGestureEffect:@""];
    
    /* =======================================《 滤镜 》================================= */
    // 缓存
    [HTTool setFloatValue:0 forKey:HT_STYLE_FILTER_SELECTED_POSITION];
    [HTTool setFloatValue:0 forKey:HT_EFFECT_FILTER_SELECTED_POSITION];
    [HTTool setFloatValue:0 forKey:HT_HAHA_FILTER_SELECTED_POSITION];
    // 效果
    [[HTEffect shareInstance] setFilter:HTFilterBeauty name:@""];
    [[HTEffect shareInstance] setFilter:HTFilterEffect name:@"0"];
    [[HTEffect shareInstance] setFilter:HTFilterFunny name:@"0"];
    
    //移除水印的编辑框
    for (UIView *old in [HTUIManager shareManager].superWindow.subviews) {
        if(old.tag == 55555){
            [old removeFromSuperview];
        }
//        if([old isKindOfClass:[HTStickerView class]]){
//            [old removeFromSuperview];
//        }
    }
    
    [HTTool initEffectValue];
    
}
  
 


+ (void)initEffectValue{
    NSArray *SkinBeautyArray = [HTTool jsonModeForPath:HTSkinBeautyPath withKey:@"HTSkinBeauty"];
    NSArray *FaceBeautyArray = [HTTool jsonModeForPath:HTFaceBeautyPath withKey:@"HTFaceBeauty"];
    NSArray *hairArray = [HTTool jsonModeForPath:[[NSBundle mainBundle] pathForResource:@"HTHair" ofType:@"json"] withKey:@"ht_hair"];
    
    /* ========================================《 美颜 》======================================== */
    for (int i = 0; i < SkinBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:SkinBeautyArray[i]];
        if (![HTTool judgeCacheValueIsNullForKey:model.key]) {
            [HTTool setFloatValue:model.defaultValue forKey:model.key];
        }
        [[HTEffect shareInstance] setBeauty:model.idCard value:[HTTool getFloatValueForKey:model.key]];
//        if (i == 1) {
//            // 精细磨皮指定初始值
//            if (![HTTool judgeCacheValueIsNullForKey:@"HT_SKIN_FINEBLURRINESS_SLIDER"]) {
//                [HTTool setFloatValue:60 forKey:@"HT_SKIN_FINEBLURRINESS_SLIDER"];
//            }
//            [[HTEffect shareInstance] setBeauty:HTBeautyClearSmoothing value:[HTTool getFloatValueForKey:@"HT_SKIN_FINEBLURRINESS_SLIDER"]];
//        }else{
//            
//        }
    }
    
    /* ========================================《 美型 》======================================== */
    for (int i = 0; i < FaceBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:FaceBeautyArray[i]];
        if (![HTTool judgeCacheValueIsNullForKey:model.key]) {
            [HTTool setFloatValue:model.defaultValue forKey:model.key];
        }
        [[HTEffect shareInstance] setReshape:model.idCard value:[HTTool getFloatValueForKey:model.key]];
    }
    /* ========================================《 美发 》======================================== */
    // 美发
    [HTTool setFloatValue:0 forKey:HT_HAIR_SELECTED_POSITION];
    for (int i = 0; i < hairArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:hairArray[i]];
        [HTTool setFloatValue:model.defaultValue forKey:model.key];
//        [[HTEffect shareInstance] setHair:model.idCard value:(int)model.defaultValue];
    }
    
    
    /* =============《 滤镜 TODO:滤镜拉条不单独保存 以下代码更换 》=================================== */
//    if (![HTTool judgeCacheValueIsNullForKey:HT_STYLE_FILTER_SLIDER]) {
//        [HTTool setFloatValue:100 forKey:HT_STYLE_FILTER_SLIDER];
//    }
//    if (![HTTool judgeCacheValueIsNullForKey:HT_EFFECT_FILTER_SLIDER]) {
//        [HTTool setFloatValue:100 forKey:HT_EFFECT_FILTER_SLIDER];
//    }
//    if (![HTTool judgeCacheValueIsNullForKey:HT_HAHA_FILTER_SLIDER]) {
//        [HTTool setFloatValue:100 forKey:HT_HAHA_FILTER_SLIDER];
//    }
    
    
    int stylePosition = [HTTool getFloatValueForKey:HT_STYLE_FILTER_SELECTED_POSITION];
    if(stylePosition){
        
        NSArray *filters = [HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_style_filter_config.json"] withKey:@"ht_style_filter"];
        
        HTModel *model = [[HTModel alloc] initWithDic:filters[stylePosition]];
        
        [[HTEffect shareInstance] setFilter:HTFilterBeauty name:model.name];
    }
    
    int effectPosition = [HTTool getFloatValueForKey:HT_EFFECT_FILTER_SELECTED_POSITION];
    if(effectPosition){
        
        NSArray *filters = [HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_effect_filter_config.json"] withKey:@"ht_effect_filter"];
        
        HTModel *model = [[HTModel alloc] initWithDic:filters[effectPosition]];
        
        [[HTEffect shareInstance] setFilter:HTFilterEffect name:model.name];
    }
    
    
    int hahaPosition = [HTTool getFloatValueForKey:HT_HAHA_FILTER_SELECTED_POSITION];
    if(hahaPosition){
        
        NSArray *filters = [HTTool jsonModeForPath:[[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_haha_filter_config.json"] withKey:@"ht_haha_filter"];
        
        HTModel *model = [[HTModel alloc] initWithDic:filters[hahaPosition]];
        
        [[HTEffect shareInstance] setFilter:HTFilterFunny name:model.name];
    }
    

}

+ (void)setFloatValue:(float)value forKey:(NSString *)key {
    if (key.length == 0 || key == nil) {
        return;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:value forKey:key];
        [defaults synchronize];
    }
}

+ (float)getFloatValueForKey:(NSString *)key {
    if (key.length == 0 || key == nil) {
        return 0;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        return [defaults integerForKey:key];
    }
}

+ (void)setBeautySlider:(float)value forType:(HTDataCategoryType)type withSelectMode:(HTModel *)selectModel{
    switch (type) {
        case HT_SKIN_SLIDER:
            [[HTEffect shareInstance] setBeauty:selectModel.idCard value:value];
            //            if(selectModel.idCard == HTBeautyBlurrySmoothing && value > 0){
            //                [[HTEffect shareInstance] setBeauty:HTBeautyClearSmoothing value:0];
            //                [[HTEffect shareInstance] setBeauty:selectModel.idCard value:value];
            //            }else if(selectModel.idCard == HTBeautyClearSmoothing && value > 0){
            //                [[HTEffect shareInstance] setBeauty:HTBeautyBlurrySmoothing value:0];
            //                [[HTEffect shareInstance] setBeauty:selectModel.idCard value:value];
            //            }
            //            else{
            //                [[HTEffect shareInstance] setBeauty:selectModel.idCard value:value];
            //            }
            break;
        case HT_RESHAPE_SLIDER:
            [[HTEffect shareInstance] setReshape:selectModel.idCard value:value];
            break;
        case HT_FILTER_SLIDER:
            //            [[HTEffect shareInstance] setFilter:1 name:selectModel.name value:value];
            break;
        case HT_HAIR_SLIDER:
            //            NSLog(@"===========%d ==== %.2f", selectModel.idCard, value);
            [[HTEffect shareInstance] setHairStyling:selectModel.idCard value:value];
            break;
        default:
            break;
    }
}

+ (NSDictionary*)getDictionaryWithHTModel:(id)object
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([object class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [object valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getDictionaryWithHTModel:obj];
}

+ (NSArray *)jsonModeForPath:(NSString *)path withKey:(NSString *)key
{
    NSDictionary *dic = [HTTool getJsonDataForPath:path];
    if([dic[key]  isEqual: @""]){
        return @[];
    }
    return [dic objectForKey:key];
}

+ (void)setWriteJsonDicFocKey:(NSString *)key index:(NSInteger)index path:(NSString *)path{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[HTTool getJsonDataForPath:path]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dic objectForKey:key]];
    NSMutableDictionary *dic0 = [NSMutableDictionary dictionaryWithDictionary:array[index]];
    [dic0 setValue:@(2) forKey:@"download"];
    [array setObject:dic0 atIndexedSubscript:index];
    [dic setValue:array forKey:key];
    [HTTool setWriteJsonDic:dic toPath:path];
}

+ (void)setWriteJsonDic:(NSDictionary *)dic toPath:(NSString *)path{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!jsonData || error) {
        NSLog(@"JSON解码失败");
        NSLog(@"JSON文件%@ 写入失败 error-- %@",path,error);
    } else {
        [jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"JSON文件%@ 写入失败 error-- %@",path,error);
        }
    }
    
}




+ (id)getJsonDataForPath:(NSString *)jsonPath{
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error;
    if (!jsonData) {
        NSLog(@"JSON文件%@ 解码失败 error--",jsonPath);
        return @{
            @"ht_sticker":@"",
            @"ht_watermark":@"",
            @"ht_gesture_effect":@"",
            @"ht_aiseg_effect":@"",
            @"ht_gsseg_effect":@""
        };
    } else {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        return jsonObj;
    }
    
}

+ (void)addWriteJsonDicFocKey:(NSString *)key newItme:(id)itme path:(NSString *)path{
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithDictionary:[HTTool getJsonDataForPath:path]];
    NSMutableArray *configArray = [NSMutableArray arrayWithArray:[config objectForKey:key]];
    [configArray addObject:itme];
    [config setValue:configArray forKey:key];
    //重新写入
    [HTTool setWriteJsonDic:config toPath:path];
}


+ (NSString *)judgeCacheValueIsNullForKey:(NSString *)key{
    
    if (key.length == 0 || key == nil) {
        return @"";
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *isNull = [defaults stringForKey:key];
        return isNull;
    }
    
}

+ (void)getImageFromeURL:(NSString *)fileURL folder:(NSString *)folder cachePaths:(NSString *)cachePaths downloadComplete:(void(^) (UIImage *image))completeBlock{
    
    NSString *imageName = [[fileURL componentsSeparatedByString:@"/"] lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Library/HTEffect/sticker/sticker_icon"
    NSString *folderPath = cachePaths;
    if (![folder isEqual:@""]) {
        folderPath = [cachePaths stringByAppendingFormat:@"%@/",folder];
    }
    //Library/HTEffect/sticker/sticker_icon/ht_sticker_whitebear_icon.png"
    NSString *imagePath = [folderPath stringByAppendingFormat:@"%@",imageName];
    
    if ([fileManager fileExistsAtPath:imagePath]){
        //文件存在
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        completeBlock(image);
    }else{
        if (![fileManager fileExistsAtPath:folderPath]) {
            //创建文件夹
            NSError *error = nil;
            [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"文件夹创建失败: %@", error);
            }else{}
        }
        //下载下载图片到本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:data];
                    //写入本地
                    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
                    completeBlock(image);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(nil);
                });
                NSLog(@"图片地址: %@\n下载失败", fileURL);
            }
        });
        
    }
    
}


+(BOOL)mutualExclusion:(NSString *)positionType{
    
    return YES;
    // 贴纸，面具，手势，哈哈镜
//    NSArray <NSString *>*mutualGroup = @[HT_ARITEM_STICKER_POSITION,HT_ARITEM_MASK_POSITION,HT_GESTURE_SELECTED_POSITION,HT_HAHA_FILTER_SLIDER];
//    if([mutualGroup containsObject:positionType]){
//        for (int i = 0; i<mutualGroup.count; i++) {
//            NSString * _Nonnull obj = mutualGroup[i];
//            if([HTTool getFloatValueForKey:obj]){
//                [MJHUD showMessage:@"贴纸特效无法与面具特效,请先关闭面具特效"];
//                break;
//                return NO;
//            }
//        }
//    }
    
    
    //贴纸
    if([positionType isEqualToString:HT_ARITEM_STICKER_POSITION]){
        //与面具
        if([HTTool getFloatValueForKey:HT_ARITEM_MASK_POSITION]){
            [MJHUD showMessage:@"贴纸特效无法与面具特效,请先关闭面具特效"];
            return NO;
        }
        //与手势
        if([HTTool getFloatValueForKey:HT_GESTURE_SELECTED_POSITION]){
            [MJHUD showMessage:@"贴纸特效无法与手势特效,请先关闭手势特效"];
            return NO;
        }
        //与哈哈镜
        if([HTTool getFloatValueForKey:HT_HAHA_FILTER_SELECTED_POSITION]){
            [MJHUD showMessage:@"贴纸特效与哈哈镜无法共存,请先关闭哈哈镜"];
            return NO;
        }
    }
    
    //面具
    if([positionType isEqualToString:HT_ARITEM_MASK_POSITION]){
        //与贴纸
        if([HTTool getFloatValueForKey:HT_ARITEM_STICKER_POSITION]){
            [MJHUD showMessage:@"面具特效与贴纸特效无法共存,请先关闭贴纸特效"];
            return NO;
        }
        //与手势
        if([HTTool getFloatValueForKey:HT_GESTURE_SELECTED_POSITION]){
            [MJHUD showMessage:@"贴纸特效无法与手势特效,请先关闭手势特效"];
            return NO;
        }
        //与哈哈镜
        if([HTTool getFloatValueForKey:HT_HAHA_FILTER_SELECTED_POSITION]){
            [MJHUD showMessage:@"贴纸特效与哈哈镜无法共存,请先关闭哈哈镜"];
            return NO;
        }
        
    }
    
    //手势
    if([positionType isEqualToString:HT_GESTURE_SELECTED_POSITION]){
        //与贴纸
        if([HTTool getFloatValueForKey:HT_ARITEM_STICKER_POSITION]){
            [MJHUD showMessage:@"手势特效与贴纸特效无法共存,请先关闭贴纸特效"];
            return NO;
        }
        //与面具
        if([HTTool getFloatValueForKey:HT_ARITEM_STICKER_POSITION]){
            [MJHUD showMessage:@"手势特效与面具特效无法共存,请先关闭面具特效"];
            return NO;
        }
        //与哈哈镜
        if([HTTool getFloatValueForKey:HT_HAHA_FILTER_SELECTED_POSITION]){
            [MJHUD showMessage:@"手势特效与哈哈镜无法共存,请先关闭哈哈镜"];
            return NO;
        }
    }
    
    //哈哈镜
    if([positionType isEqualToString:HT_HAHA_FILTER_SELECTED_POSITION]){
        //与贴纸
        if([HTTool getFloatValueForKey:HT_ARITEM_STICKER_POSITION]){
            [MJHUD showMessage:@"哈哈镜与贴纸特效无法共存,请先关闭贴纸特效"];
            return NO;
        }
        //与面具
        if([HTTool getFloatValueForKey:HT_ARITEM_STICKER_POSITION]){
            [MJHUD showMessage:@"哈哈镜与面具特效无法共存,请先关闭面具特效"];
            return NO;
        }
        //与手势
        if([HTTool getFloatValueForKey:HT_GESTURE_SELECTED_POSITION]){
            [MJHUD showMessage:@"哈哈镜无法与手势特效,请先关闭手势特效"];
            return NO;
        }
    }
    
    
    return YES;
}



UIViewController * GetCurrentActivityViewController(void){
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    NSLog(@"window level: %.0f", window.windowLevel);
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activityVC = nil;
    
    while (true) {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            activityVC = [(UINavigationController *)rootVC visibleViewController];
        } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
            activityVC = [(UITabBarController *)rootVC selectedViewController];
        }else if (rootVC.presentedViewController) {
            activityVC = rootVC.presentedViewController;
        } else {
            break;
        }
        
        rootVC = activityVC;
    }
    
    return (UIViewController*)activityVC;
}


+(CGRect)mapPointLocationSize:(CGSize)oSize forSize:(CGSize)tSize itmeBounds:(CGRect)bounds{
//    CGFloat scaleX = oSize.width/tSize.width;
//    CGFloat scaleY = oSize.height/tSize.height;
//
//    CGFloat rx = bounds.origin.x*scaleX;
//    CGFloat ry = bounds.origin.y*scaleY;
//    CGFloat rw = bounds.size.width*scaleX;
//    CGFloat rh = bounds.size.height*scaleY;
//    CGRect r = CGRectMake(rx, ry, rw, rh);
    
    float sWidth = oSize.width;//super width
    float sHeight = oSize.height;//super height
     
    float fWidth = tSize.width;//from width
    float fHeight = tSize.height;//from height
    
    //如果大于1则放大 小于1则缩小
//    float sfWratio = sWidth / fWidth;
    //super 相对于 from的比例
    float sfHratio = sHeight / fHeight;
    
    //默认竖屏
    //计算得到fromSize 缩进到superSize 比例的大小
    float retractWidth = fWidth * sfHratio;
//    float retractHeight = sHeight;
    
    float extraWidth = retractWidth - sWidth;
    float rx = bounds.origin.x * sfHratio + 40;
    float ry = bounds.origin.y * sfHratio + 10;
   
    float rw = bounds.size.width * sfHratio;
    float rh = bounds.size.height * sfHratio;
    
    NSLog(@"###x: %f, y: %f bounds.size.width: %f height: %f", rx, ry, rw, rh);
    
    CGRect r = CGRectMake(rx, ry, rw, rh);
    return r;
}
@end

