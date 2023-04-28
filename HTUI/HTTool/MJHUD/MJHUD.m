//
//  MJHUD.m
//  MJHUD
//
//  Created by mingjin on 18/10/15.
//  Copyright © 2018年 mingjin. All rights reserved.
//

#import "MJHUD.h"
//#import "UIView+Extension.h"

#define MJHUDWidth 150
#define MJHUDMargin 12
#define MJHUDMessageHeight 50
#define MJHUDMessageFont [UIFont boldSystemFontOfSize:14]

#define AnimateDuration 0.2f
#define TipsDuration 2.0f

@interface MJHUD ()
@property (strong, nonatomic) UIImage *infoImage;
@property (strong, nonatomic) UIImage *successImage;
@property (strong, nonatomic) UIImage *errorImage;

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *hudView;

@property (nonatomic, weak) UIActivityIndicatorView *aivLoading;
@property (nonatomic, weak) UILabel *lblMessage;
@property (nonatomic, weak) UIImageView *imgSuccess;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIColor *activityIndicatorColor;


@end

@implementation MJHUD

+ (MJHUD *)hud {
    __strong static MJHUD *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
        sharedManager.messageColor = [UIColor whiteColor];
        sharedManager.activityIndicatorColor = [UIColor whiteColor];
    });
    
    return sharedManager;
}

#pragma mark - =======================Public=======================

+ (void)configMessageColor:(UIColor *)color {
    [self hud].messageColor = color;
}

+ (void)showLoading:(NSString *)message {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MJHUD *hud = [self hud];
    [window addSubview:hud];
    
    hud.lblMessage.text = message;
    hud.message = message;
    
    hud.lblMessage.hidden = NO;
    hud.aivLoading.hidden = NO;
    hud.imgSuccess.hidden = YES;
    
    [hud layoutSubviews];

    hud.transform = CGAffineTransformScale(hud.transform, 0.1, 0.1);
    [UIView animateWithDuration:AnimateDuration animations:^{
        hud.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    
}


+ (void)showSuccess:(NSString *)message {
    
    [MJHUD showInfo:message image:[MJHUD hud].successImage];
}

+ (void)showFaild:(NSString *)message {
    
    [MJHUD showInfo:message image:[MJHUD hud].errorImage];
}

+ (void)showInfo:(NSString *)message {

    [MJHUD showInfo:message image:[MJHUD hud].infoImage];
}
+ (void)showMessage:(NSString *)message {

    [MJHUD showInfo:message image:nil];
}

+ (void)showInfo:(NSString *)message image:(UIImage *)image{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MJHUD *hud = [self hud];
    hud.userInteractionEnabled = NO;
    [window addSubview:hud];
    
    hud.lblMessage.text = message;
    hud.message = message;
    
    hud.lblMessage.hidden = NO;
    hud.aivLoading.hidden = YES;
    if(image){
        hud.imgSuccess.hidden = NO;
        hud.imgSuccess.image = image;
    }else{
        hud.imgSuccess.hidden = YES;
    }
   
    
    [hud layoutSubviews];
    
    hud.transform = CGAffineTransformScale(hud.transform, 0.1, 0.1);
    [UIView animateWithDuration:AnimateDuration animations:^{
        hud.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TipsDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }];
}
+ (void)dismiss {
    MJHUD *hud = [self hud];
    [UIView animateWithDuration:AnimateDuration animations:^{
        hud.transform = CGAffineTransformScale(hud.transform, 0.1, 0.1);
    } completion:^(BOOL finished) {
        [hud removeFromSuperview];
    }];
}

#pragma mark - =======================Life Cycle=======================

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.overlayView];
        [self.overlayView addSubview:self.hudView];
        self.hudView.center = self.overlayView.center;

        _infoImage = [UIImage imageNamed:@"MJHUD.bundle/HUD_info"];
        _successImage = [UIImage imageNamed:@"MJHUD.bundle/HUD_success"];;
        _errorImage = [UIImage imageNamed:@"MJHUD.bundle/HUD_error"];;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 适配横竖屏切换
    self.overlayView.frame = [UIScreen mainScreen].bounds;
    
//    CGFloat hudWH = MJHUDWidth;
    CGFloat hudW = MJHUDWidth;
    CGFloat hudH = MJHUDWidth;
    CGFloat aivW = 37;
    CGFloat aivH = 37;
    
    CGFloat hudX = (screenW - hudW) * 0.5;
    CGFloat hudY = (screenH - hudH) * 0.5;
    self.hudView.frame = CGRectMake(hudX, hudY, hudW, hudH);
    
    CGFloat aivX = (hudW - aivW) * 0.5;
//    CGFloat aivY = (hudH - aivH) * 0.5;
    CGFloat aivY = MJHUDMargin;
    
    if(self.imgSuccess.hidden == YES &&self.aivLoading.hidden == YES){
        hudH = MJHUDMessageHeight;
        aivW = 0;
        aivH = 0;
        aivY = 0;
    }
      
    self.aivLoading.frame = CGRectMake(aivX, aivY, aivW, aivH);
    self.imgSuccess.frame = CGRectMake(aivX, aivY, aivW, aivH);

    // 有文字消息
    if(![@"" isEqualToString:self.message]) {
        CGSize size = [self sizeOfText:self.message WithMaxSize:CGSizeMake(MJHUDWidth - MJHUDMargin * 2, MAXFLOAT) font:MJHUDMessageFont];
        
        // 略微调高aiv
//        CGFloat aivY = (hudH - aivH) * 0.5 - 15;
//        self.aivLoading.frame = CGRectMake(self.aivLoading.frame.origin.x, aivY, self.aivLoading.frame.size.width, self.aivLoading.frame.size.height);
        
//        self.imgSuccess.frame = CGRectMake(self.imgSuccess.frame.origin.x, aivY, self.imgSuccess.frame.size.width, self.imgSuccess.frame.size.height);

        CGFloat messageW = MJHUDWidth - MJHUDMargin * 2;
        CGFloat messageH = size.height;
        CGFloat messageX = (hudW - messageW) * 0.5;
        CGFloat messageY = CGRectGetMaxY(self.aivLoading.frame) + MJHUDMargin;
        if(self.imgSuccess.hidden == YES &&self.aivLoading.hidden == YES){
            messageY = MJHUDMargin;
        }
        self.lblMessage.frame = CGRectMake(messageX, messageY, messageW, messageH);
        
        // 高超过限定值，增加自身高度
        if (size.height > (MJHUDMessageHeight)) {
            
            self.hudView.frame = CGRectMake(self.hudView.frame.origin.x, self.hudView.frame.origin.y, self.hudView.frame.size.width, CGRectGetMaxY(self.lblMessage.frame) + MJHUDMargin);
            
            self.hudView.center = self.overlayView.center;
        }
    }
}

