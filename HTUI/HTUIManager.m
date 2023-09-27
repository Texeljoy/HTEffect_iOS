//
//  HTUIManager.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTUIManager.h"
#import "HTOptionalView.h"
#import "HTBeautyView.h"
#import "HTARItemView.h"
#import "HTMattingView.h"
#import "HTGestureView.h"
#import "HTTool.h"
#import "HTFilterView.h"
#import "HTRestoreAlertView.h"
#import "HTLandmarkView.h"

@interface HTUIManager ()<HTRestoreAlertViewDelegate>

@property (nonatomic, weak) id <HTUIManagerDelegate>delegate;

// 添加退出手势的View
@property (nonatomic, strong) UIView *exitTapView;

// 当前显示的状态
@property (nonatomic, assign) ShowStatus showStatus;

// 功能选择视图
@property (nonatomic, strong) HTOptionalView *optionalView;
@property (nonatomic, strong) HTBeautyView *beautyView;
@property (nonatomic, strong) HTARItemView *itemView;
@property (nonatomic, strong) HTGestureView* gestureView;
@property (nonatomic, strong) HTMattingView* mattingView;
@property (nonatomic, strong) HTFilterView* filterView;

// 关键点视图
@property (nonatomic, strong) HTLandmarkView *landmarkView;

///**
// *   弹出美颜功能选择页面
// */
//- (void)showOptionalView;

@end

@implementation HTUIManager
// MARK: --单例初始化方法--
+ (HTUIManager *)shareManager{
    static id shareManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        shareManager = [[HTUIManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentMode = HTEffectViewContentModeScaleAspectFill;
        self.resolutionSize = CGSizeMake(720, 1280);
        
        // 初始化相关参数
        int value = [HTTool getFloatValueForKey:HT_ALL_EFFECT_CACHES];
        if (value == 0) {
            NSLog(@"---------------  initEffectValue");
            [HTTool initEffectValue];
        }
    }
    return self;
}

#pragma mark - 弹框代理方法 HTRestoreAlertViewDelegate
- (void)alertViewDidSelectedStatus:(BOOL)status {
    
    if (status) {
        [HTTool resetAll];
        
        if(self.beautyView){
            [self.beautyView removeFromSuperview];
            self.beautyView = nil;
        }
        if(self.itemView){
            [self.itemView removeFromSuperview];
            self.itemView = nil;
        }
        if(self.mattingView){
            [self.mattingView removeFromSuperview];
            self.mattingView = nil;
        }
        if(self.gestureView){
            [self.gestureView removeFromSuperview];
            self.gestureView = nil;
        }
        if(self.filterView){
            [self.filterView removeFromSuperview];
            self.filterView = nil;
        }
    }
    
    self.superWindow.hidden = YES;
    // 关闭退出手势--防止被打断
    self.exitEnable = NO;
}

// MARK: 懒加载
- (HTLandmarkView *)landmarkView{
    if(!_landmarkView){
        _landmarkView = [[HTLandmarkView alloc] initWithFrame:CGRectMake(0, 0, HTScreenWidth, HTScreenHeight)];
        _landmarkView.backgroundColor = [UIColor clearColor];
    }
    return _landmarkView;
}

- (UIWindow *)superWindow{
    if (!_superWindow) {
        _superWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _superWindow.windowLevel = UIWindowLevelAlert;
        _superWindow.userInteractionEnabled = YES;
        [_superWindow makeKeyAndVisible];
        _superWindow.hidden = YES;
    }
    return _superWindow;
}

- (HTDefaultButton *)defaultButton{
    if (!_defaultButton) {
        CGFloat height = HTHeight(162) + 2 * [[HTAdapter shareInstance] getSaftAreaHeight];
        _defaultButton = [[HTDefaultButton alloc] initWithFrame:CGRectMake(0, HTScreenHeight - height, HTScreenWidth,height)];
        WeakSelf;
        _defaultButton.defaultButtonCameraBlock = ^{
            //拍照
            if ([weakSelf.delegate respondsToSelector:@selector(didClickCameraCaptureButton)]) {
                [weakSelf.delegate didClickCameraCaptureButton];
            }
        };
        _defaultButton.defaultButtonBeautyBlock = ^{
            //显示功能显示页
            [weakSelf showOptionalView];
        };
        _defaultButton.defaultButtonResetBlock = ^{
            // 重置
            weakSelf.superWindow.hidden = NO;
            // 关闭退出手势--防止被打断
            weakSelf.exitEnable = YES;
            [HTRestoreAlertView showWithTitle:@"是否将所有效果恢复到默认?" delegate:weakSelf];
        };
        
        _defaultButton.defaultButtonVideoBlock = ^(NSInteger status) {
            // 录制视频
            if ([weakSelf.delegate respondsToSelector:@selector(didClickVideoCaptureButton:)]) {
                [weakSelf.delegate didClickVideoCaptureButton:status];
            }
        };
    }
    return _defaultButton;
}

- (UIView *)exitTapView{
    if (!_exitTapView) {
        _exitTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(170))];
        _exitTapView.hidden = YES;
        _exitTapView.userInteractionEnabled = YES;
        [_exitTapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onExitTap)]];
    }
    return _exitTapView;
}

