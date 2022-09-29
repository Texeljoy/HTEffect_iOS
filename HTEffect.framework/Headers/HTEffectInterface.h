//
//  HTEffectInterface.h
//  HTEffect
//
//  Created by HTLab on 2022/06/29.
//  Copyright © 2022 TexelJoy Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/gltypes.h>

@protocol HTEffectDelegate <NSObject>

/**
 * 网络鉴权初始化成功回调函数
 */
- (void)onInitSuccess;

/**
 * 网络鉴权初始化失败回调函数
 */
- (void)onInitFailure;
 
@end

@interface HTEffect: NSObject

#pragma mark - 数据类型

/**
 * 美肤类型枚举
 */
typedef NS_ENUM(NSInteger, HTBeautyTypes) {
    HTBeautySkinWhitening       = 0, // 美白，0~100，0为无效果
    HTBeautyBlurrySmoothing     = 1, // 朦胧磨皮，0~100，0为无效果
    HTBeautyClearSmoothing      = 2, // 精细磨皮，0~100，0为无效果
    HTBeautySkinRosiness        = 3, // 红润，0~100，0为无效果
    HTBeautyImageSharpness      = 4, // 清晰，0~100，0为无效果
    HTBeautyImageBrightness     = 5, // 亮度，-50~50，0为无效果
    HTBeautyDarkCircleLessening = 6, // 去黑眼圈，0~100，0为无效果
    HTBeautyNasolabialLessening = 7  // 去法令纹，0~100，0为无效果
};

/**
 * 美型类型枚举
 */
typedef NS_ENUM(NSInteger, HTReshapeTypes) {
    // 眼睛
    HTReshapeEyeEnlarging       = 10, // 大眼，0-100，0为无效果
    HTReshapeEyeRounding        = 11, // 圆眼，0-100，0为无效果
    HTReshapeEyeSpaceTrimming   = 12, // 眼间距，-50-50， 0为无效果
    HTReshapeEyeCornerTrimming  = 13, // 眼睛角度，-50-50， 0为无效果
    HTReshapeEyeCornerEnlarging = 14, // 开眼角，0-100， 0为无效果
    // 脸廓
    HTReshapeCheekThinning      = 20, // 瘦脸，0-100，0为无效果
    HTReshapeCheekVShaping      = 21, // V脸，0-100，0为无效果
    HTReshapeCheekNarrowing     = 22, // 窄脸，0-100，0为无效果
    HTReshapeCheekboneThinning  = 23, // 瘦颧骨，0-100，0为无效果
    HTReshapeJawboneThinning    = 24, // 瘦下颌骨，0-100，0为无效果
    HTReshapeTempleEnlarging    = 25, // 丰太阳穴，0-100，0为无效果
    HTReshapeHeadLessening      = 26, // 小头，0-100，0为无效果
    HTReshapeFaceLessening      = 27, // 小脸，0-100，0为无效果
    HTReshapeCheekShortening    = 28, // 短脸，0-100，0为无效果
    // 鼻部
    HTReshapeNoseEnlarging      = 30, // 长鼻
    HTReshapeNoseThinning       = 31, // 瘦鼻，0-100，0为无效果
    HTReshapeNoseApexLessening  = 32, // 鼻头，0-100，0为无效果
    HTReshapeNoseRootEnlarging  = 33, // 山根，0-100，0为无效果
    // 嘴部
    HTReshapeMouthTrimming      = 40, // 嘴型，-50-50， 0为无效果
    HTReshapeMouthSmiling       = 41, // 微笑嘴角，0-100，0为无效果
    // 其它
    HTReshapeChinTrimming       = 0,  // 下巴，-50-50， 0为无效果
    HTReshapeForeheadTrimming   = 1,  // 发际线，-50-50， 0为无效果
    HTReshapePhiltrumTrimming   = 2   // 缩人中，-50-50， 0为无效果
};

/**
 * 推荐风格类型枚举
 *
 * 在调用推荐风格设置接口时，设置类型
 */
typedef NS_ENUM(NSInteger, HTStyleEnum) {
    HTStyleTypeOne   = 1,  // 风格一，HTEffect UI显示名称为"经典"
    HTStyleTypeTwo   = 2,  // 风格二，HTEffect UI显示名称为"网红"
    HTStyleTypeThree = 3,  // 风格三，HTEffect UI显示名称为"女神"
    HTStyleTypeFour  = 4,  // 风格四，HTEffect UI显示名称为"复古"
    HTStyleTypeFive  = 5,  // 风格五，HTEffect UI显示名称为"日杂"
    HTStyleTypeSix   = 6,  // 风格六，HTEffect UI显示名称为"初恋"
    HTStyleTypeSeven = 7,  // 风格七，HTEffect UI显示名称为"质感"
    HTStyleTypeEight = 8,  // 风格八，HTEffect UI显示名称为"伪素颜"
    HTStyleTypeNine  = 9,  // 风格九，HTEffect UI显示名称为"清冷"
    HTStyleTypeTen   = 10  // 风格十，HTEffect UI显示名称为"甜心"
};

