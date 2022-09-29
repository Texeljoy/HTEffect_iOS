//
//  HTUIManager.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "HTDefaultButton.h"
#import "HTUIConfig.h"

@protocol HTUIManagerDelegate <NSObject>

@optional
/**
 * 切换摄像头
 */
- (void)didClickSwitchCameraButton;
/**
 * 拍照
 */
- (void)didClickCameraCaptureButton;

@end

@interface HTUIManager : NSObject
/**
 *   初始化单例
 */
+ (HTUIManager *)shareManager;

// 主窗口
@property (nonatomic, strong) UIWindow *superWindow;

@property (nonatomic, strong) HTDefaultButton *defaultButton;

// 是否启用退出手势
@property (nonatomic, assign) bool exitEnable;

// 是否触发拍照回调
@property (nonatomic, assign) bool isCameraBlock;

/**
 *   直接弹出美颜页面
 */
- (void)showBeautyView;

/**
 *   直接弹出AR道具页面
 */
- (void)showARItemView;

/**
 *   直接弹出人像抠图页面
 */
- (void)showMattingView;

/**
 *  加载UI 通过Window默认初始化在当前页面最上层
 */
- (void)loadToWindowDelegate:(id<HTUIManagerDelegate>)delegate;
/**
 * 释放UI资源
 */
- (void)destroy;

@end
