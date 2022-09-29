//
//  HTEffectView.h
//  HTEffect
//
//  Created by HTLab on 2022/06/29.
//  Copyright © 2022 TexelJoy Tech. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <AVFoundation/AVCaptureSession.h>

typedef NS_ENUM(NSInteger, HTEffectViewOrientation) {
    HTEffectViewOrientationPortrait              = 0,
    HTEffectViewOrientationLandscapeRight        = 1,
    HTEffectViewOrientationPortraitUpsideDown    = 2,
    HTEffectViewOrientationLandscapeLeft         = 3,
};

typedef NS_ENUM(NSInteger, HTEffectViewContentMode) {
    // 等比例短边充满
    HTEffectViewContentModeScaleAspectFill       = 0,
    // 拉伸铺满
    HTEffectViewContentModeScaleToFill           = 1,
    // 等比例长边充满
    HTEffectViewContentModeScaleAspectFit        = 2,

};

@interface HTEffectView : UIView

// 视频填充模式
@property (nonatomic, assign) HTEffectViewContentMode contentMode;

// 设置视频朝向，保证视频总是竖屏播放
@property (nonatomic, assign) HTEffectViewOrientation orientation;

// 预览渲染后的视频
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer isMirror:(BOOL)isMirror;

@end
