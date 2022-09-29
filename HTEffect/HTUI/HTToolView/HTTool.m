//
//  HTTool.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import "HTTool.h"
#import <objc/runtime.h>
#import "HTModel.h"

@implementation HTTool

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
            break;
        case HT_RESHAPE_SLIDER:
            [[HTEffect shareInstance] setReshape:selectModel.idCard value:value];
            break;
        case HT_FILTER_SLIDER:
            [[HTEffect shareInstance] setFilter:selectModel.name value:value];
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
        NSLog(NSLocalizedString(@"JSON解码失败", nil));
        NSLog(NSLocalizedString(@"JSON文件%@ 写入失败 error-- %@", nil),path,error);
    } else {
        [jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(NSLocalizedString(@"JSON文件%@ 写入失败 error-- %@", nil),path,error);
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
                NSLog(NSLocalizedString(@"文件夹创建失败 err %@", nil),error);
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
                NSLog(NSLocalizedString(@"图片地址URL-》%@ \n下载失败", nil),fileURL);
            }
        });
        
    }
    
}

@end
