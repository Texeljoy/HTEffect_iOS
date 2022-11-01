//
//  HTUIConfig.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import "HTAdapter.h"
#import <HTEffect/HTEffectView.h>
#import <HTEffect/HTEffectInterface.h>
#import "HTUIColor+ColorChange.h"
#import "HTModel.h"

@interface HTUIConfig : NSObject

#pragma mark -- UI保存参数时对应滑动条的键值枚举
typedef NS_ENUM(NSInteger, HTDataCategoryType) {
    HT_SKIN_SLIDER = 0, // 美肤滑动条
    HT_RESHAPE_SLIDER = 1, // 美型滑动条
    HT_FILTER_SLIDER = 2, // 滤镜滑动条
};

@end

#ifndef HT_CONFIG_H
#define HT_CONFIG_H

// UI版本号
#define ea2b9cbbc0814e39ba43cf5f0d022ecb @"1.0"

// 在线鉴权密钥
#define HTAppId @"7aeba3d6f306480988ff63bcef9619b5"

// 防止block的循环引用
#define WeakSelf __weak typeof(self) weakSelf = self;

#define HTColor(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define HTColors(s,a) [UIColor colorWithRed:((s) / 255.0) green:((s) / 255.0) blue:((s) / 255.0) alpha:(a)]

#define HTFontRegular(s) [UIFont fontWithName:@"PingFang-SC-Regular" size:s]
#define HTFontMedium(s) [UIFont fontWithName:@"PingFang-SC-Medium" size:s]

#define HTWidth(width) [[HTAdapter shareInstance] getAfterAdaptionWidth:width]
#define HTHeight(height) [[HTAdapter shareInstance] getAfterAdaptionHeight:height]

#define HTSkinBeautyPath [[NSBundle mainBundle] pathForResource:@"HTSkinBeauty" ofType:@"json"]
#define HTFaceBeautyPath [[NSBundle mainBundle] pathForResource:@"HTFaceBeauty" ofType:@"json"]
#define HTFilterPath [[[HTEffect shareInstance] getFilterPath] stringByAppendingFormat:@"ht_filter_config.json"]

// 滤镜滑动条默认参数
#define FilterValue 100

#endif /* HT_CONFIG_H */
