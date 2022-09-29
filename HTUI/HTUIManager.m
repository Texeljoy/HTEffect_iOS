//
//  HTUIManager.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import "HTUIManager.h"
#import "HTOptionalView.h"
#import "HTBeautyView.h"
#import "HTARItemView.h"
#import "HTMattingView.h"
#import "HTGestureView.h"
#import "HTTool.h"

@interface HTUIManager ()

typedef NS_ENUM(NSInteger, ShowStatus) {
    ShowOptional = 0,
    ShowBeauty = 1,
    ShowARItem = 2,
    ShowGesture = 3,
    ShowMatting = 4,
    ShowNone = 5,
};

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

/**
 *   弹出美颜功能选择页面
 */
- (void)showOptionalView;

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
        [_defaultButton setOnClickBlock:^(NSInteger tag) {
            switch (tag) {
                case 0:
                case 3:
                    //显示功能显示页
                    [weakSelf showOptionalView];
                    break;
                case 1:
                    //拍照
                    [weakSelf.delegate didClickCameraCaptureButton];
                    break;
                default:
                    break;
            }
            
        }];
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
        _optionalView.backgroundColor = HTColors(0, 0.6);
        WeakSelf;
        [_optionalView setOnClickBlock:^(NSInteger tag) {
            switch (tag) {
                case 0:
                    [weakSelf showBeautyView];
                    break;
                case 1:
                    [weakSelf showARItemView];
                    break;
                case 2:
                    [weakSelf showGestureView];
                    break;
                case 3:
                    [weakSelf showMattingView];
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
        WeakSelf;
        [_beautyView setOnClickBackBlock:^{
            [weakSelf onExitTap];
        }];
        [_beautyView setOnClickCameraBlock:^{
            [weakSelf clickCameraButton];
        }];
    }
    return _beautyView;
}

- (HTARItemView *)itemView{
    if (!_itemView) {
        _itemView = [[HTARItemView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(278))];
        _itemView.backgroundColor = HTColors(0, 0.7);
        WeakSelf;
        [_itemView setOnClickCameraBlock:^{
            [weakSelf clickCameraButton];
        }];
    }
    return _itemView;
}

- (HTGestureView *)gestureView{
    if (!_gestureView) {
        _gestureView = [[HTGestureView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(267))];
        _gestureView.backgroundColor = HTColors(0, 0.7);
        WeakSelf;
        [_gestureView setOnClickCameraBlock:^{
            [weakSelf clickCameraButton];
        }];
    }
    return _gestureView;
}

- (HTMattingView *)mattingView{
    if (!_mattingView) {
        _mattingView = [[HTMattingView alloc] initWithFrame:CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(278))];
        _mattingView.backgroundColor = HTColors(0, 0.7);
        WeakSelf;
        [_mattingView setOnClickCameraBlock:^{
            [weakSelf clickCameraButton];
        }];
    }
    return _mattingView;
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
    [self.superWindow setHidden:YES];
    self.isCameraBlock = YES;
}

// MARK: --弹出美颜功能选择UI--
- (void)showOptionalView{
    
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    // 关闭退出手势--防止被打断
    self.exitEnable = false;
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
    
    [self.superWindow addSubview:self.beautyView];
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
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(326));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出AR道具--
- (void)showARItemView{
    
    [self.superWindow addSubview:self.itemView];
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
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(278));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出手势--
- (void)showGestureView{
    
    [self.superWindow addSubview:self.gestureView];
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
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(267));
        self.exitEnable = true;
    }];
    
}

// MARK: --直接弹出AI抠图--
- (void)showMattingView{
    
    [self.superWindow addSubview:self.mattingView];
    self.exitTapView.hidden = NO;
    self.superWindow.hidden = NO;
    self.exitEnable = false;
    [UIView animateWithDuration:0.3 animations:^{
        [self.defaultButton setHidden:YES];
        self.optionalView.frame = CGRectMake(0, HTScreenHeight, HTScreenWidth, HTHeight(170));
    }completion:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.mattingView.frame = CGRectMake(0, HTScreenHeight - HTHeight(278), HTScreenWidth, HTHeight(278));
    }completion:^(BOOL finished) {
        self.showStatus = ShowMatting;
        self.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(278));
        self.exitEnable = true;
    }];
    
}

