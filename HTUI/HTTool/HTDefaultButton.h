//
//  HTDefaultButton.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>
#import "HTCaptureView.h"

@interface HTDefaultButton : UIView

@property (nonatomic, copy) void(^defaultButtonCameraBlock)(void);
@property (nonatomic, copy) void(^defaultButtonVideoBlock)(NSInteger status);//0=结束，1=开始
@property (nonatomic, copy) void(^defaultButtonBeautyBlock)(void);
@property (nonatomic, copy) void(^defaultButtonResetBlock)(void);

@property (nonatomic, assign) BOOL isThemeWhite;

/**
 *  3D界面隐藏重置按钮
 */
@property (nonatomic, assign) BOOL resetButtonHide;

/**
 *  显示拍照/视频按钮
 */
@property (nonatomic, assign) BOOL cameraShow;


@end