- (HTOptionalView *)optionalView{
    if (!_optionalView) {
        _optionalView = [[HTOptionalView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(170))];
//        _optionalView.backgroundColor = HTColors(0, 0.6);
        WeakSelf;
        [_optionalView setOnClickOptionalBlock:^(NSInteger tag) {
            switch (tag) {
                case 0:
                    [weakSelf showBeautyView];
                    break;
                case 1:
                    [weakSelf showARItemView];
                    break;
                case 2:
                    [weakSelf showMattingView];
                    break;
                case 3:
                    [weakSelf showGestureView];
                    break;
                case 4:
                    [weakSelf showFilterView];
                    break;
                default:
                    break;
            }
        }];
    }
    return _optionalView;
}

- (HTBeautyView *)beautyView{
    if (!_beautyView) {
        _beautyView = [[HTBeautyView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(326))];
    }
    return _beautyView;
}

- (HTARItemView *)itemView{
    if (!_itemView) {
        _itemView = [[HTARItemView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(278))];
    }
    return _itemView;
}

- (HTGestureView *)gestureView{
    if (!_gestureView) {
        _gestureView = [[HTGestureView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(267))];
    }
    return _gestureView;
}

- (HTMattingView *)mattingView{
    if (!_mattingView) {
        _mattingView = [[HTMattingView alloc] initWithFrame:CGRectMake(0, HTScreenHeight, HTScreenWidth, HTHeight(353))];// HTHeight(278))
    }
    return _mattingView;
}

- (HTFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[HTFilterView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(326))];
    }
    return _filterView;
}

- (UIWindow*)mainWindow{
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    } else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    return nil;
}

- (void)clickCameraButton{
    [self.delegate didClickCameraCaptureButton];
}

// MARK: --弹出美颜功能选择UI--
- (void)showOptionalView{
    
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    // 关闭退出手势--防止被打断
    self.exitEnable = false;
    [self cameraButtonShow:ShowOptional];
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, HTScreenHeight - HTHeight(170), HTScreenWidth, HTHeight(170));
    }completion:^(BOOL finished) {
        self.showStatus = ShowOptional;
        // 更新并开启退出手势
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(170));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出美颜--
- (void)showBeautyView{
    if(![self.superWindow.subviews containsObject:self.beautyView]){
        [self.superWindow addSubview:self.beautyView];
        // 避免在白色主题下重置所有参数后再弹出时回到初始化状态
        if (self.themeWhite) {
            self.beautyView.isThemeWhite = YES;
        }
    }
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, HTScreenHeight, HTScreenWidth, HTHeight(170));
    }completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.beautyView.frame = CGRectMake(0, HTScreenHeight - HTHeight(326), HTScreenWidth, HTHeight(326));
    }completion:^(BOOL finished) {
        self.showStatus = ShowBeauty;
        [self cameraButtonShow:self.showStatus];
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(326));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出AR道具--
- (void)showARItemView{
    if(![self.superWindow.subviews containsObject:self.itemView]){
        [self.superWindow addSubview:self.itemView];
    }
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, HTScreenHeight, HTScreenWidth, HTHeight(170));
    }completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.itemView.frame = CGRectMake(0, HTScreenHeight - HTHeight(278), HTScreenWidth, HTHeight(278));
    }completion:^(BOOL finished) {
        self.showStatus = ShowARItem;
        [self cameraButtonShow:self.showStatus];
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(278));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出手势--
- (void)showGestureView{
    if(![self.superWindow.subviews containsObject:self.gestureView]){
        [self.superWindow addSubview:self.gestureView];
    }

    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, HTScreenHeight, HTScreenWidth, HTHeight(170));
    }completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.gestureView.frame = CGRectMake(0, HTScreenHeight - HTHeight(267), HTScreenWidth, HTHeight(267));
    }completion:^(BOOL finished) {
        self.showStatus = ShowGesture;
        [self cameraButtonShow:self.showStatus];
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(267));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出人像分割--
- (void)showMattingView{
    if(![self.superWindow.subviews containsObject:self.mattingView]){
        [self.superWindow addSubview:self.mattingView];
    }
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, HTScreenHeight, HTScreenWidth, HTHeight(170));
    }completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.mattingView.frame = CGRectMake(0, HTScreenHeight - HTHeight(353), HTScreenWidth, HTHeight(353));
    }completion:^(BOOL finished) {
        self.showStatus = ShowMatting;
        [self cameraButtonShow:self.showStatus];
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(353));
        self.exitEnable = true;
    }];
}


