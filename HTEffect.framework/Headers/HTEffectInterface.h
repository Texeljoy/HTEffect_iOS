//
//  HTEffectInterface.h
//  HTEffect
//
//  Created by HTLab on 2022/06/29.
//  Copyright © 2022 TexelJoy Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
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

/**
 * 人脸检测结果报告
 */
@interface HTFaceDetectionReport : NSObject

/// 人脸边界框
@property (nonatomic, assign) CGRect rect;

/// 人脸关键点数组
@property (nonatomic, assign) CGPoint *keyPoints;

/// 人脸偏转角-yaw
@property (nonatomic, assign) CGFloat yaw;

/// 人脸偏转角-pitch
@property (nonatomic, assign) CGFloat pitch;

/// 人脸偏转角-roll
@property (nonatomic, assign) CGFloat roll;

/// 人脸动作-张嘴
@property (nonatomic, assign) CGFloat mouthOpen;

/// 人脸动作-眨眼
@property (nonatomic, assign) CGFloat eyeBlink;

/// 人脸动作-挑眉
@property (nonatomic, assign) CGFloat browJump;

@end

/**
 * 人手检测结果报告
 */
@interface HTHandDetectionReport : NSObject

/// 人手识别准概率
@property (nonatomic, assign) CGFloat score;

/// 人手骨骼关键点坐标
@property (nonatomic, assign) CGPoint *keyPoints;

/// 人手区域坐标
@property (nonatomic, assign) CGPoint *position;

/// 手势类型
@property (nonatomic, assign) int gesture;

@end

/**
 * 人体检测结果报告
 */
@interface HTPoseDetectionReport : NSObject

/// 人体骨骼关键点坐标
@property (nonatomic, assign) CGPoint *keyPoints;

/// 人体骨骼关键点3D坐标
@property (nonatomic, assign) CGFloat *keyPoints3D;

/// 人体区域坐标
@property (nonatomic, assign) CGRect rect;

@end

@interface HTEffect: NSObject

#pragma mark - 数据类型

/**
 * 美肤类型枚举
 */
typedef NS_ENUM(NSInteger, HTBeautyTypes) {
    HTBeautySkinWhitening       = 0, //!< 美白，0~100，0为无效果
    HTBeautyClearSmoothing      = 1, //!< 精细磨皮，0~100，0为无效果
    HTBeautySkinRosiness        = 2, //!< 红润，0~100，0为无效果
    HTBeautyImageSharpness      = 3, //!< 清晰，0~100，0为无效果
    HTBeautyImageBrightness     = 4, //!< 亮度，-50~50，0为无效果
    HTBeautyDarkCircleLessening = 5, //!< 去黑眼圈，0~100，0为无效果
    HTBeautyNasolabialLessening = 6  //!< 去法令纹，0~100，0为无效果
};

/**
 * 美型类型枚举
 */
typedef NS_ENUM(NSInteger, HTReshapeTypes) {
    //! 眼睛
    HTReshapeEyeEnlarging       = 10, //!< 大眼，0-100，0为无效果
    HTReshapeEyeRounding        = 11, //!< 圆眼，0-100，0为无效果
    HTReshapeEyeSpaceTrimming   = 12, //!< 眼间距，-50-50， 0为无效果
    HTReshapeEyeCornerTrimming  = 13, //!< 眼睛角度，-50-50， 0为无效果
    HTReshapeEyeCornerEnlarging = 14, //!< 开眼角，0-100， 0为无效果
    //! 脸廓
    HTReshapeCheekThinning      = 20, //!< 瘦脸，0-100，0为无效果
    HTReshapeCheekVShaping      = 21, //!< V脸，0-100，0为无效果
    HTReshapeCheekNarrowing     = 22, //!< 窄脸，0-100，0为无效果
    HTReshapeCheekboneThinning  = 23, //!< 瘦颧骨，0-100，0为无效果
    HTReshapeJawboneThinning    = 24, //!< 瘦下颌骨，0-100，0为无效果
    HTReshapeTempleEnlarging    = 25, //!< 丰太阳穴，0-100，0为无效果
    HTReshapeHeadLessening      = 26, //!< 小头，0-100，0为无效果
    HTReshapeFaceLessening      = 27, //!< 小脸，0-100，0为无效果
    HTReshapeCheekShortening    = 28, //!< 短脸，0-100，0为无效果
    //! 鼻部
    HTReshapeNoseEnlarging      = 30, //!< 长鼻
    HTReshapeNoseThinning       = 31, //!< 瘦鼻，0-100，0为无效果
    HTReshapeNoseApexLessening  = 32, //!< 鼻头，0-100，0为无效果
    HTReshapeNoseRootEnlarging  = 33, //!< 山根，0-100，0为无效果
    //! 嘴部
    HTReshapeMouthTrimming      = 40, //!< 嘴型，-50-50， 0为无效果
    HTReshapeMouthSmiling       = 41, //!< 微笑嘴角，0-100，0为无效果
    //! 其它
    HTReshapeChinTrimming       = 0,  //!< 下巴，-50-50， 0为无效果
    HTReshapeForeheadTrimming   = 1,  //!< 发际线，-50-50， 0为无效果
    HTReshapePhiltrumTrimming   = 2   //!< 缩人中，-50-50， 0为无效果
};