#pragma mark - =======================Getter Setter=======================

- (void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    self.lblMessage.textColor = self.messageColor;
}

- (UIActivityIndicatorView *)aivLoading {
    if (_aivLoading == nil) {
        UIActivityIndicatorView *aivLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [aivLoading startAnimating];
        aivLoading.color = self.activityIndicatorColor;
        [self.hudView addSubview:aivLoading];
        _aivLoading = aivLoading;
    }
    return _aivLoading;
}

- (UILabel *)lblMessage {
    if (_lblMessage == nil) {
        UILabel *lblMessage = [[UILabel alloc] init];
        lblMessage.font = MJHUDMessageFont;
        lblMessage.numberOfLines = 0;
        lblMessage.textColor = self.messageColor;
        lblMessage.textAlignment = NSTextAlignmentCenter;
        [self.hudView addSubview:lblMessage];
        _lblMessage = lblMessage;
    }
    return _lblMessage;
}

- (UIImageView *)imgSuccess {
    if (_imgSuccess == nil) {
        UIImageView *imgSuccess = [[UIImageView alloc] init];
        [self.hudView addSubview:imgSuccess];
        _imgSuccess = imgSuccess;
    }
    return _imgSuccess;
}

- (UIControl*)overlayView {
    if(!_overlayView) {
#if !defined(SV_APP_EXTENSIONS)
        CGRect windowBounds = [[[UIApplication sharedApplication] delegate] window].bounds;
        _overlayView = [[UIControl alloc] initWithFrame:windowBounds];
#else
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
#endif
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

- (UIView *)hudView{
    if (!_hudView) {
        _hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MJHUDWidth, MJHUDWidth)];
        _hudView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _hudView.layer.masksToBounds = YES;
        _hudView.layer.cornerRadius = 20.0;
    }
    return _hudView;
}


#pragma mark --  size helper
- (CGSize)sizeOfText:(NSString *)text WithMaxSize:(CGSize)maxSize font:(UIFont *)font {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