// MARK: --弹出滤镜--
- (void)showFilterView{
    if(![self.superWindow.subviews containsObject:self.filterView]){
        [self.superWindow addSubview:self.filterView];
        if (self.themeWhite) {
            self.filterView.isThemeWhite = YES;
        }
    }
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, HTScreenHeight, HTScreenWidth, HTHeight(170));
    }completion:^(BOOL finished) {
       
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.filterView.frame = CGRectMake(0, HTScreenHeight - HTHeight(326), HTScreenWidth, HTHeight(326));
    }completion:^(BOOL finished) {
        self.showStatus = ShowFilter;
        [self cameraButtonShow:self.showStatus];
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(326));
        self.exitEnable = true;
    }];
    
}

-(void)hideView:(BOOL)showOptional{
    
    if (self.exitEnable) {
        // 关闭退出手势--防止被打断
        self.exitEnable = false;
        switch (self.showStatus) {
            case ShowOptional:
            {
                showOptional = NO;
                [self cameraButtonShow:ShowNone];
                [UIView animateWithDuration:0.3 animations:^{
                    self.optionalView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(170));
                }completion:^(BOOL finished) {
                    self.showStatus = ShowNone;
                    [self.defaultButton setHidden:NO];
                    // 更新并开启退出手势
                    self.exitEnable = true;
                    self.exitTapView.hidden = YES;
                    self.superWindow.hidden = YES;
                }];
            }
                break;
            case ShowBeauty:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.beautyView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(326));
                }completion:nil];
             
            }
                break;
            case ShowARItem:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.itemView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(278));
                }completion:nil];
                 
            }
                break;
            case ShowGesture:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.gestureView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(267));
                }completion:nil];
            }
                break;
            case ShowMatting:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.mattingView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(353));
                }completion:nil];
            }
                break;
            case ShowFilter:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.filterView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(326));
                }completion:nil];
            }
                break;
            default:
                break;
        }
        
        if(showOptional){
            [self cameraButtonShow:ShowOptional];
            [UIView animateWithDuration:0.3 animations:^{
                self.optionalView.frame = CGRectMake(0, HTScreenHeight - HTHeight(170), HTScreenWidth, HTHeight(170));
            } completion:^(BOOL finished) {
                self.showStatus = ShowOptional;
                self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(170));
                self.exitEnable = true;
            }];
        }
    }
}

#pragma mark - 更加当前状态通知外部拍照按钮的显示或者隐藏
- (void)cameraButtonShow:(ShowStatus)status {
    
    if ([self.delegate respondsToSelector:@selector(didCameraCaptureButtonShow:)]) {
        [self.delegate didCameraCaptureButtonShow:status==0 || status==5 ? NO : YES];
    }
}

// MARK: --退出手势相关--
- (void)onExitTap{
    [self hideView:YES];
}

// MARK: --loadToWindow 相关代码--
- (void)loadToWindowDelegate:(id<HTUIManagerDelegate>)delegate{
    
    self.delegate = delegate;
    
    if(![self.superWindow.subviews containsObject:self.landmarkView]){
        [self.superWindow addSubview:self.landmarkView];
    }
    
    if(![self.superWindow.subviews containsObject:self.exitTapView]){
        [self.superWindow addSubview:self.exitTapView];
    }
    if(![self.superWindow.subviews containsObject:self.optionalView]){
        [self.superWindow addSubview:self.optionalView];
    }
    
}

#pragma mark - 切换主题
- (void)setThemeWhite:(BOOL)themeWhite {
    _themeWhite = themeWhite;
    self.optionalView.isThemeWhite = themeWhite;
    self.beautyView.isThemeWhite = themeWhite;
    self.filterView.isThemeWhite = themeWhite;
    self.defaultButton.isThemeWhite = themeWhite;
}

#pragma mark - 显示拍照/视频按钮
- (void)setDefaultButtonCameraShow:(BOOL)defaultButtonCameraShow {
    _defaultButtonCameraShow = defaultButtonCameraShow;
    if (defaultButtonCameraShow) {
        self.defaultButton.cameraShow = YES;
    }
}

