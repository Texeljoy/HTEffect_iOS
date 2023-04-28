//
//  HTSliderView.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/22.
//

#import "HTSliderView.h"
#import "HTUIConfig.h"

@interface HTSliderView ()<UIGestureRecognizerDelegate>{
    CGRect _trackRect;
    HTSliderType _sliderType;
}

@property (nonatomic, strong) UITapGestureRecognizer *htTapGesture;

@end

@implementation HTSliderView

- (UILabel *)sliderLabel{
    if (!_sliderLabel) {
        _sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -HTWidth(11), HTWidth(25), HTHeight(10))];
        [_sliderLabel setTextAlignment:NSTextAlignmentCenter];
        [_sliderLabel setFont:HTFontRegular(12)];
        _sliderLabel.userInteractionEnabled = NO;
        [_sliderLabel setAlpha:0];
    }
    return _sliderLabel;
}

- (UIView *)slideBar{
    if (!_slideBar) {
        _slideBar = [[UIView alloc] init];
        _slideBar.frame = _trackRect;
        _slideBar.layer.cornerRadius = HTHeight(2);
        _slideBar.userInteractionEnabled = NO;
    }
    return _slideBar;
}

- (UIView *)splitPoint{
    if (!_splitPoint) {
        _splitPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HTWidth(2), HTHeight(10))];
        _splitPoint.hidden = YES;
        _splitPoint.userInteractionEnabled = NO;
        _splitPoint.layer.cornerRadius = 1;
    }
    return _splitPoint;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _trackRect = CGRectZero;
        [self setBackgroundColor:HTColors(238, 0.5)];
        self.minimumTrackTintColor = [UIColor clearColor];
        self.maximumTrackTintColor = [UIColor clearColor];
        
        [self.sliderLabel setTextColor:HTColors(238, 0.9)];
        self.slideBar.backgroundColor = HTColors(238, 1.0);
        self.splitPoint.backgroundColor = HTColors(238, 0.5);
        // 滑块背景
        [self setThumbImage:[self resizeImage:[UIImage imageNamed:@"slider.png"] toSize:CGSizeMake(HTWidth(15), HTWidth(15))] forState:UIControlStateNormal];
        [self setThumbImage:[self resizeImage:[UIImage imageNamed:@"slider.png"] toSize:CGSizeMake(HTWidth(15), HTWidth(15))] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = HTHeight(2);
        
        [self addSubview:self.sliderLabel];
        [self addSubview:self.slideBar];
        [self addSubview:self.splitPoint];
        
        self.htTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
        self.htTapGesture.delegate = self;
        [self addGestureRecognizer:self.htTapGesture];
        
        // ios 14.0
        [self insertSubview:self.splitPoint atIndex:0];
        [self insertSubview:self.slideBar atIndex:0];
        [self addTarget:self action:@selector(didBeginUpdateValue:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didUpdateValue:) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(didEndUpdateValue:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        
        self.slideBar.backgroundColor = MAIN_COLOR;
        self.splitPoint.backgroundColor = MAIN_COLOR;
    }
    return self;
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    //    CGPoint touchPoint = [sender locationInView:self.slideBar];
    //    CGFloat value = (_slider.maximumValue - _slider.minimumValue) * (touchPoint.x / _slider.frame.size.width );
    //    [_slider setValue:value animated:YES];
}

- (void)setSliderType:(HTSliderType)sliderType WithValue:(float)value{
    _sliderType = sliderType;
    [self refreshWithValue:value isSet:YES];
    if (sliderType == HTSliderTypeI)
    {
        self.splitPoint.hidden = YES;
        self.minimumValue = 0;
        self.maximumValue = 100;
        self.slideBar.layer.cornerRadius = HTHeight(4)/2;
        [self setValue:value animated:YES];
    }else if (sliderType == HTSliderTypeII){
        self.splitPoint.hidden = NO;
        self.minimumValue = -50;
        self.maximumValue = 50;
        self.slideBar.layer.cornerRadius = 0;
        [self setValue:value animated:YES];
    }
}

// 开始拖拽
- (void)didBeginUpdateValue:(UISlider *)sender {
    [self refreshWithValue:sender.value isSet:NO];
    [UIView animateWithDuration:0.3 animations:^{
        [self.sliderLabel setAlpha:1.0f];
    }];
}

// 正在拖拽
- (void)didUpdateValue:(UISlider *)sender {
    [self refreshWithValue:sender.value isSet:NO];
    
}

// 结束拖拽
- (void)didEndUpdateValue:(UISlider *)sender {
    if (self.endDragBlock) {
        self.endDragBlock(sender.value);
    }
    [self refreshWithValue:sender.value isSet:NO];
    [UIView animateWithDuration:0.1 animations:^{
        [self.sliderLabel setAlpha:0];
    }];
    
}

- (void)refreshWithValue:(float)value isSet:(BOOL)set{
    if (self.refreshValueBlock&&!set) {
        self.refreshValueBlock(value);
    }
    if(self.valueBlock){
        self.valueBlock(value);
    }
    if (self->_sliderType == HTSliderTypeI)
    {
        self.slideBar.frame = CGRectMake(0, 0, self->_trackRect.origin.x + HTWidth(15)/2, HTHeight(4));
    }
    else if (self->_sliderType == HTSliderTypeII)
    {
        CGFloat W = -(self.frame.size.width/2 - (self->_trackRect.origin.x + HTWidth(15)/2));
        self.slideBar.frame = CGRectMake(self.frame.size.width/2, 0, W, HTHeight(4));
    }
    self.sliderLabel.center = CGPointMake(self->_trackRect.origin.x + HTWidth(15)/2,-self.center.y+HTHeight(10));
    [self.sliderLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
    
}

// 返回滑块轨迹的绘制矩形。
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, MAX(bounds.size.height, 2.0));
}

// 调整中间滑块位置，并获取滑块坐标
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width;
    _trackRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    return _trackRect;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        return result;
    }
    if ((point.y >= -HTWidth(15)) && (point.y < _trackRect.size.height + HTWidth(15))) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= _trackRect.origin.x - HTWidth(15)) && (point.x <= (_trackRect.origin.x + _trackRect.size.width + HTWidth(15))) && (point.y < (_trackRect.size.height + HTWidth(15)))) {
            result = YES;
        }
        
    }
    return result;
}

// FIXME: --layoutSubviews--
- (void)layoutSubviews
{
    [super layoutSubviews];
    //使用 mas //这里才能获取到self.frame 并且刷新Value 视图变动的时候也会调用
    self.splitPoint.frame = CGRectMake(self.frame.size.width/2, -HTHeight(10)/2 + HTHeight(4)/2, HTWidth(2), HTHeight(10));
    [self refreshWithValue:self.value isSet:YES];
    
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (IBAction)sliderTouchDown:(UISlider *)sender {
    _htTapGesture.enabled = NO;
}

- (IBAction)sliderTouchUp:(UISlider *)sender {
    _htTapGesture.enabled = YES;
}

@end
