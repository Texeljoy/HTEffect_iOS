//
//  HTStickerView.m
//  HTStickerView
//
//  Created by HTLab on 23/4/27.
//  Copyright © 2023年 HTLab. All rights reserved.
//

#import "HTStickerView.h"

@interface HTStickerView()<UIGestureRecognizerDelegate>

/**
 CtrlTypeOne
 变换控制图
 */
@property (strong, nonatomic) UIImageView *transformCtrl;//同时控制旋转和缩放，右下角

/**
 CtrlTypeTwo
 变换控制图
 */
@property (strong, nonatomic) UIImageView *rotateCtrl;//控制旋转，右上角
@property (strong, nonatomic) UIImageView *resizeCtrl;//控制缩放，右下角

/**
 移除StickerView
 */
@property (strong, nonatomic) UIImageView *removeCtrl;

/**
 参考点视图
 */
@property (strong, nonatomic) UIView *oCtrlPointView;

/**
 旋转的初始水平角度
 */
@property (nonatomic) CGFloat initialAngle;


/**
 记录上一个控制点
 */
@property (nonatomic) CGPoint lastCtrlPoint;


/**
 self的手势
 */
@property (nonatomic) UIPinchGestureRecognizer *pinchGesture;     //捏合手势
@property (nonatomic) UIRotationGestureRecognizer *rotateGesture; //旋转手势
@property (nonatomic) UIPanGestureRecognizer *panGesture;         //拖动手势


@end

@implementation HTStickerView

#define CTRL_RADIUS 10 //控制图的半径


- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super init];
    if (self) {
        self.contentView = contentView;
        [self showRemoveCtrl:YES];
        self.ctrlType = HTStickerViewCtrlTypeGesture;//默认为手势模式
        self.originalPoint = CGPointMake(0.5, 0.5);  //默认参考点为中心点
        self.scaleFit = YES;
        
        [self addGestureRecognizer:self.panGesture];//添加拖动手势，所有模式通用
        
        
        
        //        self.hidden
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            NSLog(@"%@",self.superview);
        //        });
        
    }
    return self;
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //监听父视图是否消失通知本地view 进行刷新位置
    //    [self.superview addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    /**
     keyPath=age,object=<HJPerson: 0x7fe64af086e0>,change={
     kind = 1;
     new = 20;
     },context=(null)
     */
    //    NSLog(@"keyPath=%@,object=%@,change=%@,context=%@",keyPath,object,change,context);
    //    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //     NSString *ageStr = [numberFormatter stringFromNumber:[change objectForKey:@"new"]];
    //    UIWindow *w = (UIWindow *)object;
    //    if (w.hidden == NO) {
    //        [self allGestureEevent];
    //    }
    
}



#pragma mark - setter & getter 方法


/* setter */

- (void)setContentView:(UIView *)contentView {
    
    if (_contentView) {
        [_contentView removeFromSuperview];
        _contentView = nil;
        self.transform = CGAffineTransformIdentity;
    }
    _contentView = contentView;
    self.frame = _contentView.frame;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:_contentView atIndex:0];
}


