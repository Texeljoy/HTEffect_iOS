//
//  HTUIConfig.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import "HTAdapter.h"
#import <HTEffect/HTEffectView.h>
#import <HTEffect/HTEffectInterface.h>
#import "HTUIColor+ColorChange.h"
#import "HTModel.h"
#import "MJHUD.h"

NS_ASSUME_NONNULL_BEGIN

/* 非3D采集界面用来记录返回按钮点击缓存，第一次点击退出后，第二次进入不再进行所有特效参数的初始化 */
static NSString * _Nullable const HT_ALL_EFFECT_CACHES = @"HT_ALL_EFFECT_CACHES";

/* AI抠图模块用来记录绿幕背景色选中位置信息缓存 */
static NSString * _Nullable const HTMattingScreenGreen  = @"#00ff00";
static NSString * _Nullable const HTMattingScreenBlue   = @"#0000ff";
static NSString * _Nullable const HTMattingScreenRed    = @"#ff0000";

// 这个是 Map NSString * 类型的数组
static  NSString * _Nonnull const HTScreenCurtainColorMap[3] = {
    [0] = HTMattingScreenGreen,
    [1] = HTMattingScreenBlue,
    [2] = HTMattingScreenRed
};

/* 美颜模块用来记录选中位置信息缓存 */
static NSString * const HT_HAIR_SELECTED_POSITION = @"HT_HAIR_SELECTED_POSITION";
static NSString * const HT_LIGHT_MAKEUP_SELECTED_POSITION = @"HT_LIGHT_MAKEUP_SELECTED_POSITION";

/* AR道具模块用来记录选中位置信息缓存 */
static NSString * const HT_ARITEM_STICKER_POSITION  = @"HT_ARITEM_STICKER_POSITION";
static NSString * const HT_ARITEM_MASK_POSITION  = @"HT_ARITEM_MASK_POSITION";
static NSString * const HT_ARITEM_GIFT_POSITION  = @"HT_ARITEM_GIFT_POSITION";
static NSString * const HT_ARITEM_WATERMARK_POSITION  = @"HT_ARITEM_WATERMARK_POSITION";
static  NSString * _Nonnull const HT_ARITEM_POSITION_MAP[4] = {
    [0] = HT_ARITEM_STICKER_POSITION,
    [1] = HT_ARITEM_MASK_POSITION,
    [2] = HT_ARITEM_GIFT_POSITION,
    [3] = HT_ARITEM_GIFT_POSITION,
};

/* AI抠图模块用来记录选中位置信息缓存 */
static NSString * const HT_MATTING_AI_POSITION  = @"HT_MATTING_AI_POSITION";
static NSString * const HT_MATTING_GS_POSITION  = @"HT_MATTING_GS_POSITION";

//* 手势特效用来记录选中位置信息缓存 */
static NSString * const HT_GESTURE_SELECTED_POSITION  = @"HT_GESTURE_SELECTED_POSITION";

//* 滤镜模块用来记录选中位置信息缓存 */
static NSString * const HT_STYLE_FILTER_NAME  = @"HT_STYLE_FILTER_NAME";
static NSString * const HT_STYLE_FILTER_SELECTED_POSITION  = @"HT_STYLE_FILTER_SELECTED_POSITION";
static NSString * const HT_EFFECT_FILTER_SELECTED_POSITION  = @"HT_EFFECT_FILTER_SELECTED_POSITION";
static NSString * const HT_HAHA_FILTER_SELECTED_POSITION  = @"HT_HAHA_FILTER_SELECTED_POSITION";
static  NSString * _Nonnull const HT_FILTER_POSITION_MAP[3] = {
    [0] = HT_STYLE_FILTER_SELECTED_POSITION,
    [1] = HT_EFFECT_FILTER_SELECTED_POSITION,
    [2] = HT_HAHA_FILTER_SELECTED_POSITION
};