/**
 * 视频帧格式
 *
 * 支持对BGRA、NV21、RGB、RGBA、NV12、I420格式的视频帧进行渲染
 */
typedef NS_ENUM(NSInteger, HTFormatEnum) {
    HTFormatBGRA = 0, // BGRA
    HTFormatNV21 = 1, // NV21
    HTFormatRGB  = 2, // RGB
    HTFormatRGBA = 3, // RGBA
    HTFormatNV12 = 4, // NV12
    HTFormatI420 = 5  // I420
};

/**
 * 视频帧朝向
 */
typedef NS_ENUM(NSInteger, HTRotationEnum){
    HTRotationClockwise0   = 0,
    HTRotationClockwise90  = 90,
    HTRotationClockwise180 = 180,
    HTRotationClockwise270 = 270
};

#pragma mark - 单例

/**
 * 单例
 */
+ (HTEffect *)shareInstance;

#pragma mark - 初始化

/**
 * 初始化 - 在线授权
 *
 * @param appId 在线鉴权appId
 * @param delegate 代理
 */
- (void)initHTEffect:(NSString *)appId withDelegate:(id<HTEffectDelegate>)delegate;

/**
 * 初始化 - 离线授权
 *
 * @param license 离线鉴权license
 * @return 鉴权结果返回值
 */
- (int)initHTEffect:(NSString *)license;

#pragma mark - 渲染处理

/**
 * 渲染总开关
 *
 * @param enable 开启为true， 关闭为false， 默认开启
 */
- (void)setRenderEnable:(BOOL)enable;

/**
 * 初始化纹理渲染器
 *
 * @param width    图像宽度
 * @param height   图像高度
 * @param rotation 图像是否需要旋转，不需旋转为CLOCKWISE_0
 * @param isMirror 图像是否存在镜像
 * @param maxFaces 人脸检测数目上限设置，推荐取值范围为1~5
 *
 * @return 返回初始化结果，成功返回true，失败返回false
 */
- (BOOL)initTextureRenderer:(int)width height:(int)height rotation:(HTRotationEnum)rotation isMirror:(BOOL)isMirror maxFaces:(int)maxFaces;

/**
 * 处理纹理数据输入
 *
 * @param textureId 纹理ID
 *
 * @return 返回处理后的纹理数据
 */
- (GLuint)processTexture:(GLuint)textureId;

/**
 * 销毁纹理渲染资源
 */
- (void)releaseTextureRenderer;

/**
 * 初始化buffer渲染器
 *
 * @param format 图像格式
 * @param width    图像宽度
 * @param height   图像高度
 * @param rotation 图像是否需要旋转，不需旋转为CLOCKWISE_0
 * @param isMirror 图像是否存在镜像
 * @param maxFaces 人脸检测数目上限设置，推荐取值范围为1~5
 *
 * @return 返回初始化结果，成功返回true，失败返回false
 */
- (BOOL)initBufferRenderer:(HTFormatEnum)format width:(int)width height:(int)height rotation:(HTRotationEnum)rotation isMirror:(BOOL)isMirror maxFaces:(int)maxFaces;

/**
 * 处理buffer数据输入
 *
 * @param buffer 视频帧数据
 */
- (void)processBuffer:(unsigned char *)buffer;

/**
 * 销毁buffer渲染资源
 */
- (void)releaseBufferRenderer;

#pragma mark - 美肤
/**
 * 设置美肤
 *
 * @param type 美肤类型，参考#HTBeautyTypes
 * @param value 美肤参数，取值范围 0-100
 */
- (void)setBeauty:(int)type value:(int)value;

#pragma mark - 美型
/**
 * 设置美型
 *
 * @param type 美型类型，参考#HTReshapeTypes
 * @param value 美型参数，0-100
 */
- (void)setReshape:(int)type value:(int)value;

#pragma mark - 滤镜

/**
 * 获取滤镜素材网络路径
 *
 * @return 返回滤镜素材网络路径
 */
- (NSString *)getFilterUrl;

/**
 * 获取滤镜素材沙盒路径
 *
 * @return 返回滤镜素材沙盒路径
 */