- (void)setCtrlType:(HTStickerViewCtrlType)ctrlType {
    _ctrlType = ctrlType;
    switch (_ctrlType) {
        case HTStickerViewCtrlTypeGesture:
            if (![self.gestureRecognizers containsObject:self.pinchGesture]) {
                [self addGestureRecognizer:self.pinchGesture];
            }
            if (![self.gestureRecognizers containsObject:self.rotateGesture]) {
                [self addGestureRecognizer:self.rotateGesture];
            }
            self.transformCtrl.hidden = YES;
            self.rotateCtrl.hidden = YES;
            self.resizeCtrl.hidden = YES;
            break;
            
        case HTStickerViewCtrlTypeOne:
            //            if ([self.gestureRecognizers containsObject:self.pinchGesture]) {
            //                [self removeGestureRecognizer:self.pinchGesture];
            //            }
            //            if ([self.gestureRecognizers containsObject:self.rotateGesture]) {
            //                [self removeGestureRecognizer:self.rotateGesture];
            //            }
            if (![self.gestureRecognizers containsObject:self.pinchGesture]) {
                [self addGestureRecognizer:self.pinchGesture];
            }
            if (![self.gestureRecognizers containsObject:self.rotateGesture]) {
                [self addGestureRecognizer:self.rotateGesture];
            }
            self.transformCtrl.hidden = NO;
            self.rotateCtrl.hidden = YES;
            self.resizeCtrl.hidden = YES;
            break;
            
        case HTStickerViewCtrlTypeTwo:
            //            if ([self.gestureRecognizers containsObject:self.pinchGesture]) {
            //                [self removeGestureRecognizer:self.pinchGesture];
            //            }
            //            if ([self.gestureRecognizers containsObject:self.rotateGesture]) {
            //                [self removeGestureRecognizer:self.rotateGesture];
            //            }
            if (![self.gestureRecognizers containsObject:self.pinchGesture]) {
                [self addGestureRecognizer:self.pinchGesture];
            }
            if (![self.gestureRecognizers containsObject:self.rotateGesture]) {
                [self addGestureRecognizer:self.rotateGesture];
            }
            self.transformCtrl.hidden = YES;
            self.rotateCtrl.hidden = NO;
            self.resizeCtrl.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)setOriginalPoint:(CGPoint)originalPoint {
    //    if (self.ctrlType == HTStickerViewCtrlTypeGesture) {
    //        _originalPoint = CGPointMake(0.5, 0.5);
    //        return;
    //    }
    _originalPoint = originalPoint;
    [self updateCtrlPoint];
}


/* getter */

- (UIImageView *)transformCtrl {
    if (!_transformCtrl) {
        CGRect frame = CGRectMake(self.bounds.size.width - CTRL_RADIUS,
                                  self.bounds.size.height - CTRL_RADIUS,
                                  CTRL_RADIUS * 2,
                                  CTRL_RADIUS * 2);
        _transformCtrl = [[UIImageView alloc] initWithFrame:frame];
        _transformCtrl.backgroundColor = [UIColor redColor];
        _transformCtrl.userInteractionEnabled = YES;
        _transformCtrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_transformCtrl];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(transformCtrlPan:)];
        [_transformCtrl addGestureRecognizer:panGesture];
    }
    return _transformCtrl;
}

- (UIImageView *)rotateCtrl {
    if (!_rotateCtrl) {
        CGRect frame = CGRectMake(self.bounds.size.width - CTRL_RADIUS,
                                  0 - CTRL_RADIUS,
                                  CTRL_RADIUS * 2,
                                  CTRL_RADIUS * 2);
        _rotateCtrl = [[UIImageView alloc] initWithFrame:frame];
        _rotateCtrl.backgroundColor = [UIColor purpleColor];
        _rotateCtrl.userInteractionEnabled = YES;
        _rotateCtrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_rotateCtrl];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateCtrlPan:)];
        [_rotateCtrl addGestureRecognizer:panGesture];
    }
    return _rotateCtrl;
}

- (UIImageView *)resizeCtrl {
    if (!_resizeCtrl) {
        CGRect frame = CGRectMake(self.bounds.size.width - CTRL_RADIUS,
                                  self.bounds.size.height - CTRL_RADIUS,
                                  CTRL_RADIUS * 2,
                                  CTRL_RADIUS * 2);
        _resizeCtrl = [[UIImageView alloc] initWithFrame:frame];
        _resizeCtrl.backgroundColor = [UIColor brownColor];
        _resizeCtrl.userInteractionEnabled = YES;
        _resizeCtrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_resizeCtrl];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeCtrlPan:)];
        [_resizeCtrl addGestureRecognizer:panGesture];
    }
    return _resizeCtrl;
}

