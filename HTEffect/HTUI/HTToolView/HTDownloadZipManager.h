//
//  HTDownloadZipManager.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "HTUIConfig.h"
#import "HTModel.h"

@interface HTDownloadZipManager : NSObject

typedef NS_ENUM(NSInteger, DownloadedType) {
    HT_DOWNLOAD_TYPE_Sticker = 0, // 贴纸
    HT_DOWNLOAD_STATE_Portraits = 1,// AI抠图
    HT_DOWNLOAD_STATE_Greenscreen = 2,// 绿幕抠图
    HT_DOWNLOAD_STATE_Gesture = 3,// 手势
};

// MARK: --单例初始化方法--
+ (HTDownloadZipManager *)shareManager;

+ (void)releaseShareManager;

- (void)downloadSuccessedType:(DownloadedType)type htModel:(HTModel *)model completeBlock:(void(^)(BOOL successful))completeBlock;

@end