/**
 * 美发类型枚举
 */
typedef NS_ENUM(NSInteger, HTHairTypes) {
    HTHairTypeNone = 0,  //!< 无美发效果
    HTHairType1    = 1,  //!< 美发类型1，HTEffect UI显示名称为"神秘紫"
    HTHairType2    = 2,  //!< 美发类型2，HTEffect UI显示名称为"巧克力"
    HTHairType3    = 3,  //!< 美发类型3，HTEffect UI显示名称为"青木棕"
    HTHairType4    = 4,  //!< 美发类型4，HTEffect UI显示名称为"焦糖棕"
    HTHairType5    = 5,  //!< 美发类型5，HTEffect UI显示名称为"落日橘"
    HTHairType6    = 6,  //!< 美发类型6，HTEffect UI显示名称为"复古玫瑰"
    HTHairType7    = 7,  //!< 美发类型7，HTEffect UI显示名称为"深玫瑰"
    HTHairType8    = 8,  //!< 美发类型8，HTEffect UI显示名称为"雾霾香芋"
    HTHairType9    = 9,  //!< 美发类型9，HTEffect UI显示名称为"孔雀蓝"
    HTHairType10   = 10, //!< 美发类型10，HTEffect UI显示名称为"雾霾蓝灰"
    HTHairType11   = 11, //!< 美发类型11，HTEffect UI显示名称为"亚麻灰棕"
    HTHairType12   = 12  //!< 美发类型12，HTEffect UI显示名称为"亚麻浅灰"
};

/**
 * 滤镜类型枚举
 *
 * 滤镜类型分为风格滤镜，特效滤镜，哈哈镜
 */
typedef NS_ENUM(NSInteger, HTFilterTypes) {
    HTFilterBeauty = 0, //!< 风格滤镜
    HTFilterEffect = 1, //!< 特效滤镜
    HTFilterFunny  = 2  //!< 哈哈镜
};

/**
 * AR道具类型枚举
 *
 * AR道具类型目前支持2D贴纸，面具，礼物，水印
 */
typedef NS_ENUM(NSInteger, HTARItemTypes) {
    HTItemSticker   = 0, //!< 2D贴纸
    HTItemMask      = 1, //!< 面具
    HTItemGift      = 2, //!< 礼物
    HTItemWatermark = 3  //!< 水印
};

/**
 * 推荐妆容推荐类型枚举
 * 3.0版本后，将风格推荐效果改为妆容推荐；
 *
 * 在调用妆容推荐设置接口时，设置类型
 */
typedef NS_ENUM(NSInteger, HTStyleTypes) {
    HTStyleTypeNone   = 0,  //!< 无，HTEffect UI显示名称为"无"
    HTStyleTypeOne   = 1,  //!< 妆容一，HTEffect UI显示名称为"清纯白花"
    HTStyleTypeTwo   = 2,  //!< 妆容二，HTEffect UI显示名称为"狐系美人"
    HTStyleTypeThree = 3,  //!< 妆容三，HTEffect UI显示名称为"清甜妆"
    HTStyleTypeFour  = 4,  //!< 妆容四，HTEffect UI显示名称为"白露"
    HTStyleTypeFive  = 5,  //!< 妆容五，HTEffect UI显示名称为"冷调"
    HTStyleTypeSix   = 6,  //!< 妆容六，HTEffect UI显示名称为"元气少女"
    HTStyleTypeSeven = 7,  //!< 妆容七，HTEffect UI显示名称为"女团"
    HTStyleTypeEight = 8  //!< 妆容八，HTEffect UI显示名称为"纯欲妆"
};

/**
 * 美妆类型枚举
 *
 * 美妆类型分为口红、眉毛，腮红、眼影、眼线、睫毛、美瞳
 */