- (UIImageView *)removeCtrl {
    if (!_removeCtrl) {
        CGRect frame = CGRectMake(0 - CTRL_RADIUS,
                                  0 - CTRL_RADIUS,
                                  CTRL_RADIUS * 2,
                                  CTRL_RADIUS * 2);
        _removeCtrl = [[UIImageView alloc] initWithFrame:frame];
        _removeCtrl.backgroundColor = [UIColor blackColor];
        _removeCtrl.userInteractionEnabled = YES;
        [self addSubview:_removeCtrl];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCtrlTap:)];
        [_removeCtrl addGestureRecognizer:tapGesture];
    }
    return _removeCtrl;
}

- (CGPoint)getRealOriginalPoint {
    return CGPointMake(self.bounds.size.width * self.originalPoint.x,
                       self.bounds.size.height * self.originalPoint.y);
}

- (CGFloat)initialAngle {
    if (self.ctrlType == HTStickerViewCtrlTypeOne) {
        _initialAngle = atan2(-(self.transformCtrl.center.y - [self getRealOriginalPoint].y),
                              self.transformCtrl.center.x - [self getRealOriginalPoint].x);
    }
    if (self.ctrlType == HTStickerViewCtrlTypeTwo) {
        _initialAngle = atan2(-(self.rotateCtrl.center.y - [self getRealOriginalPoint].y),
                              self.rotateCtrl.center.x - [self getRealOriginalPoint].x);
    }
    return _initialAngle;
}

- (UIPinchGestureRecognizer *)pinchGesture {
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        _pinchGesture.delegate = self;
    }
    return _pinchGesture;
}

- (UIRotationGestureRecognizer *)rotateGesture {
    if (!_rotateGesture) {
        _rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        _rotateGesture.delegate = self;
    }
    return _rotateGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _panGesture.delegate = self;
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 2;
    }
    return _panGesture;
}


#pragma mark - 手势响应事件 --- 无控制图

- (void)rotate:(UIRotationGestureRecognizer *)gesture {
    NSUInteger touchCount = gesture.numberOfTouches;
    if (touchCount <= 1) {
        return;
    }
    
    CGPoint p1 = [gesture locationOfTouch: 0 inView:self];
    CGPoint p2 = [gesture locationOfTouch: 1 inView:self];
    CGPoint newCenter = CGPointMake((p1.x+p2.x)/2,(p1.y+p2.y)/2);
    self.originalPoint = CGPointMake(newCenter.x/self.bounds.size.width, newCenter.y/self.bounds.size.height);
    
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;
    
    self.transform = CGAffineTransformRotate(self.transform, gesture.rotation);
    //    NSLog(@"&&&** rotation %f",gesture.rotation);
    gesture.rotation = 0;
    
    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
    
    //    self.transform = CGAffineTransformRotate(self.transform, gesture.rotation);
    //    gesture.rotation = 0;
    
    //NSLog(@"%s",__func__);
    [self allGestureEevent];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    
    
    NSUInteger touchCount = gesture.numberOfTouches;
    if (touchCount <= 1) {
        return;
    }
    
    CGPoint p1 = [gesture locationOfTouch: 0 inView:self];
    CGPoint p2 = [gesture locationOfTouch: 1 inView:self];
    CGPoint newCenter = CGPointMake((p1.x+p2.x)/2,(p1.y+p2.y)/2);
    self.originalPoint = CGPointMake(newCenter.x/self.bounds.size.width, newCenter.y/self.bounds.size.height);
    
    
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;
    
    
    CGFloat scale = gesture.scale;
    if (self.scaleMode == HTStickerViewScaleModeBounds) {
        self.bounds = CGRectMake(self.bounds.origin.x,
                                 self.bounds.origin.y,
                                 self.bounds.size.width * scale,
                                 self.bounds.size.height * scale);
        self.contentView.maskView.frame = self.contentView.bounds;
        
        //        NSLog(@"count:%lu",(unsigned long)self.contentView.subviews.count);
        if (self.contentView.subviews.count >= 1) {
            UIView *view = self.contentView.subviews.firstObject;
            CGPoint center = view.center;
            view.bounds = CGRectMake(view.bounds.origin.x,
                                     view.bounds.origin.y,
                                     view.bounds.size.width * scale,
                                     view.bounds.size.height * scale);
            view.center = CGPointMake(center.x * scale, center.y * scale);
        }
        
    } else {
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
        [self fitCtrlScaleX:scale scaleY:scale];
    }
    
    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
    
    
    //    CGFloat scale = gesture.scale;
    //    if (self.scaleMode == HTStickerViewScaleModeBounds) {
    //        self.bounds = CGRectMake(self.bounds.origin.x,
    //                                 self.bounds.origin.y,
    //                                 self.bounds.size.width * scale,
    //                                 self.bounds.size.height * scale);
    //    } else {
    //        self.transform = CGAffineTransformScale(self.transform, scale, scale);
    //        [self fitCtrlScaleX:scale scaleY:scale];
    //    }
    gesture.scale = 1;
    
    //NSLog(@"%s",__func__);
    [self allGestureEevent];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    CGPoint pt = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + pt.x , self.center.y + pt.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:self.superview];
    
    //NSLog(@"%s",__func__);
    [self allGestureEevent];
}


