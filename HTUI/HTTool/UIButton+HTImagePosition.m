//
//  UIButton+HTImagePosition.m
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/4/6.
//

#import "UIButton+HTImagePosition.h"

//@interface HTButtonPositionCacheManager : NSObject
//
//@property (nonatomic, strong) NSCache *cache;
//
//@end
//
//@implementation HTButtonPositionCacheManager
//
//+ (instancetype)sharedInstance {
//    static HTButtonPositionCacheManager * _sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = [[[self class] alloc] init];
//    });
//    return _sharedInstance;
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _cache = [[NSCache alloc] init];
//    }
//    return self;
//}
//
//@end
//
//
///**
// 缓存用数据结构
// */
//@interface HTButtonPositionCacheModel : NSObject
//@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
//@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;
//@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
//@end
//
//@implementation HTButtonPositionCacheModel
//@end

@implementation UIButton (HTImagePosition)

//- (void)setImagePosition:(HTImagePosition)postion spacing:(CGFloat)spacing {
//    NSCache *cache = [HTButtonPositionCacheManager sharedInstance].cache;
//    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@_%@", self.currentTitle, @(self.titleLabel.font.hash),@(postion)];
//    HTButtonPositionCacheModel *savedModel = [cache objectForKey:cacheKey];
//    if (savedModel != nil) {
//        self.imageEdgeInsets = savedModel.imageEdgeInsets;
//        self.titleEdgeInsets = savedModel.titleEdgeInsets;
//        self.contentEdgeInsets = savedModel.contentEdgeInsets;
//        return;
//    }
//    
//    CGFloat imageWidth = self.currentImage.size.width;
//    CGFloat imageHeight = self.currentImage.size.height;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    // Single line, no wrapping. Truncation based on the NSLineBreakMode.
//    CGSize size = [self.currentTitle sizeWithFont:self.titleLabel.font];
//    CGFloat labelWidth = size.width;
//    CGFloat labelHeight = size.height;
//#pragma clang diagnostic pop
//    
//    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
//    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
//    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
//    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
//    
//    CGFloat tempWidth = MAX(labelWidth, imageWidth);
//    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
//    CGFloat tempHeight = MAX(labelHeight, imageHeight);
//    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
//    
//    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
//    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
//    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsZero;
//    
//    switch (postion) {
//        case HTImagePositionLeft:
//            imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
//            titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
//            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
//            break;
//            
//        case HTImagePositionRight:
//            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
//            titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
//            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
//            break;
//            
//        case HTImagePositionTop:
//            imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
//            titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
//            contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
//            break;
//            
//        case HTImagePositionBottom:
//            imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
//            titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
//            contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
//            break;
//        default:
//            break;
//    }
//    
//    HTButtonPositionCacheModel *model = [[HTButtonPositionCacheModel alloc] init];
//    model.imageEdgeInsets = imageEdgeInsets;
//    model.titleEdgeInsets = titleEdgeInsets;
//    model.contentEdgeInsets = contentEdgeInsets;
//    [cache setObject:model forKey:cacheKey];
//    [self bringSubviewToFront:self.imageView];
//    self.imageEdgeInsets = imageEdgeInsets;
//    self.titleEdgeInsets = titleEdgeInsets;
//    self.contentEdgeInsets = contentEdgeInsets;
//    
//}

#pragma mark - 新方法 CC
- (void)layoutButtonWithEdgeInsetsStyle:(HTImagePosition)style imageTitleSpace:(CGFloat)space{
    //    self.backgroundColor = [UIColor cyanColor];
    
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    
    // 1. 得到imageView和titleLabel的宽、高
    
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    
    labelWidth = self.titleLabel.intrinsicContentSize.width;
    labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case HTImagePositionTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case HTImagePositionLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case HTImagePositionBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case HTImagePositionRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

//#pragma mark - 创建默认渐变色的按钮
//+ (UIButton *)defaultMutableColorButtonWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *_Nullable)font isLevel:(BOOL)isLevel {
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = frame;
//    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
//    gradientLayer.frame = btn.bounds;
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    //CGPointMake(1, 0)=水平  CGPointMake(0, 1)垂直
//    gradientLayer.endPoint = isLevel ? CGPointMake(1, 0) : CGPointMake(0, 1);
//    gradientLayer.locations = @[@(0),@(1.0)];//渐变点
//    [gradientLayer setColors:@[(id)[UIColor colorWithHexString:@"#FC9EDE"].CGColor,(id)[UIColor colorWithHexString:@"#9E85FF"].CGColor]];//渐变数组
//    [btn.layer addSublayer:gradientLayer];
//    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    if (font == nil) {
//        btn.titleLabel.font = [UIFont systemFontOfSize:16];
//    }else {
//        btn.titleLabel.font = font;
//    }
//
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = frame.size.height/2;
//
//    return btn;
//}
//
//#pragma mark - 创建一个按钮
//+ (UIButton *)initWithButton:(CGRect)rect text:(NSString *_Nullable)title font:(CGFloat)fontSize textColor:(UIColor *_Nullable)color normalImg:(NSString *_Nullable)nImg highImg:(NSString *_Nullable)hImg selectedImg:(NSString *_Nullable)sImg{
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = rect;
//    btn.titleLabel.font = PingFangSCFont(fontSize);
//    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitleColor:color forState:UIControlStateNormal];
//    if (nImg) {
//        [btn setImage:[UIImage imageNamed:nImg] forState:UIControlStateNormal];
//    }
//    if (hImg) {
//        [btn setImage:[UIImage imageNamed:hImg] forState:UIControlStateHighlighted];
//    }
//    if (sImg) {
//        [btn setImage:[UIImage imageNamed:sImg] forState:UIControlStateSelected];
//    }
//    btn.backgroundColor = [UIColor clearColor];
//    return btn;
//}

@end
