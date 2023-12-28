//
//  HTTool.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "HTUIConfig.h"

NS_ASSUME_NONNULL_BEGIN


//static  NSString * _Nonnull const HTScreenCurtainColorMap[3];

@interface HTTool : NSObject

/**
 * 根据2个尺寸大小映射对应尺寸上的坐标点
 *
 * @param oSize 第一个尺寸
 * @param tSize 第二个尺寸
 * @param bounds 需要映射的坐标
 * @return 返回完成的坐标点
 */
//+(CGRect)mapPointLocationSize:(CGSize)oSize forSize:(CGSize)tSize itmeBounds:(CGRect)bounds;
 
/**
 *  初始化所有参数
 */
+ (void)initEffectValue;
//设置缓存
+ (void)setFloatValue:(float)value forKey:(NSString *)key;
//获取缓存的参数
+ (float)getFloatValueForKey:(NSString *)key;

/**
 *  字符串缓存
 */
+ (void)setObject:(NSString *)value forKey:(NSString *)key;

+ (NSString *)getObjectForKey:(NSString *)key;

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
//添加新的itme到本地json
+ (void)addWriteJsonDicFocKey:(NSString *)key newItme:(id)itme path:(NSString *)path;


//下载图片并缓存的公共方法
+ (void)getImageFromeURL:(NSString *)fileURL folder:(NSString *)folder cachePaths:(NSString *)cachePaths downloadComplete:(void(^) (UIImage *image))completeBlock;

//特效互斥逻辑
+(BOOL)mutualExclusion:(NSString *)positionType;

/// 当前正在活动的的vc
extern UIViewController * GetCurrentActivityViewController(void);

/**
 *  重置所有参数
 */
+ (void)resetAll;

/**
 *  弹框
 */
+(void)showHUD:(NSString *)title;

+ (BOOL)isCurrentLanguageChinese;
@end

NS_ASSUME_NONNULL_END