#pragma mark - 手势响应事件 --- 一个控制图
- (void)transformCtrlPan:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastCtrlPoint = [self convertPoint:self.transformCtrl.center toView:self.superview];
        return;
    }
    
    CGPoint ctrlPoint = [gesture locationInView:self.superview];
    
    // scale
    [self scaleFitWithCtrlPoint:ctrlPoint];
    
    // rotate
    [self rotateAroundOPointWithCtrlPoint:ctrlPoint];
    
    self.lastCtrlPoint = ctrlPoint;
    
    //NSLog(@"%s",__func__);
    [self allGestureEevent];
}


#pragma mark - 手势响应事件 --- 两个控制图
- (void)rotateCtrlPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastCtrlPoint = [self convertPoint:self.rotateCtrl.center toView:self.superview];
        return;
    }
    
    CGPoint ctrlPoint = [gesture locationInView:self.superview];
    [self rotateAroundOPointWithCtrlPoint:ctrlPoint];
    
    self.lastCtrlPoint = ctrlPoint;
    
}

- (void)resizeCtrlPan:(UIPanGestureRecognizer *)gesture {
    //等比缩放
    if (self.isScaleFit) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            self.lastCtrlPoint = [self convertPoint:self.resizeCtrl.center toView:self.superview];
            return;
        }
        
        CGPoint ctrlPoint = [gesture locationInView:self.superview];
        [self scaleFitWithCtrlPoint:ctrlPoint];
        
        self.lastCtrlPoint = ctrlPoint;
        return;
    }
    
    //自由缩放 ScaleModeBounds
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastCtrlPoint = self.resizeCtrl.center;
        return;
    }
    
    CGPoint ctrlPoint = [gesture locationInView:self];
    [self scaleFreeByChangeBoundsWithCtrlPoint:ctrlPoint ctrlCenter:self.resizeCtrl.center];
    
    self.lastCtrlPoint = ctrlPoint;
    [self allGestureEevent];
    return;
    
    
    //自由缩放 ScaleModeTransform
    /*if (gesture.state == UIGestureRecognizerStateBegan) {
     self.lastCtrlPoint = [self convertPoint:self.resizeCtrl.center toView:self.superview];
     return;
     }
     
     CGPoint ctrlPoint = [gesture locationInView:self.superview];
     [self scaleFreeByChangeTransformWithCtrlPoint:ctrlPoint ctrlCenter:self.resizeCtrl.center];
     
     self.lastCtrlPoint = ctrlPoint;*/
    
    //NSLog(@"%s",__func__);
    
}


#pragma mark - 旋转 --- 实现
- (void)rotateAroundOPointWithCtrlPoint:(CGPoint)ctrlPoint {
    
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x - (self.center.x - oPoint.x),
                              self.center.y - (self.center.y - oPoint.y));
    
    
    float angle = atan2(self.center.y - ctrlPoint.y, ctrlPoint.x - self.center.x);
    float lastAngle = atan2(self.center.y - self.lastCtrlPoint.y, self.lastCtrlPoint.x - self.center.x);
    angle = - angle + lastAngle;
    self.transform = CGAffineTransformRotate(self.transform, angle);
    //    NSLog(@"&&&** angle  %f",angle);
    
    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
    
    //NSLog(@"%s",__func__);
    [self allGestureEevent];
}


