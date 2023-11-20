//
//  HTUIManager.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "HTDefaultButton.h"
#import "HTUIConfig.h"

typedef NS_ENUM(NSInteger, ShowStatus) {
    ShowOptional    = 0,
    ShowBeauty      = 1,
    ShowARItem      = 2,
    ShowGesture     = 3,
    ShowMatting     = 4,
    ShowNone        = 5,
    ShowFilter      = 6,
};

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

/**
 * 录制视频
 */
- (void)didClickVideoCaptureButton:(NSInteger)status;

/**
 * 显示或隐藏外部拍照按钮
 */
- (void)didCameraCaptureButtonShow:(BOOL)show;

@end

@interface HTUIManager : NSObject
/**
 *   初始化单例
 */
+ (HTUIManager *)shareManager;

//相机采集视频帧尺寸
@property (nonatomic, assign) CGSize resolutionSize;
//视频预览的填充模式
@property (nonatomic, assign) HTEffectViewContentMode contentMode;

// 主窗口
@property (nonatomic, strong) UIWindow *superWindow;

@property (nonatomic, strong) HTDefaultButton *defaultButton;

// 是否启用退出手势
@property (nonatomic, assign) bool exitEnable;

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
 *   直接弹出手势识别
 */
- (void)showGestureView;

/**
 *   弹出滤镜
 */
- (void)showFilterView;

/**
 *   弹出功能页面
 */
- (void)showOptionalView;

/**
 *   关闭当前弹框
 *   showOptional: 是否重新显示Optional页面
 */
-(void)hideView:(BOOL)showOptional;

/**
 *  加载UI 通过Window默认初始化在当前页面最上层
 */
- (void)loadToWindowDelegate:(id<HTUIManagerDelegate>)delegate;

/**
 *  更改当前状态通知外部拍照按钮的显示或者隐藏
 */
- (void)cameraButtonShow:(ShowStatus)status;

/**
 *  切换主题是否为白色，根据展示比例
 */
@property (nonatomic, assign) BOOL themeWhite;

/**
 *  显示拍照/视频按钮
 */
@property (nonatomic, assign) BOOL defaultButtonCameraShow;

/**
 *  关键点展示
 */
- (void)showLandmark:(NSInteger)type orientation:(HTEffectViewOrientation)orientation resolutionWidth:(NSInteger)resolutionWidth resolutionHeight:(NSInteger)resolutionHeight;

/**
 * 释放UI资源
 */
- (void)destroy;

@end