typedef NS_ENUM(NSInteger, HTMakeupTypes) {
    HTMakeupLipstick = 0, //!< 口红
    HTMakeupEyebrow = 1, //!< 眉毛
    HTMakeupBlush  = 2,  //!< 腮红
    HTMakeupEyeshadow  = 3, //!< 眼影
    HTMakeupEyeline  = 4, //!< 眼线
    HTMakeupEyelash  = 5, //!< 睫毛
    HTMakeupPupils  = 6 //!< 美瞳
};

/**
 * 美体类型枚举
 *
 * 美体类型分为长腿、瘦身
 */
typedef NS_ENUM(NSInteger, HTBodyBeautyTypes) {
    HTBodyBeautyLegSlimming = 0, //!< 长腿
    HTBodyBeautyBodyThinning = 1 //!< 瘦身
};

/**
 * 视频帧格式
 *
 * 支持对RGB、RGBA、BGR、BGRA、NV12、NV21、I420格式的视频帧进行渲染
 */
typedef NS_ENUM(NSInteger, HTFormatEnum) {
    HTFormatRGB  = 0, //!< RGB
    HTFormatRGBA = 1, //!< RGBA
    HTFormatBGR  = 2, //!< BGR
    HTFormatBGRA = 3, //!< BGRA
    HTFormatNV12 = 4, //!< NV12
    HTFormatNV21 = 5, //!< NV21
    HTFormatI420 = 6  //!< I420
};

/**
 * 视频帧朝向
 *
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
 * 初始化视频帧渲染器
 *
 * @param format 视频帧格式
 * @param width    视频帧宽度
 * @param height   视频帧高度
 * @param rotation 视频帧图像是否需要旋转，不需旋转为CLOCKWISE_0
 * @param isMirror 视频帧图像是否存在镜像
 * @param maxFaces 人脸检测数目上限设置，推荐取值范围为1~5
 *
 * @return 返回初始化结果，成功返回true，失败返回false
 */
- (BOOL)initBufferRenderer:(HTFormatEnum)format width:(int)width height:(int)height rotation:(HTRotationEnum)rotation isMirror:(BOOL)isMirror maxFaces:(int)maxFaces;

/**
 * 处理视频帧数据输入
 *
 * @param pixels 视频帧数据
 */
- (void)processBuffer:(unsigned char *)pixels;

/**
 * 销毁视频帧渲染资源
 */
- (void)releaseBufferRenderer;

/**
 * 初始化图片渲染器
 *
 * @param format 图片格式
 * @param width    图片宽度
 * @param height   图片高度
 * @param rotation 图片是否需要旋转，不需旋转为CLOCKWISE_0
 * @param isMirror 图片是否存在镜像
 * @param maxFaces 人脸检测数目上限设置，推荐取值范围为1~5
 *
 * @return 返回初始化结果，成功返回true，失败返回false
 */
- (BOOL)initImageRenderer:(HTFormatEnum)format width:(int)width height:(int)height rotation:(HTRotationEnum)rotation isMirror:(BOOL)isMirror maxFaces:(int)maxFaces;

/**
 * 处理图片数据输入
 *
 * @param pixels 视频帧数据
 */
- (void)processImage:(unsigned char *)pixels;

/**
 * 销毁图片渲染资源
 */
- (void)releaseImageRenderer;

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

#pragma mark - 美发
/**
 * 设置美发特效参数函数
 *
 * @param type 美发类型，参考#HTHairTypes
 * @param value 美发参数，0-100
 */
- (void)setHairStyling:(int)type value:(int)value;

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
 * @param type 滤镜类型，参考类型定义#HTFilterTypes
 * @param name 滤镜名称，如果传null或者空字符，则取消滤镜效果
 */
- (void)setFilter:(int)type name:(NSString *)name;

#pragma mark - 妆容推荐

/**
 * 设置妆容推荐
 * 该接口使用需要同时支持美妆、滤镜特效
 *
 * @param type 妆容类型，参考类型定义#HTStyleTypes
 */
- (void)setStyle:(int)type;

#pragma mark - AR道具

/**
 * 获取AR道具素材网络路径
 *
 * @param  type AR道具类型，参考类型定义#HTARItemTypes
 * @return 返回AR道具素材网络路径
 */
- (NSString *)getARItemUrlBy:(int)type;

/**
 * 获取AR道具素材沙盒路径
 *
 * @param  type AR道具类型，参考类型定义#HTARItemTypes
 * @return 返回AR道具素材沙盒路径
 */
- (NSString *)getARItemPathBy:(int)type;

/**
 * 设置AR道具，v2.0后启用
 *
 * @param type AR道具类型，参考类型定义#HTARItemTypes
 * @param name AR道具名称，如果传null或者空字符，则取消道具效果
 */