#pragma mark - 缩放 --- 实现
/* 等比缩放 */
- (void)scaleFitWithCtrlPoint:(CGPoint)ctrlPoint {
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;
    
    
    CGFloat preDistance = [self distanceWithStartPoint:self.center endPoint:self.lastCtrlPoint];
    CGFloat newDistance = [self distanceWithStartPoint:self.center endPoint:ctrlPoint];
    CGFloat scale = newDistance / preDistance;
    if (self.scaleMode == HTStickerViewScaleModeBounds) {
        self.bounds = CGRectMake(self.bounds.origin.x,
                                 self.bounds.origin.y,
                                 self.bounds.size.width * scale,
                                 self.bounds.size.height * scale);
        [self updateCtrlPoint];
    } else {
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
        [self fitCtrlScaleX:scale scaleY:scale];
    }
    
    
    
    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
    
    //NSLog(@"%s",__func__);
    [self allGestureEevent];
}

/* 自由缩放 ScaleModeBounds */
- (void)scaleFreeByChangeBoundsWithCtrlPoint:(CGPoint)ctrlPoint ctrlCenter:(CGPoint)ctrlCenter {
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;
    
    
    CGFloat cX = ctrlPoint.x - self.lastCtrlPoint.x;
    CGFloat cY = ctrlPoint.y - self.lastCtrlPoint.y;
    
    if ([self getRealOriginalPoint].y == ctrlCenter.y) {
        cY = 0;
    }
    if ([self getRealOriginalPoint].x == ctrlCenter.x) {
        cX = 0;
    }
    
    CGFloat width = self.bounds.size.width + cX;
    CGFloat height = self.bounds.size.height + cY;
    if (width > 0 && height > 0) {
        self.bounds = CGRectMake(self.bounds.origin.x,
                                 self.bounds.origin.y,
                                 self.bounds.size.width + cX,
                                 self.bounds.size.height + cY);
        [self updateCtrlPoint];
    }
    
    
    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
    
    //NSLog(@"%s",__func__);
    [self allGestureEevent];
}

/* 自由缩放 ScaleModeTransform */
/*- (void)scaleFreeByChangeTransformWithCtrlPoint:(CGPoint)ctrlPoint ctrlCenter:(CGPoint)ctrlCenter {
 CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
 self.center = oPoint;
 
 
 CGFloat cX = ctrlPoint.x - self.lastCtrlPoint.x;
 CGFloat cY = ctrlPoint.y - self.lastCtrlPoint.y;
 CGFloat preDistanceX = self.lastCtrlPoint.x - self.center.x;
 CGFloat preDistanceY = self.lastCtrlPoint.y - self.center.y;
 CGFloat scaleX = cX / preDistanceX + 1;
 CGFloat scaleY = cY / preDistanceY + 1;
 
 self.transform = CGAffineTransformScale(self.transform, scaleX, scaleY);
 [self fitCtrlScaleX:scaleX scaleY:scaleY];
 
 
 oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
 self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
 self.center.y + (self.center.y - oPoint.y));
 }*/

/* 控制图保持大小不变 */
- (void)fitCtrlScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    self.removeCtrl.transform = CGAffineTransformScale(self.removeCtrl.transform, 1/scaleX, 1/scaleY);
    self.transformCtrl.transform = CGAffineTransformScale(self.transformCtrl.transform, 1/scaleX, 1/scaleY);
    self.resizeCtrl.transform = CGAffineTransformScale(self.resizeCtrl.transform, 1/scaleX, 1/scaleY);
    self.rotateCtrl.transform = CGAffineTransformScale(self.rotateCtrl.transform, 1/scaleX, 1/scaleY);
    self.oCtrlPointView.transform = CGAffineTransformScale(self.oCtrlPointView.transform, 1/scaleX, 1/scaleY);
}