#pragma mark - 关键点展示
- (void)showLandmark:(NSInteger)type orientation:(HTEffectViewOrientation)orientation resolutionWidth:(NSInteger)resolutionWidth resolutionHeight:(NSInteger)resolutionHeight{
    
    return;
    // todo 关键点展示
    NSArray *array = [[HTEffect shareInstance] getFaceDetectionReport];
    self.landmarkView.drawEnable = @0;
    if(array.count > 0){//识别到人脸
        CGFloat imageOnPreviewScale = MAX(HTScreenWidth / resolutionWidth, HTScreenHeight / resolutionHeight);
        CGFloat previewImageWidth = resolutionWidth * imageOnPreviewScale;
        CGFloat previewImageHeight = resolutionHeight * imageOnPreviewScale;
        for(int i = 0; i < array.count; i++){
            HTFaceDetectionReport *report = array[i];
            UIDevice *device = [UIDevice currentDevice];
            switch (device.orientation) {
                case UIDeviceOrientationPortrait:
                    self.landmarkView.faceRect = CGRectMake(report.rect.origin.x * imageOnPreviewScale - (previewImageWidth - HTScreenWidth) / 2, report.rect.origin.y * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    self.landmarkView.faceRect = CGRectMake(previewImageWidth - report.rect.origin.x * imageOnPreviewScale - (previewImageWidth - HTScreenWidth) / 2 - report.rect.size.width * imageOnPreviewScale, previewImageHeight - report.rect.origin.y * imageOnPreviewScale - report.rect.size.height * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                case UIDeviceOrientationLandscapeLeft:
                    self.landmarkView.faceRect = CGRectMake(previewImageWidth - report.rect.origin.y * imageOnPreviewScale - (previewImageWidth - HTScreenWidth) / 2 - report.rect.size.height * imageOnPreviewScale,  report.rect.origin.x * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                case UIDeviceOrientationLandscapeRight:
                    self.landmarkView.faceRect = CGRectMake((report.rect.origin.y * imageOnPreviewScale - (previewImageWidth - HTScreenWidth) / 2), previewImageHeight - report.rect.origin.x * imageOnPreviewScale - report.rect.size.width * imageOnPreviewScale, report.rect.size.width * imageOnPreviewScale, report.rect.size.height * imageOnPreviewScale);
                    break;
                default:
                    break;
            }
            self.landmarkView.pointXArray = [[NSMutableArray alloc] init];
            self.landmarkView.pointYArray = [[NSMutableArray alloc] init];
            for(int j = 0; j < 106; j++){
                NSLog(@"111111111111 ==== %d", i);
                CGPoint point = report.keyPoints[j];
                //默认HTEffectViewOrientationPortrait
                CGFloat x = imageOnPreviewScale * point.x - (previewImageWidth - HTScreenWidth) / 2;
                CGFloat y = imageOnPreviewScale * point.y;
                switch (orientation) {
                    case HTEffectViewOrientationLandscapeRight:
                        y = previewImageHeight - imageOnPreviewScale * point.x;
                        x = previewImageWidth - imageOnPreviewScale * point.y - (previewImageWidth - HTScreenWidth) / 2;
                        break;
                    case HTEffectViewOrientationPortraitUpsideDown:
                        x = imageOnPreviewScale * point.x - (previewImageWidth - HTScreenWidth) / 2;
                        y = previewImageHeight - imageOnPreviewScale * point.y;
                        break;
                    case HTEffectViewOrientationLandscapeLeft:
                        y = imageOnPreviewScale * point.x;
                        x = imageOnPreviewScale * point.y - (previewImageWidth - HTScreenWidth) / 2;
                        break;
                    default:
                        break;
                }
                [self.landmarkView.pointXArray addObject:@(x)];
                [self.landmarkView.pointYArray addObject:@(y)];
            }
            self.landmarkView.drawEnable = @1;
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.drawLabel1.text = [NSString stringWithFormat:@"yaw:%f",report.yaw];
//                self.drawLabel2.text = [NSString stringWithFormat:@"pitch:%f",report.pitch];
//                self.drawLabel3.text = [NSString stringWithFormat:@"roll:%f",report.roll];
                [self.landmarkView setNeedsDisplay];
            });
        }
    }
    NSLog(@"人脸数量:%lu",(unsigned long)array.count);
}


// MARK: --destroy释放 相关代码--
- (void)destroy{
    
    [HTTool setFloatValue:1 forKey:HT_ALL_EFFECT_CACHES];

    [_defaultButton removeFromSuperview];
    _defaultButton = nil;
    
    [_exitTapView removeFromSuperview];
    _exitTapView = nil;
    
    [_superWindow removeFromSuperview];
    _superWindow = nil;
    
    if (self.landmarkView){
        [self.landmarkView removeFromSuperview];
        self.landmarkView = nil;
    }
    
}

@end