- (NSString *)getFilterPath;

/**
 * 设置滤镜
 *
 * @param name 滤镜名称，如果传null或者空字符，则取消滤镜效果
 * @param value 滤镜参数，0-100
 */
- (void)setFilter:(NSString *)name value:(int)value;

#pragma mark - 风格推荐

/**
 * 设置推荐风格
 * 该接口使用需同时支持美肤、美型、滤镜特效
 *
 * @param type 风格类型，参考类型定义HTStyleEnum
 */
- (void)setStyle:(int)type value:(int)value;

#pragma mark - AR道具 - 贴纸

/**
 * 获取贴纸素材网络路径
 *
 * @return 返回贴纸素材网络路径
 */
- (NSString *)getStickerUrl;

/**
 * 获取贴纸素材沙盒路径
 *
 * @return 返回贴纸素材沙盒路径
 */
- (NSString *)getStickerPath;

/**
 * 设置贴纸
 *
 * @param name 贴纸名称，如果传null或者空字符，则取消贴纸效果
 */
- (void)setSticker:(NSString *)name;

#pragma mark - AR道具 - 3D道具

/**
 * 获取3D道具素材网络路径
 *
 * @return 返回3D道具素材网络路径
 */
- (NSString *)getThreeDUrl;

/**
 * 获取3D道具素材沙盒路径
 *
 * @return 返回3D道具素材沙盒路径
 */
- (NSString *)getThreeDPath;

/**
 * 设置3D道具
 *
 * @param name 3D道具名称，如果传null或者空字符，则取消3D道具效果
 */
- (void)setThreeD:(NSString *)name;

#pragma mark - AR道具 - 水印

/**
 * 获取水印素材网络路径
 *
 * @return 返回水印素材网络路径
 */
- (NSString *)getWatermarkUrl;

/**
 * 获取水印素材沙盒路径
 *
 * @return 返回水印素材沙盒路径
 */
- (NSString *)getWatermarkPath;

/**
 * 设置水印
 *
 * @param name 水印效果名称，如果传null或者空字符，则取消水印效果
 */
- (void)setWatermark:(NSString *)name;

#pragma mark - 人像抠图 - AI抠图

/**
 * 获取AI抠图素材网络路径
 *
 * @return 返回AI抠图素材网络路径
 */
- (NSString *)getAISegEffectUrl;

/**
 * 获取AI抠图素材沙盒路径
 *
 * @return 返回AI抠图素材沙盒路径
 */
- (NSString *)getAISegEffectPath;

/**
 * 设置AI抠图
 *
 * @param name AI抠图效果名称，如果传null或者空字符，则取消人像抠图效果
 */
- (void)setAISegEffect:(NSString *)name;

#pragma mark - 人像抠图 - 绿幕抠图

/**
 * 获取绿幕抠图素材网络路径
 *
 * @return 返回绿幕抠图素材网络路径
 */
- (NSString *)getGSSegEffectUrl;

/**
 * 获取绿幕抠图素材沙盒路径
 *
 * @return 返回绿幕抠图素材沙盒路径
 */
- (NSString *)getGSSegEffectPath;

/**
 * 设置绿幕抠图
 *
 * @param name 绿幕抠图效果名称，如果传null或者空字符，则取消绿幕抠图效果
 */
- (void)setGSSegEffect:(NSString *)name;

#pragma mark - 手势识别

/**
 * 获取手势识别素材网络路径
 *
 * @return 返回手势识别素材网络路径
 */
- (NSString *)getGestureEffectUrl;

/**
 * 获取手势识别素材沙盒路径
 *
 * @return 返回手势识别素材沙盒路径
 */
- (NSString *)getGestureEffectPath;

/**
 * 设置手势识别特效
 *
 * @param name 手势识别效果名称，如果传null或者空字符，则取消手势识别效果
 */
- (void)setGestureEffect:(NSString *)name;

#pragma mark - 人脸追踪

/**
 * 判断是否检测到人脸
 *
 * @return 检测到的人脸个数，返回 0 代表没有检测到人脸
 */
- (int)isTracking;

#pragma mark - 其它

/**
 * 获取当前 SDK 版本信息
 *
 * @return 版本信息
 */
- (NSString *)getVersion;

/**
 * 设置素材网络路径
 * 将素材保存在自定义的网络存储中的情况下，设置网络路径
 *
 * @param url 素材网络路径
 */
- (void)setResourceUrl:(NSString *)url;

/**
 * 获取素材网络路径
 *
 * @return 素材网络路径
 */
- (NSString *)getResourceUrl;

@end