- (void)setARItem:(int)type name:(NSString *)name;

/**
 * 设置AR道具-水印参数，v2.0后启用
 * 水印参数为水印图像在手机屏幕中相对视频帧的四个顶点的坐标值，配合外部操作框获取
 *
 * @param x1 左上角横坐标值
 * @param y1 左上角纵坐标值
 * @param x2 左下角横坐标值
 * @param y2 左下角纵坐标值
 * @param x3 右下角横坐标值
 * @param y3 右下角纵坐标值
 * @param x4 右下角横坐标值
 * @param y4 右下角纵坐标值
 */
- (void)setWatermarkParam:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 x3:(float)x3 y3:(float)y3 x4:(float)x4 y4:(float)y4;

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

#pragma mark - 人像抠图 - 色（键）值抠图，原绿幕抠图

/**
 * 获取色（键）值抠图素材网络路径
 *
 * @return 返回色（键）值抠图素材网络路径
 */
- (NSString *)getChromaKeyingUrl;

/**
 * 获取色（键）值抠图素材沙盒路径
 *
 * @return 返回色（键）值抠图素材沙盒路径
 */
- (NSString *)getChromaKeyingPath;

/**
 * 设置色（键）值抠图特效场景
 *
 * @param name 场景名称
 */
- (void)setChromaKeyingScene:(NSString *)name;

/**
 * 设置色（键）值抠图特效幕布颜色
 *
 * @param color 幕布颜色，传字符串类型16进制色值
 *        目前仅支持绿幕 (#00ff00) 蓝幕(#0000ff)  白幕(#ffffff)三种幕布颜色和透明幕布，默认为绿幕
 */
- (void)setChromaKeyingCurtain:(NSString *)color;

/**
 * 设置色（键）值抠图特效调节参数
 *
 * @param type 参数类型，0-相似度；1-平滑度；2-祛色度；3-精确度
 * @param value 调节参数，参数范围0-100
 */
- (void)setChromaKeyingParams:(int)type value:(int)value;

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

#pragma mark - 美妆
/**
 * 获取美妆素材总目录网络路径
 *
 * @return 返回美妆素材总目录网络路径
 */
- (NSString *)getMakeupUrl;

/**
 * 获取美妆素材总目录沙盒路径
 *
 * @return 返回美妆素材总目录沙盒路径
 */
- (NSString *)getMakeupPath;

/**
 * 获取美妆某一类型素材网络路径
 *
 * @return 返回美妆某一类型素材网络路径
 */
- (NSString *)getMakeupUrl:(int)type;

/**
 * 获取美妆某一类型素材沙盒路径
 *
 * @return 返回美妆某一类型素材沙盒路径
 */
- (NSString *)getMakeupPath:(int)type;

/**
 * 设置美妆特效
 *
 * @param type 美妆类别
 * @param name 美妆名称
 * @param value 美妆参数
 */
- (void)setMakeup:(int)type name:(NSString *)name value:(int)value;

#pragma mark - 美体

/**
 * 设置美体特效
 *
 * @param type 美体类别
 * @param value 美体名称
 */
- (void)setBodyBeauty:(int)type value:(int)value;

#pragma mark - 算法

/**
 * 判断是否检测到人脸
 *
 * @return 检测到的人脸个数，返回 0 代表没有检测到人脸
 */
- (int)isTracking;

/**
 * 获取人脸检测结果报告
 */
- (NSArray<HTFaceDetectionReport *> *)getFaceDetectionReport;

/**
 * 获取人手检测结果报告
 */
- (NSArray<HTHandDetectionReport *> *)getHandDetectionReport;

/**
 * 判断是否检测到全身人体
 *
 * @return 检测到的全身人体个数，返回 0 代表没有检测到全身人体
 */
- (int)isFullBody;

/**
 * 获取人体检测结果报告
 */
- (NSArray<HTPoseDetectionReport *> *)getPoseDetectionReport;

#pragma mark - 其它

/**
 * 获取当前 SDK 版本号
 *
 * @return 版本号
 */
- (NSString *)getVersionCode;

/**
 * 获取当前 SDK 版本信息
 *
 * @return 版本信息
 */
- (NSString *)getVersion;

/**
 * 设置参数极值限制开关，默认为开
 */
- (void)setExtremeLimitEnable:(BOOL)enable;

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

/**
 * 设置资源拷贝至沙盒的自定义目标路径
 *
 * @param path 路径
 */
- (void)setResourcePath:(NSString *)path;

@end
