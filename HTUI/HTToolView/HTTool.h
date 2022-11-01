//
//  HTTool.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTool : NSObject

+ (void)initEffectValue;
//设置缓存
+ (void)setFloatValue:(float)value forKey:(NSString *)key;
//获取缓存的参数
+ (float)getFloatValueForKey:(NSString *)key;

+ (void)setBeautySlider:(float)value forType:(HTDataCategoryType)type withSelectMode:(HTModel *)selectModel;

// HTModel——>NSDictionary
+ (NSDictionary*)getDictionaryWithHTModel:(id)object;

//判断缓存的值是否为空
+ (NSString *)judgeCacheValueIsNullForKey:(NSString *)key;

//根据路径获取对应的json文件数据->数组
+ (NSArray *)jsonModeForPath:(NSString *)path withKey:(NSString *)key;

//根据路径获取对应的json文件数据
+ (id)getJsonDataForPath:(NSString *)path;

//根据路径将对应的字典写入json
+ (void)setWriteJsonDic:(NSDictionary *)dic toPath:(NSString *)path;
+ (void)setWriteJsonDicFocKey:(NSString *)key index:(NSInteger)index path:(NSString *)path;

//下载图片并缓存的公共方法
+ (void)getImageFromeURL:(NSString *)fileURL folder:(NSString *)folder cachePaths:(NSString *)cachePaths downloadComplete:(void(^) (UIImage *image))completeBlock;

@end

NS_ASSUME_NONNULL_END