#pragma mark - 移除StickerView

- (void)removeCtrlTap:(UITapGestureRecognizer *)gesture {
    if(self.removeBlock)self.removeBlock();
    [self removeFromSuperview];
}


#pragma mark - UIGestureRecognizerDelegate

/* 同时触发多个手势 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/* 控制手势是否触发 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer.view == self) {
        CGPoint p = [touch locationInView:self];
        if (CGRectContainsPoint(self.transformCtrl.frame, p) ||
            CGRectContainsPoint(self.rotateCtrl.frame, p) ||
            CGRectContainsPoint(self.resizeCtrl.frame, p)) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - 重写hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        int count = (int)self.subviews.count;
        for (int i = count - 1; i >= 0; i--) {
            UIView *subView = self.subviews[i];
            CGPoint p = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, p)) {
                if (subView.isHidden) {
                    continue;
                }
                return subView;
            }
        }
    }
    return view;
}


#pragma mark - Actions

- (void)showOriginalPoint:(BOOL)b {
    if (self.ctrlType == HTStickerViewCtrlTypeGesture) {
        return;
    }
    if (!self.oCtrlPointView && b) {
        self.oCtrlPointView = [[UIView alloc] initWithFrame:CGRectMake([self getRealOriginalPoint].x - 4, [self getRealOriginalPoint].y - 4, 8, 8)];
        self.oCtrlPointView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.oCtrlPointView];
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.oCtrlPointView.bounds];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor redColor].CGColor;
        layer.path = path.CGPath;
        [self.oCtrlPointView.layer addSublayer:layer];
        self.oCtrlPointView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    self.oCtrlPointView.hidden = !b;
}

- (void)updateCtrlPoint {
    if (self.oCtrlPointView) {
        self.oCtrlPointView.frame = CGRectMake([self getRealOriginalPoint].x - 4, [self getRealOriginalPoint].y - 4, 8, 8);
    }
}

- (void)showRemoveCtrl:(BOOL)b {
    self.removeCtrl.hidden = !b;
}

/* 计算两点间距 */
- (CGFloat)distanceWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    CGFloat x = start.x - end.x;
    CGFloat y = start.y - end.y;
    return sqrt(x * x + y * y);
}


#pragma mark - 设置控制图图片

- (void)setTransformCtrlImage:(UIImage *)image {
    self.transformCtrl.backgroundColor = [UIColor clearColor];
    self.transformCtrl.image = image;
}

- (void)setResizeCtrlImage:(UIImage *)resizeImage rotateCtrlImage:(UIImage *)rotateImage {
    self.resizeCtrl.backgroundColor = [UIColor clearColor];
    self.rotateCtrl.backgroundColor = [UIColor clearColor];
    self.resizeCtrl.image = resizeImage;
    self.rotateCtrl.image = rotateImage;
}

- (void)setRemoveCtrlImage:(UIImage *)image {
    self.removeCtrl.backgroundColor = [UIColor clearColor];
    self.removeCtrl.image = image;
}