// MARK: --退出手势相关--
- (void)onExitTap{
    WeakSelf;
    if (self.exitEnable) {
        // 关闭退出手势--防止被打断
        self.exitEnable = false;
        switch (self.showStatus) {
            case ShowOptional:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.optionalView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(170));
                }completion:^(BOOL finished) {
                    weakSelf.showStatus = ShowNone;
                    [weakSelf.defaultButton setHidden:NO];
                    // 更新并开启退出手势
                    weakSelf.exitEnable = true;
                    weakSelf.exitTapView.hidden = YES;
                    weakSelf.superWindow.hidden = YES;
                }];
            }
                break;
            case ShowBeauty:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.beautyView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(326));
                }completion:nil];
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.optionalView.frame = CGRectMake(0, HTScreenHeight - HTHeight(170), HTScreenWidth, HTHeight(170));
                } completion:^(BOOL finished) {
                    weakSelf.showStatus = ShowOptional;
                    weakSelf.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(170));
                    weakSelf.exitEnable = true;
                }];
            }
                break;
            case ShowARItem:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.itemView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(278));
                }completion:nil];
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.optionalView.frame = CGRectMake(0, HTScreenHeight - HTHeight(170), HTScreenWidth, HTHeight(170));
                } completion:^(BOOL finished) {
                    weakSelf.showStatus = ShowOptional;
                    weakSelf.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(170));
                    weakSelf.exitEnable = true;
                }];
            }
                break;
            case ShowGesture:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.gestureView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(267));
                }completion:nil];
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.optionalView.frame = CGRectMake(0, HTScreenHeight - HTHeight(170), HTScreenWidth, HTHeight(170));
                } completion:^(BOOL finished) {
                    weakSelf.showStatus = ShowOptional;
                    weakSelf.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(170));
                    weakSelf.exitEnable = true;
                }];
            }
                break;
            case ShowMatting:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.mattingView.frame = CGRectMake(0,HTScreenHeight, HTScreenWidth, HTHeight(278));
                }completion:nil];
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.optionalView.frame = CGRectMake(0, HTScreenHeight - HTHeight(170), HTScreenWidth, HTHeight(170));
                } completion:^(BOOL finished) {
                    weakSelf.showStatus = ShowOptional;
                    weakSelf.exitTapView.frame = CGRectMake(0, 0, HTScreenWidth, HTScreenHeight - HTHeight(170));
                    weakSelf.exitEnable = true;
                }];
            }
                break;
            default:
                break;
        }
    }
}

// MARK: --loadToWindow 相关代码--
- (void)loadToWindowDelegate:(id<HTUIManagerDelegate>)delegate{
    
    self.delegate = delegate;
    [self.superWindow addSubview:self.exitTapView];
    [self.superWindow addSubview:self.optionalView];
    
    NSArray *SkinBeautyArray = [HTTool jsonModeForPath:HTSkinBeautyPath withKey:@"HTSkinBeauty"];
    NSArray *FaceBeautyArray = [HTTool jsonModeForPath:HTFaceBeautyPath withKey:@"HTFaceBeauty"];
    NSArray *FilterArray = [HTTool jsonModeForPath:HTFilterPath withKey:@"ht_filter"];
    
    /* ========================================《 美颜 》======================================== */
    for (int i = 0; i < SkinBeautyArray.count; i++) {
        if (i == 1) {
            // 朦胧磨皮指定初始值
            if (![HTTool judgeCacheValueIsNullForKey:@"HT_SKIN_HAZYBLURRINESS_SLIDER"]) {
                [HTTool setFloatValue:60 forKey:@"HT_SKIN_HAZYBLURRINESS_SLIDER"];
            }
            [[HTEffect shareInstance] setBeauty:HTBeautyBlurrySmoothing value:[HTTool getFloatValueForKey:@"HT_SKIN_HAZYBLURRINESS_SLIDER"]];
        }else{
            HTModel *model = [[HTModel alloc] initWithDic:SkinBeautyArray[i]];
            if (![HTTool judgeCacheValueIsNullForKey:model.key]) {
                [HTTool setFloatValue:model.defaultValue forKey:model.key];
            }
            [[HTEffect shareInstance] setBeauty:model.idCard value:[HTTool getFloatValueForKey:model.key]];
        }
    }
    
    /* ========================================《 美型 》======================================== */
    for (int i = 0; i < FaceBeautyArray.count; i++) {
        HTModel *model = [[HTModel alloc] initWithDic:FaceBeautyArray[i]];
        if (![HTTool judgeCacheValueIsNullForKey:model.key]) {
            [HTTool setFloatValue:model.defaultValue forKey:model.key];
        }
        [[HTEffect shareInstance] setReshape:model.idCard value:[HTTool getFloatValueForKey:model.key]];
    }
    
    /* ========================================《 滤镜 》======================================== */
    for (int i = 0; i < FilterArray.count; i++) {
        NSString *key = [@"HT_FILTER_SLIDER" stringByAppendingFormat:@"%d",i];
        if (![HTTool judgeCacheValueIsNullForKey:key]) {
            [HTTool setFloatValue:100 forKey:key];
        }
        //判断选中的滤镜位置
        if (i == [HTTool getFloatValueForKey:@"HT_FILTER_SELECTED_POSITION"]) {
            HTModel *model = [[HTModel alloc] initWithDic:FilterArray[i]];
            [[HTEffect shareInstance] setFilter:model.name value:[HTTool getFloatValueForKey:key]];
        }
    }
    
}

// MARK: --destroy释放 相关代码--
- (void)destroy{
    
    [HTTool setFloatValue:0 forKey:@"HT_ARITEM_STICKER_POSITION"];
    [HTTool setFloatValue:0 forKey:@"HT_ARITEM_WATERMARK_POSITION"];
    [HTTool setFloatValue:0 forKey:@"HT_MATTING_AI_POSITION"];
    [HTTool setFloatValue:0 forKey:@"HT_MATTING_GS_POSITION"];

    [_defaultButton removeFromSuperview];
    _defaultButton = nil;
    
    [_exitTapView removeFromSuperview];
    _exitTapView = nil;
    
    [_superWindow removeFromSuperview];
    _superWindow = nil;
    
}

@end