//* 切换幕布模块用来记录选中位置信息缓存 */
static NSString * const HT_MATTING_SWITCHSCREEN_POSITION  = @"HT_MATTING_SWITCHSCREEN_POSITION";


/* 滤镜模块用来记录Value值信息缓存 */
//static NSString * const HT_STYLE_FILTER_SLIDER  = @"HT_STYLE_FILTER_SLIDER";
//static NSString * const HT_EFFECT_FILTER_SLIDER  = @"HT_EFFECT_FILTER_SLIDER";
//static NSString * const HT_HAHA_FILTER_SLIDER  = @"HT_HAHA_FILTER_SLIDER";
/* 美颜模块的SLIDER Key在json文件中配置 */

/* 3D模块用来记录选中位置信息缓存 */
static NSString * const HT_3D_SELECTED_POSITION  = @"HT_3D_SELECTED_POSITION";


@interface HTUIConfig : NSObject

#pragma mark -- UI保存参数时对应滑动条的键值枚举
typedef NS_ENUM(NSInteger, HTDataCategoryType) {
    HT_SKIN_SLIDER = 0,     // 美肤滑动条
    HT_RESHAPE_SLIDER = 1,  // 美型滑动条
    HT_FILTER_SLIDER = 2,   // 滤镜滑动条
    HT_HAIR_SLIDER = 3,     // 美发滑动条
    HT_MAKEUP_SLIDER = 4,   // 美妆滑动条
    HT_BODY_SLIDER = 5,     // 美体滑动条
};


typedef NS_ENUM(NSInteger, HTARItemType) {
    HT_Sticker = 0, // 贴纸
    HT_Mask = 1, // 面具
    HT_Gift = 2, // 礼物
    HT_WaterMark = 3,// 水印
};


@end

#ifndef HT_CONFIG_H
#define HT_CONFIG_H

//主色调
#define MAIN_COLOR [UIColor colorWithRed:170/255.0 green:242/255.0 blue:0/255.0 alpha:1.0]
#define COVER_COLOR [UIColor colorWithRed:198/255.0 green:161/255.0 blue:134/255.0 alpha:0.8]

#define HTColor(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define HTColors(s,a) [UIColor colorWithRed:((s) / 255.0) green:((s) / 255.0) blue:((s) / 255.0) alpha:(a)]

#define HTFontRegular(s) [UIFont fontWithName:@"PingFang-SC-Regular" size:s]
#define HTFontMedium(s) [UIFont fontWithName:@"PingFang-SC-Medium" size:s]

#define HTWidth(width) [[HTAdapter shareInstance] getAfterAdaptionWidth:width]
#define HTHeight(height) [[HTAdapter shareInstance] getAfterAdaptionHeight:height]

#define HTSkinBeautyPath [[NSBundle mainBundle] pathForResource:@"HTSkinBeauty" ofType:@"json"]
#define HTFaceBeautyPath [[NSBundle mainBundle] pathForResource:@"HTFaceBeauty" ofType:@"json"]
#define HTMakeupBeautyPath [[NSBundle mainBundle] pathForResource:@"HTMakeupBeauty" ofType:@"json"]
#define HTBodyBeautyPath [[NSBundle mainBundle] pathForResource:@"HTBodyBeauty" ofType:@"json"]

// 防止block的循环引用
#define WeakSelf __weak typeof(self) weakSelf = self;
/************************* Seperate Line ****************************/
 

// 滤镜滑动条默认参数
#define FilterStyleDefaultName @"ziran3"
#define FilterStyleDefaultPositionIndex 3



// 屏幕尺寸相关
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kSafeAreaBottom \
^(){\
   if (@available(iOS 11.0, *)) {\
     return  (CGFloat)UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;\
    } else {\
     return  (CGFloat)0.f;\
    }\
}()

#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)

#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)





#endif /* HT_CONFIG_H */


NS_ASSUME_NONNULL_END