-(void)allGestureEevent {
    //0-360
    
//    float  degrees =  [self calculateDegrees];
//    if(self.updateCurrentLocationBlock) {
//
//        float offsetX = (CGRectGetWidth(self.frame) - CGRectGetWidth(self.bounds))/2;
//        float offsetY = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.bounds))/2;
//
//        self.updateCurrentLocationBlock(CGRectMake(self.frame.origin.x + offsetX, self.frame.origin.y + offsetY, self.bounds.size.width, self.bounds.size.height), degrees, self.transform);
//    }
    
    //    NSLog(@"bounds xxx %f ",self.bounds.origin.x);
    //
    //    NSLog(@"xxx %f ",self.frame.origin.x);
    //    NSLog(@"yyy %f ",self.frame.origin.y);
    //    NSLog(@"www %f ",self.frame.size.width);
    //    NSLog(@"hhh %f ",self.frame.size.height);
    //
    //    NSLog(@"&&&**tx tx %f ",self.transform.tx);
    //    NSLog(@"&&&**ty tx %f ",self.transform.ty);
    //    NSLog(@"&&&**-aaa %f ",self.transform.a);
    //    NSLog(@"&&&**-bbb %f ",self.transform.b);
    //    NSLog(@"&&&**ccc %f ",self.transform.c);
    //    NSLog(@"&&&**ddd %f ",self.transform.d);
    
    
    if(_updateCornerPositionBlock)
    {
        CGPoint originalCenter = CGPointApplyAffineTransform(self.center,
                                                             CGAffineTransformInvert(self.transform));
        CGPoint topLeft = originalCenter;
        topLeft.x -= self.bounds.size.width / 2;
        topLeft.y -= self.bounds.size.height / 2;
        topLeft = CGPointApplyAffineTransform(topLeft, self.transform);
        
        CGPoint topRight = originalCenter;
        topRight.x += self.bounds.size.width / 2;
        topRight.y -= self.bounds.size.height / 2;
        topRight = CGPointApplyAffineTransform(topRight, self.transform);
        
        CGPoint bottomLeft = originalCenter;
        bottomLeft.x -= self.bounds.size.width / 2;
        bottomLeft.y += self.bounds.size.height / 2;
        bottomLeft = CGPointApplyAffineTransform(bottomLeft, self.transform);
        
        CGPoint bottomRight = originalCenter;
        bottomRight.x += self.bounds.size.width / 2;
        bottomRight.y += self.bounds.size.height / 2;
        bottomRight = CGPointApplyAffineTransform(bottomRight, self.transform);
        
        _updateCornerPositionBlock(topLeft,topRight,bottomLeft,bottomRight);
    }
}

- (float)calculateDegrees
{
    CGAffineTransform transform = self.transform;
    float radans = atan2f(transform.b, transform.a);
    float degrees = radans * (180/M_PI);
    degrees = degrees >= 0 ?degrees:degrees+360;
    return degrees;
     
}

 

+(CGRect)superView:(CGSize)sSize convertBounds:(CGRect)bounds toSize:(CGSize)size
{
 
    
    float sWidth = size.width;//super width
    float sHeight = size.height;//super height
     
    float fWidth = sSize.width;//from width
    float fHeight = sSize.height;//from height
    
    //如果大于1则放大 小于1则缩小
//    float sfWratio = sWidth/fWidth;
    //super 相对于 from的比例
    float sfHratio = sHeight/fHeight;
    
    //默认竖屏
    //计算得到fromSize 缩进到superSize 比例的大小
    float retractWidth = fWidth * sfHratio;
//    float retractHeight = sHeight;
    
    float extraWidth = retractWidth - sWidth;
    float rx = bounds.origin.x * sfHratio - (extraWidth/2);
    float ry = bounds.origin.y * sfHratio;
    float rw = bounds.size.width * sfHratio;
    float rh = bounds.size.height * sfHratio;
    
    CGRect r = CGRectMake(rx, ry, rw, rh);
    return r;
}

+(CGPoint)superView:(CGSize)sSize convertPoint:(CGPoint)point fromSize:(CGSize)size{
//    float scalex = sSize.width/size.width;
//    float scaley = sSize.width/size.width;
    
    float sWidth = sSize.width;  //super width
    float sHeight = sSize.height;//super height
     
    float width = size.width;  //from width
    float height = size.height;//from height
    
    //如果大于1则放大 小于1则缩小
//    float sfWratio = sWidth/fWidth;
    //super 相对于 from的比例
    float sfHratio = sHeight/height;
    
    //默认竖屏
    //计算得到fromSize 缩进到superSize 比例的大小
    float retractWidth = width * sfHratio;
//    float retractHeight = sHeight;
    
    float extraWidth = retractWidth - sWidth;
    float rx = point.x * sfHratio - (extraWidth/2);
    float ry = point.y * sfHratio;
    
    
    return CGPointMake(rx, ry);
}


@end
